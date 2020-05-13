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
	where ReadCode in ('B34..00','B34..11','B34..98','B34..99','B340.00','B340.99','B340000','B340100','B340z00','B341.00','B342.00','B342.99','B343.00','B343.99','B344.00','B344.99','B345.00','B345.99','B346.00','B346.99','B347.00','B34y.00','B34y000','B34yz00','B34z.00','B34z.99','B35..00','B35..99','B350.00','B350000','B350100','B350z00','B35z.00','B35z000','B35zz00','B36..00','BB91.00','BB91000','BB91100','BB92.00','BB93.00','BB94.00','BB94.11','BB96.00','BB98.00','BB9D.00','BB9F.00','BB9G.00','BB9H.00','BB9J.00','BB9J.11','BB9K.00','BB9K000','BBM8.00','BBM9.00','Byu6.00','B34..','B340.','B3400','B3401','B340z','B341.','B342.','B343.','B344.','B345.','B346.','B347.','B34y.','B34y0','B34yz','B34z.','B35..','B350.','B3500','B3501','B350z','B35z.','B35z0','B35zz','B36..','BB91.','BB910','BB911','BB92.','BB93.','BB94.','BB96.','BB98.','BB9D.','BB9F.','BB9G.','BB9H.','BB9J.','BB9K.','BB9K0','BBM8.','BBM9.','Byu6.')
	and EntryDate <= '2020-05-13'
	group by PatID
) sub 
where FirstDiagnosis >= '2015-01-01'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select EntryDate, count(*) as num into #Prevalence from (
	select PatID, EntryDate from SIR_ALL_Records_Narrow
	where ReadCode in ('B34..00','B34..11','B34..98','B34..99','B340.00','B340.99','B340000','B340100','B340z00','B341.00','B342.00','B342.99','B343.00','B343.99','B344.00','B344.99','B345.00','B345.99','B346.00','B346.99','B347.00','B34y.00','B34y000','B34yz00','B34z.00','B34z.99','B35..00','B35..99','B350.00','B350000','B350100','B350z00','B35z.00','B35z000','B35zz00','B36..00','BB91.00','BB91000','BB91100','BB92.00','BB93.00','BB94.00','BB94.11','BB96.00','BB98.00','BB9D.00','BB9F.00','BB9G.00','BB9H.00','BB9J.00','BB9J.11','BB9K.00','BB9K000','BBM8.00','BBM9.00','Byu6.00','B34..','B340.','B3400','B3401','B340z','B341.','B342.','B343.','B344.','B345.','B346.','B347.','B34y.','B34y0','B34yz','B34z.','B35..','B350.','B3500','B3501','B350z','B35z.','B35z0','B35zz','B36..','BB91.','BB910','BB911','BB92.','BB93.','BB94.','BB96.','BB98.','BB9D.','BB9F.','BB9G.','BB9H.','BB9J.','BB9K.','BB9K0','BBM8.','BBM9.','Byu6.')
	and EntryDate >= '2015-01-01'
	and EntryDate <= '2020-05-13'
	group by PatID, EntryDate
) sub 
group by EntryDate

PRINT 'Date,IncidenceOfBreastCancer,PrevalenceOfBreastCancer'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.EntryDate = d.date
order by date;
