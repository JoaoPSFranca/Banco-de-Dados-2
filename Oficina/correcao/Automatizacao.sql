set search_path to oficina;

-- Controle de Caixa
CREATE OR REPLACE FUNCTION atualiza_caixa() RETURNS TRIGGER
    LANGUAGE plpgsql
AS $$
begin
    if (TG_OP = 'INSERT') then
        new.saldo = new.valor_abertura;
    elsif (TG_OP = 'UPDATE') then
        new.saldo = new.entradas - new.saidas;
    end if;

    return new;
end;
$$;

CREATE OR REPLACE TRIGGER tg_caixa
    AFTER INSERT OR UPDATE OR DELETE on caixa
    FOR EACH ROW EXECUTE PROCEDURE atualiza_caixa();

-- Controle de Despesas
CREATE OR REPLACE FUNCTION atualiza_despesa() RETURNS TRIGGER
    LANGUAGE plpgsql
AS $$
declare total DECIMAL(10,2); caiValor DECIMAL(10,2);
begin
    select c.saldo into caiValor from caixa c where c.idcaixa = new.idcaixa;

    if (TG_OP = 'DELETE') then
        total := -(old.valor);
    elsif (caiValor > (new.valor - old.valor)) then
        if (TG_OP = 'INSERT') then
            total := new.valor;
        else
            total := (new.valor - old.valor);
        end if;
    else
        total := caiValor;
    end if;

    update caixa c
    set saidas = c.saidas - total
    where c.idcaixa = old.idcaixa;

    return new;
end;
$$;

CREATE OR REPLACE TRIGGER tg_despesa
    AFTER INSERT OR UPDATE OR DELETE on despesa
    FOR EACH ROW EXECUTE PROCEDURE atualiza_despesa();

-- Controle de Pagamento
CREATE OR REPLACE FUNCTION atualiza_pagamento() RETURNS TRIGGER
    LANGUAGE plpgsql
AS $$
declare total DECIMAL(10,2); caiValor DECIMAL(10,2);
begin
    select c.saldo into caiValor from caixa c where c.idcaixa = new.idcaixa;

    if (TG_OP = 'DELETE') then
        total := -(old.valor);
    elsif (caiValor > (new.valor - old.valor)) then
        if (TG_OP = 'INSERT') then
            total := new.valor;
        else
            total := (new.valor - old.valor);
        end if;
    else
        total := caiValor;
    end if;

    update caixa c
    set saidas = c.saidas - total
    where c.idcaixa = old.idcaixa;

    return new;
end;
$$;

CREATE OR REPLACE TRIGGER tg_pagamento
    AFTER INSERT OR UPDATE OR DELETE on pagamento
    FOR EACH ROW EXECUTE PROCEDURE atualiza_pagamento();

-- Controle de Recebimento
CREATE OR REPLACE FUNCTION atualiza_recebimento() RETURNS TRIGGER
    LANGUAGE plpgsql
AS $$
declare total DECIMAL(10,2); caiValor DECIMAL(10,2);
begin
    select saldo into caiValor from caixa c where c.idcaixa = new.idcaixa;

    if (TG_OP = 'INSERT') then
        total := new.valor;
    elsif (caiValor > (new.valor - old.valor)) then
        if (TG_OP = 'UPDATE') then
            total := (new.valor - old.valor);
        elsif (TG_OP = 'DELETE') then
            total := -old.valor;
        end if;
    else
        total := -(caiValor);
    end if;

    update caixa c
    set entradas = c.entradas + total
    where c.idcaixa = new.idcaixa;

    return new;
end;
$$;

CREATE OR REPLACE TRIGGER tg_recebimento
    AFTER INSERT OR UPDATE OR DELETE on recebimento
    FOR EACH ROW EXECUTE PROCEDURE atualiza_recebimento();

-- Cria uma venda a partir do orcamento
CREATE OR REPLACE PROCEDURE gerar_venda(codOrcamento int)
    LANGUAGE plpgsql
AS $$
declare
    codPeca INT;
    codVenda INT;
    qtde INT;
    valor DECIMAL(10,2);
begin
    select COALESCE(max(idvenda), 0) + 1 into codVenda from venda;
    insert into venda values (codVenda, current_date, 0);

    for codPeca in (select idpeca from peca_orcamento where idorcamento = codOrcamento) loop
            select quantidade into qtde
            from peca_orcamento
            where idorcamento = codOrcamento and
                idpeca = codPeca;

            select preco into valor from peca
            where idpeca = codPeca;

            insert into peca_vendida values (codPeca, codVenda, qtde, valor);
        end loop;
end;
$$;

CREATE OR REPLACE FUNCTION atualiza_codigo_cliente(
    name VARCHAR(80),
    cp VARCHAR(15),
    tel VARCHAR(20))
    RETURNS INT LANGUAGE plpgsql
AS $$
declare codCli INT;
begin
    select idcliente into codCli from cliente where cpf = cp;

    if (codCli is null) then
        select max(idcliente) + 1 into codCli from cliente;
        insert into cliente values (codCli, cp, tel, name);
    end if;

    return codCli;
end;
$$;

-- Controle de Orcamento
CREATE OR REPLACE FUNCTION atualiza_orcamento() RETURNS TRIGGER
    LANGUAGE plpgsql
AS $$
declare
    texto text;
