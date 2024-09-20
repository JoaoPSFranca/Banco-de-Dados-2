set search_path to oficina;

-- Controle de Caixa
CREATE OR REPLACE FUNCTION atualiza_caixa() RETURNS TRIGGER
    LANGUAGE plpgsql
AS $$
    begin
        if (TG_OP = 'INSERT') then
            new.cai_valor_final = new.cai_valor_inicial;
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
        select cai_valor_final into caiValor from caixa where cai_data = new.cai_data;

        if (TG_OP = 'DELETE') then
            total := -(old.des_valor);
        elsif (caiValor > (new.des_valor - old.des_valor)) then
            if (TG_OP = 'INSERT') then
                total := new.des_valor;
            else
                total := (new.des_valor - old.des_valor);
            end if;
        else
            total := caiValor;
        end if;

        update caixa
        set cai_valor_final = cai_valor_final - total
        where cai_data = old.cai_data;

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
        select cai_valor_final into caiValor from caixa where cai_data = new.cai_data;

        if (TG_OP = 'DELETE') then
            total := -old.pag_valor;
        elsif (caiValor > (new.pag_valor - old.pag_valor)) then
            if (TG_OP = 'INSERT') then
                total := new.pag_valor;
            else
                total := (new.pag_valor - old.pag_valor);
            end if;
        else
            total := caiValor;
        end if;

        update caixa
        set cai_valor_final = cai_valor_final - total
        where cai_data = old.cai_data;

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
        select cai_valor_final into caiValor from caixa where cai_data = new.cai_data;

        if (TG_OP = 'INSERT') then
            total := new.rec_valor;
        elsif (caiValor > (new.rec_valor - old.rec_valor)) then
            if (TG_OP = 'UPDATE') then
                total := (new.rec_valor - old.rec_valor);
            elsif (TG_OP = 'DELETE') then
               total := -old.rec_valor;
            end if;
        else
            total := -caiValor;
        end if;

        update caixa
        set cai_valor_final = cai_valor_final + total
        where cai_data = new.cai_data;

        return new;
    end;
$$;

CREATE OR REPLACE TRIGGER tg_recebimento
    AFTER INSERT OR UPDATE OR DELETE on recebimento
    FOR EACH ROW EXECUTE PROCEDURE atualiza_recebimento();

-- Cria uma venda a partir do orcamento
CREATE OR REPLACE PROCEDURE gerar_venda(idOrcamento int)
    LANGUAGE plpgsql
AS $$
    declare
        idpeca INT;
        idvenda INT;
        quantidade INT;
    begin
        select COALESCE(max(ven_codigo), 0) + 1 into idvenda from venda;
        insert into venda values (idvenda, current_date, 0);

        for idpeca in (select pec_codigo from peca_orcamento where orc_codigo = idOrcamento) loop
            select po_quantidade into quantidade
            from peca_orcamento
            where orc_codigo = idOrcamento and
                  pec_codigo = idpeca;

            insert into peca_venda values (idpeca, idvenda, quantidade);
        end loop;
    end;
$$;

CREATE OR REPLACE FUNCTION atualiza_codigo_cliente(
    idCli INT,
    cpf VARCHAR(20),
    nome VARCHAR(60),
    telefone VARCHAR(20)
) RETURNS INT
    LANGUAGE plpgsql
AS $$
    declare idCliente INT;
    begin
        select cli_codigo into idcliente from cliente where cli_cpf = cpf;

        if (idcliente is null) then
            select max(cli_codigo) + 1 into idcliente from cliente;
            insert into cliente values (idcliente, nome, telefone, cpf);
        end if;

        idCli := idcliente;

        return idCli;
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
            if (new.orc_data_aprovacao is not null) then
                call gerar_venda(new.orc_codigo);
            end if;

            if (TG_OP = 'INSERT') then
                new.orc_valor := new.orc_valor_adicional;

                if (new.cli_codigo IS NULL) then
                    new.cli_codigo := atualiza_codigo_cliente(new.cli_codigo, new.cli_cpf, new.cli_nome, new.cli_telefone);
                end if;

                if (new.cli_cpf is null) then
                    select cli_cpf into texto from cliente where cli_codigo = new.cli_codigo;
                    new.cli_cpf := texto;
                end if;

                if (new.cli_nome is null) then
                    select cli_nome into texto from cliente where cli_codigo = new.cli_codigo;
                    new.cli_nome := texto;
                end if;

                if (new.cli_telefone is null) then
                    select cli_telefone into texto from cliente where cli_codigo = new.cli_codigo;
                    new.cli_telefone := texto;
                end if;
            end if;
        end if;

        return new;
    end;
