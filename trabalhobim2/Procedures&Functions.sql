set search_path to trabalhobim2;

create or replace function contar_cidade (estado varchar(3))
    returns integer
    language plpgsql
as $$
    begin
        return (select count(id_cidade)
                from cidade
                where uf = estado);
    end;
$$;

create or replace function ceps_disponiveis (cep_dado integer)
    returns text
    language plpgsql
as $$
    declare
        cep_minimo integer;
        cep_maximo integer;
        cidade_cep varchar (100);
    begin
        select c.cidade into cidade_cep
        from cidade c
            inner join endereco e
                on c.id_cidade = e.id_cidade
        where e.cep = cep_dado;

        if (cidade_cep is null) then
            return 'CEP não encontrado';
        end if;

        select
            coalesce(
                (select cep from geo
                where cep > cep_dado
                order by cep limit 1),
                cep_dado)
        into cep_maximo;

        select
            coalesce(
                (select cep from geo
                 where cep < cep_dado
                 order by cep desc limit 1),
                 0)
        into cep_minimo;

        return format('CEP: %s, Cidade: %s, Quantidade de CEPs disponíveis: %s',
                      cep_minimo, cidade_cep, (cep_maximo - cep_minimo - 1));
    end;
$$;

create or replace function pre_cliente()
    returns trigger
    language plpgsql
as $$
    declare
        cidade_alvo text;
        bairro_alvo text;
        estado_alvo text;
        local_alvo text;
        ibge_alvo text;
    begin
        select
            c.cidade,
            b.bairro,
            c.uf,
            e.local,
            c.cod_ibge
            into
                cidade_alvo,
                bairro_alvo,
                estado_alvo,
                local_alvo,
                ibge_alvo
        from cidade c
            inner join endereco e
                on c.id_cidade = e.id_cidade
            inner join bairro b
                on c.id_cidade = b.id_cidade
        where e.cep = new.cep;

        if (cidade_alvo is null) or (bairro_alvo is null) then
            raise exception 'CEP incorreto';
        end if;

        new.nomecidade := cidade_alvo;
        new.nomebairro := bairro_alvo;
        new.estado := estado_alvo;
        new.local := local_alvo;
        new.codigoibge := ibge_alvo;

        return new;
    end;
$$;

create or replace trigger tg_pre_cliente
    before insert or update on cliente
    for each row execute procedure pre_cliente();

create or replace function pre_venda()
    returns trigger
    language plpgsql
as $$
    declare
        limite numeric;
        statusCliente text;
        cep_val integer;
    begin
        select limitecomprafiado, status into limite, statusCliente from cliente where idcliente = new.idcliente;

        if (limite < 0) or (upper(statusCliente) = 'B') then
            raise exception 'Cliente não habilitado para compra';
        end if;

        select cep into cep_val from geo where cep = new.cep;

        if (cep_val is null) then
            raise exception 'CEP inválido';
        end if;

        return new;
    end;
$$;

create or replace trigger tg_pre_venda
    before insert on venda
    for each row execute procedure pre_venda();

create or replace function pos_venda()
    returns trigger
    language plpgsql
as $$
    declare
        limite numeric;
        compra numeric;
        lanc integer;
        saldo numeric;
        total numeric;
        res_ano integer;
    begin
        if old.valortotal is null then
            compra := new.valortotal;
        else
            compra := new.valortotal - old.valortotal;
        end if;

        if (new.datapagamento is not null and old.datapagamento is null) then
            res_ano := extract(year from new.datapagamento);

            select sum(valortotal) into saldo
            from venda
            where datapagamento = new.datapagamento;

            select (coalesce(max(lancamento), 0) + 1)
            into lanc
            from resumo_diario
            where ano = res_ano;

            insert into resumo_diario (ano, lancamento, datapagamento, numerovenda, valorrecebido, saldododia)
            values (res_ano, lanc, new.datapagamento, new.numero, new.valortotal,saldo);

            compra := -(compra);
        end if;

        if old.valortotal is null then
            total := new.valortotal;
        else
            total := new.valortotal - old.valortotal;
        end if;

        update cliente
        set totalcomprado = totalcomprado + total,
            limitecomprafiado = limitecomprafiado - compra
        where idcliente = new.idcliente;

        if (tg_op = 'INSERT') then
            update cliente
            set quantidadevendas = quantidadevendas + 1
            where idcliente = new.idcliente;
        end if;

        select limitecomprafiado into limite from cliente where idcliente = new.idcliente;

        if (limite < 0) then
            update cliente
            set status = 'B'
            where idcliente = new.idcliente;
        end if;

        return new;
    end;
