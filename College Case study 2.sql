

--Instructors with a course
Select Distinct LastName, FirstName
From Instructors
Where InstructorID in (select instructorID from Courses)
Order by LastName, FirstName;

--Instructor with higher than average salaries
Select LastName, FirstName, AnnualSalary
From Instructors
Where AnnualSalary > (select AVG(AnnualSalary) from Instructors)
Order by AnnualSalary desc;

--Instructors without courses
Select LastName, FirstName
From Instructors
Where Not exists (
		select instructorID from Courses
		Where Instructors.InstructorID=Courses.InstructorID)
Order by LastName, FirstName;

--students taking more than one class
Select LastName, FirstName, COUNT(*) as NumberofClasses
from Students as s
	Join StudentCourses c on s.StudentID=c.StudentID
Where s.StudentID in (
		select c.StudentID 
		from StudentCourses
		Group by StudentID
		Having COUNT(*)>1
		)
Group by LastName, FirstName
Order by LastName, Firstname;

--Instructors with unique anual salaries
Select LastName, FirstName, AnnualSalary
From Instructors
Where AnnualSalary not in (Select AnnualSalary
		From Instructors
		Group by AnnualSalary
		Having COUNT(AnnualSalary)>1)
Order by LastName, FirstName;



--Modifying tables

Insert into Departments (DepartmentName)
Values('History');

Insert into Instructors 
Values
	('Benedict','Susan','P',0,GETDATE(),34000.00,9),
	('Adams', Null, 'F', 1, GETDATE(), 66000.00, 9);



Update Instructors 
set AnnualSalary=35000
where InstructorID=17;

Delete Instructors
Where InstructorID=18;


Delete Instructors
Where DepartmentID=9
 Delete Departments
 Where DepartmentID=9;

 
 Update Instructors
 Set AnnualSalary=AnnualSalary + AnnualSalary*0.05
 Where InstructorID in (Select InstructorID 
			from Instructors i
			Join Departments d on i.DepartmentID=d.DepartmentID
			Where DepartmentName='education');

Select * from Instructors

Delete Instructors
Where InstructorID not in 
	(Select i.InstructorID from Instructors i
		Join Courses c on i.InstructorID=c.InstructorID)



Create table GradStudent(
	StudentID int not null,
	LastName varchar(25),
	FirstName varchar(25),
	EnrollmentDate datetime2(0)not null,
	GraduationDate date null)
Insert into GradStudent
Select * from Students
Where GraduationDate is null

Select AnnualSalary/12 as 'MonthlySalary',
	   Cast(AnnualSalary/12 as decimal(10,1)) as 'MonthlySalary1',
	   Convert(int, AnnualSalary/12) as 'MonthlySalary2',
	   Cast(AnnualSalary/12 as int) as 'MonthlySalary3'
From Instructors;

Select EnrollmentDate,
	  Cast(EnrollmentDate as date) as 'EnrollmentDate1',
	  Cast(EnrollmentDate as time) as 'EnrollmentDate2',
	  Cast(EnrollmentDate as varchar(7)) as 'EnrollmentDate3'
From Students


Select CONVERT(varchar, EnrollmentDate, 101),
	   CONVERT(varchar, EnrollmentDate, 0),
	   CONVERT(varchar, EnrollmentDate, 114),
	   CONVERT(varchar(5), EnrollmentDate, 1)
From Students





	 