$$;

CREATE OR REPLACE TRIGGER tg_orcamento
    AFTER INSERT OR UPDATE OR DELETE ON orcamento
    FOR EACH ROW EXECUTE PROCEDURE atualiza_orcamento();

-- Controle do Peca_compra
CREATE OR REPLACE FUNCTION atualiza_peca_compra() RETURNS TRIGGER
    LANGUAGE plpgsql
AS $$
    declare preco decimal(10,2); total decimal(10,2); quant int;
    begin
        select pec_valor into preco from peca where pec_codigo = new.pec_codigo;

        if (TG_OP = 'INSERT') then
            total := (preco * new.pc_quantidade);
            quant := new.pc_quantidade;
        elsif (TG_OP = 'UPDATE') then
            total := (preco * new.pc_quantidade) - (preco * old.pc_quantidade);
            quant := (new.pc_quantidade) - (old.pc_quantidade);
        else
            total := -(preco * old.pc_quantidade);
            quant := -(old.pc_quantidade);
        end if;

        update compra
        set com_valor = com_valor + total
        where com_codigo = new.com_codigo or
              com_codigo = old.com_codigo;

        update peca
        set pec_estoque = pec_estoque - quant
        where pec_codigo = new.pec_codigo or
              pec_codigo = old.pec_codigo;

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
declare preco decimal(10,2); total decimal(10,2); quant int;
    begin
        select pec_valor into preco from peca where pec_codigo = new.pec_codigo;

        if (TG_OP = 'INSERT') then
            total := (preco * new.po_quantidade);
            quant := new.po_quantidade;
        elsif (TG_OP = 'UPDATE') then
            total := (preco * new.po_quantidade) - (preco * old.po_quantidade);
            quant := (new.po_quantidade) - (old.po_quantidade);
        else
            total := -(preco * old.po_quantidade);
            quant := -(old.po_quantidade);
        end if;

        update orcamento
        set orc_valor = orc_valor + total
        where orc_codigo = new.orc_codigo or
            orc_codigo = old.orc_codigo;

        update peca
        set pec_estoque = pec_estoque - quant
        where pec_codigo = new.pec_codigo or
            pec_codigo = old.pec_codigo;

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
declare preco decimal(10,2); total decimal(10,2); quant int;
    begin
        select pec_valor into preco from peca where pec_codigo = new.pec_codigo;

        if (TG_OP = 'INSERT') then
            total := (preco * new.pv_quantidade);
            quant := new.pv_quantidade;
        elsif (TG_OP = 'UPDATE') then
            total := (preco * new.pv_quantidade) - (preco * old.pv_quantidade);
            quant := (new.pv_quantidade) - (old.pv_quantidade);
        else
            total := -(preco * old.pv_quantidade);
            quant := -(old.pv_quantidade);
        end if;

        update venda
        set ven_valor = ven_valor + total
        where ven_codigo = new.ven_codigo or
            ven_codigo = old.ven_codigo;

        update peca
        set pec_estoque = pec_estoque - quant
        where pec_codigo = new.pec_codigo or
            pec_codigo = old.pec_codigo;

        return new;
    end;
$$;

CREATE OR REPLACE TRIGGER tg_peca_venda
    AFTER INSERT OR UPDATE OR DELETE ON peca_venda
    FOR EACH ROW EXECUTE PROCEDURE atualiza_peca_venda();

-- Controle do servico_orcamento
CREATE OR REPLACE FUNCTION atualiza_servico_orcamento() RETURNS TRIGGER
    LANGUAGE plpgsql
AS $$
declare preco decimal(10,2);
    begin
        select ser_valor into preco from servico where ser_codigo = new.ser_codigo;

        if (TG_OP = 'DELETE') then
            preco := -preco;
        end if;

        update orcamento
        set orc_valor = orc_valor + preco
        where orc_codigo = new.orc_codigo or
            orc_codigo = old.orc_codigo;

        return new;
    end;
$$;

CREATE OR REPLACE TRIGGER tg_servico_orcamento
    AFTER INSERT OR UPDATE OR DELETE ON servico_orcamento
    FOR EACH ROW EXECUTE PROCEDURE atualiza_servico_orcamento();
