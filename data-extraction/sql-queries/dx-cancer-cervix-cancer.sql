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
	where ReadCode in ('B41..00','B41..11','B410.00','B410.99','B410000','B410100','B410z00','B411.00','B411.99','B412.00','B41y.00','B41y000','B41y100','B41yz00','B41z.00','B831.12','B831.13','BB2J.00','B41..','B410.','B4100','B4101','B410z','B411.','B412.','B41y.','B41y0','B41y1','B41yz','B41z.','BB2J.')
	and EntryDate <= '2020-05-20'
	group by PatID
) sub 
where FirstDiagnosis >= '2015-01-01'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select EntryDate, count(*) as num into #Prevalence from (
	select PatID, EntryDate from SIR_ALL_Records_Narrow
	where ReadCode in ('B41..00','B41..11','B410.00','B410.99','B410000','B410100','B410z00','B411.00','B411.99','B412.00','B41y.00','B41y000','B41y100','B41yz00','B41z.00','B831.12','B831.13','BB2J.00','B41..','B410.','B4100','B4101','B410z','B411.','B412.','B41y.','B41y0','B41y1','B41yz','B41z.','BB2J.')
	and EntryDate >= '2015-01-01'
	and EntryDate <= '2020-05-20'
	group by PatID, EntryDate
) sub 
group by EntryDate

PRINT 'Date,IncidenceOfCervixCancer,PrevalenceOfCervixCancer'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.EntryDate = d.date
order by date;