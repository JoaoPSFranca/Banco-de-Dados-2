-- Aluno: João Pedro Franca PE3021114
-- Exercicio 01 Cidades
SELECT 
	COUNT(municipio) AS total_cidades,
    MIN(populacao) AS menor_populacao,
    MAX(populacao) AS maior_populacao
FROM cidades
WHERE estado = 'SC';

-- Aluno: João Pedro Franca PE3021114
-- Exercicio 02 Cidades
SELECT 
	SUM(populacao) AS total_populacao,
    (SELECT municipio FROM cidades WHERE estado = 'SC' ORDER BY populacao ASC LIMIT 1) as menor_populacao,
	(SELECT municipio FROM cidades WHERE estado = 'SC' ORDER BY populacao DESC LIMIT 1) as maior_populacao
FROM cidades
WHERE estado = 'SC';

-- Aluno: João Pedro Franca PE3021114
-- Exercicio 03 Cidades
SELECT 
	estado,
    COUNT(municipio) as total_cidades
FROM cidades
GROUP BY estado
ORDER BY estado;

-- Aluno: João Pedro Franca PE3021114
-- Exercicio 04 Cidades
SELECT
	municipio,
    estado,
    populacao
FROM cidades
ORDER BY populacao DESC
LIMIT 5;

-- Aluno: João Pedro Franca PE3021114
-- Exercicio 05 Cidades
SELECT 
	estado,
    COUNT(municipio) as total_cidades
FROM cidades
GROUP BY estado
ORDER BY total_cidades DESC
LIMIT 5;

-- Aluno: João Pedro Franca PE3021114
-- Exercicio 06 Cidades
SELECT 
	estado,
    COUNT(municipio) as qtde_cidades,
    SUM(populacao) AS total_populacao
FROM cidades
GROUP BY estado
ORDER BY total_populacao ASC
LIMIT 5;

-- Aluno: João Pedro Franca PE3021114
-- Exercicio 07 Cidades
SELECT 
	estado,
    ROUND(AVG(pctHomem), 2) AS perc_homem,
    ROUND(AVG(pctMulher), 2) AS perc_mulher
FROM cidades
GROUP BY estado
ORDER BY estado;

-- Aluno: João Pedro Franca PE3021114
-- Exercicio 08 Cidades
SELECT 
	estado,
    SUM(populacao) as populacao,
    ROUND(((SUM(populacao) / 100) * ROUND(AVG(pcthomem), 2)), 0) as pop_homem,
    ROUND(((SUM(populacao) / 100) * ROUND(AVG(pctmulher), 2)), 0) as pop_mulher
FROM cidades
GROUP BY estado
LIMIT 5;

-- Aluno: João Pedro Franca PE3021114
-- Exercicio 09 Cidades
SELECT 
	estado,
    SUM(populacao) as populacao,
    AVG(pctMulher) as media_mulher
FROM cidades
GROUP BY estado
HAVING media_mulher > 50;

-- Aluno: João Pedro Franca PE3021114
-- Exercicio 10 Cidades
SELECT 
	estado,
    SUM(populacao) as populacao,
    ROUND(((SUM(populacao) / 100) * ROUND(AVG(pcthomem), 2)), 0) as pop_homem,
    ROUND(((SUM(populacao) / 100) * ROUND(AVG(pctmulher), 2)), 0) as pop_mulher
FROM cidades
GROUP BY estado
HAVING pop_mulher > pop_homem;

-- Aluno: João Pedro Franca PE3021114
-- Exercicio 11 Cidades
SELECT 
	municipio,
    estado,
    ROUND(pctmulher, 2) AS pct_mulher,
    ROUND(pcthomem, 2) AS pct_homem,
    ROUND((pcthomem - pctmulher), 2) AS diferenca
FROM cidades
ORDER BY pctmulher ASC
LIMIT 1;

-- Aluno: João Pedro Franca PE3021114
-- Exercicio 12 Cidades
SELECT
	estado,
    MIN(populacao) AS populacao,
    (SELECT c2.municipio FROM cidades c2 WHERE c2.estado = c.estado AND c2.populacao = MIN(c.populacao)) AS nome_cidade
FROM cidades c
GROUP BY estado;

-- Aluno: João Pedro Franca PE3021114
-- Exercicio 13 Cidades
SELECT DISTINCT
	estado,
    populacao,
    municipio AS nome_cidade
FROM cidades
ORDER BY populacao DESC
LIMIT 5;

-- Aluno: João Pedro Franca PE3021114
-- Exercicio 14 Cidades
SELECT 
	estado,
    ROUND(((SUM(populacao) / 100) * ROUND(AVG(pcthomem), 2)), 0) as pop_homem,
    ROUND(((SUM(populacao) / 100) * ROUND(AVG(pctmulher), 2)), 0) as pop_mulher
FROM cidades
GROUP BY estado
ORDER BY estado ASC;

-- Aluno: João Pedro Franca PE3021114
-- Exercicio 15 Cidades
SELECT 
	LEFT(municipio, 1) AS letra,
    SUM(populacao) AS populacao
FROM cidades
GROUP BY LEFT(municipio, 1);

-- Aluno: João Pedro Franca PE3021114
-- Exercicio 16 Cidades
SELECT
	estado,
    sum(populacao) AS populacao
FROM cidades
WHERE pctHomem > pctMulher
GROUP BY estado;

-- Aluno: João Pedro Franca PE3021114
-- Exercicio 17 Cidades
SELECT
	estado,
    municipio,
	ROUND((populacao / 100) * ROUND(pcthomem, 2), 0) as pop_homem,
    ROUND((populacao / 100) * ROUND(pctmulher, 2), 0) as pop_mulher,
    ABS(
		(ROUND((populacao / 100) * ROUND(pcthomem, 2), 0)) - 
        (ROUND((populacao / 100) * ROUND(pctmulher, 2), 0))
	) AS diferenca
FROM cidades
ORDER BY diferenca DESC
LIMIT 1;

-- Aluno: João Pedro Franca PE3021114
-- Exercicio 18 Cidades
SELECT 
	estado,
    AVG(populacao) AS media_populacao
FROM cidades
WHERE populacao > 50000
GROUP BY estado
ORDER BY media_populacao DESC
LIMIT 3;

-- Aluno: João Pedro Franca PE3021114
-- Exercicio 19 Cidades
SELECT
	municipio,
    ROUND((populacao / 100) * ROUND(pcthomem, 2), 2) AS populacao_masculina,
    CONCAT(ROUND(pctUrbana, 2), '%') AS percentual
FROM cidades
WHERE pctUrbana > 80.00
ORDER BY populacao_masculina ASC
LIMIT 5;

-- Aluno: João Pedro Franca PE3021114
-- Exercicio 20 Cidades
SELECT 
	c.estado, 
	c.municipio, 
    c.populacao
FROM cidades c
JOIN 
	(SELECT 
		c2.estado, 
        AVG(c2.populacao) AS mediaPopulacao
	FROM cidades c2
	GROUP BY c2.estado) e 
    ON c.estado = e.estado
WHERE 
	(c.estado, ABS(c.populacao - e.mediaPopulacao)) 
    IN 
		(SELECT 
			c3.estado, MIN(ABS(c3.populacao - e2.mediaPopulacao))
		FROM cidades c3
		JOIN 
			(SELECT 
				c4.estado, 
				AVG(c4.populacao) AS mediaPopulacao
			FROM cidades c4
			GROUP BY c4.estado) e2 
		ON c3.estado = e2.estado
		GROUP BY c3.estado);