--Just want the output, not the messages
SET NOCOUNT ON; 

--populate table with all dates from 2015-01-01
IF OBJECT_ID('tempdb..#AllDates') IS NOT NULL DROP TABLE #AllDates;
CREATE TABLE #AllDates ([date] date);
declare @dt datetime = '2015-01-01'
declare @dtEnd datetime = '2020-05-13';
WHILE (@dt <= @dtEnd) BEGIN
    insert into #AllDates([date])
        values(@dt)
    SET @dt = DATEADD(day, 1, @dt)
END;

-- Populate incidence table - only count those occurrences
-- of the code where it is the first time the patient has had it
select FirstDiagnosis, count(*) as num into #Incidence from (
	select PatID, min(EntryDate) as FirstDiagnosis from SIR_ALL_Records_Narrow
	where ReadCode in ('B53..00','B53..99','BB5c.00','BB5c200','BB5d.00','BB5d100','BB5f.00','BB5f100','BB5f111','BB5f200','BB5f300','BB5f600','BB5f700','BB9B.11','BB9B.12','BB9C.00','B53..','BB5c.','BB5c2','BB5d.','BB5d1','BB5f.','BB5f1','BB5f2','BB5f3','BB5f6','BB5f7','BB9C.')
	and EntryDate <= '2020-05-13'
	group by PatID
) sub 
where FirstDiagnosis >= '2015-01-01'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select EntryDate, count(*) as num into #Prevalence from (
	select PatID, EntryDate from SIR_ALL_Records_Narrow
	where ReadCode in ('B53..00','B53..99','BB5c.00','BB5c200','BB5d.00','BB5d100','BB5f.00','BB5f100','BB5f111','BB5f200','BB5f300','BB5f600','BB5f700','BB9B.11','BB9B.12','BB9C.00','B53..','BB5c.','BB5c2','BB5d.','BB5d1','BB5f.','BB5f1','BB5f2','BB5f3','BB5f6','BB5f7','BB9C.')
	and EntryDate >= '2015-01-01'
	and EntryDate <= '2020-05-13'
	group by PatID, EntryDate
) sub 
group by EntryDate

PRINT 'Date,IncidenceOfThyroidCancer,PrevalenceOfThyroidCancer'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.EntryDate = d.date
order by date;
