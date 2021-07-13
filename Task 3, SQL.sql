/*	1.Retreive all job titles that have minimum salary 5000	*/
select j.job_title from jobs j 
where j.min_salary > 5000;

/*	2.Total salaries in IT department	*/
select sum(e.salary) as "Total saraies in IT" from employees e
join departments d on e.department_id = d.department_id
where d.department_name = 'IT';

/*	3.Report showing the cost for each department in all countries.	*/
select c1.country_name, d.department_name, sum(e.salary) costs from employees e
join departments d on e.department_id = d.department_id
join locations l on d.location_id = l.location_id
join countries c1 on c1.country_id = l.country_id
group by c1.country_name, d.department_name
order by c1.country_name , d.department_name


/*	4.Number of employees children for every department	*/
select d1.department_name, count(*) kids from employees e
join departments d1 on e.department_id = d1.department_id
join dependents d2 on e.employee_id = d2.employee_id
where d2.relationship = 'Child'
group by d1.department_name
order by kids desc

/*	5.All employees works in Europe with their departments*/
select e.first_name, e.last_name, d.department_name, c1.country_name from employees e
join departments d on e.department_id = d.department_id
join locations l on d.location_id = l.location_id
join countries c1 on l.country_id = c1.country_id
join regions r on c1.region_id = r.region_id
where r.region_name = 'Europe'

/*	6.All the employees who hired before their managers	*/
select e.last_name "employee last name", e.hire_date "employee hire date", m.hire_date "manager hire date" from employees e
join employees m on e.manager_id = m.employee_id
where e.hire_date < m.hire_date


/*	7.Number of employees for each department in every region	*/
select r.region_name Region, d.department_name "Department name" , count(e.employee_id) "Employees count" from employees e
join departments d on e.department_id = d.department_id
join locations l on d.location_id = l.location_id
join countries c1 on l.country_id = c1.country_id
join regions r on c1.region_id = r.region_id
group by r.region_name, d.department_name
order by r.region_name, count(e.employee_id) desc

/*	8.Average salary for every department	*/
select  d.department_name "Department name" , round(avg(e.salary)) "Average salary" from employees e
join departments d on e.department_id = d.department_id
group by d.department_name
order by round(avg(e.salary)) asc;

/*	9.Job positions distribution	*/
select j.job_title, count(e.employee_id) "Employees count" from employees e
right join jobs j on e.job_id = j.job_id
group by j.job_title
order by j.job_title

/*	10.Job titles for every manager	*/
select e.employee_id, e.first_name, e.last_name, j.job_title, e.salary from employees e
join jobs j on e.job_id = j.job_id
where e.employee_id in (
    select distinct manager_id from employees
)
order by e.employee_id

/*	11.The employees who their salaries are less than the average salary for their job title */
select e.first_name, e.last_name, j.job_title, e.salary from employees e
join jobs j on e.job_id = j.job_id
where e.salary < 
(select (j.max_salary + j.min_salary)/2 from jobs j where j.job_id = e.job_id)

/*	12.Manager contact info	*/
select m.first_name, m.last_name, m.phone_number, m.email, d.department_name from employees m
join departments d on m.department_id = d.department_id
where m.employee_id in (
    select distinct manager_id from employees
)
order by m.first_name

/*	13.Employees with childern less 3	*/
select e.first_name, e.last_name, count(d.dependent_id) "Kids have" from employees e
join dependents d on e.employee_id = d.employee_id
group by e.first_name, e.last_name
having count(d.dependent_id) <= 2
order by count(d.dependent_id), e.first_name, e.last_name


/*	14.Departments location in the USA	*/
select d.department_name, l.city, l.state_province from locations l
join countries c1 on l.country_id = c1.country_id
join departments d on l.location_id = d.location_id
where c1.country_id = 'US'
order by l.state_province
