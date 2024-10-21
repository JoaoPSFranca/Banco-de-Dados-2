set search_path to provabim1_correcao;

insert into usuario (nome, email, categoria)
values ('Vilson','vilson@gmail.com','Professor'),
       ('Jota','jota@gmail.com','Aluno'),
       ('Ed','bigEd@gmail.com','Professor');

select * from usuario;

INSERT INTO livro (titulo, autor, qtdelivro, qtdedisponivel) VALUES
('PostgreSQL Avançado', 'Autor A', 0, 0),
('Introdução à Programação', 'Autor B', 0, 0),
('Estruturas de Dados', 'Autor C', 0, 0),
('Engenharia de Software', 'Autor D', 0, 0);

INSERT INTO acervo (idlivro, idacervo, numeroisbn, status) VALUES
(1, 1, '978-1234567890', 'D'),
(1, 2, '978-1234567891', 'D'),
(1, 3, '978-1234567892', 'D'),
(1, 4, '978-1234567893', 'D'),
(1, 5, '978-1234567894', 'D');

INSERT INTO acervo (idlivro, idacervo, numeroisbn, status) VALUES
(2, 1, '978-2234567890', 'D'),
(2, 2, '978-2234567891', 'D'),
(2, 3, '978-2234567892', 'D'),
(2, 4, '978-2234567893', 'D'),
(2, 5, '978-2234567894', 'D');

INSERT INTO acervo (idlivro, idacervo, numeroisbn, status) VALUES
(3, 1, '978-2234567890', 'D'),
(3, 2, '978-2234567891', 'D'),
(3, 3, '978-2234567892', 'D'),
(3, 4, '978-2234567893', 'D'),
(3, 5, '978-2234567894', 'D');

INSERT INTO acervo (idlivro, idacervo, numeroisbn, status) VALUES
(4, 1, '978-2234567890', 'D'),
(4, 2, '978-2234567891', 'D'),
(4, 3, '978-2234567892', 'D'),
(4, 4, '978-2234567893', 'D'),
(4, 5, '978-2234567894', 'D');

insert into emprestimo (data_emprestimo, previsao_devolucao, status,idusuario)
values (current_date, current_date+5, 'Aberto', 1),
       (current_date, current_date+5, 'Aberto', 2),
       (current_date, current_date+5, 'Aberto', 1),
       (current_date, current_date+5, 'Aberto', 3),
       (current_date, current_date+5, 'Aberto', 1);

select * from emprestimo;

insert into itensemprestados (idemprestimo, iditem, idlivro, idacervo)
values (1, 1, 1, 3),
       (1, 2, 2, 4);

insert into itensemprestados (idemprestimo, iditem, idlivro, idacervo)
values (2, 1, 2, 2),
       (2, 2, 3, 2);

insert into itensemprestados (idemprestimo, iditem, idlivro, idacervo)
values (3, 1, 1, 5),
       (3, 2, 3, 4);

insert into itensemprestados (idemprestimo, iditem, idlivro, idacervo)
values (4, 1, 4, 2);

insert into itensemprestados (idemprestimo, iditem, idlivro, idacervo)
values (5, 1, 4, 5);

select * from itensemprestados;