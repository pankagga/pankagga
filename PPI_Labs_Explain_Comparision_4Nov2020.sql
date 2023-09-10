SHOW TABLE employee;
SHOW TABLE employee;

CREATE SET TABLE PD.ppi_employee ,FALLBACK ,
     NO BEFORE JOURNAL,
     NO AFTER JOURNAL,
     CHECKSUM = DEFAULT,
     DEFAULT MERGEBLOCKRATIO,
     MAP = TD_MAP1
     (
      Employee_Number INTEGER NOT NULL,
      department_number INTEGER,
      Emp_Mgr_Number INTEGER,
      Job_Code INTEGER,
      Last_Name CHAR(20) CHARACTER SET Latin NOT CaseSpecific,
      First_Name VARCHAR(20) CHARACTER SET Latin NOT CaseSpecific,
      Salary_Amount DECIMAL(10,2))
PRIMARY INDEX ( department_number )
PARTITION BY Range_N (department_number BETWEEN 1000 AND 1060 EACH 1);

INS INTO pd.ppi_employee SEL * FROM pd.Employee;

EXPLAIN 
SELECT LAST_NAME,First_name,Dept_name FROM pd.employee e,pd.department d
WHERE e.Department_number=d.Dept_number;


EXPLAIN 
SELECT LAST_NAME,First_name,Dept_name FROM pd.ppi_employee e,pd.department d
WHERE e.Department_number=d.Dept_number;

SHOW TABLE pd.department
SHOW TABLE pd.department;

CREATE SET TABLE pd.ppi_department ,FALLBACK ,
     NO BEFORE JOURNAL,
     NO AFTER JOURNAL,
     CHECKSUM = DEFAULT,
     DEFAULT MERGEBLOCKRATIO,
     MAP = TD_MAP1
     (
      Dept_Number INTEGER NOT NULL,
      Dept_Name CHAR(20) CHARACTER SET Latin NOT CaseSpecific NOT NULL,
      Dept_Mgr_Number INTEGER,
      Budget_Amount DECIMAL(10,2) )
	PRIMARY INDEX ( Dept_Number )
	PARTITION BY Range_N (Dept_Mgr_Number BETWEEN 100001 AND 1000000 EACH 1);
INS INTO ppi_department SEL * FROM department;

EXPLAIN 
SELECT LAST_NAME,First_name,Dept_name FROM pd.ppi_employee e,pd.ppi_department d
WHERE e.Department_number=d.Dept_number;

EXPLAIN 
SELECT LAST_NAME,First_name,Dept_name FROM pd.employee e,pd.ppi_department d
WHERE e.Department_number=d.Dept_number;