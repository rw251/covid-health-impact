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
	where ReadCode in ('B4A..11','B4A..99','B4A0.00','B4A0.99','B4A0000','BB5a.00','BB5a000','BB5a011','BB5a012','BBL7.11','BBL7100','BBL7112','BBL7200','BBL7300','BBLJ.00','K01w112','B4A0.','B4A00','BB5a.','BB5a0','BBL71','BBL72','BBL73','BBLJ.')
	and EntryDate <= '2020-05-13'
	group by PatID
) sub 
where FirstDiagnosis >= '2015-01-01'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select EntryDate, count(*) as num into #Prevalence from (
	select PatID, EntryDate from SIR_ALL_Records_Narrow
	where ReadCode in ('B4A..11','B4A..99','B4A0.00','B4A0.99','B4A0000','BB5a.00','BB5a000','BB5a011','BB5a012','BBL7.11','BBL7100','BBL7112','BBL7200','BBL7300','BBLJ.00','K01w112','B4A0.','B4A00','BB5a.','BB5a0','BBL71','BBL72','BBL73','BBLJ.')
	and EntryDate >= '2015-01-01'
	and EntryDate <= '2020-05-13'
	group by PatID, EntryDate
) sub 
group by EntryDate

PRINT 'Date,IncidenceOfKidneyCancer,PrevalenceOfKidneyCancer'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.EntryDate = d.date
order by date;
