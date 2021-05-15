Appendix ‘D’ – Useful SQL for a Teradata DBA

This section provides a collection of useful SQL scripts/queries, which the Managed Services DBA team can utilize as reference for supporting, monitoring, and maintaining their various Teradata environments.

These queries are categorized under various types’ i.e. Space management, Security management, System management, Workload management etc. 





14.7	Statistics
---------------------
Understaning Stale Statistics

Query that shows missing statistics on Indexes.
-----------------------------------------------
	SEL Databasename, TableName, IndexName 
	FROM	 DBC.Indices 
	WHERE	 TRIM(Databasename)||'.'||TRIM(TableName) NOT IN (
	SELECT	 TRIM(Databasename)||'.'||TRIM(TableName) 
	FROM	 DBC.IndexStats WHERE IndexStatistics IS NOT NULL
	GROUP	 BY 1);

Collecting Statistics
A detailed document on using the Teradata General Purpose SQL is provided on TKO, Asset ID= SE7533. The SQL statement below is taken from this document and generates “collect statistics” SQL statements. It has no parameters, but you should set the target database before running it. The target database can be set through,

DATABASE “%target%”;
Where, %target% is the name of the target database or user defined in the RDBMS dictionary.

Note that simply running the SQL below doesn’t actually execute the task of “collecting statistics”: you need to run the generated SQL statements to complete your task.

-------------------------------------------------------------
-- NAME       : Collect Statistics
-- DESCRIPTION: Generates all collects statistics SQL
--    statements needed to collect statistics on both primary
--    and secondary indices of tables and on their columns.
-- PARAMETERS : none (current database is used as target)
-- NOTE       : "TableName" is needed in the order by clause
--  to group together indices belonging to the same table;
--  "IndexNumber" is needed to group columns belonging to the
--  same index, as on a table can be defined several indices;
--  "ColumnPosition" just sorts the columns in the same order
--  they were defined in the index.
-- REMARKS    :
-- SUPPORTED  : TD V2R5.x
-- VERSION    : 2.0, 9 Feb 2005
-- AUTHOR     : Daniele Giabbai
-- CHANGES    : One single query
-------------------------------------------------------------
-- VERSION    : 1.0, Mar 2004
-- AUTHOR     : Alessandro Cagnetti
-- NOTE       : Two separate queries for collecting primary
--  and secondary indices.
-------------------------------------------------------------

select strSQL from
  (
  select 'collect statistics on ' || trim(database)
        || '.' || trim(A.TableName)
        || ' index (' || ColumnName as strSQL
       , A.TableName
       , IndexNumber
       , cast (0 as smallint) as ColumnPosition
    from DBC.Indices A, DBC.Tables B
   where A.DatabaseName=B.DatabaseName and A.TableName = B.TableName
     and B.Tablekind = 'T'
     and A.DatabaseName   = trim(database)
     and IndexType     <> 'J'
     and ColumnPosition = 1
  union
  select ',' || ColumnName as strSQL
       , A.TableName
       , IndexNumber
       , cast(ColumnPosition as smallint) as ColumnPosition
    from DBC.Indices A, DBC.Tables B
   where A.DatabaseName=B.DatabaseName and A.TableName = B.TableName
     and B.Tablekind = 'T'
     and A.DatabaseName   = trim(database)
     and IndexType     <> 'J'
     and ColumnPosition > 1
  union
  select ');' as strSQL
       , A.TableName
       , IndexNumber
       , cast(255 as smallint) as ColumnPosition
    from DBC.Indices A, DBC.Tables B
   where A.DatabaseName=B.DatabaseName and A.TableName = B.TableName
     and B.Tablekind = 'T'
     and A.DatabaseName   = trim(database)
     and IndexType     <> 'J'
     and ColumnPosition = 1
  union
  select distinct 'collect statistics on ' || trim(database)
        || '.' || trim(A.TableName)
        || ' column ' || trim(ColumnName) || ';' as strSQL
       , A.TableName
       , 0 As IndexNumber
       , cast(256 as smallint) as ColumnPosition
    from DBC.Indices A, DBC.Tables B
   where A.DatabaseName=B.DatabaseName and A.TableName = B.TableName
     and B.Tablekind = 'T'
     and A.DatabaseName   = trim(database)
     and IndexType     <> 'J'
  ) a
order by TableName
       , IndexNumber
       , ColumnPosition
; 