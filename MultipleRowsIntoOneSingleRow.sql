--https://downloads.teradata.com/forum/database/concatenate-value-of-multiple-rows-into-one-single-row-1
--concatenate-value-of-multiple-rows-into-one-single-row-1

CREATE TABLE temp (parent_id INT, child_id VARCHAR(30),city_nm VARCHAR(30), Email VARCHAR(100));
INS INTO temp VALUES (1,'Sales','Portland','1ABC@XYZ.COM');
INS INTO temp VALUES (1,'Finance','San Francisco','1ABC@XYZ.COM');
INS INTO temp VALUES (1,'CC','NEW York','1ABC@XYZ.COM');
INS INTO temp VALUES (2,'Risk management','NEW Orleans','2DEF@XYZ.COM');
INS INTO temp VALUES (2,'Healthcare','Chicago','2DEF@XYZ.COM');
INS INTO temp VALUES (3,'Finance','Salem','3GHI@XYZ.COM');
INS INTO temp VALUES (3,'CC','Los Angeles','3GHI@XYZ.COM');
INS INTO temp VALUES (4,'Sales','Houston','4JKL@XYZ.COM');
ALTER TABLE temp RENAME EMail TO EMAIL_ADDR;
CREATE VOLATILE TABLE vt_temp AS (
 SELECT
   Parent_ID                     
   ,Child_ID                      
   ,city_nm                       
   ,EMAIL_ADDR                    
   ,Row_Number() Over (PARTITION BY parent_id ORDER BY child_id) AS rn
FROM temp
) WITH DATA PRIMARY INDEX(parent_id) ON COMMIT PRESERVE ROWS;
 
WITH RECURSIVE rec_test(Parent,child, location,mail,LVL)
   AS
   (
    SELECT parent_id,child_id (VARCHAR(1000)),city_nm (VARCHAR(1000)),email_addr, 1
    FROM vt_temp
    WHERE rn = 1
    UNION ALL
    SELECT  parent_id, Trim(child_id) || ', ' || child, Trim(city_nm)  || ', ' || location ,email_addr,LVL+1
    FROM vt_temp INNER JOIN rec_test
    ON parent_id = Parent
   AND vt_temp.rn = rec_test.lvl+1
   )
   SELECT Parent,child, location,mail,LVL
   FROM rec_test
QUALIFY Rank() Over(PARTITION BY Parent ORDER BY LVL DESC) = 1;