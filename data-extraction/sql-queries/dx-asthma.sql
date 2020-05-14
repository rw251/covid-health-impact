--Just want the output, not the messages
SET NOCOUNT ON; 

--populate table with all dates from 2015-01-01
IF OBJECT_ID('tempdb..#AllDates') IS NOT NULL DROP TABLE #AllDates;
CREATE TABLE #AllDates ([date] date);
declare @dt datetime = '2015-01-01'
declare @dtEnd datetime = '2020-05-14';
WHILE (@dt <= @dtEnd) BEGIN
    insert into #AllDates([date])
        values(@dt)
    SET @dt = DATEADD(day, 1, @dt)
END;

-- Populate incidence table - only count those occurrences
-- of the code where it is the first time the patient has had it
select FirstDiagnosis, count(*) as num into #Incidence from (
	select PatID, min(EntryDate) as FirstDiagnosis from SIR_ALL_Records_Narrow
	where ReadCode in ('14B4.','173d.','1O2..','8H2P.','H3120','H312000','H312011','H33..','H330.','H3300','H330000','H330011','H3301','H330100','H330111','H330z','H330z00','H331.','H3310','H331000','H3311','H331111','H331z','H331z00','H332.','H333.','H334.','H335.','H33z.','H33z0','H33z000','H33z011','H33z1','H33z100','H33z111','H33z2','H33z200','H33zz','H33zz00','H33zz11','H33zz12','H33zz13','H3B..','H47y0','H3120','H3300','H3301','H330z','H3310','H331z','H33z0','H33z1','H33z2','H33zz')
	and EntryDate <= '2020-05-14'
	group by PatID
) sub 
where FirstDiagnosis >= '2015-01-01'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select EntryDate, count(*) as num into #Prevalence from (
	select PatID, EntryDate from SIR_ALL_Records_Narrow
	where ReadCode in ('14B4.','173d.','1O2..','8H2P.','H3120','H312000','H312011','H33..','H330.','H3300','H330000','H330011','H3301','H330100','H330111','H330z','H330z00','H331.','H3310','H331000','H3311','H331111','H331z','H331z00','H332.','H333.','H334.','H335.','H33z.','H33z0','H33z000','H33z011','H33z1','H33z100','H33z111','H33z2','H33z200','H33zz','H33zz00','H33zz11','H33zz12','H33zz13','H3B..','H47y0','H3120','H3300','H3301','H330z','H3310','H331z','H33z0','H33z1','H33z2','H33zz')
	and EntryDate >= '2015-01-01'
	and EntryDate <= '2020-05-14'
	group by PatID, EntryDate
) sub 
group by EntryDate

PRINT 'Date,IncidenceOfAsthma,PrevalenceOfAsthma'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.EntryDate = d.date
order by date;
