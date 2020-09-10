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
	where ReadCode in ('B40..00','B43..00','B43..98','B43..99','B430.00','B430000','B430100','B430200','B430211','B430300','B430z00','B431.00','B431000','B431z00','B432.00','B43y.00','B43z.00','B43z.99','BB5j.00','BBL0.00','BBL5.00','B40..','B43..','B430.','B4300','B4301','B4302','B4303','B430z','B431.','B4310','B431z','B432.','B43y.','B43z.','BB5j.','BBL0.','BBL5.')
	and entrydate <= '2020-09-10'
	group by NHSNo
) sub 
where FirstDiagnosis >= '2009-12-28'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select entrydate, count(*) as num into #Prevalence from (
	select NHSNo, entrydate from journal
	where ReadCode in ('B40..00','B43..00','B43..98','B43..99','B430.00','B430000','B430100','B430200','B430211','B430300','B430z00','B431.00','B431000','B431z00','B432.00','B43y.00','B43z.00','B43z.99','BB5j.00','BBL0.00','BBL5.00','B40..','B43..','B430.','B4300','B4301','B4302','B4303','B430z','B431.','B4310','B431z','B432.','B43y.','B43z.','BB5j.','BBL0.','BBL5.')
	and entrydate >= '2009-12-28'
	and entrydate <= '2020-09-10'
	group by NHSNo, entrydate
) sub 
group by entrydate

PRINT 'Date,IncidenceOfUterusCancer,PrevalenceOfUterusCancer'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.entrydate = d.date
order by date;
