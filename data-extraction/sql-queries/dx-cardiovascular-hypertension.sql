--Just want the output, not the messages
SET NOCOUNT ON; 

--populate table with all dates from 2009-12-28
IF OBJECT_ID('tempdb..#AllDates') IS NOT NULL DROP TABLE #AllDates;
CREATE TABLE #AllDates ([date] date);
declare @dt datetime = '2009-12-28'
declare @dtEnd datetime = '2020-08-12';
WHILE (@dt <= @dtEnd) BEGIN
    insert into #AllDates([date])
        values(@dt)
    SET @dt = DATEADD(day, 1, @dt)
END;

-- Populate incidence table - only count those occurrences
-- of the code where it is the first time the patient has had it
select FirstDiagnosis, count(*) as num into #Incidence from (
	select NHSNo, min(entrydate) as FirstDiagnosis from journal
	where ReadCode in ('G2...00','G2...11','G2z..00','G2y..00','G28..00','G26..00','G26..11','G25..00','G25..11','G251.00','G250.00','G24..00','G24z.00','G24zz00','G24z000','G244.00','G241.00','G241z00','G241000','G240.00','G240z00','G240000','G20..11','G20..00','G20..12','G20z.00','G20z.11','G203.00','G202.00','G201.00','G200.00','Gyu2.00','Gyu2100','Gyu2000','G2...','G2z..','G2y..','G28..','G26..','G25..','G251.','G250.','G24..','G24z.','G24zz','G24z0','G244.','G241.','G241z','G2410','G240.','G240z','G2400','G20..','G20z.','G203.','G202.','G201.','G200.','Gyu2.','Gyu21','Gyu20')
	and entrydate <= '2020-08-12'
	group by NHSNo
) sub 
where FirstDiagnosis >= '2009-12-28'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select entrydate, count(*) as num into #Prevalence from (
	select NHSNo, entrydate from journal
	where ReadCode in ('G2...00','G2...11','G2z..00','G2y..00','G28..00','G26..00','G26..11','G25..00','G25..11','G251.00','G250.00','G24..00','G24z.00','G24zz00','G24z000','G244.00','G241.00','G241z00','G241000','G240.00','G240z00','G240000','G20..11','G20..00','G20..12','G20z.00','G20z.11','G203.00','G202.00','G201.00','G200.00','Gyu2.00','Gyu2100','Gyu2000','G2...','G2z..','G2y..','G28..','G26..','G25..','G251.','G250.','G24..','G24z.','G24zz','G24z0','G244.','G241.','G241z','G2410','G240.','G240z','G2400','G20..','G20z.','G203.','G202.','G201.','G200.','Gyu2.','Gyu21','Gyu20')
	and entrydate >= '2009-12-28'
	and entrydate <= '2020-08-12'
	group by NHSNo, entrydate
) sub 
group by entrydate

PRINT 'Date,IncidenceOfHypertension,PrevalenceOfHypertension'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.entrydate = d.date
order by date;
