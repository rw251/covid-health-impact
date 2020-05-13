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
	where ReadCode in ('68W2400','9Ow1.00','B13..00','B130.00','B130.99','B131.00','B131.99','B132.00','B132.99','B133.00','B133.99','B134.00','B134.11','B135.00','B136.00','B136.99','B137.00','B137.99','B138.00','B139.00','B13y.00','B13z.00','B13z.11','B140.00','B140.99','B141.00','B141.11','B141.12','B141.99','B803800','BB5L.00','BB5Lz00','BB5M.00','BB5N.00','BB5N100','BB5R600','68W24','9Ow1.','B13..','B130.','B131.','B132.','B133.','B134.','B135.','B136.','B137.','B138.','B139.','B13y.','B13z.','B140.','B141.','B8038','BB5L.','BB5Lz','BB5M.','BB5N.','BB5N1','BB5R6')
	and EntryDate <= '2020-05-13'
	group by PatID
) sub 
where FirstDiagnosis >= '2015-01-01'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select EntryDate, count(*) as num into #Prevalence from (
	select PatID, EntryDate from SIR_ALL_Records_Narrow
	where ReadCode in ('68W2400','9Ow1.00','B13..00','B130.00','B130.99','B131.00','B131.99','B132.00','B132.99','B133.00','B133.99','B134.00','B134.11','B135.00','B136.00','B136.99','B137.00','B137.99','B138.00','B139.00','B13y.00','B13z.00','B13z.11','B140.00','B140.99','B141.00','B141.11','B141.12','B141.99','B803800','BB5L.00','BB5Lz00','BB5M.00','BB5N.00','BB5N100','BB5R600','68W24','9Ow1.','B13..','B130.','B131.','B132.','B133.','B134.','B135.','B136.','B137.','B138.','B139.','B13y.','B13z.','B140.','B141.','B8038','BB5L.','BB5Lz','BB5M.','BB5N.','BB5N1','BB5R6')
	and EntryDate >= '2015-01-01'
	and EntryDate <= '2020-05-13'
	group by PatID, EntryDate
) sub 
group by EntryDate

PRINT 'Date,IncidenceOfColorectalCancer,PrevalenceOfColorectalCancer'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.EntryDate = d.date
order by date;
