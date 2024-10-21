-- drop schema aposentadoria cascade;
-- create schema if not exists aposentadoria;
set search_path to aposentadoria;

alter table aposentados
    rename column "Regime Juridico" to regimejuridico;

update aposentados
set numerodoc = NULL
where numerodoc =' ';

update aposentados
set numerodoc = '19584'
where numerodoc ='19.584';

alter table aposentados
    alter column nome
        type varchar(50),
    alter column cpf
        type varchar(14),
    alter column situacao
        type varchar(15),
    alter column matricula
        type varchar(8),
    alter column fundamentacao
        type varchar(10),
    alter column ato
        type varchar(10),
    alter column doclegal
        type varchar(15),
    alter column numerodoc
        type int USING numerodoc::integer,
    alter column regimejuridico
        type varchar(10);

select numerodoc from aposentados where numerodoc is not null;

select distinct uorg, orgao from aposentados;

update aposentados
set uorg = 25204
where orgao = 'ELETROBRAS';

alter table aposentados
    alter column uorg
        type int using uorg::integer,
    alter column orgao
        type varchar(45),
    alter column classe
        type varchar(19),
    alter column padrao
        type varchar(5),
    alter column dataocorrencia
        type date using dataocorrencia::date,
    alter column datadou
        type date using datadou::date;

create table Orgao_table as
    select distinct(uorg), orgao from aposentados;

alter table Orgao_table
    add primary key(uorg);

alter table aposentados
    drop column orgao;

alter table aposentados
    add foreign key(uorg) references Orgao_table(uorg);

create table classes as
    select distinct classe, padrao from aposentados;

alter table classes
    add column idclasses serial,
    add primary key (idclasses);

-- alter table aposentados
--     drop column classe,
--     drop column padrao;

-- alter table aposentados
--     add column idclasses int,
--     add foreign key idclasses;

alter table aposentados
    add column idclasses int;

update aposentados a
    set idclasses = (select idclasses from classes where classe = a.classe and padrao = a.padrao)
    where idclasses is null;

drop table resumomensal;

create table resumomensal as
    (select distinct
         extract(year from dataocorrencia) as ano,
         extract(month from dataocorrencia) as mes
     from aposentados);

alter table resumomensal
    add column total int,
    add primary key (ano, mes);

alter table aposentados
    add column idaposentados serial,
    add primary key (idaposentados);

update resumomensal r
set total = (
    select count(idaposentados)
    from aposentados
    where extract(year from dataocorrencia) = r.ano and
          extract(month from dataocorrencia) = r.mes
)
where total is null;

select * from resumomensal order by total desc;