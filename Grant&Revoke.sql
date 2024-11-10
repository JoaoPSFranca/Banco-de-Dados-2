create database exercicio;
create schema rh;

-- 1
create table cliente(
    id_cliente serial primary key,
    nome varchar(60)
);

-- 2
create role usuario5 with password '123';
grant all privileges on table cliente to usuario5;

create role usuario6 with password '123';
grant create, usage on schema rh to usuario6;

grant select on table cliente to usuario5;

revoke all privileges on table cliente from usuario6;
revoke all privileges on schema rh from usuario6;

-- 3
create table venda(
    id_venda serial primary key,
    data date,
    valor decimal(10,2)
);

create procedure inserir_venda(quando date, val decimal(10,2))
    language plpgsql
as $$
    begin
        insert into venda(data, valor) values (quando, val);
    end;
$$;

create role usuario7 with password '123';
grant execute on procedure inserir_venda() to usuario7;
grant insert on table cliente to usuario7;

-- 4
create view venda_do_mes as (
    select
        sum(valor) as valor,
        month(data) as mes,
        year(data) as ano
    from venda
    where
        month(data) = month(current_date) and
        year(data) = year(current_date)
);

create role usuario8 with password '123';
grant select on venda_do_mes to usuario8;

-- 5
create role superusuario with password 'admin';
grant all privileges on database exercicio to superusuario;
revoke all privileges on database exercicio from superusuario;

-- 6
create table funcionario(
    id_funcionario serial primary key,
    nome varchar(100),
    salario decimal(10,2),
    departamento varchar(100)
);

create role usuario9 with password '123';
grant select(nome) on table funcionario to usuario9;

-- 7
create schema financeiro;

create role usuario10 with password '123';

grant select on all tables in schema financeiro to usuario10;
grant update on all tables in schema financeiro to usuario10;
grant insert on all tables in schema financeiro to usuario10;

revoke all privileges on schema financeiro from usuario10;

-- 8
create table estoque(
    id_produto serial primary key,
    quantidade int,
    valor decimal(10,2)
);

create role usuario12 with password '123';

grant update on table estoque to usuario12;
grant delete on table estoque to usuario12;

revoke all privileges on table estoque from usuario12;

-- 9
create database vendas;

create role usuario13 with password '123';

grant usage on vendas to usuario13;