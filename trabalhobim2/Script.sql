-- drop schema if exists trabalhobim2 cascade;
-- create schema trabalhobim2;
set search_path to trabalhobim2;

create table cliente (
    idcliente           serial          not null,
    nome                varchar(100)    not null,
    telefone            varchar(20)     not null,
    cep                 integer         not null,
    numero              integer         not null,

    nomecidade          varchar(100)    null,
    nomebairro          varchar(100)    null,
    estado              varchar(30)     null,
    local               varchar(100)    null,
    codigoIBGE          varchar(50)     null,

    quantidadeVendas    int             default 0,
    totalComprado       decimal(10,2)   default 0.0,
    status              varchar(2)      default 'L',

    limitecomprafiado   decimal         default 1000.00,

    primary key(idcliente)
);

create table venda(
    idvenda         serial          not null,
    idcliente       int             not null,
    cep             integer         not null,
    numero          int             not null,
    valorTotal      decimal(10,2)   default 0.0,
    datavenda       date            default current_date,
    datapagamento   date            null,
    primary key (idvenda),
    foreign key (idcliente)
        references cliente(idcliente)
);

create table produto(
    idproduto       serial          not null,
    qtdeestoque     int             not null,
    precocusto      decimal(10, 2)  not null,
    percentuallucro decimal(10,2)   default 0.0,
    precovenda      decimal(10,2)   not null,
    primary key (idproduto)
);

create table itemvenda(
    idvenda     int             not null,
    idproduto   int             not null,
    quantidade  int             not null,
    valor       decimal(10,2)   not null,
    primary key (idvenda, idproduto),
    foreign key (idvenda)
        references venda (idvenda),
    foreign key (idproduto)
        references produto (idproduto)
);

create table resumo_diario(
    ano             integer         not null,
    lancamento      int             not null,
    datapagamento   date            not null,
    numerovenda     int             not null,
    valorrecebido   decimal(10,2)   default 0.0,
    saldododia      decimal(10,2)   not null,
    primary key (ano, lancamento)
);

-- Import Estado
alter table estado
    alter column uf
        type varchar(3),
    alter column estado
        type varchar(30),
    alter column cod_ibge
        type varchar(50);

alter table estado
    add primary key (uf);

-- Import Cidade
alter table cidade
    alter column id_cidade
        type integer using id_cidade::integer,
    alter column cidade
        type varchar(100),
    alter column uf
        type varchar(3),
    alter column cod_ibge
        type varchar(50),
    alter column area
        type double precision using area::double precision;

alter table cidade
    add primary key (id_cidade);

alter table cidade
    add foreign key (uf)
        references estado (uf);

-- Import Bairro
alter table bairro
    alter column id_bairro
        type int using id_bairro::integer,
    alter column bairro
        type varchar(150),
    alter column id_cidade
        type integer using id_cidade::integer;

alter table bairro
    add primary key (id_bairro);

delete from bairro
where id_bairro = 0;

alter table bairro
    add foreign key (id_cidade)
        references cidade (id_cidade);

-- Import Geo
update geo
set latitude = null
where latitude = '-';

update geo
set longitude = null
where longitude = '-';

alter table geo
    alter column cep
        type integer using cep::integer,
    alter column latitude
        type double precision using latitude::double precision,
    alter column longitude
        type double precision using longitude::double precision;

alter table geo
    add primary key (cep);

-- Import endereco
alter table endereco
    alter column cep
        type integer using cep::integer,
    alter column logradouro
        type varchar(200),
    alter column tipo_logradouro
        type varchar(100),
    alter column complemento
        type varchar(100),
    alter column local
        type varchar(100),
    alter column id_cidade
        type integer using id_cidade::integer,
    alter column id_bairro
        type integer using id_bairro::integer;

alter table endereco
    add column id_endereco serial;

alter table endereco
    add primary key (id_endereco);

update endereco
set id_bairro = null
where id_bairro = 0;

DO $$
    declare
        i integer;
        id integer;
    begin
        for i in (select cep from endereco) loop
                select cep into id from geo where cep = i;
                if (id is null) then
                    insert into geo values (i, null, null);
                end if;
            end loop;
    end;
$$;

alter table endereco
    add foreign key (id_cidade)
        references cidade (id_cidade),
    add foreign key (id_bairro)
        references bairro (id_bairro),
    add foreign key (cep)
        references geo (cep);
