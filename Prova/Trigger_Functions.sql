set search_path to provabim1_correcao;

-- Questão 1
--
create or replace function update_user() returns trigger
    language plpgsql
as $$
    begin
        new.idusuario = (select coalesce(max(idusuario), 0) from usuario) + 1;

        if (lower(new.categoria) = 'professor') then
            new.limite_livros = 5;
        elsif (lower(new.categoria) = 'aluno') then
            new.limite_livros = 3;
        end if;

        new.qtde_livros_emprestados = 0;
        new.total_multas = 0;

        return new;
    end;
$$;

create or replace trigger tg_update_user
    before insert on usuario
    for each row execute procedure update_user();

-- Questão 2
--
create or replace function criar_emprestimo() returns trigger
    language plpgsql
as
$$
    declare qtdeEmp INT; qtdeMax INT;
    begin
        select qtde_livros_emprestados, limite_livros into qtdeEmp, qtdeMax from usuario where idusuario = new.idusuario;
        if (qtdeMax <= qtdeEmp) then
            raise exception 'Limite Maximo de livros Emprestados para este Usuario';
        end if;

        return new;
    end;
$$;

create or replace trigger tg_criar_emprestimo
    before insert on emprestimo
    for each row execute procedure criar_emprestimo();

create or replace function emprestar_livro() returns trigger
    language plpgsql
as
$$
    declare qtdeEmp INT; qtdeMax INT; statusLivro TEXT; id INT;
    begin
        select
            qtde_livros_emprestados, limite_livros
        into qtdeEmp, qtdeMax
        from usuario
        where
            idusuario = (
                select idusuario
                from emprestimo
                where idemprestimo = new.idemprestimo);
        if (qtdeMax <= qtdeEmp) then
            raise exception 'Limite Maximo de livros Emprestados para este Usuario. ';
        end if;

        select status into statusLivro from acervo where idlivro = new.idlivro and idacervo = new.idacervo;
        if (statusLivro = 'E') then
            raise exception 'Livro Indisponivel, favor escolher outro exemplar. ';
        end if;

        select idusuario into id from emprestimo where idemprestimo = new.idemprestimo;

        update usuario
        set qtde_livros_emprestados = qtde_livros_emprestados + 1
        where idusuario = id;

        update acervo
        set status = 'E'
        where idlivro = new.idlivro and
              idacervo = new.idacervo;

        update livro
        set qtdedisponivel = qtdedisponivel - 1
        where idlivro = new.idlivro;

        return new;
    end;
$$;

create or replace trigger tg_emprestar_livro
    before insert on itensemprestados
    for each row execute procedure emprestar_livro();

create or replace function criar_multa() returns trigger
    language plpgsql
as $$
    declare idMul INT; idUs INT; val DECIMAL(10,2); valorMul DECIMAL(10,2); dataEmp DATE;
    begin
        if (old.datadevolucao is null) and (new.datadevolucao is not null) then
            select idusuario, data_emprestimo into idUs, dataEmp from emprestimo where idemprestimo = new.idemprestimo;
            select valor into val from historico_multas where data_multa = new.datadevolucao and idusuario = idUs;

            new.valormulta = (datadevolucao - dataEmp) * 2;

            if (val is null or val = 0) then
                select (coalesce(max(idmulta), 0) + 1) into idMul from historico_multas where idusuario = idUs;
                insert into historico_multas (idusuario, idmulta, valor, data_multa)
                values (idUs, idMul, new.valormulta, new.datadevolucao);
            else
                update historico_multas
                set valor = valor + new.valormulta
                where idusuario = idUs and
                      data_multa = new.datadevolucao;
            end if;

            return new;
        end if;
    end;
$$;

create or replace trigger tg_criar_multa
    after update on itensemprestados
    for each row execute procedure criar_multa();

-- Questão 3
create or replace procedure devolver(idEmp INT, dataDev DATE)
    language plpgsql
as $$
    declare idLiv INT; idUs INT; dataEsperada DATE;
    begin
        select idusuario into idUs from emprestimo where idemprestimo = idEmp;

        update emprestimo
        set status = 'Concluido'
        where idemprestimo = idEmp;

        update itensemprestados
        set datadevolucao = dataDev
        where idemprestimo = idEmp;

        for idLiv in (select idlivro from itensemprestados where idemprestimo = idEmp) loop
            update usuario
            set qtde_livros_emprestados = qtde_livros_emprestados - 1
            where idusuario = idUs;

            update acervo
            set status = 'D'
            where idlivro = idLiv and
                  idacervo = (
                      select idacervo
                      from itensemprestados
                      where idlivro = idLiv and
                            idemprestimo = idEmp
                      );

            update livro
            set qtdedisponivel = qtdedisponivel + 1
            where idlivro = idLiv;
        end loop;

        select previsao_devolucao into dataEsperada from emprestimo where idemprestimo = idEmp;

        if (dataEsperada < dataDev) then
            update itensemprestados
            set valormulta = (dataEsperada - dataDev) * 2.00
            where idemprestimo = idEmp;
        end if;
    end;
$$;

-- Questão 4
CREATE OR REPLACE VIEW livrosAtrasdos AS
SELECT
    u.nome as nomeusuario,
    l.titulo as nomeLivro,
    e.previsao_devolucao as atrasado_desde
FROM emprestimo e
JOIN usuario u
    on e.idusuario = u.idusuario
JOIN itensemprestados ie
    on e.idemprestimo = ie.idemprestimo
JOIN acervo a
    on ie.idlivro = a.idlivro and ie.idacervo = a.idacervo
JOIN livro l
    on a.idlivro = l.idlivro;

-- Questão 5
create or replace function update_historico_multas() returns trigger
    language plpgsql
as $$
    begin
        if tg_op = 'insert' then
            update usuario
            set total_multas = total_multas + new.valor
            where idusuario = new.idusuario;
        elsif ((new.data_pagamento is not null) and (old.data_pagamento is null)) then
            update usuario
            set total_multas = total_multas - new.valor
            where idusuario = new.idusuario;
        end if;

        return new;
    end;
$$;

create or replace trigger tg_update_historico_multas
    after insert or update on historico_multas
    for each row execute procedure update_historico_multas();

create or replace function update_serial_livro() returns trigger
    language plpgsql
as $$
    begin
        new.idlivro = (select coalesce(max(idlivro), 0) from livro) + 1;
        return new;
    end;
$$;

create or replace trigger tg_update_serial_livro
    before insert on livro
    for each row execute procedure update_serial_livro();

create or replace function update_serial_emprestimo() returns trigger
    language plpgsql
as $$
    begin
        new.idemprestimo = (select coalesce(max(idemprestimo), 0) from emprestimo) + 1;
        return new;
    end;
$$;

create or replace trigger tg_update_serial_emprestimo
    before insert on emprestimo
    for each row execute procedure update_serial_emprestimo();

create or replace function atualiza_acervo() returns trigger
    language plpgsql
as $$
    begin
        update livro
        set qtdedisponivel = qtdedisponivel+1,
            qtdelivro = qtdelivro + 1
        where idlivro = new.idlivro;

        return new;
    end;
$$;

create or replace trigger tg_atualiza_acervo
    after insert on acervo
    for each row execute procedure atualiza_acervo();