drop database if exists oficina;
create database oficina;
use oficina;

create table cliente (
	cli_codigo INT,
    cli_nome VARCHAR(60) NOT NULL,
    cli_telefone VARCHAR(20) NOT NULL,
    cli_cpf VARCHAR(20) NOT NULL,
    PRIMARY KEY (cli_codigo)
);

CREATE TABLE veiculo (
	vei_codigo INT,
    cli_codigo INT NOT NULL,
    vei_marca VARCHAR(60) NOT NULL,
    vei_modelo VARCHAR(60) NOT NULL,
    vei_anoFabricacao VARCHAR(10) NOT NULL,
    PRIMARY KEY (vei_codigo),
    FOREIGN KEY (cli_codigo) REFERENCES cliente (cli_codigo)
);

CREATE TABLE servico (
	ser_codigo INT,
    ser_descricao VARCHAR(100),
    ser_valor DECIMAL(10,2),
    PRIMARY KEY (ser_codigo)
);

CREATE TABLE peca (
	pec_codigo INT,
    pec_descricao VARCHAR(50),
    pec_valor DECIMAL(10,2),
    PRIMARY KEY (pec_codigo)
);

CREATE TABLE orcamento (
	orc_codigo INT,
    vei_codigo INT NOT NULL,
    cli_codigo INT,
    cli_nome VARCHAR(60),
    cli_telefone VARCHAR(20),
    orc_dataValidade DATE NOT NULL,
    orc_dataAprovacao DATE DEFAULT NULL,
    orc_valor DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (orc_codigo),
    FOREIGN KEY (vei_codigo) REFERENCES veiculo (vei_codigo),
    FOREIGN KEY (cli_codigo) REFERENCES cliente (cli_codigo)
);

CREATE TABLE servico_orcamento(
	ser_codigo INT,
    orc_codigo INT,
    PRIMARY KEY (ser_codigo, orc_codigo),
    FOREIGN KEY (ser_codigo) REFERENCES servico (ser_codigo),
    FOREIGN KEY (orc_codigo) REFERENCES orcamento (orc_codigo)
);

CREATE TABLE peca_orcamento(
	pec_codigo INT,
    orc_codigo INT,
    PRIMARY KEY (pec_codigo, orc_codigo),
    FOREIGN KEY (pec_codigo) REFERENCES peca (pec_codigo),
    FOREIGN KEY (orc_codigo) REFERENCES orcamento (orc_codigo)
);

CREATE TABLE fornecedor(
	for_codigo INT,
    for_razao_social VARCHAR(60),
    for_cnpj VARCHAR(30),
    for_telefone VARCHAR(20),
    PRIMARY KEY (for_codigo)
);

CREATE TABLE compra(
	com_codigo INT,
    for_codigo INT,
    com_data DATE,
    PRIMARY KEY (com_codigo),
    FOREIGN KEY (for_codigo) REFERENCES fornecedor (for_codigo)
);

CREATE TABLE peca_compra(
	pec_codigo INT,
    com_codigo INT,
    PRIMARY KEY (pec_codigo, com_codigo),
    FOREIGN KEY (pec_codigo) REFERENCES peca (pec_codigo),
    FOREIGN KEY (com_codigo) REFERENCES compra (com_codigo)
);