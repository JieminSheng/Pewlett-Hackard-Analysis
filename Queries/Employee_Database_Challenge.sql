-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
     dept_no VARCHAR(8) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);
CREATE TABLE employees (
     emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager (
    dept_no VARCHAR(8) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
    FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE salaries (
    emp_no INT NOT NULL,
    salary INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
    PRIMARY KEY (emp_no)
);

CREATE TABLE dept_emp (
    emp_no INT NOT NULL,
    dept_no VARCHAR(8) NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
    FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE title (
    emp_no INT NOT NULL,
    title_name VARCHAR(40) NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);

-- Deliverable 1
-- Creating retirement titles table from employees and title tables for employees born in 1952 and 1955
SELECT DISTINCT employees.emp_no, first_name, last_name, title_name, from_date, to_date
INTO retirement_titles
FROM employees, title
Where employees.emp_no = title.emp_no 
AND (employees.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY emp_no ASC;

-- Creating unique titles table from retirement titles table for employees born in 1952 and 1955 who are still employed

SELECT DISTINCT ON (emp_no) emp_no, first_name, last_name, title_name
INTO unique_titles
FROM retirement_titles
Where to_date = '9999-01-01' 
ORDER BY emp_no ASC,to_date DESC;

-- Creating retiring titles table from unique titles table to categorize the number of employees born in 1952 and 1955 who are still employed by each title

SELECT COUNT(emp_no), title_name
INTO retiring_titles
FROM unique_titles 
GROUP BY title_name
ORDER BY COUNT(title_name) DESC;

-- Deliverable 2
-- Creating mentorship eligibility table from employees, title, and department employees tables for employees born in 1965 who are still employed
-- Please note that the example table given in the module is incorrect as it does not reflect the current titles of employees

SELECT DISTINCT ON (emp_no) employees.emp_no, first_name, last_name, birth_date, dept_emp.from_date, dept_emp.to_date, title_name 
INTO mentorship_eligibilty
FROM employees, title, dept_emp
Where employees.emp_no = dept_emp.emp_no
And employees.emp_no = title.emp_no 
And dept_emp.to_date = '9999-01-01' 
And title.to_date = '9999-01-01' 
AND (birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY emp_no ASC;

-- Creating mentorship titles table from mentorship eligibility table to categorize the number of employees born in 1965 who are still employed by each title

SELECT COUNT(emp_no), title_name
INTO mentorship_titles
FROM mentorship_eligibilty
GROUP BY title_name
ORDER BY COUNT(title_name) DESC;

-- Deliverable 3
-- creating a currently employed table by filtering for currently employed employees

SELECT DISTINCT emp_no, from_date, to_date, title_name 
INTO currently_employed
FROM title
Where title.to_date = '9999-01-01'
ORDER BY emp_no ASC;

-- Creating employed titles table from currently employed table to categorize the number of employees who are currently employed

SELECT COUNT(emp_no), title_name
INTO employed_titles
FROM currently_employed
GROUP BY title_name
ORDER BY COUNT(title_name) DESC;

-- Creating retirement titles by department table from employees, title, and department tables for employees born in 1952 and 1955

SELECT DISTINCT employees.emp_no, dept_no, first_name, last_name, title_name, dept_emp.from_date, dept_emp.to_date
INTO retirement_titles_dept
FROM employees, title, dept_emp
Where employees.emp_no = dept_emp.emp_no
And employees.emp_no = title.emp_no 
AND (employees.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY emp_no ASC;

-- Creating unique titles table by department from retirement titles by department table for employees born in 1952 and 1955 who are still employed

SELECT DISTINCT ON (emp_no) emp_no, dept_no, first_name, last_name, title_name
INTO unique_titles_dept
FROM retirement_titles_dept
Where to_date = '9999-01-01' 
ORDER BY emp_no ASC,to_date DESC;

-- Creating retiring titles table by department from unique titles by department table to categorize the number of employees born in 1952 and 1955 who are still employed by each title

SELECT COUNT(emp_no), dept_no, title_name
INTO retiring_titles_dept
FROM unique_titles_dept
GROUP BY dept_no, title_name
ORDER BY dept_no ASC;

-- Creating mentorship eligibility by department table from employees, title, and department employees tables for employees born in 1965 who are still employed

SELECT DISTINCT ON (emp_no) employees.emp_no, dept_no ,first_name, last_name, birth_date, dept_emp.from_date, dept_emp.to_date, title_name 
INTO mentorship_eligibilty_dept
FROM employees, title, dept_emp
Where employees.emp_no = dept_emp.emp_no
And employees.emp_no = title.emp_no 
And dept_emp.to_date = '9999-01-01' 
And title.to_date = '9999-01-01' 
AND (birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY emp_no ASC;

-- Creating mentorship titles by department table from mentorship eligibility by department table to categorize the number of employees born in 1965 who are still employed by each title

SELECT COUNT(emp_no), dept_no, title_name
INTO mentorship_titles_dept
FROM mentorship_eligibilty_dept
GROUP BY dept_no, title_name
ORDER BY dept_no ASC;
