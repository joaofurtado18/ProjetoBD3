CREATE VIEW sales(ean, cat, ano, trimestre, semana, dia, distrito, concelho, unidades) AS
    SELECT r.EAN AS ean, 
        r.units AS unidades, 
        p.product_category as cat, 
        EXTRACT(YEAR FROM TIMESTAMP r.instant), 
        EXTRACT(QUARTER FROM TIMESTAMP r.instant),  
        EXTRACT(WEEK FROM TIMESTAMP r.instant),
        EXTRACT(DAY FROM TIMESTAMP r.instant),
    FROM replenishment_event r NATURAL JOIN product p