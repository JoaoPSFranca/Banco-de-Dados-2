-- 1ª PARTE

-- Aluno: João Pedro Franca PE3021114
-- Exercicio 01 CD Parte 1 com JOIN
SELECT 
	a.nomeaut AS autor,
	COUNT(ma.codmus) AS qtd_musicas
FROM autor a
JOIN musicaAutor ma 
	ON a.codaut = ma.codaut
GROUP BY a.codaut
ORDER BY qtd_musicas DESC
LIMIT 5;

-- Aluno: João Pedro Franca PE3021114
-- Exercicio 01 CD Parte 1 sem JOIN
SELECT 
	a.nomeaut AS autor,
	(SELECT COUNT(*) 
	FROM musicaAutor ma 
    WHERE ma.codaut = a.codaut) AS qtd_musicas
FROM autor a
ORDER BY qtd_musicas DESC
LIMIT 5;

-- Aluno: João Pedro Franca PE3021114
-- Exercicio 02 CD Parte 1 com JOIN
SELECT 
	c.nomecd AS Nome,
    SUM(m.duracao) AS Duracao
FROM cd c
JOIN faixa f
	ON c.codcd = f.codcd
JOIN musica m
	ON f.codmus = m.codmus
GROUP BY c.codcd;

-- Aluno: João Pedro Franca PE3021114
-- Exercicio 02 CD Parte 1 sem JOIN
SELECT 
	c.nomecd AS Nome,
    (SELECT SUM(m.duracao) 
	FROM 
		musica m, 
        faixa f 
    WHERE 
		m.codmus = f.codmus 
		AND f.codcd = c.codcd) AS Duracao
FROM cd c
GROUP BY c.codcd;

-- Aluno: João Pedro Franca PE3021114
-- Exercicio 03 CD Parte 1 com JOIN
SELECT 
	c.nomecd AS Nome,
    SUM(m.duracao) AS Duracao,
    COUNT(m.codmus) AS qtd_musicas
FROM cd c
JOIN faixa f
	ON c.codcd = f.codcd
JOIN musica m
	ON f.codmus = m.codmus
GROUP BY c.codcd
HAVING qtd_musicas > 3;

-- Aluno: João Pedro Franca PE3021114
-- Exercicio 03 CD Parte 1 sem JOIN
SELECT 
	c.nomecd AS Nome,
    (SELECT SUM(m.duracao)
	FROM 
		musica m, 
        faixa f 
    WHERE 
		m.codmus = f.codmus 
		AND f.codcd = c.codcd) AS Duracao,
	(SELECT COUNT(m.codmus) AS qtd_musicas
	FROM 
		musica m, 
        faixa f 
    WHERE 
		m.codmus = f.codmus 
		AND f.codcd = c.codcd) AS qtd_musicas
FROM cd c
GROUP BY c.codcd
HAVING qtd_musicas > 3;

-- 2ª Parte
-- Aluno: João Pedro Franca PE3021114
-- Exercicio 01 CD Parte 2
SELECT 
	a.nomeaut AS 'Autor',
    m.nomemus AS 'Musica',
    c.nomecd AS 'CD'
FROM cd c
JOIN faixa f
	ON c.codcd = f.codcd
JOIN musica m
	ON f.codmus = m.codmus
JOIN musicaAutor ma
	ON m.codmus = ma.codmus
JOIN autor a
	ON ma.codaut = a.codaut
ORDER BY a.nomeaut;

-- Aluno: João Pedro Franca PE3021114
-- Exercicio 02 CD Parte 2
SELECT 
	nomecd,
	preco
FROM CD
WHERE preco > (SELECT AVG(preco) FROM CD);

-- Aluno: João Pedro Franca PE3021114
-- Exercicio 03 CD Parte 2
SELECT
	g.nomegrav AS 'Gravadora',
	ROUND(AVG(c.preco), 2) AS 'Media'
FROM CD c
JOIN gravadora g
	ON c.codgrav = g.codgrav
GROUP BY c.codgrav;

-- Aluno: João Pedro Franca PE3021114
-- Exercicio 04 CD Parte 2
SELECT
	g.nomegrav AS 'Gravadora',
	MAX(c.preco) AS 'Preco'
FROM CD c
JOIN gravadora g
	ON c.codgrav = g.codgrav
GROUP BY c.codgrav
ORDER BY 'Preco' DESC
LIMIT 1;

-- Aluno: João Pedro Franca PE3021114
-- Exercicio 05 CD Parte 2
WITH musica_custo AS (
	SELECT 
		f.codmus, 
		f.codcd, 
		(c.preco / (SELECT COUNT(*) FROM Faixa WHERE codcd = f.codcd)) AS custo_musica
    FROM 
		Faixa f
    INNER JOIN 
		CD c ON f.codcd = c.codcd
  ),
  autor_total AS (
    SELECT 
		ma.codaut, 
		SUM(mc.custo_musica) AS total
    FROM 
		musica_custo mc
    INNER JOIN 
		MusicaAutor ma ON mc.codmus = ma.codmus
    GROUP BY 
		ma.codaut
  )

SELECT 
	a.nomeaut, 
	ROUND(at.total, 2) AS total
FROM 
	autor_total at
INNER JOIN 
	Autor a ON at.codaut = a.codaut
ORDER BY 
	at.total DESC
LIMIT 1;