$$;

create or replace trigger tg_pos_venda
    after insert or update on venda
    for each row execute procedure pos_venda();

create or replace function pos_item_venda()
    returns trigger
    language plpgsql
as $$
    declare
        valorItens numeric;
        quant integer;
    begin
        if old.quantidade is null then
            quant := new.quantidade;
        else
            quant := (new.quantidade - old.quantidade);
        end if;

        if old.valor is null then
            valorItens := new.valor;
        else
            valorItens := new.valor - old.valor;
        end if;

        update venda
        set valortotal = valortotal + valorItens
        where idvenda = new.idvenda;

        update produto
        set qtdeestoque = qtdeestoque - quant
        where idproduto = new.idproduto;

        return new;
    end;
$$;

create or replace trigger tg_pos_item_venda
    after insert or update on itemvenda
    for each row execute procedure pos_item_venda();

create function gerarresumodiario() returns trigger
    language plpgsql
as $$
    declare
        anoAux          int;
        numeroVendaAux  int;
        valorRecebidoAux decimal(10,2);
        saldoAux         decimal(10,2);
        qtdelancamentoAux int;
    begin
        if(TG_OP = 'UPDATE') then
            anoAux := extract(year from new.datapagamento);
            numeroVendaAux := new.numero;
            valorRecebidoAux := new.valortotal;
            select sum(valortotal) from venda where datapagamento = new.datapagamento into saldoAux;

            select coalesce(max(lancamento), 0) from resumo_diario where ano = anoAux into qtdelancamentoAux;
            qtdelancamentoAux := qtdelancamentoAux + 1;

            insert into resumo_diario (ano, lancamento, datapagamento, numerovenda, valorrecebido, saldododia)
            values (anoAux, qtdelancamentoAux, new.datapagamento, numeroVendaAux, valorRecebidoAux, saldoAux);
            return new;
        end if;
        return null;
    end
$$;


create or replace procedure inserir_cliente (cli_nome text, cli_telefone text,
                                  cli_cep integer, cli_numero integer)
    language plpgsql
as $$
    begin
        insert into cliente(nome, telefone, cep, numero)
        values(cli_nome, cli_telefone, cli_cep, cli_numero);
    end;
$$;

create or replace procedure inserir_venda (cli_codigo integer,
                                ven_cep integer,
                                ven_numero integer)
    language plpgsql
as $$
    begin
        insert into venda (idcliente, cep, numero, datavenda)
        values (cli_codigo, ven_cep, ven_numero, current_date);
    end;
$$;

create or replace procedure inserir_itemvenda (ven_codigo integer, pro_codigo integer,
                                    iv_quantidade integer)
    language plpgsql
as $$
    declare
        iv_valor numeric;
        pro_valor numeric;
    begin
        select precovenda into pro_valor from produto where idproduto = pro_codigo;

        iv_valor := iv_quantidade * pro_valor;

        insert into itemvenda(idvenda, idproduto, quantidade, valor)
        values (ven_codigo, pro_codigo, iv_quantidade, iv_valor);

    end;
$$;

create or replace procedure inserir_produto (pro_estoque integer, pro_custo numeric,
                                  pro_lucro numeric)
    language plpgsql
as $$
    declare
        pro_preco_venda numeric;
    begin
        pro_preco_venda := pro_custo * ((pro_lucro / 100) + 1);

        insert into produto(qtdeestoque, precocusto, percentuallucro, precovenda)
        values (pro_estoque, pro_custo, pro_lucro, pro_preco_venda);
    end;
$$;

create or replace view exibir_venda as
    select
        v.idvenda as Código,
        v.idcliente as Codigo_cliente,
        v.cep as cep,
        v.numero as numero,
        v.valortotal as valor,
        v.datavenda as data,
        v.datapagamento as pagamento,
        c.nome as cliente,
        c.nomecidade as cidade,
        c.estado as uf,
        c.nomebairro as bairro,
        c.local as endereço
    from venda v
             inner join cliente c
                        on c.idcliente = v.idcliente;
