--Just want the output, not the messages
SET NOCOUNT ON; 

--populate table with all dates from 2009-12-28
IF OBJECT_ID('tempdb..#AllDates') IS NOT NULL DROP TABLE #AllDates;
CREATE TABLE #AllDates ([date] date);
declare @dt datetime = '2009-12-28'
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
	where ReadCode in ('B51..00','B522.00','B525.00','B52y.00','BBb..00','BBb..99','BBb0.00','BBb0.11','BBb0.12','BBb1.00','BBb2.00','BBb2.11','BBb3.00','BBb3.11','BBb3.12','BBb6.00','BBb8.11','BBbB.00','BBbB.11','BBbB.12','BBbC.00','BBbD.00','BBbE.00','BBbE.11','BBbF.00','BBbG.00','BBbG.11','BBbG.12','BBbH.00','BBbJ.00','BBbK.00','BBbL.00','BBbL.11','BBbL.12','BBbM.00','BBbN.00','BBbP.00','BBbS.00','BBbT.00','BBbU.00','BBbV.00','BBbW.00','BBbX.00','BBbZ.00','BBba.00','BBbz.00','BBe7.00','ByuA.00','ByuA000','ByuA100','ByuA300','B51..','B522.','B525.','B52y.','BBb..','BBb0.','BBb1.','BBb2.','BBb3.','BBb6.','BBbB.','BBbC.','BBbD.','BBbE.','BBbF.','BBbG.','BBbH.','BBbJ.','BBbK.','BBbL.','BBbM.','BBbN.','BBbP.','BBbS.','BBbT.','BBbU.','BBbV.','BBbW.','BBbX.','BBbZ.','BBba.','BBbz.','BBe7.','ByuA.','ByuA0','ByuA1','ByuA3')
	and entrydate <= '2020-06-05'
	group by NHSNo
) sub 
where FirstDiagnosis >= '2009-12-28'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select entrydate, count(*) as num into #Prevalence from (
	select NHSNo, entrydate from journal
	where ReadCode in ('B51..00','B522.00','B525.00','B52y.00','BBb..00','BBb..99','BBb0.00','BBb0.11','BBb0.12','BBb1.00','BBb2.00','BBb2.11','BBb3.00','BBb3.11','BBb3.12','BBb6.00','BBb8.11','BBbB.00','BBbB.11','BBbB.12','BBbC.00','BBbD.00','BBbE.00','BBbE.11','BBbF.00','BBbG.00','BBbG.11','BBbG.12','BBbH.00','BBbJ.00','BBbK.00','BBbL.00','BBbL.11','BBbL.12','BBbM.00','BBbN.00','BBbP.00','BBbS.00','BBbT.00','BBbU.00','BBbV.00','BBbW.00','BBbX.00','BBbZ.00','BBba.00','BBbz.00','BBe7.00','ByuA.00','ByuA000','ByuA100','ByuA300','B51..','B522.','B525.','B52y.','BBb..','BBb0.','BBb1.','BBb2.','BBb3.','BBb6.','BBbB.','BBbC.','BBbD.','BBbE.','BBbF.','BBbG.','BBbH.','BBbJ.','BBbK.','BBbL.','BBbM.','BBbN.','BBbP.','BBbS.','BBbT.','BBbU.','BBbV.','BBbW.','BBbX.','BBbZ.','BBba.','BBbz.','BBe7.','ByuA.','ByuA0','ByuA1','ByuA3')
	and entrydate >= '2009-12-28'
	and entrydate <= '2020-06-05'
	group by NHSNo, entrydate
) sub 
group by entrydate

PRINT 'Date,IncidenceOfBrainCnsCancer,PrevalenceOfBrainCnsCancer'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.entrydate = d.date
order by date;
