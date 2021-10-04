-- DELIVERABLE 1
-- Create the list of retirement eligible employees, including
-- their job titles
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	t.title,
	t.from_date,
	t.to_date
INTO retirement_titles
FROM employees as e
INNER JOIN titles as t
	ON e.emp_no = t.emp_no
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (rt.emp_no) 
    rt.emp_no,
	rt.first_name,
    rt.last_name,
    rt.title
INTO unique_titles
FROM retirement_titles as rt
ORDER BY rt.emp_no ASC, rt.to_date DESC

-- Count the number of employees by job title that are
-- nearing retirement
SELECT COUNT(ut.title),
	ut.title
INTO retiring_titles
FROM unique_titles AS ut
GROUP BY ut.title
ORDER BY count DESC

-- DELIVERABLE 2
-- Create a mentorship eligibility table that includes the list
-- of employees that are eligible for the mentorship program
SELECT DISTINCT ON (e.emp_no) 
	e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
	de.from_date,
	de.to_date,
	t.title
INTO mentorship_eligibility
FROM employees AS e
	LEFT JOIN dept_emp as de
		ON de.emp_no = e.emp_no
	LEFT JOIN titles as t
		ON t.emp_no = e.emp_no
WHERE de.to_date = ('9999-01-01') AND
	(e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no ASC

-- Count the number of employees by job title that are
-- nearing retirement
SELECT COUNT(rt.title),
	rt.title
FROM retiring_titles AS rt
GROUP BY rt.title
ORDER BY count DESC