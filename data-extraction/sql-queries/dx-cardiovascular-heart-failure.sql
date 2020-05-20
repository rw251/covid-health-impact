--Just want the output, not the messages
SET NOCOUNT ON; 

--populate table with all dates from 2015-01-01
IF OBJECT_ID('tempdb..#AllDates') IS NOT NULL DROP TABLE #AllDates;
CREATE TABLE #AllDates ([date] date);
declare @dt datetime = '2015-01-01'
declare @dtEnd datetime = '2020-05-20';
WHILE (@dt <= @dtEnd) BEGIN
    insert into #AllDates([date])
        values(@dt)
    SET @dt = DATEADD(day, 1, @dt)
END;

-- Populate incidence table - only count those occurrences
-- of the code where it is the first time the patient has had it
select FirstDiagnosis, count(*) as num into #Incidence from (
	select PatID, min(EntryDate) as FirstDiagnosis from SIR_ALL_Records_Narrow
	where ReadCode in ('G58..11','G58..00','G583.00','G583.11','G583.12','G582.00','G58z.11','G58z.12','G58z.00','G584.00','G580.00','G580.11','G580.12','G580.14','G580.13','G580400','G580300','G580200','G580100','G580000','G581.13','G581.00','G581000','662i.00','662h.00','662g.00','662f.00','G1yz100','1O1..00','33BA.00','G58..','G583.','G582.','G58z.','G584.','G580.','G5804','G5803','G5802','G5801','G5800','G581.','G5810','662i.','662h.','662g.','662f.','G1yz1','1O1..','33BA.')
	and EntryDate <= '2020-05-20'
	group by PatID
) sub 
where FirstDiagnosis >= '2015-01-01'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select EntryDate, count(*) as num into #Prevalence from (
	select PatID, EntryDate from SIR_ALL_Records_Narrow
	where ReadCode in ('G58..11','G58..00','G583.00','G583.11','G583.12','G582.00','G58z.11','G58z.12','G58z.00','G584.00','G580.00','G580.11','G580.12','G580.14','G580.13','G580400','G580300','G580200','G580100','G580000','G581.13','G581.00','G581000','662i.00','662h.00','662g.00','662f.00','G1yz100','1O1..00','33BA.00','G58..','G583.','G582.','G58z.','G584.','G580.','G5804','G5803','G5802','G5801','G5800','G581.','G5810','662i.','662h.','662g.','662f.','G1yz1','1O1..','33BA.')
	and EntryDate >= '2015-01-01'
	and EntryDate <= '2020-05-20'
	group by PatID, EntryDate
) sub 
group by EntryDate

PRINT 'Date,IncidenceOfHeartFailure,PrevalenceOfHeartFailure'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.EntryDate = d.date
order by date;