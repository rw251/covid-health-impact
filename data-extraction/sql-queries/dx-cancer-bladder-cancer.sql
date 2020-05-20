--Just want the output, not the messages
SET NOCOUNT ON; 

--populate table with all dates from 2015-01-01
IF OBJECT_ID('tempdb..#AllDates') IS NOT NULL DROP TABLE #AllDates;
CREATE TABLE #AllDates ([date] date);
declare @dt datetime = '2015-01-01'
declare @dtEnd datetime = '2020-05-20';
WHILE (@dt <= @dtEnd) BEGIN
    insert into #AllDates([date])
        values(@dt)
    SET @dt = DATEADD(day, 1, @dt)
END;

-- Populate incidence table - only count those occurrences
-- of the code where it is the first time the patient has had it
select FirstDiagnosis, count(*) as num into #Incidence from (
	select PatID, min(EntryDate) as FirstDiagnosis from SIR_ALL_Records_Narrow
	where ReadCode in ('B49..00','B49z.00','B49y.00','B49y000','B495.00','B494.00','B493.00','B492.00','B491.00','B490.00','B498.00','B497.00','B496.00','B581100','ByuC500','B49..','B49z.','B49y.','B49y0','B495.','B494.','B493.','B492.','B491.','B490.','B498.','B497.','B496.','B5811','ByuC5')
	and EntryDate <= '2020-05-20'
	group by PatID
) sub 
where FirstDiagnosis >= '2015-01-01'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select EntryDate, count(*) as num into #Prevalence from (
	select PatID, EntryDate from SIR_ALL_Records_Narrow
	where ReadCode in ('B49..00','B49z.00','B49y.00','B49y000','B495.00','B494.00','B493.00','B492.00','B491.00','B490.00','B498.00','B497.00','B496.00','B581100','ByuC500','B49..','B49z.','B49y.','B49y0','B495.','B494.','B493.','B492.','B491.','B490.','B498.','B497.','B496.','B5811','ByuC5')
	and EntryDate >= '2015-01-01'
	and EntryDate <= '2020-05-20'
	group by PatID, EntryDate
) sub 
group by EntryDate

PRINT 'Date,IncidenceOfBladderCancer,PrevalenceOfBladderCancer'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.EntryDate = d.date
order by date;
