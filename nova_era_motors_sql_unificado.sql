-- ============================================================
-- PROJETO: NOVA ERA MOTORS - ARQUIVO SQL UNIFICADO
-- Contem: estrutura, dados, consultas agregadas, JOIN, IN,
-- NOT IN, EXISTS, NOT EXISTS e VIEW.
-- INTEGRANTES: Matheus Pinheiro, Matheus Francisco,
-- Vinicius Gomes, Noah e Dazi
-- ============================================================

use nova_era_motors;

show tables;


USE nova_era_motors;




-- 1. Tabela de clientes
CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    email VARCHAR(120) NOT NULL,
    endereco VARCHAR(200)
);

-- 2. Tabela de funcionários
CREATE TABLE funcionarios (
    id_funcionario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    email VARCHAR(120) NOT NULL,
    cargo VARCHAR(50) NOT NULL
);

-- 3. Tabela de veículos
CREATE TABLE veiculos (
    id_veiculo INT AUTO_INCREMENT PRIMARY KEY,
    marca VARCHAR(50) NOT NULL,
    modelo VARCHAR(100) NOT NULL,
    ano INT NOT NULL,
    cor VARCHAR(30),
    placa VARCHAR(10) NOT NULL UNIQUE,
    quilometragem INT DEFAULT 0,
    status VARCHAR(20) NOT NULL DEFAULT 'Disponivel',
    preco DECIMAL(12,2) NOT NULL
);

-- 4. Tabela de serviços
CREATE TABLE servicos (
    id_servico INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(255),
    preco DECIMAL(10,2) NOT NULL
);

-- 5. Tabela de vendas
CREATE TABLE vendas (
    id_venda INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_veiculo INT NOT NULL,
    id_funcionario INT NOT NULL,

    FOREIGN KEY (id_cliente)
        REFERENCES clientes(id_cliente),

    FOREIGN KEY (id_veiculo)
        REFERENCES veiculos(id_veiculo),

    FOREIGN KEY (id_funcionario)
        REFERENCES funcionarios(id_funcionario)
);

-- 6. Tabela de contatos do site
CREATE TABLE contatos (
    id_contato INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(120) NOT NULL,
    telefone VARCHAR(20),
    mensagem TEXT NOT NULL
);

-- Conferir se as tabelas foram criadas
SHOW TABLES;



-- =========================================================
-- PROJETO: NOVA ERA MOTORS
-- INTEGRANTES: MATHEUS PINHEIRO, MATHEUS FRANCISCO,
-- VINICIUS GOMES, NOAH, DAZI
-- DATA: 07/10/2026
-- =========================================================


-- =========================================================
-- VISUALIZAÇÃO DOS DADOS
-- =========================================================

SELECT * FROM clientes;
SELECT * FROM veiculos;
SELECT * FROM servicos;
SELECT * FROM funcionarios;
SELECT * FROM vendas;


-- =========================================================
-- ESTRUTURA DAS TABELAS
-- =========================================================

DESCRIBE clientes;
DESCRIBE veiculos;
DESCRIBE funcionarios;
DESCRIBE servicos;
DESCRIBE vendas;


-- =========================================================
-- CADASTRO DOS VEÍCULOS
-- =========================================================

INSERT INTO veiculos
(marca, modelo, ano, cor, placa, quilometragem, status, preco)
VALUES
('Volvo', 'EX30', 2024, 'Branco', 'PCX2Y24', 343, 'Disponivel', 239990.00),
('Toyota', 'Corolla', 2024, 'Preto', 'ABC1D23', 8, 'Disponivel', 159990.00),
('Volkswagen', 'Nivus GTS', 2026, 'Branco', 'XRT3F45', 14, 'Disponivel', 189990.00),
('Chevrolet', 'Tracker', 2026, 'Vermelho', 'CDA8L13', 11, 'Disponivel', 174990.00);


-- Conferindo os veículos cadastrados

SELECT * FROM veiculos;


-- =========================================================
-- DADOS PARA REALIZAR OS INNER JOIN
-- =========================================================

INSERT INTO clientes
(nome, cpf, telefone, email, endereco)
VALUES
('Carlos Silva', '111.111.111-11', '(11) 99999-1111',
 'carlos@email.com', 'Rua A, 100'),

('Ana Souza', '222.222.222-22', '(11) 99999-2222',
 'ana@email.com', 'Rua B, 200'),

