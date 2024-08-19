DROP DATABASE IF EXISTS gerenciamentoBiblioteca;
CREATE DATABASE gerenciamentoBiblioteca;
USE gerenciamentoBiblioteca;

CREATE TABLE Cliente (
    cli_codigo INT AUTO_INCREMENT,
    cli_nome VARCHAR(100) NOT NULL,
    PRIMARY KEY (cli_codigo)
);

CREATE TABLE Autor (
    aut_codigo INT AUTO_INCREMENT,
    aut_nome VARCHAR(100) NOT NULL,
    PRIMARY KEY (aut_codigo)
);

CREATE TABLE Editora (
    edi_codigo INT AUTO_INCREMENT,
    edi_nome VARCHAR(70) NOT NULL,
    edi_endereco TEXT,
    edi_telefone VARCHAR(30),
    PRIMARY KEY (edi_codigo)
);

CREATE TABLE Categoria (
    cat_codigo INT AUTO_INCREMENT,
    cat_nome VARCHAR(50) NOT NULL,
    PRIMARY KEY (cat_codigo)
);

CREATE TABLE Livro (
    liv_codigo INT AUTO_INCREMENT,
    cat_codigo INT,
    edi_codigo INT,
    liv_titulo VARCHAR(60) NOT NULL,
    liv_quantidadeExemplar INT,
    liv_quantidadeEmprestimo INT,
    PRIMARY KEY (liv_codigo), 
    FOREIGN KEY (cat_codigo) REFERENCES Categoria(cat_codigo),
    FOREIGN KEY (edi_codigo) REFERENCES Editora(edi_codigo)
);

CREATE TABLE Exemplar (
    exe_codigo INT AUTO_INCREMENT,
    liv_codigo INT,
    exe_edicao INT,
    exe_data DATE,
    PRIMARY KEY (exe_codigo),
    FOREIGN KEY (liv_codigo) REFERENCES Livro(liv_codigo)
);

CREATE TABLE Emprestimo (
    emp_codigo INT AUTO_INCREMENT,
    cli_codigo INT,
    emp_data DATE,
    PRIMARY KEY (emp_codigo),
    FOREIGN KEY (cli_codigo) REFERENCES Cliente(cli_codigo)
);

CREATE TABLE Reserva (
    cli_codigo INT,
    liv_codigo INT,
    res_data DATE,
    PRIMARY KEY (cli_codigo, liv_codigo),
    FOREIGN KEY (cli_codigo) REFERENCES Cliente(cli_codigo),
    FOREIGN KEY (liv_codigo) REFERENCES Livro(liv_codigo)
);

CREATE TABLE Autores_Livros (
    aut_codigo INT,
    liv_codigo INT,
    PRIMARY KEY (aut_codigo, liv_codigo),
    FOREIGN KEY (aut_codigo) REFERENCES Autor(aut_codigo),
    FOREIGN KEY (liv_codigo) REFERENCES Livro(liv_codigo)
);

CREATE TABLE Emprestimo_Exemplar (
    emp_codigo INT,
    exe_codigo INT,
    ee_dataDevolucao DATE,
    PRIMARY KEY (emp_codigo, exe_codigo),
    FOREIGN KEY (emp_codigo) REFERENCES Emprestimo(emp_codigo),
    FOREIGN KEY (exe_codigo) REFERENCES Exemplar(exe_codigo)
);

INSERT INTO Cliente (cli_nome) 
VALUES ('Maria Silva'), ('João Santos'), ('Ana Pereira');

INSERT INTO Autor (aut_nome) 
VALUES ('Machado de Assis'), ('Clarice Lispector'), ('Jorge Amado');

INSERT INTO Editora (edi_nome, edi_endereco, edi_telefone) 
VALUES 	('Edelvives', 'Rua Rui Barbosa 156, Bela Vista, São Paulo', '0800 772 230'), 
		('Editora Rocco', 'Rua Evaristo da Veiga, Centro, Rio de Janeiro', '(21) 98556-2171'),
        ('Editora Moderna', 'Rua Padre Adelino, 758, Zona Leste, São Paulo', '0800 770 3004');

INSERT INTO Categoria (cat_nome) 
VALUES ('Romance'), ('Ficção Científica'), ('Biografia');

INSERT INTO Livro (cat_codigo, edi_codigo, liv_titulo, liv_quantidadeExemplar, liv_quantidadeEmprestimo) 
VALUES 	(1, 1, 'Dom Casmurro', 5, 2),
		(2, 2, 'A Hora da Estrela', 3, 1),
        (3, 3, 'Gabriela, Cravo e Canela', 4, 3);

INSERT INTO Exemplar (liv_codigo, exe_edicao, exe_data) 
VALUES 	(1, 6, '2022-02-09'), 
		(1, 7, '2023-01-22'),
        (2, 6, '2022-05-13'),
        (3, 4, '2023-03-27');

INSERT INTO Emprestimo (cli_codigo, emp_data) 
VALUES 	(1, '2024-07-01'),
		(1, '2024-08-05'),
		(2, '2024-07-15'),
        (3, '2024-08-07');

INSERT INTO Reserva (cli_codigo, liv_codigo, res_data) 
VALUES 	(1, 2, '2024-08-09'),
		(2, 3, '2024-08-15'),
        (3, 1, '2024-08-17');

INSERT INTO Autores_Livros (aut_codigo, liv_codigo) 
VALUES (1, 1), (2, 2), (3, 3);

INSERT INTO Emprestimo_Exemplar (emp_codigo, exe_codigo, ee_dataDevolucao) 
VALUES 	(1, 1, '2024-07-15'), 
		(2, 3, '2024-08-19'), 
        (3, 4, '2024-07-29'), 
        (4, 2, '2024-08-21');
