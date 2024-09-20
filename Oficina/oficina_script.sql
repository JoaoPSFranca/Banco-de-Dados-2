drop schema if exists oficina cascade ;
create schema oficina;
set search_path to oficina;

CREATE TABLE cliente (
    idcliente SERIAL PRIMARY KEY,
    cpf VARCHAR(45) NOT NULL UNIQUE,
    email VARCHAR(45) NOT NULL UNIQUE,
    nome VARCHAR(45) NOT NULL
);

CREATE TABLE veiculos (
    idveiculos SERIAL PRIMARY KEY,
    placa VARCHAR(45) NOT NULL UNIQUE,
    marca VARCHAR(45) NOT NULL,
    modelo VARCHAR(45) NOT NULL
);

CREATE TABLE pecas (
    idpecas SERIAL PRIMARY KEY,
    valor VARCHAR(45) NOT NULL,
    descricao VARCHAR(45) NOT NULL,
    estoque INT NOT NULL
);

CREATE TABLE servicos (
    idservicos SERIAL PRIMARY KEY,
    valor DECIMAL(10,2) NOT NULL,
    descricao VARCHAR(45) NOT NULL
);

CREATE TABLE funcionario (
    idfuncionario SERIAL PRIMARY KEY,
    nome VARCHAR(45) NOT NULL,
    cpf VARCHAR(45) NOT NULL UNIQUE,
    telefone VARCHAR(45) NOT NULL
);

CREATE TABLE orcamento (
    idorcamento SERIAL PRIMARY KEY,
    idveiculos INT NOT NULL,
    idfuncionario INT NOT NULL,
    idcliente INT NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    data_aprovacao DATE NOT NULL,
    data DATE NOT NULL,
    cpf VARCHAR(45) NOT NULL,
    nome_cliente VARCHAR(45) NOT NULL,
    status VARCHAR(20) NOT NULL,
    FOREIGN KEY (idveiculos) REFERENCES veiculos(idveiculos),
    FOREIGN KEY (idfuncionario) REFERENCES funcionario(idfuncionario),
    FOREIGN KEY (idcliente) REFERENCES cliente(idcliente)
);

CREATE TABLE venda (
    idvenda SERIAL PRIMARY KEY,
    idorcamento INT,
    valor DECIMAL(10,2) NOT NULL,
    data DATE NOT NULL,
    FOREIGN KEY (idorcamento) REFERENCES orcamento(idorcamento)
);

CREATE TABLE caixa (
    idcaixa SERIAL PRIMARY KEY,
    idfuncionario INT NOT NULL,
    valor_abertura DECIMAL(10,2) NOT NULL,
    valor_fechamento DECIMAL(10,2) NOT NULL,
    saldo DECIMAL(10,2) NOT NULL,
    entradas DECIMAL(10,2) NOT NULL,
    saidas DECIMAL(10,2) NOT NULL,
    data_abertura DATE NOT NULL,
    data_fechamento DATE NOT NULL,
    FOREIGN KEY (idfuncionario) REFERENCES funcionario(idfuncionario)
);

CREATE TABLE fornecedor (
    idfornecedor SERIAL PRIMARY KEY,
    razao_social VARCHAR(45) NOT NULL,
    cnpj VARCHAR(20) NOT NULL UNIQUE,
    telefone VARCHAR(15) NOT NULL
);

CREATE TABLE compra (
    idcompra SERIAL PRIMARY KEY,
    idfornecedor INT NOT NULL,
    data DATE NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (idfornecedor) REFERENCES fornecedor(idfornecedor)
);

CREATE TABLE recebimento (
    idrecebimento SERIAL PRIMARY KEY,
    idorcamento INT,
    idcaixa INT,
    data DATE NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (idorcamento) REFERENCES orcamento(idorcamento),
    FOREIGN KEY (idcaixa) REFERENCES caixa(idcaixa)
);

CREATE TABLE pagamento (
    idpagamento SERIAL PRIMARY KEY,
    idcompra INT NOT NULL,
    idcaixa INT NOT NULL,
    data DATE NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (idcompra) REFERENCES compra(idcompra),
    FOREIGN KEY (idcaixa) REFERENCES caixa(idcaixa)
);

CREATE TABLE despesas (
    iddespesas SERIAL PRIMARY KEY,
    idcaixa INT NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    descricao VARCHAR(45) NOT NULL,
    data DATE NOT NULL,
    funcionario_idfuncionario INT,
    FOREIGN KEY (idcaixa) REFERENCES caixa(idcaixa),
    FOREIGN KEY (funcionario_idfuncionario) REFERENCES funcionario(idfuncionario)
);

CREATE TABLE orc_pecas (
    idorcamento INT,
    idpecas INT,
    qtd INT,
    preco DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (idorcamento, idpecas),
    FOREIGN KEY (idorcamento) REFERENCES orcamento(idorcamento),
    FOREIGN KEY (idpecas) REFERENCES pecas(idpecas)
);

CREATE TABLE orc_serv (
    idorcamento INT,
    idservicos INT,
    preco DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (idorcamento, idservicos),
    FOREIGN KEY (idorcamento) REFERENCES orcamento(idorcamento),
    FOREIGN KEY (idservicos) REFERENCES servicos(idservicos)
);

CREATE TABLE peca_compra (
    idpecas INT,
    idcompra INT,
    qtd INT,
    preco DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (idpecas, idcompra),
    FOREIGN KEY (idpecas) REFERENCES pecas(idpecas),
    FOREIGN KEY (idcompra) REFERENCES compra(idcompra)
);

CREATE TABLE peca_venda (
    idpecas INT,
    idvenda INT,
    qtd INT,
    preco DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (idpecas, idvenda),
    FOREIGN KEY (idpecas) REFERENCES pecas(idpecas),
    FOREIGN KEY (idvenda) REFERENCES venda(idvenda)
);

CREATE TABLE venda_caixa (
    venda_idvenda INT,
    caixa_idcaixa INT,
    PRIMARY KEY (venda_idvenda, caixa_idcaixa),
    FOREIGN KEY (venda_idvenda) REFERENCES venda(idvenda),
    FOREIGN KEY (caixa_idcaixa) REFERENCES caixa(idcaixa)
);