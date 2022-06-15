---------------------
-- 7.1
---------------------
CREATE INDEX index_cat_name ON responsable_for(category)
-- Justificação: Não é preciso criar index para o TIN, visto que este é uma 
-- primary key de retailer e foreign key de responsable_for. "P.nome_cat = 'Frutos'"
-- tem alta seletividade.

---------------------
-- 7.2
---------------------
CREATE INDEX index_cat_name ON product(product_category)
CREATE INDEX index_product_descr ON product(descr)
CREATE INDEX index_cat_name ON has_category(category_name)
-- Justificação: product_category e category_name são foreign keys de outras tabelas.
-- Já sabemos que a descrição do produto começa com 'A', então faz sentido usar index.