-- Template for the groups of conditions
-- E.g. all malignant cancers, or all cvd

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
	-- anxiety disorders
select NHSNo, min(EntryDate) as FirstDiagnosis from journal
where ReadCode in ('173f.00','1B13.00','1B13.11','1B13.12','1B1V.00','1Bb1.00','1P3..00','2258.00','2259.00','225J.00','285..00','8CAZ000','8G52.00','8G94.00','8HHp.00','8IH5300','E20..00','E20..99','E200.00','E200.99','E200000','E200100','E200111','E200200','E200300','E200400','E200500','E200z00','E202.00','E202.11','E202.12','E202.99','E202000','E202100','E202199','E202200','E202299','E202300','E202400','E202500','E202600','E202700','E202800','E202900','E202A00','E202B00','E202C00','E202E00','E202z00','E202z98','E202z99','E203.00','E203.11','E203000','E203100','E203z00','E20z.00','E261.99','E262099','E262100','E28..11','E283100','E28z.00','E28z.12','E292000','E29y100','E29y199','E2D0.00','E2D0000','E2D0z00','Eu05400','Eu34114','Eu40.00','Eu40000','Eu40011','Eu40012','Eu40100','Eu40111','Eu40112','Eu40200','Eu40211','Eu40212','Eu40213','Eu40214','Eu40299','Eu40300','Eu40y00','Eu40z00','Eu40z11','Eu40z12','Eu41.00','Eu41000','Eu41011','Eu41012','Eu41100','Eu41111','Eu41112','Eu41113','Eu41200','Eu41211','Eu41300','Eu41y00','Eu41y11','Eu41z00','Eu41z11','Eu42.00','Eu42.12','Eu42000','Eu42100','Eu42200','Eu42y00','Eu42z00','Eu43013','Eu43100','Eu43111','Eu43300','Eu43400','Eu43500','Eu43y00','Eu43z00','Eu93000','Eu93100','Eu93200','Eu93y12','Z481.00','Z4I7.00','Z4I7100','Z4I7200','Z4I7211','Z4L1.00','Z522600','','173f.','1B13.','1B1V.','1Bb1.','1P3..','2258.','2259.','225J.','285..','8CAZ0','8G52.','8G94.','8HHp.','8IH53','E20..','E200.','E2000','E2001','E2002','E2003','E2004','E2005','E200z','E202.','E2020','E2021','E2022','E2023','E2024','E2025','E2026','E2027','E2028','E2029','E202A','E202B','E202C','E202E','E202z','E203.','E2030','E2031','E203z','E20z.','E2621','E2831','E28z.','E2920','E29y1','E2D0.','E2D00','E2D0z','Eu054','Eu40.','Eu400','Eu401','Eu402','Eu403','Eu40y','Eu40z','Eu41.','Eu410','Eu411','Eu412','Eu413','Eu41y','Eu41z','Eu42.','Eu420','Eu421','Eu422','Eu42y','Eu42z','Eu431','Eu433','Eu434','Eu435','Eu43y','Eu43z','Eu930','Eu931','Eu932','Z481.','Z4I7.','Z4I71','Z4I72','Z4L1.','Z5226')
and EntryDate <= '2020-09-10'
group by NHSNo
 UNION ALL 
