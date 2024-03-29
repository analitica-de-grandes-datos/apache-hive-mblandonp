/*

Pregunta
===========================================================================

Escriba una consulta que calcule la cantidad de registros por clave de la 
columna 3. En otras palabras, cuántos registros hay que tengan la clave 
`aaa`?

Apache Hive se ejecutará en modo local (sin HDFS).

Escriba el resultado en la carpeta `output` de directorio de trabajo.

*/

DROP TABLE IF EXISTS t0; 
DROP TABLE IF EXISTS datos; 
CREATE TABLE t0 ( 
    c1 STRING, 
    c2 ARRAY<CHAR(1)>,  
    c3 MAP<STRING, INT> 
    ) 
    ROW FORMAT DELIMITED  
        FIELDS TERMINATED BY '\t' 
        COLLECTION ITEMS TERMINATED BY ',' 
        MAP KEYS TERMINATED BY '#' 
        LINES TERMINATED BY '\n'; 
LOAD DATA LOCAL INPATH 'data.tsv' INTO TABLE t0; 
 
CREATE TABLE datos AS SELECT key, value FROM t0 LATERAL VIEW explode(c3) letra_numer; 
 
INSERT OVERWRITE LOCAL DIRECTORY './output' 
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' 
SELECT key, COUNT(1) FROM datos GROUP BY key;