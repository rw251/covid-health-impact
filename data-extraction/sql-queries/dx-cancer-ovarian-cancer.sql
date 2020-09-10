--Just want the output, not the messages
SET NOCOUNT ON; 

--populate table with all dates from 2009-12-28
IF OBJECT_ID('tempdb..#AllDates') IS NOT NULL DROP TABLE #AllDates;
CREATE TABLE #AllDates ([date] date);
declare @dt datetime = '2009-12-28'
declare @dtEnd datetime = '2020-09-10';
WHILE (@dt <= @dtEnd) BEGIN
    insert into #AllDates([date])
        values(@dt)
    SET @dt = DATEADD(day, 1, @dt)
END;

-- Populate incidence table - only count those occurrences
-- of the code where it is the first time the patient has had it
select FirstDiagnosis, count(*) as num into #Incidence from (
	select NHSNo, min(entrydate) as FirstDiagnosis from journal
	where ReadCode in ('B440.00','B440.11','BB5j200','BB80.00','BB80100','BB81100','BB81200','BB81400','BB81500','BB81800','BB81B00','BB81D00','BB81E00','BB81E11','BB81H00','BB81J00','BB81K00','BB81M00','BB82.00','BBC1100','BBC4.00','BBC6.00','BBC6100','BBC6111','BBCE.11','BBM0100','BBQ0.00','BBQ4.00','BBQA100','BBQA200','B440.','BB5j2','BB80.','BB801','BB811','BB812','BB814','BB815','BB818','BB81B','BB81D','BB81E','BB81H','BB81J','BB81K','BB81M','BB82.','BBC11','BBC4.','BBC6.','BBC61','BBM01','BBQ0.','BBQ4.','BBQA1','BBQA2')
	and entrydate <= '2020-09-10'
	group by NHSNo
) sub 
where FirstDiagnosis >= '2009-12-28'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select entrydate, count(*) as num into #Prevalence from (
	select NHSNo, entrydate from journal
	where ReadCode in ('B440.00','B440.11','BB5j200','BB80.00','BB80100','BB81100','BB81200','BB81400','BB81500','BB81800','BB81B00','BB81D00','BB81E00','BB81E11','BB81H00','BB81J00','BB81K00','BB81M00','BB82.00','BBC1100','BBC4.00','BBC6.00','BBC6100','BBC6111','BBCE.11','BBM0100','BBQ0.00','BBQ4.00','BBQA100','BBQA200','B440.','BB5j2','BB80.','BB801','BB811','BB812','BB814','BB815','BB818','BB81B','BB81D','BB81E','BB81H','BB81J','BB81K','BB81M','BB82.','BBC11','BBC4.','BBC6.','BBC61','BBM01','BBQ0.','BBQ4.','BBQA1','BBQA2')
	and entrydate >= '2009-12-28'
	and entrydate <= '2020-09-10'
	group by NHSNo, entrydate
) sub 
group by entrydate

PRINT 'Date,IncidenceOfOvarianCancer,PrevalenceOfOvarianCancer'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.entrydate = d.date
order by date;
