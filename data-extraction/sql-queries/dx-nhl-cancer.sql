--Just want the output, not the messages
SET NOCOUNT ON; 

--populate table with all dates from 2015-01-01
IF OBJECT_ID('tempdb..#AllDates') IS NOT NULL DROP TABLE #AllDates;
CREATE TABLE #AllDates ([date] date);
declare @dt datetime = '2015-01-01'
declare @dtEnd datetime = '2020-05-14';
WHILE (@dt <= @dtEnd) BEGIN
    insert into #AllDates([date])
        values(@dt)
    SET @dt = DATEADD(day, 1, @dt)
END;

-- Populate incidence table - only count those occurrences
-- of the code where it is the first time the patient has had it
select FirstDiagnosis, count(*) as num into #Incidence from (
	select PatID, min(EntryDate) as FirstDiagnosis from SIR_ALL_Records_Narrow
	where ReadCode in ('4M20.00','4M21.00','4M22.00','4M23.00','B60..00','B600.00','B600000','B600100','B600200','B600300','B600400','B600500','B600600','B600700','B600800','B600z00','B601.00','B601000','B601100','B601200','B601300','B601400','B601500','B601600','B601700','B601800','B601z00','B602.00','B602.99','B602000','B602100','B602200','B602300','B602400','B602500','B602600','B602700','B602800','B602z00','B60y.00','B60z.00','B620.00','B620.11','B620000','B620100','B620200','B620300','B620400','B620500','B620600','B620700','B620800','B620z00','B621.00','B621000','B621100','B621200','B621300','B621400','B621500','B621600','B621700','B621800','B621z00','B622.00','B622.11','B622000','B622100','B622200','B622300','B622400','B622500','B622600','B622700','B622800','B622z00','B627.00','B627.11','B627000','B627100','B627200','B627300','B627400','B627500','B627600','B627700','B627800','B627A00','B627B00','B627C00','B627C11','B627D00','B627E00','B627G00','B627W00','B627X00','B628.00','B628000','B628100','B628200','B628300','B628400','B628500','B628600','B628700','B62E.00','B62E000','B62E100','B62E200','B62E300','B62Ew00','B62F.00','B62F.11','B62F000','B62F100','B62F200','B62Fy00','B62x.00','B62x000','B62x100','B62x200','B62x400','B62xX00','B62y.00','B62y000','B62y100','B62y200','B62y300','B62y400','B62y500','B62y600','B62y700','B62y800','B62yz00','B640000','B640011','BBg..00','BBg1.00','BBg1.11','BBg1000','BBg2.00','BBg2.11','BBg3.00','BBg4.00','BBg5.00','BBg6.00','BBg7.00','BBg8.00','BBg9.00','BBg9.11','BBg9.12','BBgA.00','BBgA.11','BBgB.00','BBgC.00','BBgC.11','BBgC.12','BBgD.00','BBgE.00','BBgF.00','BBgG.00','BBgG.11','BBgG.12','BBgG.13','BBgH.00','BBgJ.00','BBgK.00','BBgL.00','BBgM.00','BBgN.00','BBgP.00','BBgQ.00','BBgR.00','BBgS.00','BBgT.00','BBgV.00','BBgz.00','BBh..00','BBh0.00','BBh0.11','BBh1.00','BBh2.00','BBhz.00','BBk..00','BBk0.00','BBk0.11','BBk0.12','BBk0.13','BBk0.14','BBk1.00','BBk1.11','BBk1.12','BBk2.00','BBk2.11','BBk3.00','BBk4.00','BBk5.00','BBk6.00','BBk7.00','BBk7.11','BBk8.00','BBkz.00','BBl..00','BBl0.00','BBl1.00','BBlz.00','BBm0.00','BBm1.11','BBm5.00','BBm9.00','BBmD.00','BBmH.00','BBv0.00','BBv2.00','ByuD100','ByuD200','ByuD300','ByuDC00','ByuDD00','ByuDE00','ByuDF00','ByuDF11','4M20.','4M21.','4M22.','4M23.','B60..','B600.','B6000','B6001','B6002','B6003','B6004','B6005','B6006','B6007','B6008','B600z','B601.','B6010','B6011','B6012','B6013','B6014','B6015','B6016','B6017','B6018','B601z','B602.','B6020','B6021','B6022','B6023','B6024','B6025','B6026','B6027','B6028','B602z','B60y.','B60z.','B620.','B6200','B6201','B6202','B6203','B6204','B6205','B6206','B6207','B6208','B620z','B621.','B6210','B6211','B6212','B6213','B6214','B6215','B6216','B6217','B6218','B621z','B622.','B6220','B6221','B6222','B6223','B6224','B6225','B6226','B6227','B6228','B622z','B627.','B6270','B6271','B6272','B6273','B6274','B6275','B6276','B6277','B6278','B627A','B627B','B627C','B627D','B627E','B627G','B627W','B627X','B628.','B6280','B6281','B6282','B6283','B6284','B6285','B6286','B6287','B62E.','B62E0','B62E1','B62E2','B62E3','B62Ew','B62F.','B62F0','B62F1','B62F2','B62Fy','B62x.','B62x0','B62x1','B62x2','B62x4','B62xX','B62y.','B62y0','B62y1','B62y2','B62y3','B62y4','B62y5','B62y6','B62y7','B62y8','B62yz','B6400','BBg..','BBg1.','BBg10','BBg2.','BBg3.','BBg4.','BBg5.','BBg6.','BBg7.','BBg8.','BBg9.','BBgA.','BBgB.','BBgC.','BBgD.','BBgE.','BBgF.','BBgG.','BBgH.','BBgJ.','BBgK.','BBgL.','BBgM.','BBgN.','BBgP.','BBgQ.','BBgR.','BBgS.','BBgT.','BBgV.','BBgz.','BBh..','BBh0.','BBh1.','BBh2.','BBhz.','BBk..','BBk0.','BBk1.','BBk2.','BBk3.','BBk4.','BBk5.','BBk6.','BBk7.','BBk8.','BBkz.','BBl..','BBl0.','BBl1.','BBlz.','BBm0.','BBm5.','BBm9.','BBmD.','BBmH.','BBv0.','BBv2.','ByuD1','ByuD2','ByuD3','ByuDC','ByuDD','ByuDE','ByuDF')
	and EntryDate <= '2020-05-14'
	group by PatID
) sub 
where FirstDiagnosis >= '2015-01-01'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select EntryDate, count(*) as num into #Prevalence from (
	select PatID, EntryDate from SIR_ALL_Records_Narrow
	where ReadCode in ('4M20.00','4M21.00','4M22.00','4M23.00','B60..00','B600.00','B600000','B600100','B600200','B600300','B600400','B600500','B600600','B600700','B600800','B600z00','B601.00','B601000','B601100','B601200','B601300','B601400','B601500','B601600','B601700','B601800','B601z00','B602.00','B602.99','B602000','B602100','B602200','B602300','B602400','B602500','B602600','B602700','B602800','B602z00','B60y.00','B60z.00','B620.00','B620.11','B620000','B620100','B620200','B620300','B620400','B620500','B620600','B620700','B620800','B620z00','B621.00','B621000','B621100','B621200','B621300','B621400','B621500','B621600','B621700','B621800','B621z00','B622.00','B622.11','B622000','B622100','B622200','B622300','B622400','B622500','B622600','B622700','B622800','B622z00','B627.00','B627.11','B627000','B627100','B627200','B627300','B627400','B627500','B627600','B627700','B627800','B627A00','B627B00','B627C00','B627C11','B627D00','B627E00','B627G00','B627W00','B627X00','B628.00','B628000','B628100','B628200','B628300','B628400','B628500','B628600','B628700','B62E.00','B62E000','B62E100','B62E200','B62E300','B62Ew00','B62F.00','B62F.11','B62F000','B62F100','B62F200','B62Fy00','B62x.00','B62x000','B62x100','B62x200','B62x400','B62xX00','B62y.00','B62y000','B62y100','B62y200','B62y300','B62y400','B62y500','B62y600','B62y700','B62y800','B62yz00','B640000','B640011','BBg..00','BBg1.00','BBg1.11','BBg1000','BBg2.00','BBg2.11','BBg3.00','BBg4.00','BBg5.00','BBg6.00','BBg7.00','BBg8.00','BBg9.00','BBg9.11','BBg9.12','BBgA.00','BBgA.11','BBgB.00','BBgC.00','BBgC.11','BBgC.12','BBgD.00','BBgE.00','BBgF.00','BBgG.00','BBgG.11','BBgG.12','BBgG.13','BBgH.00','BBgJ.00','BBgK.00','BBgL.00','BBgM.00','BBgN.00','BBgP.00','BBgQ.00','BBgR.00','BBgS.00','BBgT.00','BBgV.00','BBgz.00','BBh..00','BBh0.00','BBh0.11','BBh1.00','BBh2.00','BBhz.00','BBk..00','BBk0.00','BBk0.11','BBk0.12','BBk0.13','BBk0.14','BBk1.00','BBk1.11','BBk1.12','BBk2.00','BBk2.11','BBk3.00','BBk4.00','BBk5.00','BBk6.00','BBk7.00','BBk7.11','BBk8.00','BBkz.00','BBl..00','BBl0.00','BBl1.00','BBlz.00','BBm0.00','BBm1.11','BBm5.00','BBm9.00','BBmD.00','BBmH.00','BBv0.00','BBv2.00','ByuD100','ByuD200','ByuD300','ByuDC00','ByuDD00','ByuDE00','ByuDF00','ByuDF11','4M20.','4M21.','4M22.','4M23.','B60..','B600.','B6000','B6001','B6002','B6003','B6004','B6005','B6006','B6007','B6008','B600z','B601.','B6010','B6011','B6012','B6013','B6014','B6015','B6016','B6017','B6018','B601z','B602.','B6020','B6021','B6022','B6023','B6024','B6025','B6026','B6027','B6028','B602z','B60y.','B60z.','B620.','B6200','B6201','B6202','B6203','B6204','B6205','B6206','B6207','B6208','B620z','B621.','B6210','B6211','B6212','B6213','B6214','B6215','B6216','B6217','B6218','B621z','B622.','B6220','B6221','B6222','B6223','B6224','B6225','B6226','B6227','B6228','B622z','B627.','B6270','B6271','B6272','B6273','B6274','B6275','B6276','B6277','B6278','B627A','B627B','B627C','B627D','B627E','B627G','B627W','B627X','B628.','B6280','B6281','B6282','B6283','B6284','B6285','B6286','B6287','B62E.','B62E0','B62E1','B62E2','B62E3','B62Ew','B62F.','B62F0','B62F1','B62F2','B62Fy','B62x.','B62x0','B62x1','B62x2','B62x4','B62xX','B62y.','B62y0','B62y1','B62y2','B62y3','B62y4','B62y5','B62y6','B62y7','B62y8','B62yz','B6400','BBg..','BBg1.','BBg10','BBg2.','BBg3.','BBg4.','BBg5.','BBg6.','BBg7.','BBg8.','BBg9.','BBgA.','BBgB.','BBgC.','BBgD.','BBgE.','BBgF.','BBgG.','BBgH.','BBgJ.','BBgK.','BBgL.','BBgM.','BBgN.','BBgP.','BBgQ.','BBgR.','BBgS.','BBgT.','BBgV.','BBgz.','BBh..','BBh0.','BBh1.','BBh2.','BBhz.','BBk..','BBk0.','BBk1.','BBk2.','BBk3.','BBk4.','BBk5.','BBk6.','BBk7.','BBk8.','BBkz.','BBl..','BBl0.','BBl1.','BBlz.','BBm0.','BBm5.','BBm9.','BBmD.','BBmH.','BBv0.','BBv2.','ByuD1','ByuD2','ByuD3','ByuDC','ByuDD','ByuDE','ByuDF')
	and EntryDate >= '2015-01-01'
	and EntryDate <= '2020-05-14'
	group by PatID, EntryDate
) sub 
group by EntryDate

PRINT 'Date,IncidenceOfNhlCancer,PrevalenceOfNhlCancer'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.EntryDate = d.date
order by date;
