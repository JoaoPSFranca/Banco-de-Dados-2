-- drop schema if exists emendas cascade;
-- create schema emendas;
set search_path to emendas;

select * from emendas;

alter table emendas
    rename column
        "ano_emenda" to ano;

alter table emendas
    rename column
        "codigo_emenda" to idemendas;

alter table emendas
    rename column
        "numero_emenda" to numero;

alter table emendas
    rename column
        "codigo_autor_emenda" to idautor;

alter table emendas
    rename column
        "nome_autor_emenda" to nomecompleto;

alter table emendas
    rename column
        "localidade_gasto" to localidade;

alter table emendas
    rename column
        "id_municipio_gasto" to idlocalidades;

alter table emendas
    rename column
        "sigla_uf_gasto" to sigla;

alter table emendas
    rename column
        "codigo_funcao" to idfuncao;

alter table emendas
    rename column
        "codigo_subfuncao" to idsubfuncao;

alter table emendas
    rename column
        "nome_subfuncao" to nome;

update emendas
set sigla = 'MULT'
where sigla is null;

update emendas
set idfuncao = '0'
where idfuncao = 'MU';

update emendas
set idsubfuncao = '0'
where idsubfuncao = 'MU';

update emendas
set idautor = '0'
where idautor = 'Sem informação';

update emendas
set numero  = '0'
where numero = 'Sem informação';

select * from emendas where idemendas = 'Sem informação';

alter table emendas
    alter column ano
        type int using ano::integer,
    alter column numero
        type int using numero::integer,
    alter column tipo_emenda
        type varchar(150),
    alter column idautor
        type int using idautor::integer,
    alter column nomecompleto
        type varchar(150),
    alter column localidade
        type varchar(60),
    alter column idlocalidades
        type int using idlocalidades::integer,
    alter column sigla
        type varchar(4),
    alter column idfuncao
        type int using idfuncao::integer,
    alter column nome_funcao
        type varchar(45),
    alter column idsubfuncao
        type int using idsubfuncao::integer,
    alter column nome
        type varchar(150);

-- Autor

update emendas
set nomecompleto = 'JUNIOR BOZZELLA'
where idautor = 9089;

update emendas
set nomecompleto = 'GUILHERME DERRITE'
where idautor = 9060;

update emendas
set nomecompleto = 'COM. CIENCIA, TECNOLOGIA, INOVACAO'
where idautor = 6013;

update emendas
set nomecompleto = 'COM. AGRICULTURA E REFORMA AGRARIA'
where idautor = 6012;

update emendas
set nomecompleto = 'COM. DESENV REGIONAL E TURISMO'
where idautor = 6011;

update emendas
set nomecompleto = 'COM. DIREITOS HUMANOS E LEGIS PARTI'
where idautor = 6009;

update emendas
set nomecompleto = 'COM. MEIO AMBIENTE'
where idautor = 6008;

update emendas
set nomecompleto = 'COM. ASSUNTOS SOCIAIS'
where idautor = 6006;

update emendas
set nomecompleto = 'COM. ASSUNTOS ECONOMICOS'
where idautor = 6005;

update emendas
set nomecompleto = 'COM. EDUCACAO, CULTURA E ESPORTE'
where idautor = 6004;

update emendas
set nomecompleto = 'COM. CONST. JUSTICA E CIDADANIA'
where idautor = 6003;

update emendas
set nomecompleto = 'COM. RELACOES EXT E DEFESA NACIONAL'
where idautor = 6002;

update emendas
set nomecompleto = 'COM. SERV.DE INFRA-ESTRUTURA'
where idautor = 6001;

update emendas
set nomecompleto = 'COM. MISTA, PLAN.ORC.E FISCALIZACAO'
where idautor = 6000;

update emendas
set nomecompleto = 'COM. DEFESA DOS DIREITOS DA PESSOA IDOSA'
where idautor = 5037;

update emendas
set nomecompleto = 'COM. DEFESA DOS DIREITOS DA MULHER'
where idautor = 5036;

