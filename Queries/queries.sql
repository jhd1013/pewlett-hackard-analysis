-- Create a list of retirement eligible employees from the
-- Sales and Development departments
SELECT de.emp_no,
	de.first_name,
	de.last_name,
	de.dept_name
FROM dept_info AS de
WHERE dept_name IN ('Sales', 'Development')

-- Create a list of employeesthat includes their
-- department name
SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	d.dept_name
INTO dept_info
FROM current_emp AS ce
	INNER JOIN dept_emp AS de
		ON (ce.emp_no = de.emp_no)
	INNER JOIN departments AS d
		ON (de.dept_no = d.dept_no)

-- List of managers per department
SELECT dm.dept_no,
	d.dept_name,
	dm.emp_no, 
	ce.first_name, 
	ce.last_name, 
	dm.from_date,
	dm.to_date
INTO manager_info
FROM dept_manager AS dm
	INNER JOIN departments AS d
		ON (dm.dept_no = d.dept_no)
	INNER JOIN current_emp AS ce
		ON (dm.emp_no = ce.emp_no);

-- Copy the list of employees and emp numbers for current
-- employees born 1952-1953 and hired 1985-1988 into a 
-- separate table. 
SELECT e.emp_no, 
	e.first_name, 
	e.last_name, 
	e.gender,
	s.salary,
	de.to_date
INTO emp_info
FROM employees AS e
INNER JOIN salaries AS s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp AS de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31') AND
	  (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31') AND
	  (de.to_date = ('9999-01-01'));

-- Employee count by department
SELECT COUNT(ce.emp_no), de.dept_no, depts.dept_name
INTO dept_retirement_counts
FROM current_emp as ce
LEFT JOIN dept_emp AS de ON ce.emp_no = de.emp_no
LEFT JOIN  departments AS depts ON de.dept_no = depts.dept_no
GROUP BY de.dept_no, depts.dept_name
ORDER BY de.dept_no

-- Join the retirement_info table with the dept_emp table
-- to get employee end dates (to_date); filter on current 
-- employees and put that into a new table
SELECT ri.emp_no, ri.first_name,
   		ri.last_name, de.to_date
INTO current_emp
FROM retirement_info AS ri
LEFT JOIN dept_emp AS de ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- Join the retirement_info table with the dept_emp table
-- to get employee end dates (to_date)
-- This time use aliases to shorten table names
SELECT ri.emp_no, ri.first_name,
   		ri.last_name, de.to_date
FROM retirement_info AS ri
LEFT JOIN dept_emp AS de ON ri.emp_no = de.emp_no
WHERE de.to_date = '9999-01-01';

-- Join the retirement_info table with the dept_emp table
-- to get employee end dates (to_date)
SELECT retirement_info.emp_no, retirement_info.first_name,
   		retirement_info.last_name, dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp ON retirement_info.emp_no = dept_emp.emp_no
WHERE dept_emp.to_date = '9999-01-01';

d 
-- Check the table
SELECT * FROM retirement_info

-- Joining departments and dept_manager tables
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments AS d
INNER JOIN dept_manager AS dm
ON d.dept_no = dm.dept_no;

-- Get the names of all employees eligible to retire along
-- with the employee's department.
SELECT first_name, last_name, dept_no 
FROM employees AS e
LEFT JOIN dept_emp AS d ON e.emp_no = d.emp_no
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31') AND
	  (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Copy the list of employees born 1952-1953 and hired 1985-1988
-- into a separate table.
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31') AND
	  (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Count the number of employees born 1952-1953 and hired 1985-1988.
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31') AND
	  (hire_date BETWEEN '1985-01-01' AND '1988-12-31');


-- Add fk from dept_emp to salaries
ALTER TABLE dept_emp 
	ADD CONSTRAINT dept_emp_salaries_emp_no FOREIGN KEY (emp_no) REFERENCES salaries (emp_no)
	ON DELETE CASCADE
	ON UPDATE CASCADE


-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
    dept_no varchar(4)   NOT NULL,
    dept_name varchar(40)  NOT NULL,
    PRIMARY KEY (dept_no),
	UNIQUE (dept_name)
);

CREATE TABLE employees(
	emp_no INT NOT NULL,
	birth_date DATE NOT NULL,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	gender VARCHAR NOT NULL,
	hire_date DATE NOT NULL,
	PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager(
	dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE salaries(
	emp_no INT NOT NULL,
	salary INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no)	
);

CREATE TABLE dept_emp(
	emp_no INT NOT NULL,
	dept_no VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
);