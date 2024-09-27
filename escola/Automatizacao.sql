set search_path to escola;

create or replace function atualiza_disciplina_curso() returns trigger
    language plpgsql
AS $$
declare
    horas INT;
begin
    select qtdehoras into horas from disciplina where iddisciplina = new.iddisciplina;

    update curso
    set totalhoras = totalhoras + horas
    where idcurso = new.idcurso;

    return new;
end;
$$;

create or replace trigger tg_atualiza_disciplina_curso
    after update or insert on disciplina_curso
    for each row execute procedure atualiza_disciplina_curso();

create or replace function atualiza_notas_alunos() returns trigger
    language plpgsql
as $$
declare
    id INT;
begin
    for id in (select dc.iddisciplina from turma t JOIN disciplina_curso dc ON (t.idcurso = dc.idcurso) where t.idturma = new.idturma) loop
        insert into notas (idmatricula, iddisciplina)
        values (new.idmatricula, id);
    end loop;

    return new;
end;
$$;

create or replace trigger tg_atualiza_notas_alunos
    after insert on matricula
    for each row execute procedure atualiza_notas_alunos();

create or replace function gerar_parcelas() returns trigger
    language plpgsql
as $$
    declare
        id int;
    begin
        select idcaixa into id from caixa where data = CURRENT_DATE;
        for i in (coalesce(old.qtdeparcelas, 0) + 1)..new.qtdeparcelas loop
            insert into pagamento values (i, new.idaluno, id, (now()  + interval '30 days'));
        end loop;
        return new;
    end;
$$;

create or replace trigger tg_gerar_parcela
    after update or insert on matricula
    for each row execute procedure gerar_parcelas();

create or replace function pagar_parcela() returns trigger
    language plpgsql
as $$
begin
    if (lower(new.status) = 'pago' and lower(old.status) = 'pendente') then
        update caixa
        set entrada = entrada + new.valor
        where idcaixa = new.idcaixa;
    end if;

    return new;
end;
$$;

create or replace trigger tg_pagar_parcela
    after update on pagamento
    for each row execute procedure pagar_parcela();

create or replace function apagar_parcelas() returns trigger
    language plpgsql
as $$
begin
    if (upper(new.situacao) = 'C' and upper(old.situacao) != 'C') then
        delete from pagamento
        where idaluno = new.idaluno
          and lower(status) = 'pendente';
    end if;

    return new;
end;
$$;

create or replace trigger tg_apagar_parcelas
    after update on matricula
    for each row execute procedure apagar_parcelas();

create or replace function calcular_media(disciplina int, matricula int) returns DECIMAL(10,2)
    language plpgsql
as $$
    declare media DECIMAL(10,2); soma decimal(10,2); total_notas INT;
    begin
        select
            sum(nota1 + nota2 + nota3 + nota4),
            count(nota1 + nota2 + nota3 + nota4)
        into soma, total_notas
        from notas
        where iddisciplina = disciplina and
              idmatricula = matricula;

        media := (soma / total_notas) / 4;
        return media;
    end;
$$;

CREATE OR REPLACE VIEW situacao_aluno AS
    SELECT
        a.idAluno,
        a.nome AS nome_aluno,
        d.nome AS nome_disciplina,
        c.nome AS nome_curso,
        calcular_media(n.idDisciplina, m.idMatricula) AS media,
        (CASE
            WHEN calcular_media(n.idDisciplina, m.idMatricula) >= 6 THEN 'Aprovado'
            ELSE 'Reprovado'
        END) AS status
    FROM aluno a
    JOIN matricula m
        ON a.idAluno = m.idAluno
    JOIN turma t
        ON m.idTurma = t.idTurma
    JOIN curso c
        ON t.idCurso = c.idCurso
    JOIN notas n
        ON m.idMatricula = n.idMatricula
    JOIN disciplina d
        ON n.idDisciplina = d.idDisciplina;

CREATE OR REPLACE VIEW relatorio_financeiro_turma AS
    SELECT
        t.idTurma,
        c.nome AS nome_curso,
        t.sala,
        SUM(CASE
                WHEN p.status = 'Pago' THEN p.valor
                ELSE 0
            END) AS total_receita,
        SUM(CASE
                WHEN d.data IS NOT NULL THEN d.valor
                ELSE 0
            END) AS total_despesas,
        (SUM(CASE
                 WHEN p.status = 'Pago' THEN p.valor
                 ELSE 0
            END) -
         SUM(CASE
                 WHEN d.data IS NOT NULL THEN d.valor
                 ELSE 0
             END)) AS lucro
    FROM turma t
    JOIN curso c
      ON t.idCurso = c.idCurso
    LEFT JOIN pagamento p
           ON p.refMatricula IN (SELECT m.idMatricula FROM matricula m WHERE m.idTurma = t.idTurma)
    LEFT JOIN despesa_turma d
           ON d.idTurma = t.idTurma
    GROUP BY t.idTurma, c.nome, t.sala;