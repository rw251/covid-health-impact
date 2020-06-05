--Just want the output, not the messages
SET NOCOUNT ON; 

--populate table with all dates from 2009-12-29
IF OBJECT_ID('tempdb..#AllDates') IS NOT NULL DROP TABLE #AllDates;
CREATE TABLE #AllDates ([date] date);
declare @dt datetime = '2009-12-29'
declare @dtEnd datetime = '2020-06-05';
WHILE (@dt <= @dtEnd) BEGIN
    insert into #AllDates([date])
        values(@dt)
    SET @dt = DATEADD(day, 1, @dt)
END;

-- Populate incidence table - only count those occurrences
-- of the code where it is the first time the patient has had it
select FirstDiagnosis, count(*) as num into #Incidence from (
	select NHSNo, min(entrydate) as FirstDiagnosis from journal
	where ReadCode in ('daE..00','daE6.00','daE4.00','daE2.00','daE5.00','daE3.00','daE1.00','da5..00','da52.00','da51.00','da54.00','da53.00','da6..00','da67.00','da65.00','da63.00','da61.00','da68.00','da66.00','da64.00','da62.00','da3..00','da34.00','da32.00','da33.00','da31.00','da4..00','da4E.00','da46.00','da43.00','da41.00','da4D.00','da4C.00','da4B.00','da4A.00','da49.00','da48.00','da47.00','da45.00','da44.00','da42.00','daC..00','daCA.00','daC7.00','daC5.00','daC3.00','daC1.00','daC9.00','daC8.00','daC6.00','daC4.00','daC2.00','da9..00','da9z.00','da95.00','da93.00','da91.00','da9A.00','da99.00','da98.00','da97.00','da96.00','da94.00','da92.00','gm1..00','gm14.00','gm12.00','gm13.00','gm11.00','daE..','daE6.','daE4.','daE2.','daE5.','daE3.','daE1.','da5..','da52.','da51.','da54.','da53.','da6..','da67.','da65.','da63.','da61.','da68.','da66.','da64.','da62.','da3..','da34.','da32.','da33.','da31.','da4..','da4E.','da46.','da43.','da41.','da4D.','da4C.','da4B.','da4A.','da49.','da48.','da47.','da45.','da44.','da42.','daC..','daCA.','daC7.','daC5.','daC3.','daC1.','daC9.','daC8.','daC6.','daC4.','daC2.','da9..','da9z.','da95.','da93.','da91.','da9A.','da99.','da98.','da97.','da96.','da94.','da92.','gm1..','gm14.','gm12.','gm13.','gm11.')
	and entrydate <= '2020-06-05'
	group by NHSNo
) sub 
where FirstDiagnosis >= '2009-12-29'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select entrydate, count(*) as num into #Prevalence from (
	select NHSNo, entrydate from journal
	where ReadCode in ('daE..00','daE6.00','daE4.00','daE2.00','daE5.00','daE3.00','daE1.00','da5..00','da52.00','da51.00','da54.00','da53.00','da6..00','da67.00','da65.00','da63.00','da61.00','da68.00','da66.00','da64.00','da62.00','da3..00','da34.00','da32.00','da33.00','da31.00','da4..00','da4E.00','da46.00','da43.00','da41.00','da4D.00','da4C.00','da4B.00','da4A.00','da49.00','da48.00','da47.00','da45.00','da44.00','da42.00','daC..00','daCA.00','daC7.00','daC5.00','daC3.00','daC1.00','daC9.00','daC8.00','daC6.00','daC4.00','daC2.00','da9..00','da9z.00','da95.00','da93.00','da91.00','da9A.00','da99.00','da98.00','da97.00','da96.00','da94.00','da92.00','gm1..00','gm14.00','gm12.00','gm13.00','gm11.00','daE..','daE6.','daE4.','daE2.','daE5.','daE3.','daE1.','da5..','da52.','da51.','da54.','da53.','da6..','da67.','da65.','da63.','da61.','da68.','da66.','da64.','da62.','da3..','da34.','da32.','da33.','da31.','da4..','da4E.','da46.','da43.','da41.','da4D.','da4C.','da4B.','da4A.','da49.','da48.','da47.','da45.','da44.','da42.','daC..','daCA.','daC7.','daC5.','daC3.','daC1.','daC9.','daC8.','daC6.','daC4.','daC2.','da9..','da9z.','da95.','da93.','da91.','da9A.','da99.','da98.','da97.','da96.','da94.','da92.','gm1..','gm14.','gm12.','gm13.','gm11.')
	and entrydate >= '2009-12-29'
	and entrydate <= '2020-06-05'
	group by NHSNo, entrydate
) sub 
group by entrydate

PRINT 'Date,IncidenceOfSsri,PrevalenceOfSsri'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.entrydate = d.date
order by date;