('Joao Santos', '333.333.333-33', '(11) 99999-3333',
 'joao@email.com', 'Rua C, 300');


INSERT INTO funcionarios
(nome, cpf, telefone, email, cargo)
VALUES
('Marcos Oliveira', '444.444.444-44', '(11) 99999-4444',
 'marcos@novaera.com', 'Vendedor'),

('Juliana Costa', '555.555.555-55', '(11) 99999-5555',
 'juliana@novaera.com', 'Vendedora');


-- =========================================================
-- VENDAS
-- =========================================================
-- PK de clientes:
-- clientes.id_cliente
--
-- PK de veiculos:
-- veiculos.id_veiculo
--
-- PK de funcionarios:
-- funcionarios.id_funcionario
--
-- FK de vendas:
-- vendas.id_cliente -> clientes.id_cliente
-- vendas.id_veiculo -> veiculos.id_veiculo
-- vendas.id_funcionario -> funcionarios.id_funcionario


INSERT INTO vendas
(id_cliente, id_veiculo, id_funcionario)
VALUES
(1, 1, 1),
(2, 2, 1),
(3, 3, 2);


-- Conferindo as vendas

SELECT * FROM vendas;


-- =========================================================
-- 1. COUNT(*)
-- =========================================================
-- Pergunta:
-- Quantos veículos estão cadastrados na Nova Era Motors?

SELECT
    COUNT(*) AS total_veiculos
FROM veiculos;


-- Resultado esperado:
-- 4 veículos


-- =========================================================
-- CONFERÊNCIA DO COUNT
-- =========================================================

SELECT
    COUNT(*) AS total_veiculos
FROM veiculos
WHERE status = 'Disponivel';


-- Resultado esperado:
-- 4 veículos disponíveis


-- =========================================================
-- 2. SUM
-- =========================================================
-- Pergunta:
-- Qual é o valor total dos veículos cadastrados?

SELECT
    SUM(preco) AS valor_total_veiculos
FROM veiculos;


-- Resultado esperado:
-- R$ 764.960,00
--
-- Unidade:
-- Reais (R$)
--
-- Interpretação:
-- Permite acompanhar o valor financeiro
-- total dos veículos cadastrados.


-- =========================================================
-- 3. AVG
-- =========================================================
-- Pergunta:
-- Qual é o preço médio dos veículos cadastrados?

SELECT
    AVG(preco) AS preco_medio_veiculos
FROM veiculos;


-- Resultado esperado:
-- R$ 191.240,00
--
-- Interpretação:
-- O preço médio permite identificar a faixa
-- de valor dos veículos cadastrados.


-- =========================================================
-- CONFERÊNCIA DO AVG
-- =========================================================

SELECT
    SUM(preco) AS soma_precos,
    COUNT(preco) AS quantidade_precos,
    AVG(preco) AS media_precos
FROM veiculos;


-- Valores considerados:
--
-- Volvo EX30        = 239.990
-- Toyota Corolla    = 159.990
-- Volkswagen Nivus  = 189.990
-- Chevrolet Tracker = 174.990
--
-- Soma = 764.960
-- Quantidade = 4
--
-- 764.960 / 4 = 191.240


-- =========================================================
-- 4. GROUP BY
-- =========================================================
-- Pergunta:
-- Quantos veículos estão cadastrados por marca?

SELECT
    marca,
    COUNT(*) AS quantidade_veiculos
FROM veiculos
GROUP BY marca;


-- Cada linha representa uma marca
-- e a quantidade de veículos dessa marca.


-- =========================================================
-- 5. INNER JOIN
-- =========================================================
-- Pergunta:
-- Quais clientes compraram quais veículos?
--
-- PK:
-- clientes.id_cliente
--
-- FK:
-- vendas.id_cliente
--
-- PK:
-- veiculos.id_veiculo
--
-- FK:
-- vendas.id_veiculo


SELECT
    c.nome AS cliente,
    v.marca AS marca_veiculo,
    v.modelo AS modelo_veiculo,
    v.ano AS ano_veiculo,
    v.preco AS preco_veiculo
FROM vendas AS vd

INNER JOIN clientes AS c
    ON vd.id_cliente = c.id_cliente

INNER JOIN veiculos AS v
    ON vd.id_veiculo = v.id_veiculo;