-- depression
select NHSNo, min(EntryDate) as FirstDiagnosis from journal
where ReadCode in ('1B17.00','1B17.11','1B17.12','1B1U.00','1B1U.11','1BT..00','1BT..11','1BT..12','1JJ..00','1S40.00','212S.00','2257.00','62T1.00','6659000','6G00.00','8BK0.00','8CAa.00','8HHq.00','8HHq000','8IH5200','9H90.00','9H91.00','9H92.00','9HA0.00','9Ov..00','9Ov0.00','9Ov1.00','9Ov2.00','9Ov3.00','9Ov4.00','9hC..00','9hC0.00','9hC1.00','9k4..00','9k40.00','9kQ..00','9kQ..11','E02y300','E11..12','E112.00','E112.11','E112.12','E112.13','E112.14','E112000','E112100','E112200','E112300','E112400','E112500','E112600','E112z00','E113.00','E113.11','E113000','E113100','E113200','E113300','E113400','E113500','E113600','E113700','E113z00','E118.00','E11y200','E11z200','E130.00','E130.11','E135.00','E200300','E204.00','E204.11','E204.99','E211299','E290.00','E290000','E290011','E290z00','E291.00','E2B..00','E2B..98','E2B..99','E2B0.00','E2B1.00','Eu05300','Eu06y11','Eu20400','Eu25100','Eu25111','Eu25112','Eu3..00','Eu32.00','Eu32.11','Eu32.12','Eu32.13','Eu32000','Eu32099','Eu32100','Eu32199','Eu32200','Eu32211','Eu32212','Eu32213','Eu32299','Eu32300','Eu32311','Eu32312','Eu32313','Eu32314','Eu32400','Eu32500','Eu32600','Eu32700','Eu32800','Eu32900','Eu32A00','Eu32B00','Eu32y00','Eu32y11','Eu32y12','Eu32z00','Eu32z11','Eu32z12','Eu32z13','Eu32z14','Eu33.00','Eu33.11','Eu33.12','Eu33.13','Eu33.14','Eu33.15','Eu33000','Eu33100','Eu33200','Eu33211','Eu33212','Eu33214','Eu33300','Eu33311','Eu33313','Eu33314','Eu33315','Eu33316','Eu33400','Eu33y00','Eu33z00','Eu33z11','Eu34.00','Eu34100','Eu34111','Eu34113','Eu34114','Eu34y00','Eu34z00','Eu3y.00','Eu3y000','Eu3y011','Eu3y100','Eu3y111','Eu3yy00','Eu3z.00','Eu41200','Eu41211','Eu53011','Eu53012','Eu92000','R007z13','ZV11100','','1B17.','1B1U.','1BT..','1JJ..','1S40.','212S.','2257.','62T1.','66590','6G00.','8BK0.','8CAa.','8HHq.','8HHq0','8IH52','9H90.','9H91.','9H92.','9HA0.','9Ov..','9Ov0.','9Ov1.','9Ov2.','9Ov3.','9Ov4.','9hC..','9hC0.','9hC1.','9k4..','9k40.','9kQ..','E02y3','E112.','E1120','E1121','E1122','E1123','E1124','E1125','E1126','E112z','E113.','E1130','E1131','E1132','E1133','E1134','E1135','E1136','E1137','E113z','E118.','E11y2','E11z2','E130.','E135.','E2003','E204.','E290.','E2900','E290z','E291.','E2B..','E2B0.','E2B1.','Eu053','Eu204','Eu251','Eu3..','Eu32.','Eu320','Eu321','Eu322','Eu323','Eu324','Eu325','Eu326','Eu327','Eu328','Eu329','Eu32A','Eu32B','Eu32y','Eu32z','Eu33.','Eu330','Eu331','Eu332','Eu333','Eu334','Eu33y','Eu33z','Eu34.','Eu341','Eu34y','Eu34z','Eu3y.','Eu3y0','Eu3y1','Eu3yy','Eu3z.','Eu412','Eu920','ZV111')
and EntryDate <= '2020-09-10'
group by NHSNo
) sub 
where FirstDiagnosis >= '2009-12-28'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select EntryDate, count(*) as num into #Prevalence from (
	-- anxiety disorders
select NHSNo, EntryDate from journal
where ReadCode in ('173f.00','1B13.00','1B13.11','1B13.12','1B1V.00','1Bb1.00','1P3..00','2258.00','2259.00','225J.00','285..00','8CAZ000','8G52.00','8G94.00','8HHp.00','8IH5300','E20..00','E20..99','E200.00','E200.99','E200000','E200100','E200111','E200200','E200300','E200400','E200500','E200z00','E202.00','E202.11','E202.12','E202.99','E202000','E202100','E202199','E202200','E202299','E202300','E202400','E202500','E202600','E202700','E202800','E202900','E202A00','E202B00','E202C00','E202E00','E202z00','E202z98','E202z99','E203.00','E203.11','E203000','E203100','E203z00','E20z.00','E261.99','E262099','E262100','E28..11','E283100','E28z.00','E28z.12','E292000','E29y100','E29y199','E2D0.00','E2D0000','E2D0z00','Eu05400','Eu34114','Eu40.00','Eu40000','Eu40011','Eu40012','Eu40100','Eu40111','Eu40112','Eu40200','Eu40211','Eu40212','Eu40213','Eu40214','Eu40299','Eu40300','Eu40y00','Eu40z00','Eu40z11','Eu40z12','Eu41.00','Eu41000','Eu41011','Eu41012','Eu41100','Eu41111','Eu41112','Eu41113','Eu41200','Eu41211','Eu41300','Eu41y00','Eu41y11','Eu41z00','Eu41z11','Eu42.00','Eu42.12','Eu42000','Eu42100','Eu42200','Eu42y00','Eu42z00','Eu43013','Eu43100','Eu43111','Eu43300','Eu43400','Eu43500','Eu43y00','Eu43z00','Eu93000','Eu93100','Eu93200','Eu93y12','Z481.00','Z4I7.00','Z4I7100','Z4I7200','Z4I7211','Z4L1.00','Z522600','','173f.','1B13.','1B1V.','1Bb1.','1P3..','2258.','2259.','225J.','285..','8CAZ0','8G52.','8G94.','8HHp.','8IH53','E20..','E200.','E2000','E2001','E2002','E2003','E2004','E2005','E200z','E202.','E2020','E2021','E2022','E2023','E2024','E2025','E2026','E2027','E2028','E2029','E202A','E202B','E202C','E202E','E202z','E203.','E2030','E2031','E203z','E20z.','E2621','E2831','E28z.','E2920','E29y1','E2D0.','E2D00','E2D0z','Eu054','Eu40.','Eu400','Eu401','Eu402','Eu403','Eu40y','Eu40z','Eu41.','Eu410','Eu411','Eu412','Eu413','Eu41y','Eu41z','Eu42.','Eu420','Eu421','Eu422','Eu42y','Eu42z','Eu431','Eu433','Eu434','Eu435','Eu43y','Eu43z','Eu930','Eu931','Eu932','Z481.','Z4I7.','Z4I71','Z4I72','Z4L1.','Z5226')
and EntryDate >= '2009-12-28'
and EntryDate <= '2020-09-10'
group by NHSNo, EntryDate
 UNION ALL 
