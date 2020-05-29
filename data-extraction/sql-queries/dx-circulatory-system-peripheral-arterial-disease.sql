--Just want the output, not the messages
SET NOCOUNT ON; 

--populate table with all dates from 2015-01-01
IF OBJECT_ID('tempdb..#AllDates') IS NOT NULL DROP TABLE #AllDates;
CREATE TABLE #AllDates ([date] date);
declare @dt datetime = '2015-01-01'
declare @dtEnd datetime = '2020-05-29';
WHILE (@dt <= @dtEnd) BEGIN
    insert into #AllDates([date])
        values(@dt)
    SET @dt = DATEADD(day, 1, @dt)
END;

-- Populate incidence table - only count those occurrences
-- of the code where it is the first time the patient has had it
select FirstDiagnosis, count(*) as num into #Incidence from (
	select NHSNo, min(entrydate) as FirstDiagnosis from journal
	where ReadCode in ('G73..12','G73..13','G73..00','G73..11','G73z.00','G73zz00','G73z000','G73z011','G73z012','G73y.00','G73yz00','G734.00','Gyu7400','G73..','G73z.','G73zz','G73z0','G73y.','G73yz','G734.','Gyu74')
	and entrydate <= '2020-05-29'
	group by NHSNo
) sub 
where FirstDiagnosis >= '2015-01-01'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select entrydate, count(*) as num into #Prevalence from (
	select NHSNo, entrydate from journal
	where ReadCode in ('G73..12','G73..13','G73..00','G73..11','G73z.00','G73zz00','G73z000','G73z011','G73z012','G73y.00','G73yz00','G734.00','Gyu7400','G73..','G73z.','G73zz','G73z0','G73y.','G73yz','G734.','Gyu74')
	and entrydate >= '2015-01-01'
	and entrydate <= '2020-05-29'
	group by NHSNo, entrydate
) sub 
group by entrydate

PRINT 'Date,IncidenceOfPeripheralArterialDisease,PrevalenceOfPeripheralArterialDisease'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.entrydate = d.date
order by date;
