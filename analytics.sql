/*
    ------------------------------------------------------------------------------
    # 1. num dado período (i.e. entre duas datas), por dia da semana, 
    #  por concelho e no total
    ------------------------------------------------------------------------------
*/
SELECT dia_semana, concelho, SUM(unidades) AS sales
FROM Sales NATURAL JOIN replenishment_event
WHERE
    instant >= '1999-02-08 00:00:00'
    AND
    instant <= '1999-03-08 00:00:00'
GROUP BY 
    CUBE(dia_semana, concelho);
/*
    ------------------------------------------------------------------------------
    # 2.num dado distrito (i.e. “Lisboa”), por concelho, categoria, dia da 
    # semana e no total
    ------------------------------------------------------------------------------
*/
SELECT concelho, cat, dia_semana, SUM(unidades) AS sales
FROM Sales NATURAL JOIN product
WHERE 
    distrito = 'Lisboa'
GROUP BY 
    CUBE(concelho, cat, dia_semana) ;
