--Just want the output, not the messages
SET NOCOUNT ON; 

--populate table with all dates from 2009-12-28
IF OBJECT_ID('tempdb..#AllDates') IS NOT NULL DROP TABLE #AllDates;
CREATE TABLE #AllDates ([date] date);
declare @dt datetime = '2009-12-28'
declare @dtEnd datetime = '2020-06-05';
WHILE (@dt <= @dtEnd) BEGIN
    insert into #AllDates([date])
        values(@dt)
    SET @dt = DATEADD(day, 1, @dt)
END;

-- Populate incidence table - only count those occurrences
-- of the code where it is the first time the patient has had it
select FirstDiagnosis, count(*) as num into #Incidence from (
	select NHSNo, min(entrydate) as FirstDiagnosis from journal
	where ReadCode in ('4C53.00','B63..00','B63..99','B630.00','B630.11','B630.12','B630000','B630011','B630100','B630200','B630300','B630400','B631.00','B936.11','B936.12','BBn0.00','BBn0.11','BBn0.12','BBn0.13','BBn0.14','BBn2.00','BBn2.11','BBn2.12','BBn3.00','BBr3.00','BBr3000','BBr3z00','4C53.','B63..','B630.','B6300','B6301','B6302','B6303','B6304','B631.','BBn0.','BBn2.','BBn3.','BBr3.','BBr30','BBr3z')
	and entrydate <= '2020-06-05'
	group by NHSNo
) sub 
where FirstDiagnosis >= '2009-12-28'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select entrydate, count(*) as num into #Prevalence from (
	select NHSNo, entrydate from journal
	where ReadCode in ('4C53.00','B63..00','B63..99','B630.00','B630.11','B630.12','B630000','B630011','B630100','B630200','B630300','B630400','B631.00','B936.11','B936.12','BBn0.00','BBn0.11','BBn0.12','BBn0.13','BBn0.14','BBn2.00','BBn2.11','BBn2.12','BBn3.00','BBr3.00','BBr3000','BBr3z00','4C53.','B63..','B630.','B6300','B6301','B6302','B6303','B6304','B631.','BBn0.','BBn2.','BBn3.','BBr3.','BBr30','BBr3z')
	and entrydate >= '2009-12-28'
	and entrydate <= '2020-06-05'
	group by NHSNo, entrydate
) sub 
group by entrydate

PRINT 'Date,IncidenceOfMyeloma,PrevalenceOfMyeloma'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.entrydate = d.date
order by date;
