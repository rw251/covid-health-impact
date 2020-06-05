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
	where ReadCode in ('B15..00','B15..99','B150.00','B150.99','B150000','B150100','B150200','B150300','B150z00','B151.00','B151.99','B151000','B151200','B151300','B151400','B151z00','B152.00','B15z.00','B15z.99','BB5D100','BB5D300','BB5D500','BB5D511','BB5D512','BB5D513','BB5D700','BB5D711','BB5D800','BB5Dz00','BB5y200','BBL8.00','BBL8.11','BBT5.00','Byu1000','Byu1100','B15..','B150.','B1500','B1501','B1502','B1503','B150z','B151.','B1510','B1512','B1513','B1514','B151z','B152.','B15z.','BB5D1','BB5D3','BB5D5','BB5D7','BB5D8','BB5Dz','BB5y2','BBL8.','BBT5.','Byu10','Byu11')
	and entrydate <= '2020-06-05'
	group by NHSNo
) sub 
where FirstDiagnosis >= '2009-12-29'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select entrydate, count(*) as num into #Prevalence from (
	select NHSNo, entrydate from journal
	where ReadCode in ('B15..00','B15..99','B150.00','B150.99','B150000','B150100','B150200','B150300','B150z00','B151.00','B151.99','B151000','B151200','B151300','B151400','B151z00','B152.00','B15z.00','B15z.99','BB5D100','BB5D300','BB5D500','BB5D511','BB5D512','BB5D513','BB5D700','BB5D711','BB5D800','BB5Dz00','BB5y200','BBL8.00','BBL8.11','BBT5.00','Byu1000','Byu1100','B15..','B150.','B1500','B1501','B1502','B1503','B150z','B151.','B1510','B1512','B1513','B1514','B151z','B152.','B15z.','BB5D1','BB5D3','BB5D5','BB5D7','BB5D8','BB5Dz','BB5y2','BBL8.','BBT5.','Byu10','Byu11')
	and entrydate >= '2009-12-29'
	and entrydate <= '2020-06-05'
	group by NHSNo, entrydate
) sub 
group by entrydate

PRINT 'Date,IncidenceOfLiverCancer,PrevalenceOfLiverCancer'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.entrydate = d.date
order by date;
