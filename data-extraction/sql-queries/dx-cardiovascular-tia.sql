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
	where ReadCode in ('G65..12','G65..13','G65..00','G65z.00','G65zz00','G65z100','G65z000','G65y.00','G657.00','G656.00','G654.00','G653.00','G652.00','G651.00','G651000','G650.00','Fyu5500','G65..','G65z.','G65zz','G65z1','G65z0','G65y.','G657.','G656.','G654.','G653.','G652.','G651.','G6510','G650.','Fyu55')
	and entrydate <= '2020-05-21'
	group by NHSNo
) sub 
where FirstDiagnosis >= '2015-01-01'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select entrydate, count(*) as num into #Prevalence from (
	select NHSNo, entrydate from journal
	where ReadCode in ('G65..12','G65..13','G65..00','G65z.00','G65zz00','G65z100','G65z000','G65y.00','G657.00','G656.00','G654.00','G653.00','G652.00','G651.00','G651000','G650.00','Fyu5500','G65..','G65z.','G65zz','G65z1','G65z0','G65y.','G657.','G656.','G654.','G653.','G652.','G651.','G6510','G650.','Fyu55')
	and entrydate >= '2015-01-01'
	and entrydate <= '2020-05-21'
	group by NHSNo, entrydate
) sub 
group by entrydate

PRINT 'Date,IncidenceOfTia,PrevalenceOfTia'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.entrydate = d.date
order by date;
