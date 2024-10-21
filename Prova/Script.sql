drop schema if exists provabim1_correcao cascade;
create schema provabim1_correcao;
set search_path to provabim1_correcao;

CREATE TABLE usuario (
  idusuario SERIAL NOT NULL UNIQUE,
  nome VARCHAR(100) NULL DEFAULT NULL,
  email VARCHAR(100) NULL DEFAULT NULL,
  categoria VARCHAR(20) NULL DEFAULT NULL,
  limite_livros INT NULL DEFAULT NULL,
  qtde_livros_emprestados INT NULL,
  total_multas DECIMAL(10,2) NULL,
  PRIMARY KEY (idusuario)
);

CREATE TABLE emprestimo(
    idemprestimo SERIAL NOT NULL UNIQUE,
    data_emprestimo DATE NULL DEFAULT NULL,
    previsao_devolucao DATE NULL DEFAULT NULL,
    status VARCHAR(20) NULL DEFAULT NULL,
    idusuario INT NOT NULL,
    PRIMARY KEY (idemprestimo, idusuario),
    FOREIGN KEY (idusuario)
        REFERENCES usuario (idusuario)
);

CREATE TABLE historico_multas(
    idusuario INT NOT NULL,
    idmulta INT NOT NULL,
    valor DECIMAL(10,2) NULL DEFAULT NULL,
    data_multa DATE NULL DEFAULT current_date,
    data_pagamento DATE NULL,
    PRIMARY KEY (idusuario, idmulta),
    FOREIGN KEY (idusuario)
        REFERENCES usuario (idusuario)
);

CREATE TABLE IF NOT EXISTS livro (
    idlivro SERIAL NOT NULL UNIQUE,
    titulo VARCHAR(200) NULL DEFAULT NULL,
    autor VARCHAR(100) NULL DEFAULT NULL,
    qtdelivro INT NULL DEFAULT NULL,
    qtdedisponivel INT NULL,
    PRIMARY KEY (idlivro)
);

CREATE TABLE IF NOT EXISTS acervo (
    idlivro INT NOT NULL,
    idacervo INT NOT NULL,
    numeroisbn VARCHAR(20) NULL,
    status VARCHAR(1) NULL,
    PRIMARY KEY (idlivro, idacervo),
    FOREIGN KEY (idlivro)
        REFERENCES livro (idlivro)
);

CREATE TABLE IF NOT EXISTS itensemprestados (
    idemprestimo INT NOT NULL,
    iditem INT NOT NULL,
    datadevolucao DATE NULL,
    valormulta DECIMAL(10,2) NULL,
    idlivro INT NOT NULL,
    idacervo INT NOT NULL,
    PRIMARY KEY (idemprestimo, iditem),
    FOREIGN KEY (idemprestimo)
        REFERENCES emprestimo (idemprestimo),
    FOREIGN KEY (idlivro , idacervo)
        REFERENCES acervo (idlivro, idacervo)
);