-- Interpretação:
-- Cada linha representa uma venda realizada,
-- mostrando o cliente e o veículo comprado.
--
-- O INNER JOIN apresenta somente registros
-- que possuem correspondência entre as tabelas.
--
-- Portanto, clientes sem vendas não aparecem.
-- Veículos sem vendas também não aparecem.


-- =========================================================
-- INNER JOIN COM CLIENTE + VEÍCULO + FUNCIONÁRIO
-- =========================================================
-- Pergunta:
-- Qual cliente comprou qual veículo
-- e qual funcionário realizou a venda?


SELECT
    c.nome AS cliente,
    v.marca AS marca_veiculo,
    v.modelo AS modelo_veiculo,
    f.nome AS funcionario,
    f.cargo AS cargo_funcionario
FROM vendas AS vd

INNER JOIN clientes AS c
    ON vd.id_cliente = c.id_cliente

INNER JOIN veiculos AS v
    ON vd.id_veiculo = v.id_veiculo

INNER JOIN funcionarios AS f
    ON vd.id_funcionario = f.id_funcionario;


-- =========================================================
-- DESAFIO
-- INNER JOIN + GROUP BY
-- =========================================================
-- Pergunta:
-- Quantas vendas cada funcionário realizou
-- e qual foi o valor total dos veículos vendidos?


SELECT
    f.nome AS funcionario,
    COUNT(vd.id_venda) AS quantidade_vendas,
    SUM(v.preco) AS valor_total_vendas
FROM vendas AS vd

INNER JOIN funcionarios AS f
    ON vd.id_funcionario = f.id_funcionario

INNER JOIN veiculos AS v
    ON vd.id_veiculo = v.id_veiculo

GROUP BY
    f.id_funcionario,
    f.nome;


-- =========================================================
-- INTERPRETAÇÃO DO DESAFIO
-- =========================================================
--
-- Antes do GROUP BY:
-- Cada linha representa uma venda individual.
--
-- Depois do GROUP BY:
-- Cada linha representa um funcionário.
--
-- quantidade_vendas:
-- Mostra quantas vendas cada funcionário realizou.
--
-- valor_total_vendas:
-- Mostra a soma dos preços dos veículos
-- vendidos por cada funcionário.


-- =========================================================
-- CONFERÊNCIA DO TOTAL DE VENDAS
-- =========================================================

SELECT
    COUNT(*) AS total_vendas
FROM vendas;


-- Resultado esperado:
-- 3 vendas


-- =========================================================
-- CONFERÊNCIA DO VALOR TOTAL DAS VENDAS
-- =========================================================

SELECT
    SUM(v.preco) AS valor_total_vendas
FROM vendas AS vd

INNER JOIN veiculos AS v
    ON vd.id_veiculo = v.id_veiculo;


-- Resultado esperado:
--
-- Volvo EX30       = 239.990
-- Toyota Corolla   = 159.990
-- Nivus GTS        = 189.990
--
-- Total = R$ 589.970,00


-- =========================================================
-- RELATÓRIO FINAL
-- =========================================================

SELECT
    f.nome AS funcionario,
    COUNT(vd.id_venda) AS total_vendas,
    SUM(v.preco) AS valor_total_vendas,
    AVG(v.preco) AS preco_medio_vendido
FROM vendas AS vd

INNER JOIN funcionarios AS f
    ON vd.id_funcionario = f.id_funcionario

INNER JOIN veiculos AS v
    ON vd.id_veiculo = v.id_veiculo

GROUP BY
    f.id_funcionario,
    f.nome;



-- ============================================================
-- ATIVIDADE: INNER JOIN, LEFT JOIN, RIGHT JOIN
-- E REGISTROS SEM CORRESPONDENCIA
-- ============================================================

-- ETAPA 1 - DESCRICAO DAS TABELAS E RELACIONAMENTO
-- Tabela principal: clientes
-- Chave primaria: clientes.id_cliente
-- Tabela relacionada: vendas
-- Chave primaria: vendas.id_venda
-- Chave estrangeira: vendas.id_cliente
-- Relacionamento: vendas.id_cliente referencia clientes.id_cliente.
--
-- Pergunta: quais clientes possuem vendas e quais ainda nao possuem?
-- Utilidade: identificar clientes que podem precisar de acompanhamento.

-- ETAPA 2 - CONFERIR OS DADOS
SELECT
    clientes.id_cliente,
    clientes.nome,
    clientes.cpf,
    clientes.email
