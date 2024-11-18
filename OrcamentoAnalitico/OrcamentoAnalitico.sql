-- João Pedro Franca e Ele mesmo

drop schema if exists orcamento;
create schema orcamento;
set search_path to orcamento;

alter table analitico
    drop column id;

alter table analitico
    add column id serial;

alter table analitico
    add primary key (id);

update analitico
set valor_unitario = 1
where valor_unitario = 'Valor Unit' or
      valor_unitario is null;

update analitico
set total = 0
where total = 'Total' or
      codigo = 'Código' or
      codigo is null;

update analitico
set quantidade = 0
where quantidade = 'Quant.' or
      quantidade is null;

update analitico
set total = REPLACE(REPLACE(total, '.', ''), ',', '.');

update analitico
set quantidade = REPLACE(quantidade, ',', '.');

update analitico
set valor_unitario = REPLACE(REPLACE(valor_unitario, '.', '') ,',', '.');

update analitico
set quantidade = '3.2600000000'
where quantidade = '3.260.0000000';

update analitico
set num_tipo = trim(num_tipo);

update analitico
set codigo = trim(codigo);

alter table analitico
    alter column total
        type numeric using total::numeric,
    alter column valor_unitario
        type numeric using valor_unitario::numeric,
    alter column quantidade
        type numeric using quantidade::numeric;

alter table analitico
    add item varchar(100);

DO $$
    declare
        result record;
        itens varchar(100);
    begin
        for result in (select * from analitico order by id) loop
            if result.num_tipo in (select distinct(num_tipo) from analitico
                                        where num_tipo != 'Composição' and
                                              num_tipo != 'Composição Auxiliar' and
                                              num_tipo != 'Insumo' order by num_tipo) then
                itens := result.num_tipo;
            end if;

            update analitico
            set item = itens
            where id = result.id;
        end loop;
    end;
$$;

update analitico
set item = trim(item);

select * from analitico order by id;

create or replace function calc_valor_total(numeracao varchar(100))
    returns numeric
    language plpgsql
as $$
    declare
        soma numeric;
    begin
        select sum(quantidade * valor_unitario) into soma from analitico where item = numeracao;
        return soma;
    end;
$$;

create table SINAP as (
    select id, codigo, descricao, valor_unitario as preco
    from analitico
    where codigo != 'Código' or codigo is null
    order by id
);

select * from SINAP;