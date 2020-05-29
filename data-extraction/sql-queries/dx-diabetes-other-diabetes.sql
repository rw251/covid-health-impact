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
	where ReadCode in ('C10..00','C10z.00','C10zz00','C10zy00','C10y.00','C10yz00','C10yy00','C10N.00','C10N100','C10N000','C10M.00','C10M000','C10H.00','C10H000','C10G.00','C10G000','C10FS00','C10ER00','C10B.00','C10B000','C10A.00','C10A.11','C10AX00','C10AW00','C10A700','C10A600','C10A500','C10A400','C10A300','C10A200','C10A100','C10A000','C108z00','C108y00','C107.00','C107.11','C107.12','C107z00','C107y00','C107200','C105.00','C105z00','C105y00','C103.00','C103z00','C103y00','C102.00','C102z00','C101.00','C101z00','C101y00','C100.00','C100z00','C100111','C106.00','C106z00','C106y00','C104.00','C104y00','C10Q.00','C10C.00','C10C.11','66AU.00','66AJ.11','66AJ100','Cyu2.00','Cyu2300','Cyu2200','Cyu2100','Cyu2000','8Hgd.00','C11y000','C314.11','C350011','PKyP.00','Kyu0300','C10..','C10z.','C10zz','C10zy','C10y.','C10yz','C10yy','C10N.','C10N1','C10N0','C10M.','C10M0','C10H.','C10H0','C10G.','C10G0','C10FS','C10ER','C10B.','C10B0','C10A.','C10AX','C10AW','C10A7','C10A6','C10A5','C10A4','C10A3','C10A2','C10A1','C10A0','C108z','C108y','C107.','C107z','C107y','C1072','C105.','C105z','C105y','C103.','C103z','C103y','C102.','C102z','C101.','C101z','C101y','C100.','C100z','C106.','C106z','C106y','C104.','C104y','C10Q.','C10C.','66AU.','66AJ1','Cyu2.','Cyu23','Cyu22','Cyu21','Cyu20','8Hgd.','C11y0','PKyP.','Kyu03')
	and entrydate <= '2020-05-29'
	group by NHSNo
) sub 
where FirstDiagnosis >= '2015-01-01'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select entrydate, count(*) as num into #Prevalence from (
	select NHSNo, entrydate from journal
	where ReadCode in ('C10..00','C10z.00','C10zz00','C10zy00','C10y.00','C10yz00','C10yy00','C10N.00','C10N100','C10N000','C10M.00','C10M000','C10H.00','C10H000','C10G.00','C10G000','C10FS00','C10ER00','C10B.00','C10B000','C10A.00','C10A.11','C10AX00','C10AW00','C10A700','C10A600','C10A500','C10A400','C10A300','C10A200','C10A100','C10A000','C108z00','C108y00','C107.00','C107.11','C107.12','C107z00','C107y00','C107200','C105.00','C105z00','C105y00','C103.00','C103z00','C103y00','C102.00','C102z00','C101.00','C101z00','C101y00','C100.00','C100z00','C100111','C106.00','C106z00','C106y00','C104.00','C104y00','C10Q.00','C10C.00','C10C.11','66AU.00','66AJ.11','66AJ100','Cyu2.00','Cyu2300','Cyu2200','Cyu2100','Cyu2000','8Hgd.00','C11y000','C314.11','C350011','PKyP.00','Kyu0300','C10..','C10z.','C10zz','C10zy','C10y.','C10yz','C10yy','C10N.','C10N1','C10N0','C10M.','C10M0','C10H.','C10H0','C10G.','C10G0','C10FS','C10ER','C10B.','C10B0','C10A.','C10AX','C10AW','C10A7','C10A6','C10A5','C10A4','C10A3','C10A2','C10A1','C10A0','C108z','C108y','C107.','C107z','C107y','C1072','C105.','C105z','C105y','C103.','C103z','C103y','C102.','C102z','C101.','C101z','C101y','C100.','C100z','C106.','C106z','C106y','C104.','C104y','C10Q.','C10C.','66AU.','66AJ1','Cyu2.','Cyu23','Cyu22','Cyu21','Cyu20','8Hgd.','C11y0','PKyP.','Kyu03')
	and entrydate >= '2015-01-01'
	and entrydate <= '2020-05-29'
	group by NHSNo, entrydate
) sub 
group by entrydate

PRINT 'Date,IncidenceOfOtherDiabetes,PrevalenceOfOtherDiabetes'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.entrydate = d.date
order by date;