FROM clientes
ORDER BY clientes.id_cliente;

SELECT
    vendas.id_venda,
    vendas.id_cliente,
    vendas.id_veiculo,
    vendas.id_funcionario
FROM vendas
ORDER BY vendas.id_venda;


-- REGISTRO OPCIONAL PARA TESTE
-- Cria um cliente sem venda somente se o CPF ainda nao existir.
-- Executar apenas no banco de desenvolvimento.
INSERT INTO clientes (nome, cpf, telefone, email, endereco)
SELECT
    'Cliente Teste JOIN',
    '999.999.999-99',
    NULL,
    'teste.join@exemplo.com',
    'Cadastro de teste'
WHERE NOT EXISTS (
    SELECT 1
    FROM clientes
    WHERE cpf = '999.999.999-99'
);


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


-- ============================================================
-- ATIVIDADE: IN, NOT IN, EXISTS E VIEW
-- ============================================================

-- Conferindo clientes e vendas
SELECT * FROM clientes;
SELECT * FROM vendas;


-- 1. IN
-- Quais clientes possuem vendas cadastradas?
SELECT
    c.id_cliente,
    c.nome,
    c.email
FROM clientes AS c
WHERE c.id_cliente IN (
    SELECT v.id_cliente
    FROM vendas AS v
    WHERE v.id_cliente IS NOT NULL
)
ORDER BY c.nome;


-- 2. NOT IN
-- Quais clientes ainda nao possuem vendas?
SELECT
    c.id_cliente,
    c.nome,
    c.email
FROM clientes AS c
WHERE c.id_cliente NOT IN (
    SELECT v.id_cliente
    FROM vendas AS v
    WHERE v.id_cliente IS NOT NULL
)
ORDER BY c.nome;


-- 3. EXISTS
-- Verifica se existe alguma venda para cada cliente.
SELECT
    c.id_cliente,
    c.nome,
    c.email
FROM clientes AS c
WHERE EXISTS (
    SELECT 1
    FROM vendas AS v
    WHERE v.id_cliente = c.id_cliente
)
ORDER BY c.nome;


-- 4. NOT EXISTS
-- Mostra clientes que nao possuem vendas.
SELECT
    c.id_cliente,
    c.nome,
    c.email
FROM clientes AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM vendas AS v
    WHERE v.id_cliente = c.id_cliente
)
ORDER BY c.nome;


-- Comparacao:
-- IN e EXISTS devem retornar os mesmos clientes com vendas.
-- NOT IN e NOT EXISTS devem retornar os clientes sem vendas.


-- 5. CRIAR A VIEW
-- O LEFT JOIN permite que clientes sem vendas tambem aparecam.
CREATE OR REPLACE VIEW vw_clientes_vendas AS
SELECT
    c.id_cliente,
    c.nome AS nome_cliente,
    c.email,
    v.id_venda,
    v.id_veiculo,
    v.id_funcionario
FROM clientes AS c
LEFT JOIN vendas AS v
    ON c.id_cliente = v.id_cliente;


-- 6. CONSULTAR A VIEW
SELECT *
FROM vw_clientes_vendas
ORDER BY nome_cliente;


-- 7. CLIENTES COM VENDAS PELA VIEW
SELECT *
FROM vw_clientes_vendas
WHERE id_venda IS NOT NULL
ORDER BY nome_cliente;


-- 8. CLIENTES SEM VENDAS PELA VIEW
SELECT
    id_cliente,
    nome_cliente,
    email
FROM vw_clientes_vendas
WHERE id_venda IS NULL
ORDER BY nome_cliente;


-- ============================================================
-- CONCLUSAO DAS ATIVIDADES
-- ============================================================
-- INNER JOIN: retorna somente registros com correspondencia.
-- LEFT JOIN: mantem todos os clientes.
-- RIGHT JOIN: mantem todos os clientes neste relacionamento.
-- LEFT JOIN + IS NULL: identifica clientes sem vendas.
-- IN: procura IDs de clientes presentes na subconsulta.
-- NOT IN: procura IDs ausentes da subconsulta.
-- EXISTS: verifica se existe uma venda para o cliente.
-- NOT EXISTS: verifica se nao existe venda para o cliente.
-- VIEW: salva a consulta de clientes e vendas para reutilizacao.
--
-- A consulta de clientes sem vendas pode apoiar o acompanhamento
-- comercial da Nova Era Motors.
-- ============================================================