update emendas
set nomecompleto = 'COM. DE TRANSP. GOV. FISC. E CONT. E DEF. DO CONSUMIDOR'
where idautor = 5035;

update emendas
set nomecompleto = 'COM. LEGISLACAO PARTICIPATIVA'
where idautor = 5034;

update emendas
set nomecompleto = 'COM. INTEG NAC DES REGIONAL E DA AMAZONIA - CINDRA'
where idautor = 5033;

update emendas
set nomecompleto = 'COM. FISC FINANCEIRA E CONTROLE'
where idautor = 5031;

update emendas
set nomecompleto = 'COM. DIREITOS HUMANOS E MINORIAS'
where idautor = 5030;

update emendas
set nomecompleto = 'COM. SENADO DO FUTURO'
where idautor = 5029;

update emendas
set nomecompleto = 'COM. MISTA DE CONTROLE DAS ATIV. DE INTELIGENCIA'
where idautor = 5027;

update emendas
set nomecompleto = 'COM. VIACAO E TRANSPORTES'
where idautor = 5024;

update emendas
set nomecompleto = 'COM. DESENV. URBANO'
where idautor = 5023;

update emendas
set nomecompleto = 'COM. TRABALHO, ADM. E SERV.PUBLICO'
where idautor = 5022;

update emendas
set nomecompleto = 'COM. SEGURIDADE SOCIAL E FAMILIA'
where idautor = 5021;

update emendas
set nomecompleto = 'COM. REL EXTERIORES E DEF. NACIONAL'
where idautor = 5020;

update emendas
set nomecompleto = 'COM. MINAS E ENERGIA'
where idautor = 5018;

update emendas
set nomecompleto = 'COM. FINANCAS E TRIBUTACAO'
where idautor = 5017;

update emendas
set nomecompleto = 'COM. DES ECONOMICO, IND. E COMERCIO'
where idautor = 5015;

update emendas
set nomecompleto = 'COM. DEFESA DO CONSUMIDOR'
where idautor = 5013;

update emendas
set nomecompleto = 'COM. CONST. JUSTICA E DE CIDADANIA'
where idautor = 5012;

update emendas
set nomecompleto = 'COM. CIENCIA,TECN. COM. INFORMATICA'
where idautor = 5011;

update emendas
set nomecompleto = 'COM. AGRICULTURA PEC ABAST D. RURAL'
where idautor = 5010;

update emendas
set nomecompleto = 'COM. MISTA PERMANENTE SOBRE MUDANCAS CLIMATICAS'
where idautor = 5009;

update emendas
set nomecompleto = 'COM. DEFESA DIREITOS DAS PESSOAS COM DEFICIENCIA'
where idautor = 5008;

update emendas
set nomecompleto = 'COM. TURISMO'
where idautor = 5007;

update emendas
set nomecompleto = 'COM. ESPORTE'
where idautor = 5006;

update emendas
set nomecompleto = 'COM. EDUCACAO'
where idautor = 5005;

update emendas
set nomecompleto = 'COM. CULTURA'
where idautor = 5004;

update emendas
set nomecompleto = 'COM. MEIO AMB DESENV SUSTENTAVEL'
where idautor = 5003;

update emendas
set nomecompleto = 'COM. SEG. PUBLICA E COMB. CRIME ORG'
where idautor = 5001;

update emendas
set nomecompleto = 'DEP. JOSIVALDO JP'
where idautor = 4212;

update emendas
set nomecompleto = 'NELSINHO TRAD FILHO'
where idautor = 4181;

update emendas
set nomecompleto = 'OTACI NASCIMENTO'
where idautor = 4165;

update emendas
set nomecompleto = 'LUIZ CARLOS DO CARMO'
where idautor = 4099;

update emendas
set nomecompleto = 'PASTOR GILDENEMYR'
where idautor = 4052;

update emendas
set nomecompleto = 'MAJOR VITOR HUGO'
where idautor = 4037;

