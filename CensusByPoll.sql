CREATE PROCEDURE CensusByPoll
@profile_id int,
@riding_name varchar(512)

-- CensusByPoll 1674,'Windsor West'
as

select 
p.ED_Name_En,
p.PD,
sum(try_cast(ce.DIM_SEX_MEMBER_ID_TOTAL_SEX as int) * co.percent_in_PD) as total_gender,
sum(try_cast(ce.DIM_SEX_MEMBER_ID_MALE as int)* co.percent_in_PD) as men,
sum(try_cast(ce.DIM_SEX_MEMBER_ID_FEMALE as int)* co.percent_in_PD) as women
from concordance co
inner join polling_division p on p.polling_division_ID = co.polling_division_ID
inner join DA d on d.da_ID = co.da_ID
inner join Census_Data ce on d.DAUID = ce.GEO_CODE_POR
WHERE ce.MEMBER_ID_PROFILE_OF_DISSEMINATION_AREAS = @profile_id
AND p.ED_Name_En = @riding_name

group by ED_Name_En,PD
order by total_gender

