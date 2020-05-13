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
	where ReadCode in ('E203.00','E203.11','E203000','E203100','E203z00','Eu42.00','Eu42.11','Eu42.12','Eu42000','Eu42100','Eu42200','Eu42y00','Eu42z00','Eu60513','Z522600','','E203.','E2030','E2031','E203z','Eu42.','Eu420','Eu421','Eu422','Eu42y','Eu42z','Z5226')
	and EntryDate <= '2020-05-13'
	group by PatID
) sub 
where FirstDiagnosis >= '2015-01-01'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select EntryDate, count(*) as num into #Prevalence from (
	select PatID, EntryDate from SIR_ALL_Records_Narrow
	where ReadCode in ('E203.00','E203.11','E203000','E203100','E203z00','Eu42.00','Eu42.11','Eu42.12','Eu42000','Eu42100','Eu42200','Eu42y00','Eu42z00','Eu60513','Z522600','','E203.','E2030','E2031','E203z','Eu42.','Eu420','Eu421','Eu422','Eu42y','Eu42z','Z5226')
	and EntryDate >= '2015-01-01'
	and EntryDate <= '2020-05-13'
	group by PatID, EntryDate
) sub 
group by EntryDate

PRINT 'Date,IncidenceOfOcd,PrevalenceOfOcd'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.EntryDate = d.date
order by date;
