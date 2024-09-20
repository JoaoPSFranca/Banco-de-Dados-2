DROP SCHEMA IF EXISTS oficina CASCADE;
CREATE SCHEMA oficina;
SET search_path TO oficina;

CREATE TABLE cliente (
    idcliente SERIAL NOT NULL,
    cpf       VARCHAR(15) UNIQUE NOT NULL,
    telefone  VARCHAR(20) NOT NULL,
    nome      VARCHAR(80) NOT NULL,
    PRIMARY KEY (idcliente)
);

CREATE TABLE fornecedor (
    idfornecedor SERIAL NOT NULL,
    razaoSocial  VARCHAR(100) NOT NULL,
    cnpj         VARCHAR(20) UNIQUE NOT NULL,
    telefone     VARCHAR(20) NOT NULL,
    endereco     VARCHAR(100),
    PRIMARY KEY (idfornecedor)
);

CREATE TABLE veiculo (
    idveiculo SERIAL NOT NULL,
    modelo    VARCHAR(60) NOT NULL,
    marca     VARCHAR(60) NOT NULL,
    placa     VARCHAR(10) NOT NULL,
    PRIMARY KEY (idveiculo)
);

CREATE TABLE servico (
    idservico SERIAL NOT NULL,
    preco     DECIMAL(10, 2) NOT NULL,
    descricao VARCHAR(100) NOT NULL,
    PRIMARY KEY (idservico)
);

CREATE TABLE funcionario (
    idfuncionario SERIAL NOT NULL,
    nome          VARCHAR(80) NOT NULL,
    cpf           VARCHAR(15) UNIQUE NOT NULL,
    telefone      VARCHAR(20) NOT NULL,
    PRIMARY KEY (idfuncionario)
);

CREATE TABLE peca (
    idpeca    SERIAL NOT NULL,
    estoque   INT NOT NULL,
    preco     DECIMAL(10, 2) NOT NULL,
    descricao VARCHAR(100) NOT NULL,
    PRIMARY KEY (idpeca)
);

CREATE TABLE compra (
    idcompra     SERIAL NOT NULL,
    idfornecedor INT NOT NULL,
    data         DATE NOT NULL,
    valorTotal   DECIMAL(10, 2) DEFAULT 0,
    PRIMARY KEY (idcompra),
    FOREIGN KEY (idfornecedor)
        REFERENCES fornecedor (idfornecedor)
);

CREATE TABLE peca_compra (
    idpeca     INT NOT NULL,
    idcompra   INT NOT NULL,
    item       INT NOT NULL,
    quantidade_comprada INT NOT NULL,
    quantidade_atendida INT DEFAULT 0,
    preco      DECIMAL(10, 2),
    PRIMARY KEY (idpeca, idcompra),
    FOREIGN KEY (idpeca)
        REFERENCES peca (idpeca),
    FOREIGN KEY (idcompra)
        REFERENCES compra (idcompra)
);

CREATE TABLE orcamento (
    idorcamento    SERIAL NOT NULL,
    idveiculo      INT NOT NULL,
    idfuncionario  INT NOT NULL,
    idcliente      INT,
    valor          DECIMAL(10, 2) DEFAULT 0,
    data           DATE NOT NULL,
    data_validade  DATE NOT NULL,
    status         VARCHAR(20) DEFAULT 'pendente',
    data_aprovacao DATE DEFAULT NULL,
    cli_cpf        VARCHAR(20),
    cli_nome       VARCHAR(80),
    cli_telefone   VARCHAR(20),
    PRIMARY KEY (idorcamento),
    FOREIGN KEY (idveiculo)
        REFERENCES veiculo (idveiculo),
    FOREIGN KEY (idfuncionario)
        REFERENCES funcionario (idfuncionario),
    FOREIGN KEY (idcliente)
        REFERENCES cliente (idcliente)
);

