CREATE OR REPLACE VIEW sales(ean, cat, ano, trimestre, mês, dia_mês, semana, dia_semana, distrito, concelho, unidades) AS
    SELECT 
        EAN AS ean, 
        category_name AS cat,
        EXTRACT(YEAR FROM instant) AS ano, 
        EXTRACT(QUARTER FROM instant) AS trimestre,
        EXTRACT(MONTH FROM instant) as mês,
        EXTRACT(DAY FROM instant) AS dia_mês,  
        EXTRACT(WEEK FROM instant) AS semana,
        EXTRACT(DOW FROM instant) AS dia_semana,
        district AS distrito,
        county AS concelho, 
        units AS unidades 
    FROM replenishment_event NATURAL JOIN instaled_at NATURAL JOIN retail_point NATURAL JOIN has_category
