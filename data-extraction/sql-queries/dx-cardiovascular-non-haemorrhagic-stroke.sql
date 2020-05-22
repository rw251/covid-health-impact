--Just want the output, not the messages
SET NOCOUNT ON; 

--populate table with all dates from 2015-01-01
IF OBJECT_ID('tempdb..#AllDates') IS NOT NULL DROP TABLE #AllDates;
CREATE TABLE #AllDates ([date] date);
declare @dt datetime = '2015-01-01'
declare @dtEnd datetime = '2020-05-22';
WHILE (@dt <= @dtEnd) BEGIN
    insert into #AllDates([date])
        values(@dt)
    SET @dt = DATEADD(day, 1, @dt)
END;

-- Populate incidence table - only count those occurrences
-- of the code where it is the first time the patient has had it
select FirstDiagnosis, count(*) as num into #Incidence from (
	select NHSNo, min(entrydate) as FirstDiagnosis from journal
	where ReadCode in ('G6X..00','G6W..00','G64..11','G64..12','G64..00','G64..13','G64z.00','G64z.11','G64z.12','G64z400','G64z300','G64z200','G64z100','G64z111','G64z000','G641.00','G641.11','G641000','G640.00','G640000','Gyu6600','Gyu6500','Gyu6G00','Gyu6400','Gyu6300','G63y100','G63y000','G666.00','G665.00','G676000','G6X..','G6W..','G64..','G64z.','G64z4','G64z3','G64z2','G64z1','G64z0','G641.','G6410','G640.','G6400','Gyu66','Gyu65','Gyu6G','Gyu64','Gyu63','G63y1','G63y0','G666.','G665.','G6760')
	and entrydate <= '2020-05-22'
	group by NHSNo
) sub 
where FirstDiagnosis >= '2015-01-01'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select entrydate, count(*) as num into #Prevalence from (
	select NHSNo, entrydate from journal
	where ReadCode in ('G6X..00','G6W..00','G64..11','G64..12','G64..00','G64..13','G64z.00','G64z.11','G64z.12','G64z400','G64z300','G64z200','G64z100','G64z111','G64z000','G641.00','G641.11','G641000','G640.00','G640000','Gyu6600','Gyu6500','Gyu6G00','Gyu6400','Gyu6300','G63y100','G63y000','G666.00','G665.00','G676000','G6X..','G6W..','G64..','G64z.','G64z4','G64z3','G64z2','G64z1','G64z0','G641.','G6410','G640.','G6400','Gyu66','Gyu65','Gyu6G','Gyu64','Gyu63','G63y1','G63y0','G666.','G665.','G6760')
	and entrydate >= '2015-01-01'
	and entrydate <= '2020-05-22'
	group by NHSNo, entrydate
) sub 
group by entrydate

PRINT 'Date,IncidenceOfNonHaemorrhagicStroke,PrevalenceOfNonHaemorrhagicStroke'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.entrydate = d.date
order by date;
