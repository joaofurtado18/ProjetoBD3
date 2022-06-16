-- QUERIE 1
SELECT retailer_name 
FROM responsable_for 
NATURAL JOIN retailer 
GROUP BY retailer_name 
HAVING COUNT(*) >= ALL 
        (SELECT COUNT(*) 
        FROM responsable_for 
        NATURAL JOIN retailer 
        GROUP BY retailer_name);


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