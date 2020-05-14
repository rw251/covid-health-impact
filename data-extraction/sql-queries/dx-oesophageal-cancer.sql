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
	where ReadCode in ('B10..00','B100.00','B101.00','B102.00','B103.00','B103.99','B104.00','B104.99','B105.00','B105.99','B106.00','B107.00','B10y.00','B10z.00','B10z.11','B10..','B100.','B101.','B102.','B103.','B104.','B105.','B106.','B107.','B10y.','B10z.')
	and EntryDate <= '2020-05-14'
	group by PatID
) sub 
where FirstDiagnosis >= '2015-01-01'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select EntryDate, count(*) as num into #Prevalence from (
	select PatID, EntryDate from SIR_ALL_Records_Narrow
	where ReadCode in ('B10..00','B100.00','B101.00','B102.00','B103.00','B103.99','B104.00','B104.99','B105.00','B105.99','B106.00','B107.00','B10y.00','B10z.00','B10z.11','B10..','B100.','B101.','B102.','B103.','B104.','B105.','B106.','B107.','B10y.','B10z.')
	and EntryDate >= '2015-01-01'
	and EntryDate <= '2020-05-14'
	group by PatID, EntryDate
) sub 
group by EntryDate

PRINT 'Date,IncidenceOfOesophagealCancer,PrevalenceOfOesophagealCancer'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.EntryDate = d.date
order by date;
