
CREATE MULTISET TABLE student(classID VARCHAR(10),
		studentid INT,studentname VARCHAR(30),subject VARCHAR(10), marks INT) 
PRIMARY INDEX (studentid);

--Inserting from a txt file with "," as dilimiter
INS INTO Student VALUES(?,?,?,?,?);

SEL	* FROM	Student;

--Cannot nest aggregate operations
SEL	Max(Sum(marks)), classID,studentName FROM	student GROUP BY 2,3;

SEL	Sum(marks), classID,studentName FROM	student GROUP BY 2,3;

SEL	* FROM	student A, (
	SEL	Sum(marks) Sum_Marks, classID,studentName FROM	student GROUP BY 2,3) B 
WHERE	A.classID=B.CLassID AND A.StudentName=B.StudentName;

SEL	DISTINCT A.ClassID,A.StudentName,B.Sum_Marks FROM	student A, (
	SEL	Sum(marks) Sum_Marks, classID,studentName FROM	student GROUP BY 2,3) B 
WHERE	A.classID=B.CLassID AND A.StudentName=B.StudentName ORDER BY 1,2,3;

SEL	DISTINCT A.ClassID,A.StudentName,B.Sum_Marks FROM	student A, (
	SEL	Sum(marks) Sum_Marks, classID,studentName FROM	student GROUP BY 2,3) B 
WHERE	A.classID=B.CLassID AND A.StudentName=B.StudentName ORDER BY 1 ASC,3 DESC;

SEL * FROM PD.Employee;
SELECT Last_Name,SALARY_AMOUNT, 
Row_Number() Over(ORDER BY SALARY_AMOUNT DESC) Row_Number,  
Rank() Over(ORDER BY SALARY_AMOUNT DESC)Rank,  
Dense_Rank() Over(ORDER BY SALARY_AMOUNT DESC) Dense_Rank  
FROM PD.Employee;

SELECT Last_Name,SALARY_AMOUNT, Row_Number() Over(ORDER BY SALARY_AMOUNT DESC) Row_Number1,  
Rank() Over(ORDER BY SALARY_AMOUNT DESC) Rank1,  Dense_Rank() Over(ORDER BY SALARY_AMOUNT DESC) Dense_Rank1 
FROM PD.Employee;

SEL Sum(marks) Sum_Marks, classID,studentName FROM student GROUP BY 2,3;

SEL Sum(marks) Sum_Marks, classID,studentName  
Row_Number() Over(ORDER BY Sum_Marks DESC) Row_Number1,  
Rank() Over(ORDER BY Sum_Marks DESC) Rank1,  Dense_Rank() Over(ORDER BY Sum_Marks DESC) Dense_Rank1  FROM student GROUP BY 2,3

SEL Sum(marks) Sum_Marks, classID,studentName,  
Row_Number() Over(ORDER BY Sum_Marks DESC) Row_Number1,  
Rank() Over(ORDER BY Sum_Marks DESC) Rank1,  Dense_Rank() Over(ORDER BY Sum_Marks DESC) Dense_Rank1  FROM student GROUP BY 2,3

SEL Sum(marks) Sum_Marks, classID,studentName,  
Row_Number() Over(ORDER BY Sum_Marks DESC GROUP BY classID) Row_Number1,  
Rank() Over(ORDER BY Sum_Marks DESC) Rank1,  Dense_Rank() Over(ORDER BY Sum_Marks DESC) Dense_Rank1  FROM student GROUP BY 2,3

SEL Sum(marks) Sum_Marks, classID,studentName,  
Row_Number(ClassID) Over(ORDER BY Sum_Marks DESC) Row_Number1,  
Rank() Over(ORDER BY Sum_Marks DESC) Rank1,  Dense_Rank() Over(ORDER BY Sum_Marks DESC) Dense_Rank1  FROM student GROUP BY 2,3

SEL Sum(marks) Sum_Marks, classID,studentName,  
Row_Number() Over(ORDER BY Sum_Marks DESC) Row_Number1,  
Rank() Over(ORDER BY Sum_Marks DESC) Rank1,  Dense_Rank() Over(ORDER BY Sum_Marks DESC) Dense_Rank1  FROM student GROUP BY 2

SEL Sum(marks) Sum_Marks, classID,  
Row_Number() Over(ORDER BY Sum_Marks DESC) Row_Number1,  
Rank() Over(ORDER BY Sum_Marks DESC) Rank1,  Dense_Rank() Over(ORDER BY Sum_Marks DESC) Dense_Rank1  FROM student GROUP BY 2

SEL Sum(marks) Sum_Marks, classID, studentName, 
Row_Number() Over(PARTITION BY classID ORDER BY Sum_Marks DESC) Row_Number1,  
Rank() Over(ORDER BY Sum_Marks DESC) Rank1,  
Dense_Rank() Over(ORDER BY Sum_Marks DESC) Dense_Rank1  FROM student GROUP BY 2,3

SEL Sum(marks) Sum_Marks, classID, studentName, 
Row_Number() Over(PARTITION BY classID ORDER BY Sum_Marks DESC) Row_Number1,  
Rank() Over(PARTITION BY classID ORDER BY Sum_Marks DESC) Rank1,  
Dense_Rank() Over(PARTITION BY classID ORDER BY Sum_Marks DESC) Dense_Rank1  FROM student GROUP BY 2,3

SEL Sum(marks) Sum_Marks, classID, studentName, 
Row_Number() Over(PARTITION BY classID ORDER BY Sum_Marks DESC) Row_Number1 
--Rank() Over(PARTITION BY classID ORDER BY Sum_Marks DESC) Rank1,  
--Dense_Rank() Over(PARTITION BY classID ORDER BY Sum_Marks DESC) Dense_Rank1  
FROM student GROUP BY 2,3

SEL Sum(marks) Sum_Marks, classID, studentName, 
Row_Number() Over(PARTITION BY classID ORDER BY Sum_Marks DESC) Row_Number1 
--Rank() Over(PARTITION BY classID ORDER BY Sum_Marks DESC) Rank1,  
--Dense_Rank() Over(PARTITION BY classID ORDER BY Sum_Marks DESC) Dense_Rank1  
FROM student 
GROUP BY 2,3 
QUALIFY Row_Number1 = 2;

SEL * FROM PD.Employee; 

SELECT Last_Name,SALARY_AMOUNT, 
Row_Number() Over(ORDER BY SALARY_AMOUNT DESC) Row_Number1,  
Rank() Over(ORDER BY SALARY_AMOUNT DESC) Rank1,  
Dense_Rank() Over(ORDER BY SALARY_AMOUNT DESC) Dense_Rank1  
FROM PD.Employee;

SEL * FROM PD.Employee; SELECT Last_Name,SALARY_AMOUNT, 
Row_Number() Over(ORDER BY SALARY_AMOUNT DESC) Row_Number1,  
Rank() Over(ORDER BY SALARY_AMOUNT DESC) Rank1,  
Dense_Rank() Over(ORDER BY SALARY_AMOUNT DESC) Dense_Rank1  
FROM PD.Employee QUALIFY Rank1 = 10;
