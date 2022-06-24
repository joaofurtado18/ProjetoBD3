-- QUERIE 1
SELECT DISTINCT retailer_name 
FROM responsable_for 
NATURAL JOIN retailer 
GROUP BY retailer_name 
HAVING COUNT(DISTINCT category_name) >= ALL 
        (SELECT COUNT(DISTINCT category_name) 
        FROM responsable_for 
        NATURAL JOIN retailer 
        GROUP BY retailer);

-- QUERIE 2
SELECT DISTINCT retailer_name
FROM retailer 
NATURAL JOIN responsable_for 
NATURAL JOIN category
WHERE category_name IN (
        SELECT simple_category_name
        FROM simple_category);

-- QUERIE 3
SELECT EAN FROM product 
EXCEPT
SELECT EAN FROM replenishment_event;

-- QUERIE 4
SELECT EAN 
FROM replenishment_event 
NATURAL JOIN product 
GROUP BY EAN 
HAVING COUNT(DISTINCT TIN) = 1;
