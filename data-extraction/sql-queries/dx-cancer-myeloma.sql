--Just want the output, not the messages
SET NOCOUNT ON; 

--populate table with all dates from 2015-01-01
IF OBJECT_ID('tempdb..#AllDates') IS NOT NULL DROP TABLE #AllDates;
CREATE TABLE #AllDates ([date] date);
declare @dt datetime = '2015-01-01'
declare @dtEnd datetime = '2020-05-29';
WHILE (@dt <= @dtEnd) BEGIN
    insert into #AllDates([date])
        values(@dt)
    SET @dt = DATEADD(day, 1, @dt)
END;

-- Populate incidence table - only count those occurrences
-- of the code where it is the first time the patient has had it
select FirstDiagnosis, count(*) as num into #Incidence from (
	select PatID, min(EntryDate) as FirstDiagnosis from SIR_ALL_Records_Narrow
	where ReadCode in ('4C53.00','B63..00','B63..99','B630.00','B630.11','B630.12','B630000','B630011','B630100','B630200','B630300','B630400','B631.00','B936.11','B936.12','BBn0.00','BBn0.11','BBn0.12','BBn0.13','BBn0.14','BBn2.00','BBn2.11','BBn2.12','BBn3.00','BBr3.00','BBr3000','BBr3z00','4C53.','B63..','B630.','B6300','B6301','B6302','B6303','B6304','B631.','BBn0.','BBn2.','BBn3.','BBr3.','BBr30','BBr3z')
	and EntryDate <= '2020-05-29'
	group by PatID
) sub 
where FirstDiagnosis >= '2015-01-01'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select EntryDate, count(*) as num into #Prevalence from (
	select PatID, EntryDate from SIR_ALL_Records_Narrow
	where ReadCode in ('4C53.00','B63..00','B63..99','B630.00','B630.11','B630.12','B630000','B630011','B630100','B630200','B630300','B630400','B631.00','B936.11','B936.12','BBn0.00','BBn0.11','BBn0.12','BBn0.13','BBn0.14','BBn2.00','BBn2.11','BBn2.12','BBn3.00','BBr3.00','BBr3000','BBr3z00','4C53.','B63..','B630.','B6300','B6301','B6302','B6303','B6304','B631.','BBn0.','BBn2.','BBn3.','BBr3.','BBr30','BBr3z')
	and EntryDate >= '2015-01-01'
	and EntryDate <= '2020-05-29'
	group by PatID, EntryDate
) sub 
group by EntryDate

PRINT 'Date,IncidenceOfMyeloma,PrevalenceOfMyeloma'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.EntryDate = d.date
order by date;
