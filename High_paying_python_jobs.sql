

/*Write one SQL query (you can and should use multiple CTEs) that returns info about high-paying remote data/analytics jobs requiring Python.
 COMPLEX QUERY */

with base_jobs_2023 as (	
	select 	
	 	jpf.job_id,
		cd.company_id, 
		cd.name,
	 	extract (year from jpf.job_posted_date) as year, 
		jpf.job_title_short, 
		jpf.job_country,
		jpf.salary_year_avg,
		round(avg(salary_year_avg) over (partition by job_title_short, job_country),2) avg_salary_per_combo
	from 
		job_postings_fact jpf
	inner join company_dim cd ON jpf.company_id = cd.company_id
	where 
		extract (year from job_posted_date) = 2023 and 
		job_work_from_home = 'Yes' and 
		salary_year_avg is not NULL and
		job_country is not NULL
), 
Python_jobs_2023 as (
	select 
		bj_2023.company_id,
		bj_2023.job_id,
		bj_2023.job_title_short, 
		bj_2023.job_country,
		bj_2023.salary_year_avg,
		sd.skills,
		bj_2023.avg_salary_per_combo,
		case 
			when salary_year_avg < 0.9 * avg_salary_per_combo then 'LOW'
			when salary_year_avg between 0.9 * avg_salary_per_combo and 1.1 * avg_salary_per_combo then 'MID'
			when salary_year_avg > 1.1 * avg_salary_per_combo then 'HIGH'
		end as salary_bucket 
	from 
		base_jobs_2023 bj_2023
	inner join skills_job_dim as sjd ON bj_2023.job_id = sjd.job_id 
	inner join skills_dim sd on sjd.skill_id = sd.skill_id 
	where 
		salary_year_avg > avg_salary_per_combo and 
		sd.skills ILIKE '%python%'
), 
postings_per_company_title_2023 as (
	select 
		pj_2023.company_id,
		pj_2023.job_title_short,
		count (*) over (partition by company_id, job_title_short) as count_postings,
		avg(salary_year_avg) over (partition by company_id , job_title_short) as avg_salary_2,
		count(*) Over (partition by company_id) as python_jobs
	from 
		Python_jobs_2023 pj_2023
)
SELECT 
	pj_2023.job_id, 
	pj_2023.job_title_short, 
	pj_2023.job_country, 
	pj_2023.salary_year_avg, 
	pj_2023.avg_salary_per_combo, 
	pj_2023.skills,
	pj_2023.salary_bucket, 
	ppct_2023.count_postings,
	ROUND(ppct_2023.avg_salary_2, 0) avg_salary_2
FROM 
	Python_jobs_2023 pj_2023 
JOIN postings_per_company_title_2023 ppct_2023 ON pj_2023.company_id = ppct_2023.company_id 
		 AND pj_2023.job_title_short = ppct_2023.job_title_short
WHERE 
	exists (
		select 1
		from job_postings_fact jpf2 
		where jpf2.company_id = pj_2023.company_id 
		and extract (year from jpf2.job_posted_date) = 2023
		and jpf2.job_title_short ILIKE '%Senior%'
		) and 
	python_jobs >= 10


	




	