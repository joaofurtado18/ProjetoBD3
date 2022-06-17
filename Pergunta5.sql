-- QUERIE C) UMA OU OUTRA !!!!!!!!!!!
-- SELECT product_category, SUM(units) FROM replenishment_event NATURAL JOIN product GROUP BY product_category;
-- SELECT DISTINCT product_category, units FROM replenishment_event NATURAL JOIN product GROUP BY product_category, units;


SELECT product_category, units 
FROM replenishment_event 
NATURAL JOIN product 
GROUP BY product_category, units, serial_number 
HAVING serial_number = '123456789';