begin
    if (TG_OP <> 'DELETE') then
        if (new.data_aprovacao is not null && old.data_aprovacao is null) then
            call gerar_venda(new.idorcamento);
        end if;

        if (TG_OP = 'INSERT') then
            new.valor := 0.0;

            if (new.idcliente IS NULL) then
                new.idcliente := atualiza_codigo_cliente(new.cli_nome, new.cli_cpf, new.cli_telefone);
            end if;

            if (new.cli_cpf is null) then
                select cli_cpf into texto from cliente c where c.idcliente = new.idcliente;
                new.cli_cpf := texto;
            end if;

            if (new.cli_nome is null) then
                select cli_nome into texto from cliente c where c.idcliente = new.idcliente;
                new.cli_nome := texto;
            end if;

            if (new.cli_telefone is null) then
                select cli_telefone into texto from cliente c where c.idcliente = new.idcliente;
                new.cli_telefone := texto;
            end if;
        end if;
    end if;

    return new;
end;
$$;

CREATE OR REPLACE TRIGGER tg_peca
    AFTER INSERT OR UPDATE OR DELETE ON orcamento
    FOR EACH ROW EXECUTE PROCEDURE atualiza_orcamento();

-- Controle do Peca_compra
CREATE OR REPLACE FUNCTION atualiza_peca_compra() RETURNS TRIGGER
    LANGUAGE plpgsql
AS $$
declare valor decimal(10,2); total decimal(10,2); quant int;
begin
    select p.preco into valor from peca p where p.idpeca = new.idpeca;

    if (TG_OP = 'INSERT') then
        total := (valor * new.quantidade_comprada);
        quant := new.quantidade_atendida;
    elsif (TG_OP = 'UPDATE') then
        total := (valor * new.quantidade_comprada) - (valor * old.quantidade_comprada);
        quant := (new.quantidade_atendida) - (old.quantidade_atendida);
    else
        total := -(valor * old.quantidade_comprada);
        quant := -(old.quantidade_atendida);
    end if;

    update compra
    set valortotal = valortotal + total
    where idcompra = new.idcompra or
        idcompra = old.idcompra;

    update peca
    set estoque = estoque + quant
    where idpeca = new.idpeca or
        idpeca = old.idpeca;

    return new;
end;
$$;

CREATE OR REPLACE TRIGGER tg_peca_compra
    AFTER INSERT OR UPDATE OR DELETE ON peca_compra
    FOR EACH ROW EXECUTE PROCEDURE atualiza_peca_compra();

-- Controle do peca_orcamento
CREATE OR REPLACE FUNCTION atualiza_peca_orcamento() RETURNS TRIGGER
    LANGUAGE plpgsql
AS $$
declare valor decimal(10,2); total decimal(10,2);
begin
    select p.preco into valor from peca p where p.idpeca = new.idpeca;

    if (TG_OP = 'INSERT') then
        total := (preco * new.quantidade);
    elsif (TG_OP = 'UPDATE') then
        total := (preco * new.quantidade) - (preco * old.quantidade);
    else
        total := -(preco * old.quantidade);
    end if;

    update orcamento
    set valor = valor + total
    where idorcamento = new.idorcamento or
        idorcamento = old.idorcamento;

    return new;
end;
$$;

CREATE OR REPLACE TRIGGER tg_peca_orcamento
    AFTER INSERT OR UPDATE OR DELETE ON peca_orcamento
    FOR EACH ROW EXECUTE PROCEDURE atualiza_peca_orcamento();

-- Controle do peca_venda
CREATE OR REPLACE FUNCTION atualiza_peca_venda() RETURNS TRIGGER
    LANGUAGE plpgsql
AS $$
declare valor decimal(10,2); total decimal(10,2); quant int;
begin
    select p.preco into valor from peca p where p.idpeca = new.idpeca;

    if (TG_OP = 'INSERT') then
        total := (valor * new.quantidade);
        quant := new.quantidade;
    elsif (TG_OP = 'UPDATE') then
        total := (valor * new.quantidade) - (valor * old.quantidade);
        quant := (new.quantidade) - (old.quantidade);
    else
        total := -(valor * old.quantidade);
        quant := -(old.quantidade);
    end if;

    update venda
    set valortotal = valortotal + total
    where idvenda = new.idvenda or
        idvenda = old.idvenda;

    update peca
    set estoque = estoque - quant
    where idpeca = new.idpeca or
        idpeca = old.idpeca;

    return new;
end;
$$;

CREATE OR REPLACE TRIGGER tg_peca_venda
    AFTER INSERT OR UPDATE OR DELETE ON peca_vendida
    FOR EACH ROW EXECUTE PROCEDURE atualiza_peca_venda();

-- Controle do servico_orcamento
CREATE OR REPLACE FUNCTION atualiza_servico_orcamento() RETURNS TRIGGER
    LANGUAGE plpgsql
AS $$
declare valor decimal(10,2);
begin
    select s.preco into valor from servico s where s.idservico = new.idservico;

    if (TG_OP = 'DELETE') then
        valor := -valor;
    end if;

    update orcamento
    set valor = valor + valor
    where idorcamento = new.idorcamento or
        idorcamento = old.idorcamento;

    return new;
end;
$$;

CREATE OR REPLACE TRIGGER tg_servico_orcamento
    AFTER INSERT OR UPDATE OR DELETE ON servico_orcamento
    FOR EACH ROW EXECUTE PROCEDURE atualiza_servico_orcamento();
