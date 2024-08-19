-- Aluno: João Pedro Franca PE3021114
-- Exercicio 1 Biblioteca
SELECT l.liv_titulo, c.cli_nome 
FROM Cliente c 
JOIN Emprestimo e 
	ON c.cli_codigo = e.cli_codigo
JOIN Emprestimo_Exemplar ee
	ON e.emp_codigo = ee.emp_codigo
JOIN Exemplar ex
	ON ee.exe_codigo = ex.exe_codigo
JOIN Livro l 
	ON ex.liv_codigo = l.liv_codigo
WHERE c.cli_nome = 'Maria Silva';

-- Aluno: João Pedro Franca PE3021114
-- Exercicio 2 Biblioteca
SELECT COUNT(l.liv_titulo), c.cat_nome
FROM Livro l
JOIN Categoria c
	ON l.cat_codigo = c.cat_codigo
JOIN Exemplar e
	ON l.liv_codigo = e.liv_codigo
JOIN Emprestimo_Exemplar ee
	ON e.exe_codigo = ee.exe_codigo
GROUP BY c.cat_nome;