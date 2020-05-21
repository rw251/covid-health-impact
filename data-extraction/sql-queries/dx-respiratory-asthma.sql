--Just want the output, not the messages
SET NOCOUNT ON; 

--populate table with all dates from 2015-01-01
IF OBJECT_ID('tempdb..#AllDates') IS NOT NULL DROP TABLE #AllDates;
CREATE TABLE #AllDates ([date] date);
declare @dt datetime = '2015-01-01'
declare @dtEnd datetime = '2020-05-21';
WHILE (@dt <= @dtEnd) BEGIN
    insert into #AllDates([date])
        values(@dt)
    SET @dt = DATEADD(day, 1, @dt)
END;

-- Populate incidence table - only count those occurrences
-- of the code where it is the first time the patient has had it
select FirstDiagnosis, count(*) as num into #Incidence from (
	select NHSNo, min(entrydate) as FirstDiagnosis from journal
	where ReadCode in ('663V300','663V200','663V100','663V000','H3B..00','H33..00','H33..11','H335.00','H334.00','H333.00','H332.00','H331.00','H331.11','H331z00','H331100','H331111','H331000','H330.00','H330.11','H330.12','H330.13','H330.14','H330z00','H330100','H330111','H330000','H330011','H33z.00','H33z200','H33z100','H33z111','H33zz00','H33zz11','H33zz12','H33z000','H33z011','173A.00','1O2..00','H312000','663V3','663V2','663V1','663V0','H3B..','H33..','H335.','H334.','H333.','H332.','H331.','H331z','H3311','H3310','H330.','H330z','H3301','H3300','H33z.','H33z2','H33z1','H33zz','H33z0','173A.','1O2..','H3120')
	and entrydate <= '2020-05-21'
	group by NHSNo
) sub 
where FirstDiagnosis >= '2015-01-01'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select entrydate, count(*) as num into #Prevalence from (
	select NHSNo, entrydate from journal
	where ReadCode in ('663V300','663V200','663V100','663V000','H3B..00','H33..00','H33..11','H335.00','H334.00','H333.00','H332.00','H331.00','H331.11','H331z00','H331100','H331111','H331000','H330.00','H330.11','H330.12','H330.13','H330.14','H330z00','H330100','H330111','H330000','H330011','H33z.00','H33z200','H33z100','H33z111','H33zz00','H33zz11','H33zz12','H33z000','H33z011','173A.00','1O2..00','H312000','663V3','663V2','663V1','663V0','H3B..','H33..','H335.','H334.','H333.','H332.','H331.','H331z','H3311','H3310','H330.','H330z','H3301','H3300','H33z.','H33z2','H33z1','H33zz','H33z0','173A.','1O2..','H3120')
	and entrydate >= '2015-01-01'
	and entrydate <= '2020-05-21'
	group by NHSNo, entrydate
) sub 
group by entrydate

PRINT 'Date,IncidenceOfAsthma,PrevalenceOfAsthma'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.entrydate = d.date
order by date;