update emendas
set nomecompleto = 'GLAUSTIN DA FOKUS'
where idautor = 4010;

update emendas
set nomecompleto = 'DR. LUIZ ANTONIO TEIXEIRA JR.'
where idautor = 3963;

update emendas
set nomecompleto = 'CABO JUNIO AMARAL'
where idautor = 3924;

update emendas
set nomecompleto = 'ALENCAR SANTANA BRAGA'
where idautor = 3905;

update emendas
set nomecompleto = 'PEDRO CHAVES DOS SANTOS FILHO'
where idautor = 3843;

update emendas
set nomecompleto = 'PASTOR FRANKLIN LIMA'
where idautor = 3820;

update emendas
set nomecompleto = 'PEDRO PINHEIRO CHAVES'
where idautor = 3672;

update emendas
set nomecompleto = 'EVANDRO ROMAN'
where idautor = 3095;

update emendas
set nomecompleto = 'EVAIR VIEIRA DE MELO'
where idautor = 3093;

update emendas
set nomecompleto = 'FERNANDO FRANCISCHINI'
where idautor = 2842;

update emendas
set nomecompleto = 'PAULO FREIRE COSTA'
where idautor = 2813;

update emendas
set nomecompleto = 'AUREO RIBEIRO'
where idautor = 2778;

update emendas
set nomecompleto = 'PAULO FOLETTO'
where idautor = 2774;

update emendas
set nomecompleto = 'FERNANDO AFFONSO COLLOR DE MELLO'
where idautor = 2579;

update emendas
set nomecompleto = 'PAULO PEREIRA DA SILVA'
where idautor = 2532;

update emendas
set nomecompleto = 'CHICO D''ANGELO'
where idautor = 2497;

update emendas
set nomecompleto = 'JOSE AIRTON FELIX CIRILO'
where idautor = 2441;

update emendas
set nomecompleto = 'IZALCI LUCAS'
where idautor = 2363;

update emendas
set nomecompleto = 'DAGOBERTO NOGUEIRA'
where idautor = 2170;

update emendas
set nomecompleto = 'JOAO BOSCO DA COSTA'
where idautor = 1313;

create table autor as
    select distinct(idautor), nomecompleto from emendas;

alter table autor
    add primary key (idautor);

-- Sub Função
create table subfuncao as
    select distinct(idsubfuncao), nome from emendas;

alter table subfuncao
    add primary key(idsubfuncao);

-- Função
create table funcao as
    select distinct(idfuncao), nome_funcao as descricao from emendas;

alter table funcao
    add primary key (idfuncao);

-- Tipo Emenda
create table tipoemenda as
    select distinct(tipo_emenda) as descricao from emendas;

alter table tipoemenda
    add idtipoemenda serial;

alter table tipoemenda
    add primary key(idtipoemenda);

-- Localidade
WITH cte AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY localidade) + (
            SELECT COALESCE(MAX(idlocalidades), 0)
            FROM emendas) AS new_id,
        localidade
    FROM emendas
    WHERE idlocalidades IS NULL
)

UPDATE emendas
SET idlocalidades = cte.new_id
FROM cte
WHERE emendas.localidade = cte.localidade;

update emendas set localidade = replace(localidade, ' (UF)', '');

create table localidade as
    select distinct idlocalidades, localidade, sigla from emendas;

alter table localidade
    add primary key(idlocalidades);

-- Atualizando ID emenda
alter table emendas
    add idtemp serial;

DO $$
    -- adicionar um atributo serial temporário
    -- rodar o DO
    -- apagar o atributo
    declare
        id int;
        minimo double precision;
    begin
        select coalesce(min(idemendas::double precision), 0) into minimo
        from emendas
        where idemendas != 'Sem informação';

        if (minimo > 0) then
            minimo := -1;
        end if;

        for id in (select idtemp from emendas where idemendas = 'Sem informação') loop
            update emendas
            set idemendas = minimo
            where idtemp = id;

            minimo := minimo-1;
        end loop;
    end
$$;

alter table emendas
    drop column idtemp;

