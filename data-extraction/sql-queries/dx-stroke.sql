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
	where ReadCode in ('G61..','G610.','G611.','G612.','G613.','G614.','G615.','G616.','G618.','G619.','G61X.','G61X0','G61X1','G61z.','G63y0','G63y1','G64..','G640.','G6400','G641.','G6410','G64z.','G64z0','G64z1','G64z2','G64z3','G64z4','G66..','G660.','G661.','G662.','G663.','G664.','G665.','G666.','G667.','G668.','G6760','G6W..','G6X..','Gyu62','Gyu62','Gyu63','Gyu64','Gyu65','Gyu66','Gyu6F','Gyu6G')
	and EntryDate <= '2020-05-13'
	group by PatID
) sub 
where FirstDiagnosis >= '2015-01-01'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select EntryDate, count(*) as num into #Prevalence from (
	select PatID, EntryDate from SIR_ALL_Records_Narrow
	where ReadCode in ('G61..','G610.','G611.','G612.','G613.','G614.','G615.','G616.','G618.','G619.','G61X.','G61X0','G61X1','G61z.','G63y0','G63y1','G64..','G640.','G6400','G641.','G6410','G64z.','G64z0','G64z1','G64z2','G64z3','G64z4','G66..','G660.','G661.','G662.','G663.','G664.','G665.','G666.','G667.','G668.','G6760','G6W..','G6X..','Gyu62','Gyu62','Gyu63','Gyu64','Gyu65','Gyu66','Gyu6F','Gyu6G')
	and EntryDate >= '2015-01-01'
	and EntryDate <= '2020-05-13'
	group by PatID, EntryDate
) sub 
group by EntryDate

PRINT 'Date,IncidenceOfStroke,PrevalenceOfStroke'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.EntryDate = d.date
order by date;
