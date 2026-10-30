-- CONSULTA 1 - INNER JOIN
-- Mostra somente clientes que possuem vendas.
SELECT
    clientes.id_cliente,
    clientes.nome,
    vendas.id_venda,
    vendas.id_veiculo,
    vendas.id_funcionario
FROM clientes
INNER JOIN vendas
    ON clientes.id_cliente = vendas.id_cliente
ORDER BY clientes.id_cliente, vendas.id_venda;


-- CONSULTA 2 - LEFT JOIN
-- Mostra todos os clientes, inclusive os que nao possuem vendas.
SELECT
    clientes.id_cliente,
    clientes.nome,
    vendas.id_venda,
    vendas.id_veiculo,
    vendas.id_funcionario
FROM clientes
LEFT JOIN vendas
    ON clientes.id_cliente = vendas.id_cliente
ORDER BY clientes.id_cliente, vendas.id_venda;


-- CONSULTA 3 - RIGHT JOIN
-- Mantem todos os clientes porque clientes esta a direita.
SELECT
    clientes.id_cliente,
    clientes.nome,
    vendas.id_venda,
    vendas.id_veiculo,
    vendas.id_funcionario
FROM vendas
RIGHT JOIN clientes
    ON vendas.id_cliente = clientes.id_cliente
ORDER BY clientes.id_cliente, vendas.id_venda;


-- CONSULTA 4 - CLIENTES SEM VENDAS (LEFT JOIN + IS NULL)
SELECT
    clientes.id_cliente,
    clientes.nome,
    clientes.telefone,
    clientes.email
FROM clientes
LEFT JOIN vendas
    ON clientes.id_cliente = vendas.id_cliente
WHERE vendas.id_venda IS NULL
ORDER BY clientes.id_cliente;
