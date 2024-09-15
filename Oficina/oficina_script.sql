drop schema if exists oficina cascade;
create schema oficina;
set search_path to oficina;

CREATE TABLE caixa(
    cai_data DATE NOT NULL,
    cai_valor_inicial DECIMAL(10,2) NOT NULL,
    cai_valor_final DECIMAL(10,2) DEFAULT 0,
    PRIMARY KEY (cai_data)
);

create table cliente (
	cli_codigo INT NOT NULL,
    cli_nome VARCHAR(60) NOT NULL,
    cli_telefone VARCHAR(20) NOT NULL,
    cli_cpf VARCHAR(20),
    PRIMARY KEY (cli_codigo)
);

CREATE TABLE fornecedor(
    for_codigo INT NOT NULL,
    for_razao_social VARCHAR(60) NOT NULL,
    for_telefone VARCHAR(20) NOT NULL,
    for_cnpj VARCHAR(30) NOT NULL,
    PRIMARY KEY (for_codigo)
);

CREATE TABLE funcionario(
    fun_codigo INT NOT NULL,
    fun_nome VARCHAR(60) NOT NULL,
    fun_telefone VARCHAR(20) NOT NULL,
    fun_cpf VARCHAR (20) NOT NULL,
    PRIMARY KEY (fun_codigo)
);

CREATE TABLE peca (
    pec_codigo INT NOT NULL,
    pec_descricao VARCHAR(50) NOT NULL,
    pec_valor DECIMAL(10,2) NOT NULL,
    pec_estoque INT NOT NULL,
    PRIMARY KEY (pec_codigo)
);

CREATE TABLE servico (
    ser_codigo INT NOT NULL,
    ser_descricao VARCHAR(100) NOT NULL,
    ser_valor DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (ser_codigo)
);

CREATE TABLE venda(
    ven_codigo INT NOT NULL,
    ven_data DATE NOT NULL,
    ven_valor DECIMAL(10,2) DEFAULT 0,
    PRIMARY KEY (ven_codigo)
);

CREATE TABLE compra(
    com_codigo INT NOT NULL,
    for_codigo INT NOT NULL,
    com_data DATE NOT NULL,
    com_valor DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (com_codigo),
    FOREIGN KEY (for_codigo) REFERENCES fornecedor (for_codigo)
);

CREATE TABLE veiculo (
	vei_codigo INT NOT NULL,
    cli_codigo INT NOT NULL,
    vei_marca VARCHAR(60) NOT NULL,
    vei_modelo VARCHAR(60) NOT NULL,
    vei_ano_fabricacao VARCHAR(10) NOT NULL,
    PRIMARY KEY (vei_codigo),
    FOREIGN KEY (cli_codigo) REFERENCES cliente (cli_codigo)
);

CREATE TABLE despesa(
    des_codigo INT NOT NULL,
    cai_data DATE NOT NULL,
    fun_codigo INT,
    des_valor DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (des_codigo),
    FOREIGN KEY (cai_data) REFERENCES caixa (cai_data),
    FOREIGN KEY (fun_codigo) REFERENCES funcionario (fun_codigo)
);

CREATE TABLE orcamento (
	orc_codigo INT NOT NULL,
    vei_codigo INT NOT NULL,
    cli_codigo INT,
    cli_cpf VARCHAR(20),
    cli_nome VARCHAR(60),
    cli_telefone VARCHAR(20),
    orc_data_validade DATE NOT NULL,
    orc_data_aprovacao DATE DEFAULT NULL,
    orc_valor DECIMAL(10,2) DEFAULT 0,
    orc_valor_adicional DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (orc_codigo),
    FOREIGN KEY (vei_codigo) REFERENCES veiculo (vei_codigo),
    FOREIGN KEY (cli_codigo) REFERENCES cliente (cli_codigo)
);

CREATE TABLE pagamento(
    pag_codigo INT NOT NULL,
    com_codigo INT NOT NULL,
    cai_data DATE NOT NULL,
    pag_data DATE NOT NULL,
    pag_valor DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (pag_codigo),
    FOREIGN KEY (com_codigo) REFERENCES compra (com_codigo),
    FOREIGN KEY (cai_data) REFERENCES caixa (cai_data)
);

CREATE TABLE peca_compra(
    pec_codigo INT NOT NULL,
    com_codigo INT NOT NULL,
    pc_quantidade INT NOT NULL,
    PRIMARY KEY (pec_codigo, com_codigo),
    FOREIGN KEY (pec_codigo) REFERENCES peca (pec_codigo),
    FOREIGN KEY (com_codigo) REFERENCES compra (com_codigo)
);

CREATE TABLE peca_orcamento(
    pec_codigo INT NOT NULL,
    orc_codigo INT NOT NULL,
    po_quantidade INT NOT NULL,
    PRIMARY KEY (pec_codigo, orc_codigo),
    FOREIGN KEY (pec_codigo) REFERENCES peca (pec_codigo),
    FOREIGN KEY (orc_codigo) REFERENCES orcamento (orc_codigo)
);

CREATE TABLE peca_venda(
    pec_codigo INT NOT NULL,
    ven_codigo INT NOT NULL,
    pv_quantidade INT NOT NULL,
    PRIMARY KEY (pec_codigo, ven_codigo),
    FOREIGN KEY (pec_codigo) REFERENCES peca (pec_codigo),
    FOREIGN KEY (ven_codigo) REFERENCES venda (ven_codigo)
);

CREATE TABLE servico_orcamento(
	ser_codigo INT NOT NULL,
    orc_codigo INT NOT NULL,
    PRIMARY KEY (ser_codigo, orc_codigo),
    FOREIGN KEY (ser_codigo) REFERENCES servico (ser_codigo),
    FOREIGN KEY (orc_codigo) REFERENCES orcamento (orc_codigo)
);

CREATE TABLE recebimento(
    rec_codigo INT NOT NULL,
    orc_codigo INT NOT NULL,
    ven_codigo INT,
    cai_data DATE NOT NULL,
    rec_data DATE NOT NULL,
    rec_valor DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (rec_codigo),
    FOREIGN KEY (ven_codigo) REFERENCES venda (ven_codigo),
    FOREIGN KEY (cai_data) REFERENCES caixa (cai_data),
    FOREIGN KEY (orc_codigo) REFERENCES orcamento (orc_codigo)
);