CREATE TABLE venda (
    idvenda     SERIAL NOT NULL,
    idorcamento INT NOT NULL,
    valorTotal  DECIMAL(10, 2) DEFAULT 0,
    data        DATE NOT NULL,
    PRIMARY KEY (idvenda),
    FOREIGN KEY (idorcamento)
        REFERENCES orcamento (idorcamento)
);

CREATE TABLE peca_orcamento (
    idorcamento INT NOT NULL,
    idpeca      INT NOT NULL,
    quantidade  INT NOT NULL,
    preco       DECIMAL(10, 2) DEFAULT 0,
    PRIMARY KEY (idorcamento, idpeca),
    FOREIGN KEY (idorcamento)
        REFERENCES orcamento (idorcamento),
    FOREIGN KEY (idpeca)
        REFERENCES peca (idpeca)
);

CREATE TABLE peca_vendida (
    idpeca     INT NOT NULL,
    idvenda    INT NOT NULL,
    quantidade INT NOT NULL,
    preco      DECIMAL(10, 2) DEFAULT 0,
    PRIMARY KEY (idvenda, idpeca),
    FOREIGN KEY (idpeca)
        REFERENCES peca (idpeca),
    FOREIGN KEY (idvenda)
        REFERENCES venda (idvenda)
);

CREATE TABLE servico_orcamento (
    idorcamento INT NOT NULL,
    idservico   INT NOT NULL,
    preco       DECIMAL(10, 2) DEFAULT 0,
    PRIMARY KEY (idorcamento, idservico),
    FOREIGN KEY (idorcamento)
        REFERENCES orcamento (idorcamento),
    FOREIGN KEY (idservico)
        REFERENCES servico (idservico)
);

CREATE TABLE caixa (
    idcaixa          SERIAL NOT NULL,
    idfuncionario    INT NOT NULL,
    idvenda          INT,
    valor_abertura   DECIMAL(10, 2) NOT NULL,
    valor_fechamento DECIMAL(10, 2) DEFAULT 0,
    saldo            DECIMAL(10, 2) DEFAULT 0,
    entradas         DECIMAL(10, 2) DEFAULT 0,
    saidas           DECIMAL(10, 2) DEFAULT 0,
    data_abertura    DATE NOT NULL,
    data_fechamento  DATE DEFAULT NULL,
    PRIMARY KEY (idcaixa),
    FOREIGN KEY (idfuncionario)
        REFERENCES funcionario (idfuncionario),
    FOREIGN KEY (idvenda)
        REFERENCES venda (idvenda)
);

CREATE TABLE recebimento (
    idrecebimento SERIAL NOT NULL,
    idorcamento   INT NOT NULL,
    idcaixa       INT NOT NULL,
    data          DATE NOT NULL,
    valor         DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (idrecebimento, idorcamento),
    FOREIGN KEY (idorcamento)
        REFERENCES orcamento (idorcamento),
    FOREIGN KEY (idcaixa)
        REFERENCES caixa (idcaixa)
);

CREATE TABLE despesa (
    iddespesa     SERIAL NOT NULL,
    idcaixa       INT NOT NULL,
    idfuncionario INT,
    valor         DECIMAL(10, 2) NOT NULL,
    descricao     VARCHAR(100) NOT NULL,
    data          DATE NOT NULL,
    PRIMARY KEY (iddespesa),
    FOREIGN KEY (idcaixa)
        REFERENCES caixa (idcaixa),
    FOREIGN KEY (idfuncionario)
        REFERENCES funcionario (idfuncionario)
);

CREATE TABLE pagamento (
    idpagamento SERIAL NOT NULL,
    idcompra    INT NOT NULL,
    idcaixa     INT NOT NULL,
    data        DATE NOT NULL,
    valor       DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (idpagamento, idcompra),
    FOREIGN KEY (idcompra)
        REFERENCES compra (idcompra),
    FOREIGN KEY (idcaixa)
        REFERENCES caixa (idcaixa)
);

