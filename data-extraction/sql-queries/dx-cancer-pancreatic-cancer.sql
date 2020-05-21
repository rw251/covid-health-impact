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
	where ReadCode in ('B161100','B17..00','B170.00','B171.00','B172.00','B173.00','B174.00','B175.00','B17y.00','B17y000','B17yz00','B17z.00','BB5B.00','BB5B100','BB5B300','BB5B311','BB5B500','BB5B511','BB5B600','BB5C.00','BB5C000','BB5C011','BB5C100','BB5C111','BB5Cz00','BBLK.00','B1611','B17..','B170.','B171.','B172.','B173.','B174.','B175.','B17y.','B17y0','B17yz','B17z.','BB5B.','BB5B1','BB5B3','BB5B5','BB5B6','BB5C.','BB5C0','BB5C1','BB5Cz','BBLK.')
	and entrydate <= '2020-05-21'
	group by NHSNo
) sub 
where FirstDiagnosis >= '2015-01-01'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select entrydate, count(*) as num into #Prevalence from (
	select NHSNo, entrydate from journal
	where ReadCode in ('B161100','B17..00','B170.00','B171.00','B172.00','B173.00','B174.00','B175.00','B17y.00','B17y000','B17yz00','B17z.00','BB5B.00','BB5B100','BB5B300','BB5B311','BB5B500','BB5B511','BB5B600','BB5C.00','BB5C000','BB5C011','BB5C100','BB5C111','BB5Cz00','BBLK.00','B1611','B17..','B170.','B171.','B172.','B173.','B174.','B175.','B17y.','B17y0','B17yz','B17z.','BB5B.','BB5B1','BB5B3','BB5B5','BB5B6','BB5C.','BB5C0','BB5C1','BB5Cz','BBLK.')
	and entrydate >= '2015-01-01'
	and entrydate <= '2020-05-21'
	group by NHSNo, entrydate
) sub 
group by entrydate

PRINT 'Date,IncidenceOfPancreaticCancer,PrevalenceOfPancreaticCancer'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.entrydate = d.date
order by date;
