DROP DATABASE IF EXISTS locacaoVeiculos;
CREATE DATABASE locacaoVeiculos;
USE locacaoVeiculos;

CREATE TABLE Cliente (
    cli_codigo INT PRIMARY KEY AUTO_INCREMENT,
    cli_nome VARCHAR(100),
    cli_cpf VARCHAR(15),
    cli_telefone VARCHAR(20),
    cli_cidade VARCHAR(50)  -- Adicionando a coluna de cidade
);

CREATE TABLE Veiculo (
    vei_codigo INT PRIMARY KEY AUTO_INCREMENT,
    vei_placa VARCHAR(10),
    vei_marca VARCHAR(50),
    vei_modelo VARCHAR(50),
    vei_ano INT,
    vei_status VARCHAR(20)
);

CREATE TABLE Locacao (
    loc_codigo INT PRIMARY KEY AUTO_INCREMENT,
    cli_codigo INT,
    vei_codigo INT,
    loc_dataInicio DATE,
    loc_dataFim DATE,
    loc_valorDiaria DECIMAL(10,2),
    loc_valorTotal DECIMAL(10,2),
    loc_status VARCHAR(20),
    FOREIGN KEY (cli_codigo) REFERENCES Cliente(cli_codigo),
    FOREIGN KEY (vei_codigo) REFERENCES Veiculo(vei_codigo)
);

CREATE TABLE Reservas (
    res_codigo INT PRIMARY KEY AUTO_INCREMENT,
    cli_codigo INT,
    vei_codigo INT,
    res_dataReserva DATE,
    res_dataInicio DATE,
    res_dataFim DATE,
    FOREIGN KEY (cli_codigo) REFERENCES Cliente(cli_codigo),
    FOREIGN KEY (vei_codigo) REFERENCES Veiculo(vei_codigo)
);

CREATE TABLE Forma_Pagamento (
    for_codigo INT PRIMARY KEY AUTO_INCREMENT,
    for_descricao VARCHAR(20)
);

CREATE TABLE Servicos_Pecas (
    ser_codigo INT PRIMARY KEY AUTO_INCREMENT,
    vei_codigo INT,
    for_codigo INT,
    ser_descricao VARCHAR(200),
    ser_data DATE,
    ser_valor DECIMAL(10,2),
    FOREIGN KEY (vei_codigo) REFERENCES Veiculo(vei_codigo),
    FOREIGN KEY (for_codigo) REFERENCES Forma_Pagamento(for_codigo)
);

CREATE TABLE Avarias (
    ava_codigo INT PRIMARY KEY AUTO_INCREMENT,
    vei_codigo INT,
    loc_codigo INT,
    ava_descricao VARCHAR(250),
    ava_dataOrcamento DATE,
    ava_valorOrcam DECIMAL(10,2),
    ava_valorFinal DECIMAL(10,2),
    FOREIGN KEY (vei_codigo) REFERENCES Veiculo(vei_codigo),
    FOREIGN KEY (loc_codigo) REFERENCES Locacao(loc_codigo)
);

INSERT INTO Cliente (cli_nome, cli_cpf, cli_telefone, cli_cidade) VALUES 
('João Silva', '123.456.789-01', '21999999999', 'Rio de Janeiro'),
('Maria Oliveira', '987.654.321-02', '21988888888', 'São Paulo'),
('Pedro Santos', '111.222.333-03', '31977777777', 'Belo Horizonte'),
('Ana Costa', '444.555.666-04', '41966666666', 'Curitiba'),
('Carlos Pereira', '777.888.999-05', '51955555555', 'Porto Alegre'),
('Mariana Almeida', '000.111.222-06', '61944444444', 'Brasília'),
('Luiz Souza', '333.444.555-07', '71933333333', 'Salvador');

