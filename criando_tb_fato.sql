
/* Este projeto foi criado com dados do "Brazilian E-Commerce Public Dataset by Olist",
foram baixados os arquivos .csv através do kaggle.com/datasets/olistbr/brazilian-ecommerce.
*/

-- Criando o database para carregar os arquivos .csv
CREATE DATABASE OLIST

-- Os arquivos .csv foram importados para as tabelas de carga pelo método 'tasks/import data'

-- Visualizando os dados:
SELECT TOP 10 * FROM [dbo].[TB_CG_OLIST_CUSTOMER];
SELECT TOP 10 * FROM [dbo].[TB_CG_OLIST_ORDER_ITEMS];
SELECT TOP 10 * FROM [dbo].[TB_CG_OLIST_ORDER_PAYMENTS];
SELECT TOP 10 * FROM [dbo].[TB_CG_OLIST_ORDER_REVIEWS];
SELECT TOP 10 * FROM [dbo].[TB_CG_OLIST_ORDERS];
SELECT TOP 10 * FROM [dbo].[TB_CG_OLIST_PRODUCTS];


-- Criando as tabelas de produção (fato)
-- a. traduzindo os nomes de tabelas e colunas para português
-- b. transformando os tipos de dados de cada coluna


-- 1) CUSTOMER
CREATE TABLE tb_olist_clientes
(
cliente_id NVARCHAR(150),
cliente_unico_id NVARCHAR(150),
cliente_cep_prefixo NVARCHAR(15),
cliente_cidade NVARCHAR(100),
cliente_estado CHAR(2)
);
-- Verificando colunas da tabela de produção (fato) criada
SELECT * FROM tb_olist_clientes;
-- Pegando os dados da tabela CG e carregando na tabela ACT via código
INSERT INTO tb_olist_clientes
SELECT * FROM [dbo].[TB_CG_OLIST_CUSTOMER];


-- CRIANDO O RESTANTES DAS TB DE FATO REPLICANDO O MÉTODO ACIMA


-- 2) ORDER_ITEMS
CREATE TABLE tb_olist_pedidos_itens
(
pedido_id NVARCHAR(150),
item_pedido_id NVARCHAR(100),
produto_id NVARCHAR(100),
vendedor_id NVARCHAR(100),
data_entrega_limite DATETIME,
preco DECIMAL(10,2),
valor_frete DECIMAL(10,2)
);
INSERT INTO tb_olist_pedidos_itens
SELECT * FROM [dbo].[TB_CG_OLIST_ORDER_ITEMS];

SELECT * FROM tb_olist_pedidos_itens


-- 3) ORDER_PAYMENTS
CREATE TABLE tb_olist_pagamentos
(
pedido_id NVARCHAR(150),
pagamento_sequencia INT,
pagamento_tipo NVARCHAR(100),
pagamento_parcelas INT,
pagamento_valor DECIMAL(10,2)
);
INSERT INTO tb_olist_pagamentos
SELECT * FROM [dbo].[TB_CG_OLIST_ORDER_PAYMENTS];

SELECT * FROM tb_olist_pagamentos


-- 4) ORDERS
-- Ajustando campos em branco em 'order_approved_at', 'order_delivered_carrier_date' e 'order_delivered_customer_date' 
-- na tabela de carga para substituir os valores em branco por NULL
UPDATE [dbo].[TB_CG_OLIST_ORDERS] SET ORDER_ESTIMATED_DELIVERY_DATE = NULL
WHERE ORDER_ESTIMATED_DELIVERY_DATE = ''

CREATE TABLE tb_olist_pedidos
(
pedido_id NVARCHAR(150),
cliente_id NVARCHAR(150),
pedido_status NVARCHAR(50),
pedido_compra_datahora DATETIME,
pedido_aprovado_datahora DATETIME,
pedido_postagem_datahora DATETIME,
pedido_entrega_datahora DATETIME,
pedido_entrega_estimativa DATETIME,
);
INSERT INTO tb_olist_pedidos
SELECT * FROM [dbo].[TB_CG_OLIST_ORDERS];

SELECT * FROM tb_olist_pedidos


-- 5) PRODUCTS
CREATE TABLE tb_olist_produtos
(
produto_id NVARCHAR(150),
produto_categoria NVARCHAR(150),
produto_nome_tamanho INT,
produto_descricao_tamanho INT,
produto_fotos_qtd INT,
produto_peso_g INT,
produto_comprimento_cm INT,
produto_altura_cm INT,
produto_largura_cm INT,
);

INSERT INTO tb_olist_produtos
SELECT * FROM [dbo].[TB_CG_OLIST_PRODUCTS];

SELECT * FROM tb_olist_produtos


-- 6) ORDER_REVIEWS
CREATE TABLE tb_olist_reviews
(
review_id NVARCHAR(150),
pedido_id NVARCHAR(150),
review_nota INT,
review_comentario NVARCHAR(300),
review_mensagem NVARCHAR(500),
review_feita_datahora DATETIME,
review_respondida_datahora DATETIME,
);

INSERT INTO tb_olist_reviews
SELECT * FROM [dbo].[TB_CG_OLIST_ORDER_REVIEWS];

SELECT * FROM tb_olist_reviews


-- Visualizando as novas tabelas de fato
SELECT TOP 10 * FROM [dbo].[tb_olist_clientes];
SELECT TOP 10 * FROM [dbo].[tb_olist_pagamentos];
SELECT TOP 10 * FROM [dbo].[tb_olist_pedidos];
SELECT TOP 10 * FROM [dbo].[tb_olist_pedidos_itens];
SELECT TOP 10 * FROM [dbo].[tb_olist_produtos];
SELECT TOP 10 * FROM [dbo].[tb_olist_reviews];
