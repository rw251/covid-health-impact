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
	where ReadCode in ('ftr..','ftr8.','ftr6.','ftr4.','ftr2.','ftr7.','ftr5.','ftr3.','ftr1.','ftp..','ftp4.','ftp2.','ftp3.','ftp1.','ftm..','ftm4.','ftm2.','ftm3.','ftm1.','ftl..','ftl2.','ftl1.','fti..','fti4.','fti2.','fti3.','fti1.','ftg..','ftg4.','ftg2.','ftg3.','ftg1.','fte..','ftez.','fte1.','ftb..','ftbz.','ftby.','ftb2.','ftb1.','ft7..','ft7z.','ft71.','f41..','f41z.','f41y.','f41x.','f41w.','f41v.','f41u.','f41t.','f41s.','f41J.','f41I.','f41H.','f41G.','f41F.','f41E.','f41D.','f41C.','f41B.','f41A.','f419.','f418.','f417.','f416.','f415.','f414.','f413.','f412.','f411.','ft4x.','ft4w.','ft4v.','ft4u.','META1787','MEM/19420NEMIS','META1788','MEM/35043NEMIS','META29314NEMIS','META42230NEMIS','PITA23356NEMIS','ROTA19075NEMIS','MEM/30449NEMIS','ROTA19074NEMIS','SATA78212NEMIS','ROTA18930NEMIS','META29313NEMIS','MEOR35740NEMIS','MEOR35741NEMIS','MEOR23336NEMIS','EMTA104969NEMIS','META76743NEMIS','CATA96770NEMIS','DATA88552NEMIS','ALTA86909NEMIS','ROTA18929NEMIS','MEOR117653NEMIS','MESU11377NEMIS','EMTA104967NEMIS','GLM/19422NEMIS','GLM/35044NEMIS','GLTA1307','DIM/74131NEMIS','GLTA1308','GLM/30450NEMIS','BOM/35196NEMIS','JATA37230NEMIS','MEM/49996NEMIS','VITA86911NEMIS','GLOR35742NEMIS','COTA23359NEMIS','MEM/47158NEMIS')
	and entrydate <= '2020-08-12'
	group by NHSNo
) sub 
where FirstDiagnosis >= '2009-12-28'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select entrydate, count(*) as num into #Prevalence from (
	select NHSNo, entrydate from journal
	where ReadCode in ('ftr..','ftr8.','ftr6.','ftr4.','ftr2.','ftr7.','ftr5.','ftr3.','ftr1.','ftp..','ftp4.','ftp2.','ftp3.','ftp1.','ftm..','ftm4.','ftm2.','ftm3.','ftm1.','ftl..','ftl2.','ftl1.','fti..','fti4.','fti2.','fti3.','fti1.','ftg..','ftg4.','ftg2.','ftg3.','ftg1.','fte..','ftez.','fte1.','ftb..','ftbz.','ftby.','ftb2.','ftb1.','ft7..','ft7z.','ft71.','f41..','f41z.','f41y.','f41x.','f41w.','f41v.','f41u.','f41t.','f41s.','f41J.','f41I.','f41H.','f41G.','f41F.','f41E.','f41D.','f41C.','f41B.','f41A.','f419.','f418.','f417.','f416.','f415.','f414.','f413.','f412.','f411.','ft4x.','ft4w.','ft4v.','ft4u.','META1787','MEM/19420NEMIS','META1788','MEM/35043NEMIS','META29314NEMIS','META42230NEMIS','PITA23356NEMIS','ROTA19075NEMIS','MEM/30449NEMIS','ROTA19074NEMIS','SATA78212NEMIS','ROTA18930NEMIS','META29313NEMIS','MEOR35740NEMIS','MEOR35741NEMIS','MEOR23336NEMIS','EMTA104969NEMIS','META76743NEMIS','CATA96770NEMIS','DATA88552NEMIS','ALTA86909NEMIS','ROTA18929NEMIS','MEOR117653NEMIS','MESU11377NEMIS','EMTA104967NEMIS','GLM/19422NEMIS','GLM/35044NEMIS','GLTA1307','DIM/74131NEMIS','GLTA1308','GLM/30450NEMIS','BOM/35196NEMIS','JATA37230NEMIS','MEM/49996NEMIS','VITA86911NEMIS','GLOR35742NEMIS','COTA23359NEMIS','MEM/47158NEMIS')
	and entrydate >= '2009-12-28'
	and entrydate <= '2020-08-12'
	group by NHSNo, entrydate
) sub 
group by entrydate

PRINT 'Date,IncidenceOfMetformin,PrevalenceOfMetformin'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.entrydate = d.date
order by date;
