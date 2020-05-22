--Just want the output, not the messages
SET NOCOUNT ON; 

--populate table with all dates from 2015-01-01
IF OBJECT_ID('tempdb..#AllDates') IS NOT NULL DROP TABLE #AllDates;
CREATE TABLE #AllDates ([date] date);
declare @dt datetime = '2015-01-01'
declare @dtEnd datetime = '2020-05-22';
WHILE (@dt <= @dtEnd) BEGIN
    insert into #AllDates([date])
        values(@dt)
    SET @dt = DATEADD(day, 1, @dt)
END;

-- Populate incidence table - only count those occurrences
-- of the code where it is the first time the patient has had it
select FirstDiagnosis, count(*) as num into #Incidence from (
	select NHSNo, min(entrydate) as FirstDiagnosis from journal
	where ReadCode in ('4M00.00','4M01.00','4M02.00','8AD0.00','B46..00','B834000','B834100','4M00.','4M01.','4M02.','8AD0.','B46..','B8340','B8341')
	and entrydate <= '2020-05-22'
	group by NHSNo
) sub 
where FirstDiagnosis >= '2015-01-01'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select entrydate, count(*) as num into #Prevalence from (
	select NHSNo, entrydate from journal
	where ReadCode in ('4M00.00','4M01.00','4M02.00','8AD0.00','B46..00','B834000','B834100','4M00.','4M01.','4M02.','8AD0.','B46..','B8340','B8341')
	and entrydate >= '2015-01-01'
	and entrydate <= '2020-05-22'
	group by NHSNo, entrydate
) sub 
group by entrydate

PRINT 'Date,IncidenceOfProstateCancer,PrevalenceOfProstateCancer'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.entrydate = d.date
order by date;
