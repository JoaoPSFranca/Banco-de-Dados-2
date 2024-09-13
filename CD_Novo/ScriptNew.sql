set search_path  to cd;

create table if not exists cliente(
    codcli INT,
    nome VARCHAR(60),
    endereco VARCHAR(50),
    cidade VARCHAR(50),
    uf VARCHAR(2),
    cep VARCHAR(9),
    PRIMARY KEY(codcli)
);

create table if not exists venda(
    idvenda INT,
    datavenda DATE,
    codcli INT,
    parcelas INT,
    PRIMARY KEY(idvenda),
    FOREIGN KEY(codcli) references cliente (codcli)
);

CREATE TABLE IF NOT EXISTS itemvenda(
    idvenda INT NOT NULL,
    codcd INT NOT NULL,
    qtde INT,
    preco NUMERIC(10,2),
    PRIMARY KEY (idvenda, codcd),
    FOREIGN KEY (codcd) references cd.cd (codcd),
    FOREIGN KEY (idvenda) references venda (idvenda)
);

create or replace procedure criarCliente()
    LANGUAGE plpgsql
as
$$
declare i int;
begin
    for i in 1..100 loop
        insert into cliente values (i, concat('xdxdGuixdxd', i), 'Rua Tapajos', 'rolandia', 'MG', '123456789');
    end loop;
end;
$$;

call criarCliente();

create or replace procedure criarVenda()
    LANGUAGE plpgsql
as
$$
declare contador int default 1;
        cliente int default 1;
begin
    for i in 1..1000 loop
        insert into venda values (i, current_date-contador, cliente, 0);
        cliente := cliente + 1;
        contador := contador + 1;
        if contador >= 100 then
            contador := 1;
        end if;
        if cliente > 100 then
            cliente := 1;
        end if;
    end loop;
end;
$$;

call criarVenda();
