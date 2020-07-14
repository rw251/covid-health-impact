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
	where ReadCode in ('bu2c.00','bu2B.00','bu2A.00','bu25.00','bu23.00','blmz.00','di13.00','ASDI224','ASE/24520EMIS','ASTA4609','bu2c.','bu2B.','bu2A.','bu25.','bu23.','blmz.','di13.')
	and entrydate <= '2020-07-14'
	group by NHSNo
) sub 
where FirstDiagnosis >= '2009-12-28'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select entrydate, count(*) as num into #Prevalence from (
	select NHSNo, entrydate from journal
	where ReadCode in ('bu2c.00','bu2B.00','bu2A.00','bu25.00','bu23.00','blmz.00','di13.00','ASDI224','ASE/24520EMIS','ASTA4609','bu2c.','bu2B.','bu2A.','bu25.','bu23.','blmz.','di13.')
	and entrydate >= '2009-12-28'
	and entrydate <= '2020-07-14'
	group by NHSNo, entrydate
) sub 
group by entrydate

PRINT 'Date,IncidenceOfAspirin75,PrevalenceOfAspirin75'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.entrydate = d.date
order by date;
