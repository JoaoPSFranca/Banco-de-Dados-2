-- Aluno: João Pedro Franca PE3021114
-- Exercicio 1 Locadora
SELECT 
    V.*,
    COUNT(L.loc_codigo) AS qtde_locacoes
FROM Veiculo V
INNER JOIN Locacao L 
	ON V.vei_codigo = L.vei_codigo
WHERE L.loc_dataInicio BETWEEN '2024-08-01' AND '2024-08-31'
GROUP BY V.vei_codigo;

-- Aluno: João Pedro Franca PE3021114
-- Exercicio 2 Locadora
SELECT 
	V.vei_placa,
    V.vei_marca,
    V.vei_modelo,
    C.cli_nome
FROM Veiculo V
INNER JOIN Locacao L 
	ON V.vei_codigo = L.vei_codigo
INNER JOIN Cliente C 
	ON L.cli_codigo = C.cli_codigo
WHERE C.cli_nome = 'João Silva';

-- Aluno: João Pedro Franca PE3021114
-- Exercicio 3 Locadora
SELECT 
    C.cli_nome,
    SUM(L.loc_valorTotal) AS total_pago
FROM Locacao L
INNER JOIN Cliente C 
	ON L.cli_codigo = C.cli_codigo
WHERE C.cli_nome = 'João Silva'
GROUP BY C.cli_nome;

-- Aluno: João Pedro Franca PE3021114
-- Exercicio 4 Locadora
SELECT 
    SP.ser_data,
    SUM(SP.ser_valor) AS total_recebido
FROM Servicos_Pecas SP
INNER JOIN Forma_Pagamento FP 
	ON SP.for_codigo = FP.for_codigo
WHERE 
    FP.for_descricao = 'Dinheiro' 
    AND SP.ser_data = '2024-08-01'
GROUP BY SP.ser_data;

-- Aluno: João Pedro Franca PE3021114
-- Exercicio 5 Locadora
SELECT 
    C.cli_nome,
    C.cli_cidade,
    COUNT(L.loc_codigo) AS qtde_locacoes
FROM Cliente C
INNER JOIN Locacao L 
	ON C.cli_codigo = L.cli_codigo
GROUP BY C.cli_nome, C.cli_cidade
ORDER BY qtde_locacoes DESC
LIMIT 3;
