--Just want the output, not the messages
SET NOCOUNT ON; 

--populate table with all dates from 2015-01-01
IF OBJECT_ID('tempdb..#AllDates') IS NOT NULL DROP TABLE #AllDates;
CREATE TABLE #AllDates ([date] date);
declare @dt datetime = '2015-01-01'
declare @dtEnd datetime = '2020-05-21';
WHILE (@dt <= @dtEnd) BEGIN
    insert into #AllDates([date])
        values(@dt)
    SET @dt = DATEADD(day, 1, @dt)
END;

-- Populate incidence table - only count those occurrences
-- of the code where it is the first time the patient has had it
select FirstDiagnosis, count(*) as num into #Incidence from (
	select PatID, min(EntryDate) as FirstDiagnosis from SIR_ALL_Records_Narrow
	where ReadCode in ('E03y.99','E03y399','E04..99','E10..98','E10..99','E101100','E101300','E102300','E105100','E105300','E106.11','E107.99','E12..99','E141000','E141z00','Eu20512','Eu20y11','Eu23111','Eu60012','ZS7C611','13Y2.00','1464.00','146H.00','1B1E.00','1BH..00','1BH..11','1BH0.00','1BH1.00','1BH2.00','1BH3.00','212W.00','212X.00','225E.00','225F.00','285..11','286..11','8G13100','8HHs.00','E03y300','E040.00','E040.11','E1...00','E10..00','E100.00','E100.11','E100000','E100100','E100200','E100300','E100400','E100500','E100z00','E101.00','E101000','E101200','E101400','E101500','E101z00','E102.00','E102000','E102100','E102200','E102400','E102500','E102z00','E103.00','E103000','E103100','E103200','E103300','E103400','E103500','E103z00','E104.00','E104.11','E105.00','E105000','E105200','E105400','E105500','E105z00','E106.00','E107.00','E107.11','E107000','E107100','E107200','E107300','E107400','E107500','E107z00','E10y.00','E10y.11','E10y000','E10y100','E10yz00','E10z.00','E11..00','E11z.00','E11z000','E11zz00','E12..00','E120.00','E121.00','E121.11','E122.00','E123.00','E123.11','E12y.00','E12y000','E12yz00','E12z.00','E13..00','E13..11','E131.00','E132.00','E133.00','E133.11','E134.00','E13y.00','E13y000','E13y100','E13yz00','E13z.00','E13z.11','E14..00','E141.00','E141.11','E141100','E14y.00','E14y000','E14y100','E14yz00','E14z.00','E14z.11','E1y..00','E1z..00','E210.00','E212.00','E212000','E212200','E212z00','Eu03.11','Eu04.00','Eu04.11','Eu04.12','Eu04.13','Eu05212','Eu05y11','Eu0z.12','Eu2..00','Eu20.00','Eu20000','Eu20011','Eu20100','Eu20111','Eu20200','Eu20211','Eu20212','Eu20213','Eu20214','Eu20300','Eu20311','Eu20400','Eu20500','Eu20511','Eu20600','Eu20y00','Eu20y12','Eu20y13','Eu20z00','Eu21.00','Eu21.11','Eu21.12','Eu21.13','Eu21.14','Eu21.15','Eu21.16','Eu21.17','Eu21.18','Eu22.00','Eu22000','Eu22011','Eu22012','Eu22013','Eu22014','Eu22015','Eu22100','Eu22111','Eu22200','Eu22300','Eu22y00','Eu22y12','Eu22y13','Eu22z00','Eu23000','Eu23011','Eu23012','Eu23100','Eu23112','Eu23200','Eu23211','Eu23212','Eu23214','Eu23300','Eu23312','Eu23z11','Eu23z12','Eu24.11','Eu25.00','Eu25000','Eu25011','Eu25012','Eu25100','Eu25111','Eu25112','Eu25200','Eu25211','Eu25212','Eu25y00','Eu25z00','Eu25z11','Eu26.00','Eu2y.00','Eu2y.11','Eu2z.00','Eu2z.11','Eu3z.11','Eu44.11','Eu44.13','Eu44.14','Eu53111','Eu60000','Eu60011','Eu60014','Eu60100','Eu84013','Eu84111','Eu84312','Eu84313','Eu84314','Eu84512','F481K00','R001.00','R001000','R001100','R001200','R001300','R001400','R001z00','Ryu5300','ZV11000','E1011','E1013','E1023','E1051','E1053','E1410','E141z','13Y2.','1464.','146H.','1B1E.','1BH..','1BH0.','1BH1.','1BH2.','1BH3.','212W.','212X.','225E.','225F.','8G131','8HHs.','E03y3','E040.','E1...','E10..','E100.','E1000','E1001','E1002','E1003','E1004','E1005','E100z','E101.','E1010','E1012','E1014','E1015','E101z','E102.','E1020','E1021','E1022','E1024','E1025','E102z','E103.','E1030','E1031','E1032','E1033','E1034','E1035','E103z','E104.','E105.','E1050','E1052','E1054','E1055','E105z','E106.','E107.','E1070','E1071','E1072','E1073','E1074','E1075','E107z','E10y.','E10y0','E10y1','E10yz','E10z.','E11..','E11z.','E11z0','E11zz','E12..','E120.','E121.','E122.','E123.','E12y.','E12y0','E12yz','E12z.','E13..','E131.','E132.','E133.','E134.','E13y.','E13y0','E13y1','E13yz','E13z.','E14..','E141.','E1411','E14y.','E14y0','E14y1','E14yz','E14z.','E1y..','E1z..','E210.','E212.','E2120','E2122','E212z','Eu04.','Eu2..','Eu20.','Eu200','Eu201','Eu202','Eu203','Eu204','Eu205','Eu206','Eu20y','Eu20z','Eu21.','Eu22.','Eu220','Eu221','Eu222','Eu223','Eu22y','Eu22z','Eu230','Eu231','Eu232','Eu233','Eu25.','Eu250','Eu251','Eu252','Eu25y','Eu25z','Eu26.','Eu2y.','Eu2z.','Eu600','Eu601','F481K','R001.','R0010','R0011','R0012','R0013','R0014','R001z','Ryu53','ZV110')
	and EntryDate <= '2020-05-21'
	group by PatID
) sub 
where FirstDiagnosis >= '2015-01-01'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select EntryDate, count(*) as num into #Prevalence from (
	select PatID, EntryDate from SIR_ALL_Records_Narrow
	where ReadCode in ('E03y.99','E03y399','E04..99','E10..98','E10..99','E101100','E101300','E102300','E105100','E105300','E106.11','E107.99','E12..99','E141000','E141z00','Eu20512','Eu20y11','Eu23111','Eu60012','ZS7C611','13Y2.00','1464.00','146H.00','1B1E.00','1BH..00','1BH..11','1BH0.00','1BH1.00','1BH2.00','1BH3.00','212W.00','212X.00','225E.00','225F.00','285..11','286..11','8G13100','8HHs.00','E03y300','E040.00','E040.11','E1...00','E10..00','E100.00','E100.11','E100000','E100100','E100200','E100300','E100400','E100500','E100z00','E101.00','E101000','E101200','E101400','E101500','E101z00','E102.00','E102000','E102100','E102200','E102400','E102500','E102z00','E103.00','E103000','E103100','E103200','E103300','E103400','E103500','E103z00','E104.00','E104.11','E105.00','E105000','E105200','E105400','E105500','E105z00','E106.00','E107.00','E107.11','E107000','E107100','E107200','E107300','E107400','E107500','E107z00','E10y.00','E10y.11','E10y000','E10y100','E10yz00','E10z.00','E11..00','E11z.00','E11z000','E11zz00','E12..00','E120.00','E121.00','E121.11','E122.00','E123.00','E123.11','E12y.00','E12y000','E12yz00','E12z.00','E13..00','E13..11','E131.00','E132.00','E133.00','E133.11','E134.00','E13y.00','E13y000','E13y100','E13yz00','E13z.00','E13z.11','E14..00','E141.00','E141.11','E141100','E14y.00','E14y000','E14y100','E14yz00','E14z.00','E14z.11','E1y..00','E1z..00','E210.00','E212.00','E212000','E212200','E212z00','Eu03.11','Eu04.00','Eu04.11','Eu04.12','Eu04.13','Eu05212','Eu05y11','Eu0z.12','Eu2..00','Eu20.00','Eu20000','Eu20011','Eu20100','Eu20111','Eu20200','Eu20211','Eu20212','Eu20213','Eu20214','Eu20300','Eu20311','Eu20400','Eu20500','Eu20511','Eu20600','Eu20y00','Eu20y12','Eu20y13','Eu20z00','Eu21.00','Eu21.11','Eu21.12','Eu21.13','Eu21.14','Eu21.15','Eu21.16','Eu21.17','Eu21.18','Eu22.00','Eu22000','Eu22011','Eu22012','Eu22013','Eu22014','Eu22015','Eu22100','Eu22111','Eu22200','Eu22300','Eu22y00','Eu22y12','Eu22y13','Eu22z00','Eu23000','Eu23011','Eu23012','Eu23100','Eu23112','Eu23200','Eu23211','Eu23212','Eu23214','Eu23300','Eu23312','Eu23z11','Eu23z12','Eu24.11','Eu25.00','Eu25000','Eu25011','Eu25012','Eu25100','Eu25111','Eu25112','Eu25200','Eu25211','Eu25212','Eu25y00','Eu25z00','Eu25z11','Eu26.00','Eu2y.00','Eu2y.11','Eu2z.00','Eu2z.11','Eu3z.11','Eu44.11','Eu44.13','Eu44.14','Eu53111','Eu60000','Eu60011','Eu60014','Eu60100','Eu84013','Eu84111','Eu84312','Eu84313','Eu84314','Eu84512','F481K00','R001.00','R001000','R001100','R001200','R001300','R001400','R001z00','Ryu5300','ZV11000','E1011','E1013','E1023','E1051','E1053','E1410','E141z','13Y2.','1464.','146H.','1B1E.','1BH..','1BH0.','1BH1.','1BH2.','1BH3.','212W.','212X.','225E.','225F.','8G131','8HHs.','E03y3','E040.','E1...','E10..','E100.','E1000','E1001','E1002','E1003','E1004','E1005','E100z','E101.','E1010','E1012','E1014','E1015','E101z','E102.','E1020','E1021','E1022','E1024','E1025','E102z','E103.','E1030','E1031','E1032','E1033','E1034','E1035','E103z','E104.','E105.','E1050','E1052','E1054','E1055','E105z','E106.','E107.','E1070','E1071','E1072','E1073','E1074','E1075','E107z','E10y.','E10y0','E10y1','E10yz','E10z.','E11..','E11z.','E11z0','E11zz','E12..','E120.','E121.','E122.','E123.','E12y.','E12y0','E12yz','E12z.','E13..','E131.','E132.','E133.','E134.','E13y.','E13y0','E13y1','E13yz','E13z.','E14..','E141.','E1411','E14y.','E14y0','E14y1','E14yz','E14z.','E1y..','E1z..','E210.','E212.','E2120','E2122','E212z','Eu04.','Eu2..','Eu20.','Eu200','Eu201','Eu202','Eu203','Eu204','Eu205','Eu206','Eu20y','Eu20z','Eu21.','Eu22.','Eu220','Eu221','Eu222','Eu223','Eu22y','Eu22z','Eu230','Eu231','Eu232','Eu233','Eu25.','Eu250','Eu251','Eu252','Eu25y','Eu25z','Eu26.','Eu2y.','Eu2z.','Eu600','Eu601','F481K','R001.','R0010','R0011','R0012','R0013','R0014','R001z','Ryu53','ZV110')
	and EntryDate >= '2015-01-01'
	and EntryDate <= '2020-05-21'
	group by PatID, EntryDate
) sub 
group by EntryDate

PRINT 'Date,IncidenceOfSchizophrenia,PrevalenceOfSchizophrenia'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.EntryDate = d.date
order by date;
