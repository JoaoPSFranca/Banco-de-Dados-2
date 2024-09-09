set search_path to cd;

alter table venda
    ADD column valorTotal decimal(10,2);

create or replace procedure atualizaValorVendaExistente()
    LANGUAGE plpgsql
as $$
declare
    id int;
    total decimal(10,2);
begin
    for id in (select idvenda from venda) loop
        total := 0;

        select sum(qtde * preco) into total
        from itemvenda
        where idvenda = id;

        update venda
        set valorTotal = total
        where idvenda = id;
    end loop;
end;
$$;

call atualizaValorVendaExistente();

create or replace function atualizaValorVenda() returns trigger
    language plpgsql
as $$
declare total decimal(10,2);
begin
    total:= 0;

    select sum(qtde * preco) into total
    from itemvenda
    where idvenda = new.idvenda;

    update venda
    set valorTotal = total
    where idvenda = new.idvenda;

    return new;
end;
$$;

create or replace trigger tg_atualizaValorVenda
    after insert or delete or update on itemvenda
    for each row execute procedure atualizaValorVenda();

alter table cliente
    add column valorComprado decimal(10,2);

create or replace procedure atualizaValorClienteExistente()
    language plpgsql
as $$
declare
    id int;
    total decimal(10,2);
begin
    for id in (select codcli from cliente) loop
        total := 0;

        select sum(valortotal) into total
        from venda
        where codcli = id;

        update cliente
        set valorComprado = total
        where codcli = id;

    end loop;
end;
$$;

call atualizaValorClienteExistente();

create or replace function atualizaValorCliente() returns trigger
    language plpgsql
as $$
declare
    total decimal(10,2);
begin
    total := 0;

    select sum(valortotal) into total
    from venda
    where codcli = new.codcli;

    update cliente
    set valorComprado = total
    where codcli = new.codcli;

    return new;
end;
$$;

create or replace trigger tg_atualizaValorCliente
    after insert or update or delete on venda
    for each row execute procedure atualizaValorCliente();

-- alter table cd
    -- add column qtdeEstoque int;

update cd set qtdeEstoque = 10000;

create or replace procedure atualizaQtdeCDExistente()
    language plpgsql
as $$
declare
    id int;
    total int;
begin
    for id in (select codcd from cd) loop
        total := 0;

        select sum(qtde) into total
        from itemvenda
        where codcd = id;

        update cd
        set qtdeEstoque = qtdeEstoque - total
        where codcd = id;
    end loop;
end;
$$;

call atualizaQtdeCDExistente();

create or replace function atualizaQtdeCD() returns trigger
    language plpgsql
as $$
begin
    update cd c
    set qtdeEstoque = qtdeEstoque - new.qtde
    where codcd = new.codcd;
    return new;
end;
$$;

create or replace trigger tg_atualizaQtdeCD
    after insert or update on itemvenda
    for each row execute procedure atualizaQtdeCD();

-- alter table autor
    -- add column renda decimal(10,2);

create or replace procedure atualizaRendaAutorExistente()
    language plpgsql
as $$
declare
    idaut int;
    idmus int;
    idcd int;
    precoCD decimal(10,2);
    qtdeMusicasCD int;
    qtdeCDsVendidos int;
    iv int;
    rendaAutor decimal(10,2);
begin
    for idaut in (select codaut from autor) loop
        rendaAutor := 0;

        for idmus in (select codmus from musicaautor where codaut = idaut) loop
            qtdeCDsVendidos := 0;

            select codcd into idcd from faixa where codmus = idmus;                 -- pega o cd em que a musica esta
            select preco into precoCD from cd where codcd = idcd;                   -- pega o preco do cd
            select count(codmus) into qtdeMusicasCD from faixa where codcd = idcd;  -- pega a quantidade de musica naquele cd

            for iv in (select idvenda from itemvenda where codcd = idcd) loop
                qtdeCDsVendidos := qtdeCDsVendidos + (select qtde from itemvenda where idvenda = iv and codcd = idcd);
            end loop;

            rendaAutor := rendaAutor + ((precoCD / qtdeMusicasCD) * qtdeCDsVendidos);
        end loop;

        update autor
        set renda = rendaAutor
        where codaut = idaut;
    end loop;
end;
$$;

call atualizaRendaAutorExistente();

create or replace function atualizaRendaAutor() returns trigger
    language plpgsql
AS $$
    declare
        idmus int;
        idaut int;
        precoCD decimal(10,2);
        qtdeMusicasCD int;
        rendaAutor decimal(10,2);
    begin
        for idmus in (select codmus from faixa where codcd = new.codcd) loop
            rendaAutor := 0;

            select codaut into idaut from musicaautor where codmus = idmus;
            select preco into precoCD from cd where codcd = new.codcd;
            select count(codmus) into qtdeMusicasCD from faixa where codcd = new.codcd;
            rendaAutor := ((precoCD / qtdeMusicasCD) * new.qtde);

            update autor
            set renda =  renda + rendaAutor
            where codaut = idaut;
        end loop;

        return new;
    end;
$$;

create or replace trigger tg_atualizaRendaAutor
    after insert or update on itemvenda
    for each row execute procedure atualizaRendaAutor();

alter table gravadora
    add column lucro numeric(10,2) default 0;

create or replace procedure atualizaGravadoraExistente()
    language plpgsql
as $$
    declare
        idcd int;
        idgrav int;
        totalIV decimal(10,2);
    begin
        for idgrav in (select codgrav from gravadora) loop
            for idcd in (select codcd from cd where codgrav = idgrav) loop
                select SUM(qtde * preco) into totalIV from itemvenda where codcd = idcd;
                    update gravadora
                        set lucro = lucro + (totalIV * 0.40)
                        where codgrav = idgrav;
            end loop;
        end loop;
    end;
$$;

call atualizaGravadoraExistente();

create or replace function atualizaGravadora() returns trigger
    language plpgsql
as $$
    declare
        idgrav int;
    begin
        select codgrav into idgrav from cd where codcd = new.codcd;
        update gravadora
            set lucro =  lucro + (new.qtde * new.preco * 0.4)
            where codgrav = idgrav;
    end;
$$;

create or replace trigger tg_atualizaGravadora
    after update or insert on itemvenda
    for each row execute procedure atualizaGravadora();