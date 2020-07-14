--Just want the output, not the messages
SET NOCOUNT ON; 

--populate table with all dates from 2009-12-28
IF OBJECT_ID('tempdb..#AllDates') IS NOT NULL DROP TABLE #AllDates;
CREATE TABLE #AllDates ([date] date);
declare @dt datetime = '2009-12-28'
declare @dtEnd datetime = '2020-07-14';
WHILE (@dt <= @dtEnd) BEGIN
    insert into #AllDates([date])
        values(@dt)
    SET @dt = DATEADD(day, 1, @dt)
END;

-- Populate incidence table - only count those occurrences
-- of the code where it is the first time the patient has had it
select FirstDiagnosis, count(*) as num into #Incidence from (
	select NHSNo, min(entrydate) as FirstDiagnosis from journal
	where ReadCode in ('B41..00','B41..11','B410.00','B410.99','B410000','B410100','B410z00','B411.00','B411.99','B412.00','B41y.00','B41y000','B41y100','B41yz00','B41z.00','B831.12','B831.13','BB2J.00','B41..','B410.','B4100','B4101','B410z','B411.','B412.','B41y.','B41y0','B41y1','B41yz','B41z.','BB2J.')
	and entrydate <= '2020-07-14'
	group by NHSNo
) sub 
where FirstDiagnosis >= '2009-12-28'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select entrydate, count(*) as num into #Prevalence from (
	select NHSNo, entrydate from journal
	where ReadCode in ('B41..00','B41..11','B410.00','B410.99','B410000','B410100','B410z00','B411.00','B411.99','B412.00','B41y.00','B41y000','B41y100','B41yz00','B41z.00','B831.12','B831.13','BB2J.00','B41..','B410.','B4100','B4101','B410z','B411.','B412.','B41y.','B41y0','B41y1','B41yz','B41z.','BB2J.')
	and entrydate >= '2009-12-28'
	and entrydate <= '2020-07-14'
	group by NHSNo, entrydate
) sub 
group by entrydate

PRINT 'Date,IncidenceOfCervixCancer,PrevalenceOfCervixCancer'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.entrydate = d.date
order by date;
