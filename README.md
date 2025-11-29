
# High-Paying Python Jobs Analysis (Advanced SQL Practice)

This SQL analysis identifies high-paying remote and Python-related job postings in 2023.  
It demonstrates advanced SQL techniques used in real-world data analytics work.

## 🚀 Concepts Demonstrated
- Multi-step CTE pipeline
- Window functions (AVG, COUNT OVER)
- Many-to-many join using bridge table (skills_job_dim)
- Analytical filtering
- CASE classification
- Correlated subquery with EXISTS
- Partitioning logic across job title, country, and company

## 📊 Goal
Find remote job postings from 2023 where:
- Salary is above average for job_title + job_country
- Posting requires Python
- Company has at least 10 Python postings in 2023
- Company has at least one Senior-level posting

## 🛠 SQL File
See the full query here:
👉 [high_paying_python_jobs.sql](./high_paying_python_jobs.sql)