alter table emendas
    alter column idemendas
        type double precision using idemendas::double precision;

update emendas
set idemendas = 202029190010
where idemendas = 202029190009 and
    idlocalidades = 5319661;

update emendas
set idemendas = 202030410014
where idemendas = 202030410010 and
    idlocalidades = 5319661;

update emendas
set idemendas = 202027190015
where idemendas = 202027190005 and
    idlocalidades = 5319661;

update emendas
set idemendas = 202392190024
where idemendas = 202392190019 and
    idlocalidades = 5319661;

update emendas
set idemendas = 202392190025
where idemendas = 202392190012 and
    idfuncao = 28;

update emendas
set idemendas = 202392190026
where idemendas = 202392190013 and
    idfuncao = 28;

update emendas
set idemendas = 202392190027
where idemendas = 202392190014 and
    idlocalidades = 5319661;

update emendas
set idemendas = 202392190028
where idemendas = 202392190015 and
    idfuncao = 28;

update emendas
set idemendas = 202392190029
where idemendas = 202392190016 and
    idfuncao = 28;

update emendas
set idemendas = 202392190030
where idemendas = 202392190017 and
    idfuncao = 28;

update emendas
set idemendas = 202392190031
where idemendas = 202392190018 and
    idlocalidades = 5319661;

update emendas
set idemendas = 202392190032
where idemendas = 202392190020 and
    idlocalidades = 5319661;

update emendas
set idemendas = 202392190033
where idemendas = 202392190021 and
    idlocalidades = 5319661;

update emendas
set idemendas = 202392190034
where idemendas = 202392190022 and
    idlocalidades = 5319661;

update emendas
set idemendas = 202392190035
where idemendas = 202392190023 and
    idlocalidades = 5319661;

update emendas
set idemendas = 202391030001
where idemendas = 202391030002 and
    idlocalidades = 5319661;

update emendas
set idemendas = 202391030004
where idemendas = 202338920009 and
    idlocalidades = 5319661;

update emendas
set idemendas = 202340480016
where idemendas = 202340480014 and
    idlocalidades = 5319661;

update emendas
set idemendas = 202330610000
where idemendas = 202330610003 and
    idfuncao = 28;

update emendas
set idemendas = 202414450005
where idemendas = 202414450006 and
    idlocalidades = 5319661;

update emendas
set idemendas = 202391030000
where idemendas = 202391030001 and
    idfuncao = 28;

update emendas
set idemendas = 202341320015
where idemendas = 202341320009 and
    idfuncao = 28;

update emendas
set idemendas = 202341320016
where idemendas = 202341320010 and
    idfuncao = 28;

update emendas
set idemendas = 202324680012
where idemendas = 202324680011 and
    idfuncao = 28;

update emendas
set idemendas = 202323680026
where idemendas = 202323680025 and
    idfuncao = 28;

update emendas
set idemendas = 202320380010
where idemendas = 202320380009 and
    idfuncao = 28;

update emendas
set idemendas = 202320380011
where idemendas = 202320380003 and
    idfuncao = 28;

update emendas
set idemendas = 202320380012
where idemendas = 202320380005 and
    idfuncao = 28;

update emendas
set idemendas = 202320380013
where idemendas = 202320380006 and
    idfuncao = 28;

update emendas
set idemendas = 202320380014
where idemendas = 202320380007 and
    idfuncao = 28;

update emendas
set idemendas = 202340830000
where idemendas = 202340830001 and
    idfuncao = 28;

update emendas
set idemendas = 202340830007
where idemendas = 202340830002 and
    idfuncao = 28;

update emendas
set idemendas = 202340780000
where idemendas = 202340780001 and
    idfuncao = 28;

update emendas
set idemendas = 202339890013
where idemendas = 202339890012 and
    idfuncao = 28;

update emendas
set idemendas = 202337960016
where idemendas = 202337960008 and
    idfuncao = 28;

update emendas
set idemendas = 202339740010
where idemendas = 202339740005 and
    idfuncao = 28;

