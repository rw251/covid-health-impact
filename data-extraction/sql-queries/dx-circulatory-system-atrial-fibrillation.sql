--Just want the output, not the messages
SET NOCOUNT ON; 

--populate table with all dates from 2009-12-29
IF OBJECT_ID('tempdb..#AllDates') IS NOT NULL DROP TABLE #AllDates;
CREATE TABLE #AllDates ([date] date);
declare @dt datetime = '2009-12-29'
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
	where ReadCode in ('G573.00','G573z00','G573700','G573500','G573400','G573300','G573200','G573000','G573900','G573800','G573600','G573100','G573.','G573z','G5737','G5735','G5734','G5733','G5732','G5730','G5739','G5738','G5736','G5731')
	and entrydate <= '2020-06-05'
	group by NHSNo
) sub 
where FirstDiagnosis >= '2009-12-29'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select entrydate, count(*) as num into #Prevalence from (
	select NHSNo, entrydate from journal
	where ReadCode in ('G573.00','G573z00','G573700','G573500','G573400','G573300','G573200','G573000','G573900','G573800','G573600','G573100','G573.','G573z','G5737','G5735','G5734','G5733','G5732','G5730','G5739','G5738','G5736','G5731')
	and entrydate >= '2009-12-29'
	and entrydate <= '2020-06-05'
	group by NHSNo, entrydate
) sub 
group by entrydate

PRINT 'Date,IncidenceOfAtrialFibrillation,PrevalenceOfAtrialFibrillation'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.entrydate = d.date
order by date;
