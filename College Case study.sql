--Instructors and courses imfo

Select LastName, FirstName, CourseDescription
From Instructors
Left Join Courses
on Instructors.InstructorID=Courses.InstructorID
Order by LastName, FirstName--classifying studentsSelect 'UNDERGRAD' as Status, FirstName, LastName, EnrollmentDate, GraduationDate
From Students
Where GraduationDate is null
UNION
Select 'GRADUATED' as Status, FirstName, LastName, EnrollmentDate, GraduationDate
From Students
Where GraduationDate is not null
Order by EnrollmentDate

--Department with no courses
Select DepartmentName, CourseID
From Departments
Left Join Courses
on Departments.DepartmentID=Courses.DepartmentID
Where CourseID is null--Number of full time instructors and average salarySelect COUNT(*) as NumberofInstructors, AVG(AnnualSalary) as AverageSalary
From Instructors
Where Status='F'

--Number of instructors by department and highest salary by department
Select DepartmentName, COUNT(*) as NumberofInstructors, Max(AnnualSalary) as MaxSalary
From Departments
Join Instructors on Departments.DepartmentID=Instructors.DepartmentID
Group By DepartmentName--Number of Courses and Units by InstructorSelect FirstName + ' ' + LastName as InstructorName, COUNT(*) as NumberofCourses,
SUM(CourseUnits) as TotalUnits
From Instructors as I
Join Courses as C on I.InstructorID=C.InstructorID
Group by FirstName + ' ' + LastName
Order by TotalUnits desc

--Course info including number of students and department
Select DepartmentName, CourseDescription, Count(*) as NumberofStudents
From Courses as C
Join Departments as D on D.DepartmentID=C.DepartmentID
Join StudentCourses as S on S.CourseID=C.CourseID
Group by DepartmentName, CourseDescription
Order by DepartmentName, NumberofStudents--Information about current full time studentSelect S.StudentID, Sum(CourseUnits) as TotalCourse
From Students as S
Join StudentCourses as St on S.StudentID=St.StudentID
Join Courses as C on St.CourseID=C.CourseID
Where GraduationDate is null
Group By S.StudentID
Having Sum(CourseUnits)>9
Order By TotalCourse desc

--Number of courses taught by part time instructors
Select LastName + ', ' + FirstName as Instructor, Count(*) as NumberofCourses
From Instructors as I
Join Courses as C on I.InstructorID=C.InstructorID
Where Status='P'
Group By Rollup(LastName + ', ' + FirstName)--Number of employees by departmentselect count(*) as NumberofEmployees, D.Name as DepartmentName
from HumanResources.EmployeeDepartmentHistory as H
Join HumanResources.Department as D on H.DepartmentID=D.DepartmentID
where EndDate is null
Group by H.DepartmentID, D.Name
Order by DepartmentName