update emendas
set idemendas = 202334920000
where idemendas = 202334920004 and
    idfuncao = 28;

update emendas
set idemendas = 202336610000
where idemendas = 202336610004 and
    idfuncao = 28;

update emendas
set idemendas = 202339950018
where idemendas = 202339950016 and
    idfuncao = 28;

update emendas
set idemendas = 202340510011
where idemendas = 202340510007 and
    idfuncao = 28;

update emendas
set idemendas = 202340750003
where idemendas = 202340750004 and
    idfuncao = 28;

update emendas
set idemendas = 202340370000
where idemendas = 202340370020 and
    idfuncao = 28;

update emendas
set idemendas = 202340370026
where idemendas = 202340370012 and
    idfuncao = 28;

update emendas
set idemendas = 202340370027
where idemendas = 202340370022 and
    idfuncao = 28;

update emendas
set idemendas = 202340370028
where idemendas = 202340370023 and
    idfuncao = 28;

update emendas
set idemendas = 202337470000
where idemendas = 202337470007 and
    idfuncao = 28;

update emendas
set idemendas = 202337310005
where idemendas = 202337310004 and
    idfuncao = 28;

update emendas
set idemendas = 202337100000
where idemendas = 202337100002 and
    idfuncao = 28;

update emendas
set idemendas = 202341160000
where idemendas = 202341160001 and
    idfuncao = 28;

update emendas
set idemendas = 202341820000
where idemendas = 202341820010 and
    idfuncao = 28;

update emendas
set idemendas = 202341810000
where idemendas = 202341810006 and
    idfuncao = 28;

update emendas
set idemendas = 202341820015
where idemendas = 202341820007 and
    idfuncao = 28;

update emendas
set idemendas = 202341820016
where idemendas = 202341820009 and
    idfuncao = 28;

update emendas
set idemendas = 202341820017
where idemendas = 202341820011 and
    idfuncao = 28;

update emendas
set idemendas = 202341020025
where idemendas = 202341020022 and
    idfuncao = 28;

update emendas
set idemendas = 202320380000
where idemendas = 202320380001 and
    idfuncao = 28;

update emendas
set idemendas = 202327240000
where idemendas = 202327240001 and
    idfuncao = 28;

alter table emendas
    add primary key(idemendas);

-- Atualizando emendas
alter table emendas
    drop column nomecompleto,
    drop column nome,
    drop column nome_funcao,
    drop column localidade,
    drop column sigla;

alter table emendas
    add foreign key (idautor) references autor (idautor),
    add foreign key (idsubfuncao) references subfuncao(idsubfuncao),
    add foreign key (idfuncao) references funcao (idfuncao),
    add foreign key (idlocalidades) references localidade (idlocalidades);

alter table emendas
    alter column valor_empenhado
        type decimal(15, 2) using valor_empenhado::numeric(15,2),
    alter column valor_liquidado
        type decimal(15, 2) using valor_liquidado::numeric(15,2),
    alter column valor_pago
        type decimal(15, 2) using valor_pago::numeric(15,2),
    alter column valor_resto_pagar_cancelado
        type decimal(15, 2) using valor_resto_pagar_cancelado::numeric(15,2),
    alter column valor_resto_pagar_inscrito
        type decimal(15, 2) using valor_resto_pagar_inscrito::numeric(15,2),
    alter column valor_resto_pagar_pagos
        type decimal(15, 2) using valor_resto_pagar_pagos::numeric(15,2);

alter table emendas
    add column idtipoemenda int;

update emendas e
    set idtipoemenda = (select idtipoemenda from tipoemenda where descricao = e.tipo_emenda)
    where idtipoemenda is null;

alter table emendas
    add foreign key(idtipoemenda) references tipoemenda(idtipoemenda);

alter table autor
    add column nome varchar(150);

update autor a
    set nome = (select nomecompleto from emendas where idautor = a.idautor limit 1)
    where idautor is null;

alter table emendas
    drop column tipo_emenda;

select * from emendas;