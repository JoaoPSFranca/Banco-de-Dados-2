set search_path to oficina;

INSERT INTO caixa (cai_data, cai_valor_inicial) VALUES
    ('2022-01-01', 1000.00),
    ('2022-01-02', 1000.00),
    ('2022-01-03', 1000.00),
    ('2022-01-04', 1000.00),
    ('2022-01-05', 1000.00),
    ('2022-01-06', 1000.00),
    ('2022-01-07', 1000.00),
    ('2022-01-08', 1000.00),
    ('2022-01-09', 1000.00),
    ('2022-01-10', 1000.00);

INSERT INTO cliente (cli_codigo, cli_nome, cli_telefone, cli_cpf) VALUES
    (1, 'Ana Luiza', '11987654321', '12345678909'),
    (2, 'João Pedro', '11998765432', '98765432109'),
    (3, 'Maria Silva', '11987654343', '12345678910'),
    (4, 'Pedro Henrique', '11998765454', '98765432111'),
    (5, 'Luana Souza', '11987654365', '12345678912'),
    (6, 'Rafael Oliveira', '11998765476', '98765432113'),
    (7, 'Gabriela Martins', '11987654387', '12345678914'),
    (8, 'Lucas Ferreira', '11998765498', '98765432115'),
    (9, 'Juliana Costa', '11987654309', '12345678916'),
    (10, 'Matheus Sousa', '11998765410', '98765432117');

INSERT INTO fornecedor (for_codigo, for_razao_social, for_telefone, for_cnpj) VALUES
    (1, 'Fornecedor A Ltda', '11987654321', '12345678901234'),
    (2, 'Fornecedor B Ltda', '11998765432', '98765432109876'),
    (3, 'Fornecedor C Ltda', '11987654343', '12345678901235'),
    (4, 'Fornecedor D Ltda', '11998765454', '98765432109877'),
    (5, 'Fornecedor E Ltda', '11987654365', '12345678901236'),
    (6, 'Fornecedor F Ltda', '11998765476', '98765432109878'),
    (7, 'Fornecedor G Ltda', '11987654387', '12345678901237'),
    (8, 'Fornecedor H Ltda', '11998765498', '98765432109879'),
    (9, 'Fornecedor I Ltda', '11987654309', '12345678901238'),
    (10, 'Fornecedor J Ltda', '11998765410', '98765432109880');

INSERT INTO funcionario (fun_codigo, fun_nome, fun_telefone, fun_cpf) VALUES
    (1, 'João da Silva', '11987654321', '12345678909'),
    (2, 'Maria Rodrigues', '11998765432', '98765432109'),
    (3, 'Pedro Henrique', '11987654343', '12345678910'),
    (4, 'Luana Souza', '11998765454', '98765432111'),
    (5, 'Rafael Oliveira', '11987654365', '12345678912'),
    (6, 'Gabriela Martins', '11998765476', '98765432113'),
    (7, 'Lucas Ferreira', '11987654387', '12345678914'),
    (8, 'Juliana Costa', '11998765498', '98765432115'),
    (9, 'Matheus Sousa', '11987654309', '12345678916'),
    (10, 'Ana Luiza', '11998765410', '98765432117');

INSERT INTO peca (pec_codigo, pec_descricao, pec_valor, pec_estoque) VALUES
    (1, 'Peca A', 10.00, 300),
    (2, 'Peca B', 20.00, 300),
    (3, 'Peca C', 30.00, 300),
    (4, 'Peca D', 40.00, 300),
    (5, 'Peca E', 50.00, 300),
    (6, 'Peca F', 60.00, 300),
    (7, 'Peca G', 70.00, 300),
    (8, 'Peca H', 80.00, 300),
    (9, 'Peca I', 90.00, 300),
    (10, 'Peca J', 100.00, 300);

INSERT INTO servico (ser_codigo, ser_descricao, ser_valor) VALUES
    (1, 'Serviço A', 50.00),
    (2, 'Serviço B', 75.00),
    (3, 'Serviço C', 100.00),
    (4, 'Serviço D', 125.00),
    (5, 'Serviço E', 150.00),
    (6, 'Serviço F', 175.00),
    (7, 'Serviço G', 200.00),
    (8, 'Serviço H', 225.00),
    (9, 'Serviço I', 250.00),
    (10, 'Serviço J', 275.00);

INSERT INTO veiculo (vei_codigo, cli_codigo, vei_marca, vei_modelo, vei_ano_fabricacao) VALUES
    (1, 1, 'Ford', 'Fiesta', '2015'),
    (2, 2, 'Chevrolet', 'Cruze', '2018'),
    (3, 3, 'Volkswagen', 'Gol', '2012'),
    (4, 4, 'Toyota', 'Corolla', '2016'),
    (5, 5, 'Hyundai', 'HB20', '2019'),
    (6, 6, 'Fiat', 'Palio', '2014'),
    (7, 7, 'Renault', 'Sandero', '2017'),
    (8, 8, 'Nissan', 'Sentra', '2013'),
    (9, 9, 'Mitsubishi', 'Lancer', '2011'),
    (10, 10, 'Kia', 'Cerato', '2010');

