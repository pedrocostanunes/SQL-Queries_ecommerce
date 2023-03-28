
/* Após uma leitura de todas as tabelas do dataset, nota-se que
apenas o ano de 2017 possui dados completos (com todos os meses e dias)
sobre os pedidos feitos por e-commerce no Brasil. Por este motivo, 
mantivemos as perguntas de negócio deste projeto filtradas para
apenas este ano de 2017.*/

-- Respondendo à perguntas de negócio
USE OLIST

-- 1. Qual foi o faturamento total  em 2017?
SELECT SUM(pagamento_valor) as faturamento_total_2017
FROM tb_olist_pagamentos p
JOIN tb_olist_pedidos o 
	ON p.pedido_id = o.pedido_id
WHERE YEAR(pedido_compra_datahora) = 2017


-- 2. Qual foi ticket médio dos pedidos 2017?
SELECT
(
SELECT SUM(pagamento_valor)
FROM tb_olist_pagamentos p
JOIN tb_olist_pedidos o 
	ON p.pedido_id = o.pedido_id
WHERE YEAR(pedido_compra_datahora) = 2017)
/
(
SELECT COUNT(DISTINCT pedido_id)
FROM tb_olist_pedidos
WHERE YEAR(pedido_compra_datahora) = 2017)
as ticket_medio_2017

/* Existem diversas formas de consultar o ticket médio, inclusive usando 
AVG e JOIN com as as colunas das tabelas "tb_olist_pagamentos" e "tb_olist_pedidos". 
Mas, já que o ticket médio pode ser etendido como uma divisão do faturamento total 
pelo número de pedidos, decidi usar uma divisão entre dois subselects que 
represetavam as respostas anteriores (faturamento_total / total_pedidos) .
*/


-- 3. Qual o faturamento e ticket médio por tipo de pagamento em 2017?
select pagamento_tipo, AVG(pagamento_valor) as ticket_por_pgmt, 
	SUM(pagamento_valor) as faturamento_por_pgmt
FROM tb_olist_pagamentos p
JOIN tb_olist_pedidos o
	ON p.pedido_id = o.pedido_id
where pagamento_tipo != 'not_defined'
	AND YEAR(pedido_compra_datahora) = 2017
group by pagamento_tipo
order by faturamento_por_pgmt desc


-- 4. Quantos pedidos foram feitos em 2017?
SELECT COUNT(DISTINCT pedido_id) as total_pedidos_2017
FROM tb_olist_pedidos
WHERE YEAR(pedido_compra_datahora) = 2017


-- 5. Qual o ranking de faturamento por tipo de pagamento em 2017?
SELECT pagamento_tipo, SUM(pagamento_valor) as faturamento_total
FROM tb_olist_pagamentos p
JOIN tb_olist_pedidos o 
	ON p.pedido_id = o.pedido_id
WHERE YEAR(pedido_compra_datahora) = 2017
GROUP BY pagamento_tipo
ORDER BY faturamento_total DESC


-- 6. Quais foram os estados com maiores faturamentos em 2017?
SELECT c.cliente_estado, SUM(p.pagamento_valor) AS faturamento
FROM tb_olist_clientes c
JOIN tb_olist_pedidos o 
	ON c.cliente_id = o.cliente_id
JOIN tb_olist_pagamentos p 
	ON o.pedido_id = p.pedido_id
WHERE YEAR(o.pedido_compra_datahora) = 2017
GROUP BY c.cliente_estado
ORDER BY faturamento DESC


-- 7. Quais categorias de produtos geraram mais receita em 2017?
SELECT p.produto_categoria, SUM(pg.pagamento_valor) AS receita_total
FROM tb_olist_pagamentos pg
INNER JOIN tb_olist_pedidos_itens pi 
	ON pg.pedido_id = pi.pedido_id
INNER JOIN tb_olist_produtos p 
	ON pi.produto_id = p.produto_id
WHERE YEAR(pi.data_entrega_limite) = 2017
GROUP BY p.produto_categoria
ORDER BY receita_total DESC;
/* começamos selecionando a coluna produto_categoria da tabela tb_olist_produtos 
e somando a coluna pagamento_valor da tabela tb_olist_pagamentos. Em seguida, 
unimos a tabela tb_olist_pagamentos com a tabela tb_olist_pedidos_itens usando 
a coluna pedido_id e, em seguida, unimos o resultado com a tabela tb_olist_produtos 
usando a coluna produto_id. Em seguida, usamos a cláusula WHERE para selecionar 
apenas os itens entregues em 2017. Então, agrupamos os resultados por categoria 
de produto usando a cláusula GROUP BY e, finalmente, ordenamos os resultados 
em ordem decrescente de receita usando a cláusula ORDER BY.
*/


-- 8. Qual o faturamento por mês em 2017?
SELECT MONTH(pedido_compra_datahora) AS mes,  
    SUM(pagamento_valor) AS faturamento 
FROM tb_olist_pagamentos p 
INNER JOIN tb_olist_pedidos o 
	ON p.pedido_id = o.pedido_id 
WHERE YEAR(pedido_compra_datahora) = 2017 
GROUP BY MONTH(pedido_compra_datahora) 
ORDER BY MONTH(pedido_compra_datahora)
/* Nesse código, estamos utilizando a função MONTH() para extrair o mês 
a partir da coluna pedido_compra_datahora da tabela "tb_olist_pedidos", 
e a função YEAR() para extrair o ano. Em seguida, estamos somando os valores 
da coluna pagamento_valor da tabela "tb_olist_pagamentos" para cada mês e 
agrupando os resultados por mês e ano.Por fim, estamos ordenando os resultados 
pelo ano e pelo mês para obter o faturamento total por mês em ordem cronológica.
*/


-- 9. Qual o faturamento por trimestre em 2017?
SELECT DATEPART(quarter, ped.pedido_compra_datahora) AS trimestre,
    SUM(pag.pagamento_valor) AS faturamento
FROM tb_olist_pedidos AS ped
INNER JOIN tb_olist_pagamentos AS pag 
	ON ped.pedido_id = pag.pedido_id
WHERE YEAR(ped.pedido_compra_datahora) = 2017
GROUP BY DATEPART(quarter, ped.pedido_compra_datahora)
ORDER BY DATEPART(quarter, ped.pedido_compra_datahora)
/*Para obter os faturamentos de cada trimestre de 2017, podemos utilizar a função 
DATEPART() para extrair o trimestre de cada data de compra e, em seguida, agrupar 
e somar o faturamento para cada trimestre
*/