-- depression
select NHSNo, EntryDate from journal
where ReadCode in ('1B17.00','1B17.11','1B17.12','1B1U.00','1B1U.11','1BT..00','1BT..11','1BT..12','1JJ..00','1S40.00','212S.00','2257.00','62T1.00','6659000','6G00.00','8BK0.00','8CAa.00','8HHq.00','8HHq000','8IH5200','9H90.00','9H91.00','9H92.00','9HA0.00','9Ov..00','9Ov0.00','9Ov1.00','9Ov2.00','9Ov3.00','9Ov4.00','9hC..00','9hC0.00','9hC1.00','9k4..00','9k40.00','9kQ..00','9kQ..11','E02y300','E11..12','E112.00','E112.11','E112.12','E112.13','E112.14','E112000','E112100','E112200','E112300','E112400','E112500','E112600','E112z00','E113.00','E113.11','E113000','E113100','E113200','E113300','E113400','E113500','E113600','E113700','E113z00','E118.00','E11y200','E11z200','E130.00','E130.11','E135.00','E200300','E204.00','E204.11','E204.99','E211299','E290.00','E290000','E290011','E290z00','E291.00','E2B..00','E2B..98','E2B..99','E2B0.00','E2B1.00','Eu05300','Eu06y11','Eu20400','Eu25100','Eu25111','Eu25112','Eu3..00','Eu32.00','Eu32.11','Eu32.12','Eu32.13','Eu32000','Eu32099','Eu32100','Eu32199','Eu32200','Eu32211','Eu32212','Eu32213','Eu32299','Eu32300','Eu32311','Eu32312','Eu32313','Eu32314','Eu32400','Eu32500','Eu32600','Eu32700','Eu32800','Eu32900','Eu32A00','Eu32B00','Eu32y00','Eu32y11','Eu32y12','Eu32z00','Eu32z11','Eu32z12','Eu32z13','Eu32z14','Eu33.00','Eu33.11','Eu33.12','Eu33.13','Eu33.14','Eu33.15','Eu33000','Eu33100','Eu33200','Eu33211','Eu33212','Eu33214','Eu33300','Eu33311','Eu33313','Eu33314','Eu33315','Eu33316','Eu33400','Eu33y00','Eu33z00','Eu33z11','Eu34.00','Eu34100','Eu34111','Eu34113','Eu34114','Eu34y00','Eu34z00','Eu3y.00','Eu3y000','Eu3y011','Eu3y100','Eu3y111','Eu3yy00','Eu3z.00','Eu41200','Eu41211','Eu53011','Eu53012','Eu92000','R007z13','ZV11100','','1B17.','1B1U.','1BT..','1JJ..','1S40.','212S.','2257.','62T1.','66590','6G00.','8BK0.','8CAa.','8HHq.','8HHq0','8IH52','9H90.','9H91.','9H92.','9HA0.','9Ov..','9Ov0.','9Ov1.','9Ov2.','9Ov3.','9Ov4.','9hC..','9hC0.','9hC1.','9k4..','9k40.','9kQ..','E02y3','E112.','E1120','E1121','E1122','E1123','E1124','E1125','E1126','E112z','E113.','E1130','E1131','E1132','E1133','E1134','E1135','E1136','E1137','E113z','E118.','E11y2','E11z2','E130.','E135.','E2003','E204.','E290.','E2900','E290z','E291.','E2B..','E2B0.','E2B1.','Eu053','Eu204','Eu251','Eu3..','Eu32.','Eu320','Eu321','Eu322','Eu323','Eu324','Eu325','Eu326','Eu327','Eu328','Eu329','Eu32A','Eu32B','Eu32y','Eu32z','Eu33.','Eu330','Eu331','Eu332','Eu333','Eu334','Eu33y','Eu33z','Eu34.','Eu341','Eu34y','Eu34z','Eu3y.','Eu3y0','Eu3y1','Eu3yy','Eu3z.','Eu412','Eu920','ZV111')
and EntryDate >= '2009-12-28'
and EntryDate <= '2020-09-10'
group by NHSNo, EntryDate
) sub 
group by EntryDate

PRINT 'Date,IncidenceOfMentalHealthMildModerate,PrevalenceOfMentalHealthMildModerate'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.EntryDate = d.date
order by date;
