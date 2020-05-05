--Just want the output, not the messages
SET NOCOUNT ON; 

--populate table with all dates from 2015-01-01
IF OBJECT_ID('tempdb..#AllDates') IS NOT NULL DROP TABLE #AllDates;
CREATE TABLE #AllDates ([date] date);
declare @dt datetime = '2015-01-01'
declare @dtEnd datetime = '2020-05-05';
WHILE (@dt <= @dtEnd) BEGIN
    insert into #AllDates([date])
        values(@dt)
    SET @dt = DATEADD(day, 1, @dt)
END;

-- Populate incidence table - only count those occurrences
-- of the code where it is the first time the patient has had it
select FirstDiagnosis, count(*) as num into #Incidence from (
	select PatID, min(EntryDate) as FirstDiagnosis from SIR_ALL_Records_Narrow
	where ReadCode in ('173f.00','1B13.00','1B13.11','1B13.12','1B1V.00','1Bb1.00','1P3..00','2258.00','2259.00','225J.00','285..00','8CAZ000','8G52.00','8G94.00','8HHp.00','8IH5300','E20..00','E20..99','E200.00','E200.99','E200000','E200100','E200111','E200200','E200300','E200400','E200500','E200z00','E202.00','E202.11','E202.12','E202.99','E202000','E202100','E202199','E202200','E202299','E202300','E202400','E202500','E202600','E202700','E202800','E202900','E202A00','E202B00','E202C00','E202E00','E202z00','E202z98','E202z99','E203.00','E203.11','E203000','E203100','E203z00','E20z.00','E261.99','E262099','E262100','E28..11','E283100','E28z.00','E28z.12','E292000','E29y100','E29y199','E2D0.00','E2D0000','E2D0z00','Eu05400','Eu34114','Eu40.00','Eu40000','Eu40011','Eu40012','Eu40100','Eu40111','Eu40112','Eu40200','Eu40211','Eu40212','Eu40213','Eu40214','Eu40299','Eu40300','Eu40y00','Eu40z00','Eu40z11','Eu40z12','Eu41.00','Eu41000','Eu41011','Eu41012','Eu41100','Eu41111','Eu41112','Eu41113','Eu41200','Eu41211','Eu41300','Eu41y00','Eu41y11','Eu41z00','Eu41z11','Eu42.00','Eu42.12','Eu42000','Eu42100','Eu42200','Eu42y00','Eu42z00','Eu43013','Eu43100','Eu43111','Eu43300','Eu43400','Eu43500','Eu43y00','Eu43z00','Eu93000','Eu93100','Eu93200','Eu93y12','Z481.00','Z4I7.00','Z4I7100','Z4I7200','Z4I7211','Z4L1.00','Z522600','','173f.','1B13.','1B1V.','1Bb1.','1P3..','2258.','2259.','225J.','285..','8CAZ0','8G52.','8G94.','8HHp.','8IH53','E20..','E200.','E2000','E2001','E2002','E2003','E2004','E2005','E200z','E202.','E2020','E2021','E2022','E2023','E2024','E2025','E2026','E2027','E2028','E2029','E202A','E202B','E202C','E202E','E202z','E203.','E2030','E2031','E203z','E20z.','E2621','E2831','E28z.','E2920','E29y1','E2D0.','E2D00','E2D0z','Eu054','Eu40.','Eu400','Eu401','Eu402','Eu403','Eu40y','Eu40z','Eu41.','Eu410','Eu411','Eu412','Eu413','Eu41y','Eu41z','Eu42.','Eu420','Eu421','Eu422','Eu42y','Eu42z','Eu431','Eu433','Eu434','Eu435','Eu43y','Eu43z','Eu930','Eu931','Eu932','Z481.','Z4I7.','Z4I71','Z4I72','Z4L1.','Z5226')
	and EntryDate <= '2020-05-05'
	group by PatID
) sub 
where FirstDiagnosis >= '2015-01-01'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select EntryDate, count(*) as num into #Prevalence from (
	select PatID, EntryDate from SIR_ALL_Records_Narrow
	where ReadCode in ('173f.00','1B13.00','1B13.11','1B13.12','1B1V.00','1Bb1.00','1P3..00','2258.00','2259.00','225J.00','285..00','8CAZ000','8G52.00','8G94.00','8HHp.00','8IH5300','E20..00','E20..99','E200.00','E200.99','E200000','E200100','E200111','E200200','E200300','E200400','E200500','E200z00','E202.00','E202.11','E202.12','E202.99','E202000','E202100','E202199','E202200','E202299','E202300','E202400','E202500','E202600','E202700','E202800','E202900','E202A00','E202B00','E202C00','E202E00','E202z00','E202z98','E202z99','E203.00','E203.11','E203000','E203100','E203z00','E20z.00','E261.99','E262099','E262100','E28..11','E283100','E28z.00','E28z.12','E292000','E29y100','E29y199','E2D0.00','E2D0000','E2D0z00','Eu05400','Eu34114','Eu40.00','Eu40000','Eu40011','Eu40012','Eu40100','Eu40111','Eu40112','Eu40200','Eu40211','Eu40212','Eu40213','Eu40214','Eu40299','Eu40300','Eu40y00','Eu40z00','Eu40z11','Eu40z12','Eu41.00','Eu41000','Eu41011','Eu41012','Eu41100','Eu41111','Eu41112','Eu41113','Eu41200','Eu41211','Eu41300','Eu41y00','Eu41y11','Eu41z00','Eu41z11','Eu42.00','Eu42.12','Eu42000','Eu42100','Eu42200','Eu42y00','Eu42z00','Eu43013','Eu43100','Eu43111','Eu43300','Eu43400','Eu43500','Eu43y00','Eu43z00','Eu93000','Eu93100','Eu93200','Eu93y12','Z481.00','Z4I7.00','Z4I7100','Z4I7200','Z4I7211','Z4L1.00','Z522600','','173f.','1B13.','1B1V.','1Bb1.','1P3..','2258.','2259.','225J.','285..','8CAZ0','8G52.','8G94.','8HHp.','8IH53','E20..','E200.','E2000','E2001','E2002','E2003','E2004','E2005','E200z','E202.','E2020','E2021','E2022','E2023','E2024','E2025','E2026','E2027','E2028','E2029','E202A','E202B','E202C','E202E','E202z','E203.','E2030','E2031','E203z','E20z.','E2621','E2831','E28z.','E2920','E29y1','E2D0.','E2D00','E2D0z','Eu054','Eu40.','Eu400','Eu401','Eu402','Eu403','Eu40y','Eu40z','Eu41.','Eu410','Eu411','Eu412','Eu413','Eu41y','Eu41z','Eu42.','Eu420','Eu421','Eu422','Eu42y','Eu42z','Eu431','Eu433','Eu434','Eu435','Eu43y','Eu43z','Eu930','Eu931','Eu932','Z481.','Z4I7.','Z4I71','Z4I72','Z4L1.','Z5226')
	and EntryDate >= '2015-01-01'
	and EntryDate <= '2020-05-05'
	group by PatID, EntryDate
) sub 
group by EntryDate

PRINT 'Date,IncidenceOfAnxietyDisorders,PrevalenceOfAnxietyDisorders'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.EntryDate = d.date
order by date;