INSERT INTO Veiculo (vei_placa, vei_marca, vei_modelo, vei_ano, vei_status) VALUES 
('ABC1234', 'Toyota', 'Corolla', 2020, 'Disponível'),
('DEF5678', 'Honda', 'Civic', 2019, 'Locado'),
('GHI9012', 'Ford', 'Fiesta', 2018, 'Disponível'),
('JKL3456', 'Chevrolet', 'Onix', 2021, 'Locado'),
('MNO7890', 'Volkswagen', 'Golf', 2017, 'Disponível'),
('PQR1234', 'Renault', 'Clio', 2016, 'Disponível'),
('STU5678', 'Fiat', 'Palio', 2015, 'Disponível');

INSERT INTO Locacao (cli_codigo, vei_codigo, loc_dataInicio, loc_dataFim, loc_valorDiaria, loc_valorTotal, loc_status) VALUES 
(1, 1, '2024-08-01', '2024-08-03', 100.00, 300.00, 'Concluída'),
(2, 2, '2024-08-04', '2024-08-06', 150.00, 450.00, 'Concluída'),
(1, 2, '2024-08-01', '2024-08-03', 150.00, 450.00, 'Concluída'),
(3, 3, '2024-08-07', '2024-08-09', 120.00, 360.00, 'Concluída'),
(3, 1, '2024-08-04', '2024-08-07', 120.00, 360.00, 'Concluída'),
(1, 4, '2024-08-10', '2024-08-12', 130.00, 390.00, 'Concluída'),
(1, 5, '2024-08-13', '2024-08-15', 140.00, 420.00, 'Concluída'),
(2, 6, '2024-08-16', '2024-08-18', 160.00, 480.00, 'Concluída'),
(2, 7, '2024-08-19', '2024-08-21', 110.00, 330.00, 'Concluída');

INSERT INTO Reservas (cli_codigo, vei_codigo, res_dataReserva, res_dataInicio, res_dataFim) VALUES 
(1, 2, '2024-07-25', '2024-08-01', '2024-08-03'),
(2, 3, '2024-07-26', '2024-08-04', '2024-08-06'),
(3, 4, '2024-07-27', '2024-08-07', '2024-08-09'),
(4, 5, '2024-07-28', '2024-08-10', '2024-08-12'),
(5, 6, '2024-07-29', '2024-08-13', '2024-08-15'),
(6, 7, '2024-07-30', '2024-08-16', '2024-08-18'),
(7, 1, '2024-07-31', '2024-08-19', '2024-08-21');

INSERT INTO Forma_Pagamento (for_descricao) VALUES 
('Dinheiro'),
('Cartão de Crédito'),
('Cartão de Débito'),
('Pix'),
('Boleto');

INSERT INTO Servicos_Pecas (vei_codigo, for_codigo, ser_descricao, ser_data, ser_valor) VALUES 
(1, 1, 'Troca de óleo', '2024-08-01', 150.00),
(2, 2, 'Substituição de pneu', '2024-08-05', 300.00),
(3, 3, 'Revisão geral', '2024-08-09', 200.00),
(4, 4, 'Troca de bateria', '2024-08-12', 400.00),
(5, 5, 'Alinhamento e balanceamento', '2024-08-15', 250.00),
(6, 1, 'Troca de pastilha de freio', '2024-08-01', 220.00),
(7, 2, 'Polimento', '2024-08-20', 180.00);

INSERT INTO Avarias (vei_codigo, loc_codigo, ava_descricao, ava_dataOrcamento, ava_valorOrcam, ava_valorFinal) VALUES 
(1, 1, 'Risco na pintura', '2024-08-01', 500.00, 450.00),
(2, 2, 'Amassado na porta', '2024-08-05', 600.00, 550.00),
(3, 3, 'Quebra de farol', '2024-08-08', 400.00, 350.00),
(4, 4, 'Arranhão no para-choque', '2024-08-11', 300.00, 250.00),
(5, 5, 'Dano no espelho retrovisor', '2024-08-14', 200.00, 180.00),
(6, 6, 'Rachadura no para-brisa', '2024-08-17', 800.00, 750.00),
(7, 7, 'Pneu furado', '2024-08-20', 100.00, 90.00);
