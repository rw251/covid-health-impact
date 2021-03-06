--Just want the output, not the messages
SET NOCOUNT ON; 

--populate table with all dates from 2009-12-28
IF OBJECT_ID('tempdb..#AllDates') IS NOT NULL DROP TABLE #AllDates;
CREATE TABLE #AllDates ([date] date);
declare @dt datetime = '2009-12-28'
declare @dtEnd datetime = '2020-09-10';
WHILE (@dt <= @dtEnd) BEGIN
    insert into #AllDates([date])
        values(@dt)
    SET @dt = DATEADD(day, 1, @dt)
END;

-- Populate incidence table - only count those occurrences
-- of the code where it is the first time the patient has had it
select FirstDiagnosis, count(*) as num into #Incidence from (
	select NHSNo, min(entrydate) as FirstDiagnosis from journal
	where ReadCode in ('B11..00','B11..11','B110.00','B110.99','B110000','B110100','B110111','B110z00','B111.00','B111.99','B111000','B111100','B111z00','B112.00','B113.00','B113.99','B114.00','B114.99','B115.00','B115.99','B116.00','B116.99','B117.00','B118.00','B119.00','B11y.00','B11y000','B11y100','B11yz00','B11z.00','BB55.00','BB57.00','BB58.00','B11..','B110.','B1100','B1101','B110z','B111.','B1110','B1111','B111z','B112.','B113.','B114.','B115.','B116.','B117.','B118.','B119.','B11y.','B11y0','B11y1','B11yz','B11z.','BB55.','BB57.','BB58.')
	and entrydate <= '2020-09-10'
	group by NHSNo
) sub 
where FirstDiagnosis >= '2009-12-28'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select entrydate, count(*) as num into #Prevalence from (
	select NHSNo, entrydate from journal
	where ReadCode in ('B11..00','B11..11','B110.00','B110.99','B110000','B110100','B110111','B110z00','B111.00','B111.99','B111000','B111100','B111z00','B112.00','B113.00','B113.99','B114.00','B114.99','B115.00','B115.99','B116.00','B116.99','B117.00','B118.00','B119.00','B11y.00','B11y000','B11y100','B11yz00','B11z.00','BB55.00','BB57.00','BB58.00','B11..','B110.','B1100','B1101','B110z','B111.','B1110','B1111','B111z','B112.','B113.','B114.','B115.','B116.','B117.','B118.','B119.','B11y.','B11y0','B11y1','B11yz','B11z.','BB55.','BB57.','BB58.')
	and entrydate >= '2009-12-28'
	and entrydate <= '2020-09-10'
	group by NHSNo, entrydate
) sub 
group by entrydate

PRINT 'Date,IncidenceOfStomachCancer,PrevalenceOfStomachCancer'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.entrydate = d.date
order by date;
