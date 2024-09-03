-- João Pedro Soares da Franca PE3021114

set search_path to cd;

-- Exercicio 1
CREATE OR REPLACE FUNCTION abntextendido(nome VARCHAR(100))
    returns varchar(60)
    LANGUAGE 'plpgsql'
AS
$$
    DECLARE
        abntado text[];
        tamanho int;
        correto varchar;
    begin
            abntado := string_to_array(nome, ' ');
            tamanho := array_length(abntado, 1);
            correto := Concat(upper(abntado[tamanho]), ',');
            for i in 1 .. (tamanho - 1) loop
                 correto := concat(correto, ' ', abntado[i]);
            end loop;
            return correto;
    end;
$$;

Select abntextendido('João pedro Soares da Franca');

-- Exercicio 2
CREATE OR REPLACE FUNCTION abnt(nome VARCHAR(100))
    returns varchar(60)
    LANGUAGE 'plpgsql'
AS
$$
DECLARE
    abntado text[];
    tamanho int;
    correto varchar;
    palavra varchar;
begin
    abntado := string_to_array(nome, ' ');
    tamanho := array_length(abntado, 1);
    correto := Concat(upper(abntado[tamanho]), ',');
    for i in 1 .. (tamanho - 1) loop
            palavra := lower(abntado[i]);
            if (palavra not in ('da', 'do', 'das', 'dos')) then
                palavra := concat(upper(left(palavra, 1)), '.');
            end if;
            correto := concat(correto, ' ', palavra);
        end loop;
    return correto;
end;
$$;

Select abnt('João pedro Soares da Franca');

-- Exercicio 3
CREATE OR REPLACE FUNCTION abrevia(nome VARCHAR(100))
    returns varchar(60)
    LANGUAGE 'plpgsql'
AS
$$
DECLARE
    abntado text[];
    tamanho int;
    correto varchar;
    palavra varchar;
begin
    abntado := string_to_array(nome, ' ');
    tamanho := array_length(abntado, 1);
    correto := abntado[1];
    for i in 2 .. (tamanho - 1) loop
        palavra := lower(abntado[i]);
        if (palavra not in ('da', 'do', 'das', 'dos')) then
            palavra := concat(upper(left(palavra, 1)), '.');
        end if;
        correto := concat(correto, ' ', palavra);
    end loop;

    correto := Concat(correto, ' ', abntado[tamanho]);
    return correto;
end;
$$;

select abrevia('João Pedro Soares da Franca');

-- Exercicio 4
CREATE OR REPLACE FUNCTION retornaNome(posicao int, nome VARCHAR(100))
    returns varchar(60)
    LANGUAGE 'plpgsql'
AS
$$
    DECLARE
        abntado text[];
        tamanho int;
    begin
            abntado := string_to_array(nome, ' ');
            tamanho := array_length(abntado, 1);
            if posicao > tamanho then
                raise exception 'Posição maior do que a quantidade de palavras';
            end if;
            return abntado[posicao];
    end;
$$;

select retornaNome(3, 'João Pedro Soares da Franca');

-- Exercicio 5
create or replace function contvogais(nome varchar(60)) returns int
    language plpgsql
as
$$
declare
    retorno int default 0;
    i int default 0;
begin
    for i in 0 .. length(nome) loop
        IF LOWER(SUBSTRING(nome, i, 1)) IN ('a', 'e', 'i', 'o', 'u') THEN
            retorno := retorno + 1;
            end if;
        end loop;
    return retorno;
end;
$$;

select contvogais('Guilherme Moraes da silva');

-- Exercicio 6
CREATE OR REPLACE FUNCTION autores(codmusica int)
RETURNS varchar
LANGUAGE plpgsql
AS $$
DECLARE
    retorno varchar;
    codigo_musica int default 0;
BEGIN
    select musica.codmus from musica where codmus = codmusica into codigo_musica;

    if (codigo_musica is not null) then
        SELECT string_agg(upper(a.nomeaut), ', ')
        INTO retorno
        FROM autor a
        INNER JOIN musicaautor m ON a.codaut = m.codaut
        WHERE m.codmus = autores.codmusica;

        RETURN retorno;
    end if;

    raise exception 'Musica não encontrada, informações invalidas';
END;
$$;

select autores(1);