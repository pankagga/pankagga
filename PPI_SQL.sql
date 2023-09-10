14.4	PPI

PPI Tables
----------------------------

SELECT DATABASENAME, TABLENAME (TITLE 'TABLE/JOIN INDEX NAME'), CONSTRAINTTEXT
FROM	 DBC.INDEXCONSTRAINTS
WHERE	 CONSTRAINTTYPE = 'Q'
ORDER	 BY DATABASENAME, TABLENAME;

Output-
-------

DatabaseName                   TABLE/JOIN INDEX NAME          ConstraintText
------------------------------ ------------------------------ ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
retail                         ClaimMultiPPI                  CHECK (/*02*/ RANGE_N(claim_date  BETWEEN DATE '2002-01-01' AND DATE '2011-12-31' EACH INTERVAL '1' MONTH ) IS NOT NULL AND RANGE_N(state_id  BETWEEN 1  AND 75  EACH 1 ) IS NOT NULL )
retail                         ITEMPPI                        CHECK ((RANGE_N(l_shipdate  BETWEEN DATE '1992-01-01' AND DATE '1998-12-01' EACH INTERVAL '1' MONTH )) BETWEEN 1 AND 00084)

Single Level PPI 
----------------------------

CREATE SET TABLE retail.ITEMPPI ,NO FALLBACK ,
     NO BEFORE JOURNAL,
     NO AFTER JOURNAL,
     CHECKSUM = DEFAULT,
     DEFAULT MERGEBLOCKRATIO
     (
      L_ORDERKEY INTEGER NOT NULL,
      L_PARTKEY INTEGER NOT NULL,
      L_SUPPKEY INTEGER NOT NULL,
      L_LINENUMBER INTEGER NOT NULL,
      L_QUANTITY DECIMAL(15,2) NOT NULL,
      L_EXTENDEDPRICE DECIMAL(15,2) NOT NULL,
      L_DISCOUNT DECIMAL(15,2) NOT NULL,
      L_TAX DECIMAL(15,2) NOT NULL,
      L_RETURNFLAG CHAR(1) CHARACTER SET LATIN NOT CASESPECIFIC NOT NULL,
      L_LINESTATUS CHAR(1) CHARACTER SET LATIN NOT CASESPECIFIC NOT NULL,
      L_SHIPDATE DATE FORMAT 'YYYY-MM-DD' NOT NULL,
      L_COMMITDATE DATE FORMAT 'YYYY-MM-DD' NOT NULL,
      L_RECEIPTDATE DATE FORMAT 'YYYY-MM-DD' NOT NULL,
      L_SHIPINSTRUCT CHAR(25) CHARACTER SET LATIN NOT CASESPECIFIC NOT NULL,
      L_SHIPMODE CHAR(10) CHARACTER SET LATIN NOT CASESPECIFIC NOT NULL,
      L_COMMENT VARCHAR(44) CHARACTER SET LATIN NOT CASESPECIFIC NOT NULL)
PRIMARY INDEX ( L_ORDERKEY )
PARTITION BY RANGE_N(l_shipdate  BETWEEN DATE '1992-01-01' AND DATE '1998-12-01' EACH INTERVAL '1' MONTH )
INDEX ( L_PARTKEY )
INDEX ( L_SHIPDATE );

SELECT	 DATABASENAME, TABLENAME (TITLE 'TABLE/JOIN INDEX NAME')
FROM	 DBC.INDEXCONSTRAINTS
WHERE	 CONSTRAINTTYPE = 'Q'
	AND	 ( SUBSTRING(CONSTRAINTTEXT 
FROM	 1 
FOR	 13) < 'CHECK (/*02*/'
	OR	 SUBSTRING(CONSTRAINTTEXT 
FROM	 1 
FOR	 13) > 'CHECK (/*15*/' )
ORDER	 BY DATABASENAME, TABLENAME;

Output-
-------

DatabaseName                    TABLE/JOIN INDEX NAME
------------------------------  ------------------------------
retail                          ITEMPPI


MultiLevel PPI 
----------------------------

CREATE TABLE Retail.ClaimMultiPPI
( claim_id INTEGER NOT NULL
,cust_id INTEGER NOT NULL
,claim_date DATE NOT NULL
,state_id BYTEINT NOT NULL)
PRIMARY INDEX (claim_id)
PARTITION BY (
/* First level of partitioning */
RANGE_N (claim_date BETWEEN
DATE '2002-01-01' AND DATE '2011-12-31' EACH INTERVAL '1' MONTH ),
/* Second level of partitioning */
RANGE_N (state_id BETWEEN 1 AND 75 EACH 1) )
UNIQUE INDEX (claim_id);


SELECT DATABASENAME, TABLENAME (TITLE 'TABLE/JOIN INDEX NAME')
FROM	 DBC.INDEXCONSTRAINTS
WHERE	 CONSTRAINTTYPE = 'Q'
	AND	 SUBSTRING(CONSTRAINTTEXT 
FROM	 1 
FOR	 13) >= 'CHECK (/*02*/'
	AND	 SUBSTRING(CONSTRAINTTEXT 
FROM	 1 
FOR	 13) <= 'CHECK (/*15*/'
ORDER	 BY DATABASENAME, TABLENAME;

Output-
------
DatabaseName                    TABLE/JOIN INDEX NAME
------------------------------  ------------------------------
retail                          ClaimMultiPPI

----------------------------------------------------------------------------------------