INSERT INTO despesa (des_codigo, cai_data, fun_codigo, des_valor) VALUES
    (1, '2022-01-01',  1, 100.00),
    (2, '2022-01-02', 2, 200.00),
    (3, '2022-01-03', null, 300.00),
    (4, '2022-01-04', 4, 400.00),
    (5, '2022-01-05', 5, 500.00),
    (6, '2022-01-06', 6, 600.00),
    (7, '2022-01-07', null, 700.00),
    (8, '2022-01-08', 8, 800.00),
    (9, '2022-01-09', 9, 900.00),
    (10, '2022-01-10', 10, 1000.00);

INSERT INTO orcamento (orc_codigo, vei_codigo, cli_codigo, cli_cpf, cli_nome, cli_telefone, orc_data_validade, orc_valor, orc_valor_adicional) VALUES
    (1, 1, 1, null, 'Ana Luiza', '11987654321', '2022-01-01', 0, 500.00),
    (2, 2, 2, '98765432109', null, '11998765432', '2022-01-02', 0, 100.00),
    (3, 3, 3, '12345678910', 'Maria Silva', null, '2022-01-03', 0, 150.00),
    (4, 4, 4, '98765432111', null, '11998765454', '2022-01-04', 0, 200.00),
    (5, 5, 5, null, 'Luana Souza', '11987654365', '2022-01-05', 0, 250.00),
    (6, 6, null, '98765432113', 'Rafael Oliveira', '11998765476', '2022-01-06', 0, 300.00),
    (7, 7, 7, null, 'Gabriela Martins', '11987654387', '2022-01-07', 0, 350.00),
    (8, 8, 8, '98765432115', null, '11998765498', '2022-01-08', 0, 400.00),
    (9, 9, 9, '12345678916', 'Juliana Costa', null, '2022-01-09', 0, 450.00),
    (10, 10, null, '98765432117', 'Matheus Sousa', '11998765410', '2022-01-10', 0, 500.00);

INSERT INTO compra (com_codigo, for_codigo, com_data, com_valor) VALUES
    (1, 1, '2022-01-01', 0),
    (2, 2, '2022-01-02', 0),
    (3, 3, '2022-01-03', 0),
    (4, 4, '2022-01-04', 0),
    (5, 5, '2022-01-05', 0),
    (6, 6, '2022-01-06', 0),
    (7, 7, '2022-01-07', 0),
    (8, 8, '2022-01-08', 0),
    (9, 9, '2022-01-09', 0),
    (10, 10, '2022-01-10', 0);

INSERT INTO peca_compra (pec_codigo, com_codigo, pc_quantidade) VALUES
    (1, 1, 10),
    (2, 2, 20),
    (3, 3, 30),
    (4, 4, 40),
    (5, 5, 50),
    (6, 6, 60),
    (7, 7, 70),
    (8, 8, 80),
    (9, 9, 90),
    (10, 10, 100);

INSERT INTO peca_orcamento (pec_codigo, orc_codigo, po_quantidade) VALUES
    (1, 1, 10),
    (2, 2, 20),
    (3, 3, 30),
    (4, 4, 40),
    (5, 5, 50),
    (6, 6, 60),
    (7, 7, 70),
    (8, 8, 80),
    (9, 9, 90),
    (10, 10, 100);

INSERT INTO servico_orcamento (ser_codigo, orc_codigo) VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5),
    (6, 6),
    (7, 7),
    (8, 8),
    (9, 9),
    (10, 10);

INSERT INTO pagamento (pag_codigo, com_codigo, cai_data, pag_data, pag_valor) VALUES
    (1, 1, '2022-01-01', '2022-01-01', 100.00),
    (2, 2, '2022-01-02', '2022-01-02', 200.00),
    (3, 3, '2022-01-03', '2022-01-03', 300.00),
    (4, 4, '2022-01-04', '2022-01-04', 400.00),
    (5, 5, '2022-01-05', '2022-01-05', 500.00),
    (6, 6, '2022-01-06', '2022-01-06', 600.00),
    (7, 7, '2022-01-07', '2022-01-07', 700.00),
    (8, 8, '2022-01-08', '2022-01-08', 800.00),
    (9, 9, '2022-01-09', '2022-01-09', 900.00),
    ( 10, 10, '2022-01-10', '2022-01-10', 1000.00);

update orcamento
    set orc_data_aprovacao = current_date
    where orc_codigo > 0;

INSERT INTO recebimento (rec_codigo, orc_codigo, ven_codigo, cai_data, rec_data, rec_valor) VALUES
    (1, 1, 1, '2022-01-01', '2022-01-01', 1000.00),
    (2, 2, 2, '2022-01-02', '2022-01-02', 2000.00),
    (3, 3, 3, '2022-01-03', '2022-01-03', 3000.00),
    (4, 4, 4, '2022-01-04', '2022-01-04', 4000.00),
    (5, 5, 5, '2022-01-05', '2022-01-05', 5000.00),
    (6, 6, 6, '2022-01-06', '2022-01-06', 6000.00),
    (7, 7, 7, '2022-01-07', '2022-01-07', 7000.00),
    (8, 8, 8, '2022-01-08', '2022-01-08', 8000.00),
    (9, 9, 9, '2022-01-09', '2022-01-09', 9000.00),
    (10, 10, 10, '2022-01-10', '2022-01-10', 10000.00);
