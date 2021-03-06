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
	where ReadCode in ('68W2400','9Ow1.00','B13..00','B130.00','B130.99','B131.00','B131.99','B132.00','B132.99','B133.00','B133.99','B134.00','B134.11','B135.00','B136.00','B136.99','B137.00','B137.99','B138.00','B139.00','B13y.00','B13z.00','B13z.11','B140.00','B140.99','B141.00','B141.11','B141.12','B141.99','B803800','BB5L.00','BB5Lz00','BB5M.00','BB5N.00','BB5N100','BB5R600','68W24','9Ow1.','B13..','B130.','B131.','B132.','B133.','B134.','B135.','B136.','B137.','B138.','B139.','B13y.','B13z.','B140.','B141.','B8038','BB5L.','BB5Lz','BB5M.','BB5N.','BB5N1','BB5R6')
	and entrydate <= '2020-09-10'
	group by NHSNo
) sub 
where FirstDiagnosis >= '2009-12-28'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select entrydate, count(*) as num into #Prevalence from (
	select NHSNo, entrydate from journal
	where ReadCode in ('68W2400','9Ow1.00','B13..00','B130.00','B130.99','B131.00','B131.99','B132.00','B132.99','B133.00','B133.99','B134.00','B134.11','B135.00','B136.00','B136.99','B137.00','B137.99','B138.00','B139.00','B13y.00','B13z.00','B13z.11','B140.00','B140.99','B141.00','B141.11','B141.12','B141.99','B803800','BB5L.00','BB5Lz00','BB5M.00','BB5N.00','BB5N100','BB5R600','68W24','9Ow1.','B13..','B130.','B131.','B132.','B133.','B134.','B135.','B136.','B137.','B138.','B139.','B13y.','B13z.','B140.','B141.','B8038','BB5L.','BB5Lz','BB5M.','BB5N.','BB5N1','BB5R6')
	and entrydate >= '2009-12-28'
	and entrydate <= '2020-09-10'
	group by NHSNo, entrydate
) sub 
group by entrydate

PRINT 'Date,IncidenceOfColorectalCancer,PrevalenceOfColorectalCancer'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.entrydate = d.date
order by date;
