-- Template for the groups of conditions
-- E.g. all malignant cancers, or all cvd

--Just want the output, not the messages
SET NOCOUNT ON; 

--populate table with all dates from 2009-12-28
IF OBJECT_ID('tempdb..#AllDates') IS NOT NULL DROP TABLE #AllDates;
CREATE TABLE #AllDates ([date] date);
declare @dt datetime = '2009-12-28'
declare @dtEnd datetime = '2020-08-05';
WHILE (@dt <= @dtEnd) BEGIN
    insert into #AllDates([date])
        values(@dt)
    SET @dt = DATEADD(day, 1, @dt)
END;

-- Populate incidence table - only count those occurrences
-- of the code where it is the first time the patient has had it
select FirstDiagnosis, count(*) as num into #Incidence from (
	-- dvt
select NHSNo, min(EntryDate) as FirstDiagnosis from journal
where ReadCode in ('G801.00','G801.11','G801.12','G801.13','G801E00','G801C00','G801z00','G801J00','G801H00','G801G00','G801F00','G801D00','G801B00','G801500','G801.','G801E','G801C','G801z','G801J','G801H','G801G','G801F','G801D','G801B','G8015')
and EntryDate <= '2020-08-05'
group by NHSNo
 UNION ALL 
-- pulmonary embolism
select NHSNo, min(EntryDate) as FirstDiagnosis from journal
where ReadCode in ('G401.11','G401.12','G401.00','G401100','G401.','G4011')
and EntryDate <= '2020-08-05'
group by NHSNo
) sub 
where FirstDiagnosis >= '2009-12-28'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select EntryDate, count(*) as num into #Prevalence from (
	-- dvt
select NHSNo, EntryDate from journal
where ReadCode in ('G801.00','G801.11','G801.12','G801.13','G801E00','G801C00','G801z00','G801J00','G801H00','G801G00','G801F00','G801D00','G801B00','G801500','G801.','G801E','G801C','G801z','G801J','G801H','G801G','G801F','G801D','G801B','G8015')
and EntryDate >= '2009-12-28'
and EntryDate <= '2020-08-05'
group by NHSNo, EntryDate
 UNION ALL 
-- pulmonary embolism
select NHSNo, EntryDate from journal
where ReadCode in ('G401.11','G401.12','G401.00','G401100','G401.','G4011')
and EntryDate >= '2009-12-28'
and EntryDate <= '2020-08-05'
group by NHSNo, EntryDate
) sub 
group by EntryDate

PRINT 'Date,IncidenceOfExtraCardiovascular,PrevalenceOfExtraCardiovascular'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.EntryDate = d.date
order by date;
