use hospitalda;

select * from billing;
select * from appointments ;
select * from doctors;
select * from treatments ;
select * from patients;

-- Find age of the patient during the treatment
Select p.patient_id, p.first_name, p.date_of_birth, a.appointment_date,
timestampdiff(year, p.date_of_birth, a.appointment_date) as patient_age
from patients as p
join appointments as a 
on a.patient_id = p.patient_id
order by timestampdiff(year, p.date_of_birth, a.appointment_date);

-- Check the diagnosis reason of below 10 year patient
select p.first_name, timestampdiff(year, p.date_of_birth, a.appointment_date) as age, a.reason, t.diagnosis
from treatments t
join appointments as a 
join patients as p
on t.appointment_id = a.appointment_id and 
a.patient_id = p.patient_id
where timestampdiff(year, p.date_of_birth, a.appointment_date) between 0 and 10
order by timestampdiff(year, p.date_of_birth, a.appointment_date);


-- How Many patients got admitted for which kind of diagnosis 

delimiter //
create procedure popular_diagnosis (IN year_input int)
begin
select t.diagnosis, count(a.patient_id) as count_patient
from treatments t
join appointments as a 
join patients as p
on t.appointment_id = a.appointment_id and 
a.patient_id = p.patient_id
where year(a.appointment_date) = year_input
group by 1
order by count(a.patient_id) desc;
end;
//

call popular_diagnosis(2024);

-- which doctor is god based on number of patient visited to them and their specialiation
Select d.first_name, d.specialty, count(a.patient_id) as count 
from appointments as a 
join doctors as d 
on d.doctor_id = a.doctor_id
group by 1,2
order by count(a.patient_id) desc
limit 10

-- find out the number of doctor in each application with there name 

SELECT 
	d.specialty,
    COUNT(d.doctor_id) AS total_doctors,
    GROUP_CONCAT(concat(d.first_name, ' ', d.last_name)
    order by d.first_name ASC SEPARATOR ',') as doctore_names
from doctors as d
group by d.specialty
order by 
total_doctors desc;

-- which treatment is expensive

-- each treatment cost