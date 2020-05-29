-- Template for the groups of conditions
-- E.g. all malignant cancers, or all cvd

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
	-- bladder cancer
select NHSNo, min(EntryDate) as FirstDiagnosis from journal
where ReadCode in ('B49..00','B49z.00','B49y.00','B49y000','B495.00','B494.00','B493.00','B492.00','B491.00','B490.00','B498.00','B497.00','B496.00','B581100','ByuC500','B49..','B49z.','B49y.','B49y0','B495.','B494.','B493.','B492.','B491.','B490.','B498.','B497.','B496.','B5811','ByuC5')
and EntryDate <= '2020-05-29'
group by NHSNo
 UNION ALL 
-- brain cns cancer
select NHSNo, min(EntryDate) as FirstDiagnosis from journal
where ReadCode in ('B51..00','B522.00','B525.00','B52y.00','BBb..00','BBb..99','BBb0.00','BBb0.11','BBb0.12','BBb1.00','BBb2.00','BBb2.11','BBb3.00','BBb3.11','BBb3.12','BBb6.00','BBb8.11','BBbB.00','BBbB.11','BBbB.12','BBbC.00','BBbD.00','BBbE.00','BBbE.11','BBbF.00','BBbG.00','BBbG.11','BBbG.12','BBbH.00','BBbJ.00','BBbK.00','BBbL.00','BBbL.11','BBbL.12','BBbM.00','BBbN.00','BBbP.00','BBbS.00','BBbT.00','BBbU.00','BBbV.00','BBbW.00','BBbX.00','BBbZ.00','BBba.00','BBbz.00','BBe7.00','ByuA.00','ByuA000','ByuA100','ByuA300','B51..','B522.','B525.','B52y.','BBb..','BBb0.','BBb1.','BBb2.','BBb3.','BBb6.','BBbB.','BBbC.','BBbD.','BBbE.','BBbF.','BBbG.','BBbH.','BBbJ.','BBbK.','BBbL.','BBbM.','BBbN.','BBbP.','BBbS.','BBbT.','BBbU.','BBbV.','BBbW.','BBbX.','BBbZ.','BBba.','BBbz.','BBe7.','ByuA.','ByuA0','ByuA1','ByuA3')
and EntryDate <= '2020-05-29'
group by NHSNo
 UNION ALL 
-- breast cancer
select NHSNo, min(EntryDate) as FirstDiagnosis from journal
where ReadCode in ('B34..00','B34..11','B34..98','B34..99','B340.00','B340.99','B340000','B340100','B340z00','B341.00','B342.00','B342.99','B343.00','B343.99','B344.00','B344.99','B345.00','B345.99','B346.00','B346.99','B347.00','B34y.00','B34y000','B34yz00','B34z.00','B34z.99','B35..00','B35..99','B350.00','B350000','B350100','B350z00','B35z.00','B35z000','B35zz00','B36..00','BB91.00','BB91000','BB91100','BB92.00','BB93.00','BB94.00','BB94.11','BB96.00','BB98.00','BB9D.00','BB9F.00','BB9G.00','BB9H.00','BB9J.00','BB9J.11','BB9K.00','BB9K000','BBM8.00','BBM9.00','Byu6.00','B34..','B340.','B3400','B3401','B340z','B341.','B342.','B343.','B344.','B345.','B346.','B347.','B34y.','B34y0','B34yz','B34z.','B35..','B350.','B3500','B3501','B350z','B35z.','B35z0','B35zz','B36..','BB91.','BB910','BB911','BB92.','BB93.','BB94.','BB96.','BB98.','BB9D.','BB9F.','BB9G.','BB9H.','BB9J.','BB9K.','BB9K0','BBM8.','BBM9.','Byu6.')
and EntryDate <= '2020-05-29'
group by NHSNo
 UNION ALL 
-- cervix cancer
select NHSNo, min(EntryDate) as FirstDiagnosis from journal
where ReadCode in ('B41..00','B41..11','B410.00','B410.99','B410000','B410100','B410z00','B411.00','B411.99','B412.00','B41y.00','B41y000','B41y100','B41yz00','B41z.00','B831.12','B831.13','BB2J.00','B41..','B410.','B4100','B4101','B410z','B411.','B412.','B41y.','B41y0','B41y1','B41yz','B41z.','BB2J.')
and EntryDate <= '2020-05-29'
group by NHSNo
 UNION ALL 
-- colorectal cancer
select NHSNo, min(EntryDate) as FirstDiagnosis from journal
where ReadCode in ('68W2400','9Ow1.00','B13..00','B130.00','B130.99','B131.00','B131.99','B132.00','B132.99','B133.00','B133.99','B134.00','B134.11','B135.00','B136.00','B136.99','B137.00','B137.99','B138.00','B139.00','B13y.00','B13z.00','B13z.11','B140.00','B140.99','B141.00','B141.11','B141.12','B141.99','B803800','BB5L.00','BB5Lz00','BB5M.00','BB5N.00','BB5N100','BB5R600','68W24','9Ow1.','B13..','B130.','B131.','B132.','B133.','B134.','B135.','B136.','B137.','B138.','B139.','B13y.','B13z.','B140.','B141.','B8038','BB5L.','BB5Lz','BB5M.','BB5N.','BB5N1','BB5R6')
and EntryDate <= '2020-05-29'
group by NHSNo
 UNION ALL 
-- kidney cancer
select NHSNo, min(EntryDate) as FirstDiagnosis from journal
where ReadCode in ('B4A..11','B4A..99','B4A0.00','B4A0.99','B4A0000','BB5a.00','BB5a000','BB5a011','BB5a012','BBL7.11','BBL7100','BBL7112','BBL7200','BBL7300','BBLJ.00','K01w112','B4A0.','B4A00','BB5a.','BB5a0','BBL71','BBL72','BBL73','BBLJ.')
and EntryDate <= '2020-05-29'
group by NHSNo
 UNION ALL 
-- leukaemia
select NHSNo, min(EntryDate) as FirstDiagnosis from journal
where ReadCode in ('B624.00','B624.11','B624.12','B624000','B624100','B624200','B624300','B624400','B624500','B624600','B624700','B624800','B624z00','B64..00','B64..11','B640.00','B640.99','B641.00','B641.11','B641.99','B641000','B641011','B641100','B641200','B641300','B642.00','B642.99','B64y.00','B64y000','B64y100','B64y200','B64y300','B64y311','B64y400','B64y411','B64y500','B64yz00','B64z.00','B65..00','B650.00','B650.99','B650000','B650100','B651.00','B651.11','B651.99','B651000','B651100','B651200','B651300','B651z00','B652.00','B652.99','B653.00','B653000','B653100','B653z00','B654.00','B65y.00','B65y000','B65y100','B65yz00','B65z.00','B66..00','B66..11','B66..12','B660.00','B660.99','B661.00','B661.99','B662.00','B662.99','B663.00','B66y.00','B66y000','B66yz00','B66z.00','B67..00','B67..98','B67..99','B670.00','B670.11','B671.00','B672.00','B672.11','B673.00','B674.00','B675.00','B675.11','B676.00','B677.00','B67y.00','B67y000','B67yz00','B67z.00','B67z.99','B68..00','B68..99','B680.00','B680.99','B681.00','B681.99','B682.00','B682.99','B68y.00','B68z.00','B68z.99','B69..00','B690.00','B691.00','B692.00','B693.00','B6y1.11','B6y1.12','BBr..00','BBr0.00','BBr0000','BBr0100','BBr0111','BBr0112','BBr0113','BBr0200','BBr0300','BBr0400','BBr0z00','BBr1.00','BBr1000','BBr1011','BBr1z00','BBr2.00','BBr2000','BBr2011','BBr2100','BBr2200','BBr2300','BBr2400','BBr2500','BBr2600','BBr2700','BBr2z00','BBr4.00','BBr4000','BBr4011','BBr4111','BBr4200','BBr4z00','BBr5.00','BBr5000','BBr5z00','BBr6.00','BBr6000','BBr6011','BBr6012','BBr6100','BBr6200','BBr6300','BBr6311','BBr6400','BBr6500','BBr6600','BBr6700','BBr6800','BBr6900','BBr6z00','BBr7.00','BBr7000','BBr7z00','BBr8.00','BBr8000','BBr8z00','BBr9.00','BBr9000','BBr9011','BBr9012','BBr9100','BBr9200','BBr9300','BBr9400','BBr9z00','BBrA.00','BBrA000','BBrA100','BBrA111','BBrA200','BBrA300','BBrA311','BBrA312','BBrA400','BBrA411','BBrA500','BBrA600','BBrA700','BBrA800','BBrAz00','BBrz.00','BBs..00','BBs1.00','ByuD500','ByuD600','ByuD700','ByuD800','ByuD900','B624.','B6240','B6241','B6242','B6243','B6244','B6245','B6246','B6247','B6248','B624z','B64..','B640.','B641.','B6410','B6411','B6412','B6413','B642.','B64y.','B64y0','B64y1','B64y2','B64y3','B64y4','B64y5','B64yz','B64z.','B65..','B650.','B6500','B6501','B651.','B6510','B6511','B6512','B6513','B651z','B652.','B653.','B6530','B6531','B653z','B654.','B65y.','B65y0','B65y1','B65yz','B65z.','B66..','B660.','B661.','B662.','B663.','B66y.','B66y0','B66yz','B66z.','B67..','B670.','B671.','B672.','B673.','B674.','B675.','B676.','B677.','B67y.','B67y0','B67yz','B67z.','B68..','B680.','B681.','B682.','B68y.','B68z.','B69..','B690.','B691.','B692.','B693.','BBr..','BBr0.','BBr00','BBr01','BBr02','BBr03','BBr04','BBr0z','BBr1.','BBr10','BBr1z','BBr2.','BBr20','BBr21','BBr22','BBr23','BBr24','BBr25','BBr26','BBr27','BBr2z','BBr4.','BBr40','BBr42','BBr4z','BBr5.','BBr50','BBr5z','BBr6.','BBr60','BBr61','BBr62','BBr63','BBr64','BBr65','BBr66','BBr67','BBr68','BBr69','BBr6z','BBr7.','BBr70','BBr7z','BBr8.','BBr80','BBr8z','BBr9.','BBr90','BBr91','BBr92','BBr93','BBr94','BBr9z','BBrA.','BBrA0','BBrA1','BBrA2','BBrA3','BBrA4','BBrA5','BBrA6','BBrA7','BBrA8','BBrAz','BBrz.','BBs..','BBs1.','ByuD5','ByuD6','ByuD7','ByuD8','ByuD9')
and EntryDate <= '2020-05-29'
group by NHSNo
 UNION ALL 
-- liver cancer
select NHSNo, min(EntryDate) as FirstDiagnosis from journal
where ReadCode in ('B15..00','B15..99','B150.00','B150.99','B150000','B150100','B150200','B150300','B150z00','B151.00','B151.99','B151000','B151200','B151300','B151400','B151z00','B152.00','B15z.00','B15z.99','BB5D100','BB5D300','BB5D500','BB5D511','BB5D512','BB5D513','BB5D700','BB5D711','BB5D800','BB5Dz00','BB5y200','BBL8.00','BBL8.11','BBT5.00','Byu1000','Byu1100','B15..','B150.','B1500','B1501','B1502','B1503','B150z','B151.','B1510','B1512','B1513','B1514','B151z','B152.','B15z.','BB5D1','BB5D3','BB5D5','BB5D7','BB5D8','BB5Dz','BB5y2','BBL8.','BBT5.','Byu10','Byu11')
and EntryDate <= '2020-05-29'
group by NHSNo
 UNION ALL 
-- lung cancer
select NHSNo, min(EntryDate) as FirstDiagnosis from journal
where ReadCode in ('B22..00','B221.00','B221000','B221100','B221z00','B222.00','B222.11','B222.99','B222000','B222100','B222z00','B223.00','B223.99','B223000','B223100','B223z00','B224.00','B224.99','B224000','B224100','B224z00','B225.00','B22y.00','B22z.00','B22z.11','BB1K.00','BB1L.00','BB1M.00','BB1N.00','BB1P.00','BB5J.12','BB5R111','BB5S200','BB5S211','BB5S212','BB5S400','BBLA.11','BBLM.00','Byu2000','B22..','B221.','B2210','B2211','B221z','B222.','B2220','B2221','B222z','B223.','B2230','B2231','B223z','B224.','B2240','B2241','B224z','B225.','B22y.','B22z.','BB1K.','BB1L.','BB1M.','BB1N.','BB1P.','BB5S2','BB5S4','BBLM.','Byu20')
and EntryDate <= '2020-05-29'
group by NHSNo
 UNION ALL 
-- melanoma
select NHSNo, min(EntryDate) as FirstDiagnosis from journal
where ReadCode in ('4M71.00','4M72.00','4M73.00','4M74.00','B32..00','B320.00','B321.00','B322.00','B322000','B322100','B322z00','B323.00','B323000','B323100','B323200','B323300','B323400','B323500','B323z00','B324.00','B324000','B324100','B324z00','B325.00','B325000','B325100','B325200','B325300','B325400','B325500','B325600','B325700','B325800','B325z00','B326.00','B326000','B326100','B326200','B326300','B326400','B326500','B326z00','B327.00','B327000','B327100','B327200','B327300','B327400','B327500','B327600','B327700','B327800','B327900','B327z00','B328.00','B329.00','B32A.00','B32B.00','B32C.00','B32D.00','B32E.00','B32F.00','B32G.00','B32H.00','B32J.00','B32y.00','B32y000','B32z.00','B509.00','BBE1.00','BBE1.11','BBE1.13','BBE1.14','BBE1000','BBE1100','BBE2.00','BBE4.00','BBEA.00','BBEC.00','BBEE.00','BBEG.00','BBEG.11','BBEG000','BBEH.00','BBEM.00','BBEP.00','BBEQ.00','BBEV.00','Byu4.00','Byu4000','Byu4100','4M71.','4M72.','4M73.','4M74.','B32..','B320.','B321.','B322.','B3220','B3221','B322z','B323.','B3230','B3231','B3232','B3233','B3234','B3235','B323z','B324.','B3240','B3241','B324z','B325.','B3250','B3251','B3252','B3253','B3254','B3255','B3256','B3257','B3258','B325z','B326.','B3260','B3261','B3262','B3263','B3264','B3265','B326z','B327.','B3270','B3271','B3272','B3273','B3274','B3275','B3276','B3277','B3278','B3279','B327z','B328.','B329.','B32A.','B32B.','B32C.','B32D.','B32E.','B32F.','B32G.','B32H.','B32J.','B32y.','B32y0','B32z.','B509.','BBE1.','BBE10','BBE11','BBE2.','BBE4.','BBEA.','BBEC.','BBEE.','BBEG.','BBEG0','BBEH.','BBEM.','BBEP.','BBEQ.','BBEV.','Byu4.','Byu40','Byu41')
and EntryDate <= '2020-05-29'
group by NHSNo
 UNION ALL 
-- myeloma
select NHSNo, min(EntryDate) as FirstDiagnosis from journal
where ReadCode in ('4C53.00','B63..00','B63..99','B630.00','B630.11','B630.12','B630000','B630011','B630100','B630200','B630300','B630400','B631.00','B936.11','B936.12','BBn0.00','BBn0.11','BBn0.12','BBn0.13','BBn0.14','BBn2.00','BBn2.11','BBn2.12','BBn3.00','BBr3.00','BBr3000','BBr3z00','4C53.','B63..','B630.','B6300','B6301','B6302','B6303','B6304','B631.','BBn0.','BBn2.','BBn3.','BBr3.','BBr30','BBr3z')
and EntryDate <= '2020-05-29'
group by NHSNo
 UNION ALL 
-- nhl cancer
select NHSNo, min(EntryDate) as FirstDiagnosis from journal
where ReadCode in ('4M20.00','4M21.00','4M22.00','4M23.00','B60..00','B600.00','B600000','B600100','B600200','B600300','B600400','B600500','B600600','B600700','B600800','B600z00','B601.00','B601000','B601100','B601200','B601300','B601400','B601500','B601600','B601700','B601800','B601z00','B602.00','B602.99','B602000','B602100','B602200','B602300','B602400','B602500','B602600','B602700','B602800','B602z00','B60y.00','B60z.00','B620.00','B620.11','B620000','B620100','B620200','B620300','B620400','B620500','B620600','B620700','B620800','B620z00','B621.00','B621000','B621100','B621200','B621300','B621400','B621500','B621600','B621700','B621800','B621z00','B622.00','B622.11','B622000','B622100','B622200','B622300','B622400','B622500','B622600','B622700','B622800','B622z00','B627.00','B627.11','B627000','B627100','B627200','B627300','B627400','B627500','B627600','B627700','B627800','B627A00','B627B00','B627C00','B627C11','B627D00','B627E00','B627G00','B627W00','B627X00','B628.00','B628000','B628100','B628200','B628300','B628400','B628500','B628600','B628700','B62E.00','B62E000','B62E100','B62E200','B62E300','B62Ew00','B62F.00','B62F.11','B62F000','B62F100','B62F200','B62Fy00','B62x.00','B62x000','B62x100','B62x200','B62x400','B62xX00','B62y.00','B62y000','B62y100','B62y200','B62y300','B62y400','B62y500','B62y600','B62y700','B62y800','B62yz00','B640000','B640011','BBg..00','BBg1.00','BBg1.11','BBg1000','BBg2.00','BBg2.11','BBg3.00','BBg4.00','BBg5.00','BBg6.00','BBg7.00','BBg8.00','BBg9.00','BBg9.11','BBg9.12','BBgA.00','BBgA.11','BBgB.00','BBgC.00','BBgC.11','BBgC.12','BBgD.00','BBgE.00','BBgF.00','BBgG.00','BBgG.11','BBgG.12','BBgG.13','BBgH.00','BBgJ.00','BBgK.00','BBgL.00','BBgM.00','BBgN.00','BBgP.00','BBgQ.00','BBgR.00','BBgS.00','BBgT.00','BBgV.00','BBgz.00','BBh..00','BBh0.00','BBh0.11','BBh1.00','BBh2.00','BBhz.00','BBk..00','BBk0.00','BBk0.11','BBk0.12','BBk0.13','BBk0.14','BBk1.00','BBk1.11','BBk1.12','BBk2.00','BBk2.11','BBk3.00','BBk4.00','BBk5.00','BBk6.00','BBk7.00','BBk7.11','BBk8.00','BBkz.00','BBl..00','BBl0.00','BBl1.00','BBlz.00','BBm0.00','BBm1.11','BBm5.00','BBm9.00','BBmD.00','BBmH.00','BBv0.00','BBv2.00','ByuD100','ByuD200','ByuD300','ByuDC00','ByuDD00','ByuDE00','ByuDF00','ByuDF11','4M20.','4M21.','4M22.','4M23.','B60..','B600.','B6000','B6001','B6002','B6003','B6004','B6005','B6006','B6007','B6008','B600z','B601.','B6010','B6011','B6012','B6013','B6014','B6015','B6016','B6017','B6018','B601z','B602.','B6020','B6021','B6022','B6023','B6024','B6025','B6026','B6027','B6028','B602z','B60y.','B60z.','B620.','B6200','B6201','B6202','B6203','B6204','B6205','B6206','B6207','B6208','B620z','B621.','B6210','B6211','B6212','B6213','B6214','B6215','B6216','B6217','B6218','B621z','B622.','B6220','B6221','B6222','B6223','B6224','B6225','B6226','B6227','B6228','B622z','B627.','B6270','B6271','B6272','B6273','B6274','B6275','B6276','B6277','B6278','B627A','B627B','B627C','B627D','B627E','B627G','B627W','B627X','B628.','B6280','B6281','B6282','B6283','B6284','B6285','B6286','B6287','B62E.','B62E0','B62E1','B62E2','B62E3','B62Ew','B62F.','B62F0','B62F1','B62F2','B62Fy','B62x.','B62x0','B62x1','B62x2','B62x4','B62xX','B62y.','B62y0','B62y1','B62y2','B62y3','B62y4','B62y5','B62y6','B62y7','B62y8','B62yz','B6400','BBg..','BBg1.','BBg10','BBg2.','BBg3.','BBg4.','BBg5.','BBg6.','BBg7.','BBg8.','BBg9.','BBgA.','BBgB.','BBgC.','BBgD.','BBgE.','BBgF.','BBgG.','BBgH.','BBgJ.','BBgK.','BBgL.','BBgM.','BBgN.','BBgP.','BBgQ.','BBgR.','BBgS.','BBgT.','BBgV.','BBgz.','BBh..','BBh0.','BBh1.','BBh2.','BBhz.','BBk..','BBk0.','BBk1.','BBk2.','BBk3.','BBk4.','BBk5.','BBk6.','BBk7.','BBk8.','BBkz.','BBl..','BBl0.','BBl1.','BBlz.','BBm0.','BBm5.','BBm9.','BBmD.','BBmH.','BBv0.','BBv2.','ByuD1','ByuD2','ByuD3','ByuDC','ByuDD','ByuDE','ByuDF')
and EntryDate <= '2020-05-29'
group by NHSNo
 UNION ALL 
-- oesophageal cancer
select NHSNo, min(EntryDate) as FirstDiagnosis from journal
where ReadCode in ('B10..00','B100.00','B101.00','B102.00','B103.00','B103.99','B104.00','B104.99','B105.00','B105.99','B106.00','B107.00','B10y.00','B10z.00','B10z.11','B10..','B100.','B101.','B102.','B103.','B104.','B105.','B106.','B107.','B10y.','B10z.')
and EntryDate <= '2020-05-29'
group by NHSNo
 UNION ALL 
-- oral cancer
select NHSNo, min(EntryDate) as FirstDiagnosis from journal
where ReadCode in ('B00..00','B00..11','B00..99','B000.00','B000000','B000100','B000z00','B001.00','B001000','B001100','B001z00','B002.00','B002000','B002100','B002200','B002300','B002z00','B003.00','B003000','B003100','B003200','B003300','B003z00','B004.00','B004000','B004100','B004200','B004300','B004z00','B005.00','B006.00','B007.00','B00y.00','B00z.00','B00z000','B00z100','B00zz00','B01..00','B01..99','B010.00','B010.11','B010000','B010z00','B011.00','B011000','B011100','B011z00','B012.00','B013.00','B013000','B013100','B013z00','B014.00','B015.00','B016.00','B017.00','B01y.00','B01z.00','B03..00','B03..99','B030.00','B031.00','B03y.00','B03z.00','B04..00','B040.00','B041.00','B042.00','B04y.00','B04z.00','B05..00','B050.00','B050.11','B051.00','B051000','B051100','B051200','B051300','B051z00','B052.00','B053.00','B054.00','B055.00','B055000','B055100','B055z00','B056.00','B05y.00','B05z.00','B062100','B062200','B062300','B200300','B550100','B00..','B000.','B0000','B0001','B000z','B001.','B0010','B0011','B001z','B002.','B0020','B0021','B0022','B0023','B002z','B003.','B0030','B0031','B0032','B0033','B003z','B004.','B0040','B0041','B0042','B0043','B004z','B005.','B006.','B007.','B00y.','B00z.','B00z0','B00z1','B00zz','B01..','B010.','B0100','B010z','B011.','B0110','B0111','B011z','B012.','B013.','B0130','B0131','B013z','B014.','B015.','B016.','B017.','B01y.','B01z.','B03..','B030.','B031.','B03y.','B03z.','B04..','B040.','B041.','B042.','B04y.','B04z.','B05..','B050.','B051.','B0510','B0511','B0512','B0513','B051z','B052.','B053.','B054.','B055.','B0550','B0551','B055z','B056.','B05y.','B05z.','B0621','B0622','B0623','B2003','B5501')
and EntryDate <= '2020-05-29'
group by NHSNo
 UNION ALL 
-- ovarian cancer
select NHSNo, min(EntryDate) as FirstDiagnosis from journal
where ReadCode in ('B440.00','B440.11','BB5j200','BB80.00','BB80100','BB81100','BB81200','BB81400','BB81500','BB81800','BB81B00','BB81D00','BB81E00','BB81E11','BB81H00','BB81J00','BB81K00','BB81M00','BB82.00','BBC1100','BBC4.00','BBC6.00','BBC6100','BBC6111','BBCE.11','BBM0100','BBQ0.00','BBQ4.00','BBQA100','BBQA200','B440.','BB5j2','BB80.','BB801','BB811','BB812','BB814','BB815','BB818','BB81B','BB81D','BB81E','BB81H','BB81J','BB81K','BB81M','BB82.','BBC11','BBC4.','BBC6.','BBC61','BBM01','BBQ0.','BBQ4.','BBQA1','BBQA2')
and EntryDate <= '2020-05-29'
group by NHSNo
 UNION ALL 
-- pancreatic cancer
select NHSNo, min(EntryDate) as FirstDiagnosis from journal
where ReadCode in ('B161100','B17..00','B170.00','B171.00','B172.00','B173.00','B174.00','B175.00','B17y.00','B17y000','B17yz00','B17z.00','BB5B.00','BB5B100','BB5B300','BB5B311','BB5B500','BB5B511','BB5B600','BB5C.00','BB5C000','BB5C011','BB5C100','BB5C111','BB5Cz00','BBLK.00','B1611','B17..','B170.','B171.','B172.','B173.','B174.','B175.','B17y.','B17y0','B17yz','B17z.','BB5B.','BB5B1','BB5B3','BB5B5','BB5B6','BB5C.','BB5C0','BB5C1','BB5Cz','BBLK.')
and EntryDate <= '2020-05-29'
group by NHSNo
 UNION ALL 
-- prostate cancer
select NHSNo, min(EntryDate) as FirstDiagnosis from journal
where ReadCode in ('4M00.00','4M01.00','4M02.00','8AD0.00','B46..00','B834000','B834100','4M00.','4M01.','4M02.','8AD0.','B46..','B8340','B8341')
and EntryDate <= '2020-05-29'
group by NHSNo
 UNION ALL 
-- stomach cancer
select NHSNo, min(EntryDate) as FirstDiagnosis from journal
where ReadCode in ('B11..00','B11..11','B110.00','B110.99','B110000','B110100','B110111','B110z00','B111.00','B111.99','B111000','B111100','B111z00','B112.00','B113.00','B113.99','B114.00','B114.99','B115.00','B115.99','B116.00','B116.99','B117.00','B118.00','B119.00','B11y.00','B11y000','B11y100','B11yz00','B11z.00','BB55.00','BB57.00','BB58.00','B11..','B110.','B1100','B1101','B110z','B111.','B1110','B1111','B111z','B112.','B113.','B114.','B115.','B116.','B117.','B118.','B119.','B11y.','B11y0','B11y1','B11yz','B11z.','BB55.','BB57.','BB58.')
and EntryDate <= '2020-05-29'
group by NHSNo
 UNION ALL 
-- thyroid cancer
select NHSNo, min(EntryDate) as FirstDiagnosis from journal
where ReadCode in ('B53..00','B53..99','BB5c.00','BB5c200','BB5d.00','BB5d100','BB5f.00','BB5f100','BB5f111','BB5f200','BB5f300','BB5f600','BB5f700','BB9B.11','BB9B.12','BB9C.00','B53..','BB5c.','BB5c2','BB5d.','BB5d1','BB5f.','BB5f1','BB5f2','BB5f3','BB5f6','BB5f7','BB9C.')
and EntryDate <= '2020-05-29'
group by NHSNo
 UNION ALL 
-- uterus cancer
select NHSNo, min(EntryDate) as FirstDiagnosis from journal
where ReadCode in ('B40..00','B43..00','B43..98','B43..99','B430.00','B430000','B430100','B430200','B430211','B430300','B430z00','B431.00','B431000','B431z00','B432.00','B43y.00','B43z.00','B43z.99','BB5j.00','BBL0.00','BBL5.00','B40..','B43..','B430.','B4300','B4301','B4302','B4303','B430z','B431.','B4310','B431z','B432.','B43y.','B43z.','BB5j.','BBL0.','BBL5.')
and EntryDate <= '2020-05-29'
group by NHSNo
) sub 
where FirstDiagnosis >= '2015-01-01'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select EntryDate, count(*) as num into #Prevalence from (
	-- bladder cancer
select PatID, EntryDate from SIR_ALL_Records_Narrow
where ReadCode in ('B49..00','B49z.00','B49y.00','B49y000','B495.00','B494.00','B493.00','B492.00','B491.00','B490.00','B498.00','B497.00','B496.00','B581100','ByuC500','B49..','B49z.','B49y.','B49y0','B495.','B494.','B493.','B492.','B491.','B490.','B498.','B497.','B496.','B5811','ByuC5')
and EntryDate >= '2015-01-01'
and EntryDate <= '2020-05-29'
group by PatID, EntryDate
 UNION ALL 
-- brain cns cancer
select PatID, EntryDate from SIR_ALL_Records_Narrow
where ReadCode in ('B51..00','B522.00','B525.00','B52y.00','BBb..00','BBb..99','BBb0.00','BBb0.11','BBb0.12','BBb1.00','BBb2.00','BBb2.11','BBb3.00','BBb3.11','BBb3.12','BBb6.00','BBb8.11','BBbB.00','BBbB.11','BBbB.12','BBbC.00','BBbD.00','BBbE.00','BBbE.11','BBbF.00','BBbG.00','BBbG.11','BBbG.12','BBbH.00','BBbJ.00','BBbK.00','BBbL.00','BBbL.11','BBbL.12','BBbM.00','BBbN.00','BBbP.00','BBbS.00','BBbT.00','BBbU.00','BBbV.00','BBbW.00','BBbX.00','BBbZ.00','BBba.00','BBbz.00','BBe7.00','ByuA.00','ByuA000','ByuA100','ByuA300','B51..','B522.','B525.','B52y.','BBb..','BBb0.','BBb1.','BBb2.','BBb3.','BBb6.','BBbB.','BBbC.','BBbD.','BBbE.','BBbF.','BBbG.','BBbH.','BBbJ.','BBbK.','BBbL.','BBbM.','BBbN.','BBbP.','BBbS.','BBbT.','BBbU.','BBbV.','BBbW.','BBbX.','BBbZ.','BBba.','BBbz.','BBe7.','ByuA.','ByuA0','ByuA1','ByuA3')
and EntryDate >= '2015-01-01'
and EntryDate <= '2020-05-29'
group by PatID, EntryDate
 UNION ALL 
-- breast cancer
select PatID, EntryDate from SIR_ALL_Records_Narrow
where ReadCode in ('B34..00','B34..11','B34..98','B34..99','B340.00','B340.99','B340000','B340100','B340z00','B341.00','B342.00','B342.99','B343.00','B343.99','B344.00','B344.99','B345.00','B345.99','B346.00','B346.99','B347.00','B34y.00','B34y000','B34yz00','B34z.00','B34z.99','B35..00','B35..99','B350.00','B350000','B350100','B350z00','B35z.00','B35z000','B35zz00','B36..00','BB91.00','BB91000','BB91100','BB92.00','BB93.00','BB94.00','BB94.11','BB96.00','BB98.00','BB9D.00','BB9F.00','BB9G.00','BB9H.00','BB9J.00','BB9J.11','BB9K.00','BB9K000','BBM8.00','BBM9.00','Byu6.00','B34..','B340.','B3400','B3401','B340z','B341.','B342.','B343.','B344.','B345.','B346.','B347.','B34y.','B34y0','B34yz','B34z.','B35..','B350.','B3500','B3501','B350z','B35z.','B35z0','B35zz','B36..','BB91.','BB910','BB911','BB92.','BB93.','BB94.','BB96.','BB98.','BB9D.','BB9F.','BB9G.','BB9H.','BB9J.','BB9K.','BB9K0','BBM8.','BBM9.','Byu6.')
and EntryDate >= '2015-01-01'
and EntryDate <= '2020-05-29'
group by PatID, EntryDate
 UNION ALL 
-- cervix cancer
select PatID, EntryDate from SIR_ALL_Records_Narrow
where ReadCode in ('B41..00','B41..11','B410.00','B410.99','B410000','B410100','B410z00','B411.00','B411.99','B412.00','B41y.00','B41y000','B41y100','B41yz00','B41z.00','B831.12','B831.13','BB2J.00','B41..','B410.','B4100','B4101','B410z','B411.','B412.','B41y.','B41y0','B41y1','B41yz','B41z.','BB2J.')
and EntryDate >= '2015-01-01'
and EntryDate <= '2020-05-29'
group by PatID, EntryDate
 UNION ALL 
-- colorectal cancer
select PatID, EntryDate from SIR_ALL_Records_Narrow
where ReadCode in ('68W2400','9Ow1.00','B13..00','B130.00','B130.99','B131.00','B131.99','B132.00','B132.99','B133.00','B133.99','B134.00','B134.11','B135.00','B136.00','B136.99','B137.00','B137.99','B138.00','B139.00','B13y.00','B13z.00','B13z.11','B140.00','B140.99','B141.00','B141.11','B141.12','B141.99','B803800','BB5L.00','BB5Lz00','BB5M.00','BB5N.00','BB5N100','BB5R600','68W24','9Ow1.','B13..','B130.','B131.','B132.','B133.','B134.','B135.','B136.','B137.','B138.','B139.','B13y.','B13z.','B140.','B141.','B8038','BB5L.','BB5Lz','BB5M.','BB5N.','BB5N1','BB5R6')
and EntryDate >= '2015-01-01'
and EntryDate <= '2020-05-29'
group by PatID, EntryDate
 UNION ALL 
-- kidney cancer
select PatID, EntryDate from SIR_ALL_Records_Narrow
where ReadCode in ('B4A..11','B4A..99','B4A0.00','B4A0.99','B4A0000','BB5a.00','BB5a000','BB5a011','BB5a012','BBL7.11','BBL7100','BBL7112','BBL7200','BBL7300','BBLJ.00','K01w112','B4A0.','B4A00','BB5a.','BB5a0','BBL71','BBL72','BBL73','BBLJ.')
and EntryDate >= '2015-01-01'
and EntryDate <= '2020-05-29'
group by PatID, EntryDate
 UNION ALL 
-- leukaemia
select PatID, EntryDate from SIR_ALL_Records_Narrow
where ReadCode in ('B624.00','B624.11','B624.12','B624000','B624100','B624200','B624300','B624400','B624500','B624600','B624700','B624800','B624z00','B64..00','B64..11','B640.00','B640.99','B641.00','B641.11','B641.99','B641000','B641011','B641100','B641200','B641300','B642.00','B642.99','B64y.00','B64y000','B64y100','B64y200','B64y300','B64y311','B64y400','B64y411','B64y500','B64yz00','B64z.00','B65..00','B650.00','B650.99','B650000','B650100','B651.00','B651.11','B651.99','B651000','B651100','B651200','B651300','B651z00','B652.00','B652.99','B653.00','B653000','B653100','B653z00','B654.00','B65y.00','B65y000','B65y100','B65yz00','B65z.00','B66..00','B66..11','B66..12','B660.00','B660.99','B661.00','B661.99','B662.00','B662.99','B663.00','B66y.00','B66y000','B66yz00','B66z.00','B67..00','B67..98','B67..99','B670.00','B670.11','B671.00','B672.00','B672.11','B673.00','B674.00','B675.00','B675.11','B676.00','B677.00','B67y.00','B67y000','B67yz00','B67z.00','B67z.99','B68..00','B68..99','B680.00','B680.99','B681.00','B681.99','B682.00','B682.99','B68y.00','B68z.00','B68z.99','B69..00','B690.00','B691.00','B692.00','B693.00','B6y1.11','B6y1.12','BBr..00','BBr0.00','BBr0000','BBr0100','BBr0111','BBr0112','BBr0113','BBr0200','BBr0300','BBr0400','BBr0z00','BBr1.00','BBr1000','BBr1011','BBr1z00','BBr2.00','BBr2000','BBr2011','BBr2100','BBr2200','BBr2300','BBr2400','BBr2500','BBr2600','BBr2700','BBr2z00','BBr4.00','BBr4000','BBr4011','BBr4111','BBr4200','BBr4z00','BBr5.00','BBr5000','BBr5z00','BBr6.00','BBr6000','BBr6011','BBr6012','BBr6100','BBr6200','BBr6300','BBr6311','BBr6400','BBr6500','BBr6600','BBr6700','BBr6800','BBr6900','BBr6z00','BBr7.00','BBr7000','BBr7z00','BBr8.00','BBr8000','BBr8z00','BBr9.00','BBr9000','BBr9011','BBr9012','BBr9100','BBr9200','BBr9300','BBr9400','BBr9z00','BBrA.00','BBrA000','BBrA100','BBrA111','BBrA200','BBrA300','BBrA311','BBrA312','BBrA400','BBrA411','BBrA500','BBrA600','BBrA700','BBrA800','BBrAz00','BBrz.00','BBs..00','BBs1.00','ByuD500','ByuD600','ByuD700','ByuD800','ByuD900','B624.','B6240','B6241','B6242','B6243','B6244','B6245','B6246','B6247','B6248','B624z','B64..','B640.','B641.','B6410','B6411','B6412','B6413','B642.','B64y.','B64y0','B64y1','B64y2','B64y3','B64y4','B64y5','B64yz','B64z.','B65..','B650.','B6500','B6501','B651.','B6510','B6511','B6512','B6513','B651z','B652.','B653.','B6530','B6531','B653z','B654.','B65y.','B65y0','B65y1','B65yz','B65z.','B66..','B660.','B661.','B662.','B663.','B66y.','B66y0','B66yz','B66z.','B67..','B670.','B671.','B672.','B673.','B674.','B675.','B676.','B677.','B67y.','B67y0','B67yz','B67z.','B68..','B680.','B681.','B682.','B68y.','B68z.','B69..','B690.','B691.','B692.','B693.','BBr..','BBr0.','BBr00','BBr01','BBr02','BBr03','BBr04','BBr0z','BBr1.','BBr10','BBr1z','BBr2.','BBr20','BBr21','BBr22','BBr23','BBr24','BBr25','BBr26','BBr27','BBr2z','BBr4.','BBr40','BBr42','BBr4z','BBr5.','BBr50','BBr5z','BBr6.','BBr60','BBr61','BBr62','BBr63','BBr64','BBr65','BBr66','BBr67','BBr68','BBr69','BBr6z','BBr7.','BBr70','BBr7z','BBr8.','BBr80','BBr8z','BBr9.','BBr90','BBr91','BBr92','BBr93','BBr94','BBr9z','BBrA.','BBrA0','BBrA1','BBrA2','BBrA3','BBrA4','BBrA5','BBrA6','BBrA7','BBrA8','BBrAz','BBrz.','BBs..','BBs1.','ByuD5','ByuD6','ByuD7','ByuD8','ByuD9')
and EntryDate >= '2015-01-01'
and EntryDate <= '2020-05-29'
group by PatID, EntryDate
 UNION ALL 
-- liver cancer
select PatID, EntryDate from SIR_ALL_Records_Narrow
where ReadCode in ('B15..00','B15..99','B150.00','B150.99','B150000','B150100','B150200','B150300','B150z00','B151.00','B151.99','B151000','B151200','B151300','B151400','B151z00','B152.00','B15z.00','B15z.99','BB5D100','BB5D300','BB5D500','BB5D511','BB5D512','BB5D513','BB5D700','BB5D711','BB5D800','BB5Dz00','BB5y200','BBL8.00','BBL8.11','BBT5.00','Byu1000','Byu1100','B15..','B150.','B1500','B1501','B1502','B1503','B150z','B151.','B1510','B1512','B1513','B1514','B151z','B152.','B15z.','BB5D1','BB5D3','BB5D5','BB5D7','BB5D8','BB5Dz','BB5y2','BBL8.','BBT5.','Byu10','Byu11')
and EntryDate >= '2015-01-01'
and EntryDate <= '2020-05-29'
group by PatID, EntryDate
 UNION ALL 
-- lung cancer
select PatID, EntryDate from SIR_ALL_Records_Narrow
where ReadCode in ('B22..00','B221.00','B221000','B221100','B221z00','B222.00','B222.11','B222.99','B222000','B222100','B222z00','B223.00','B223.99','B223000','B223100','B223z00','B224.00','B224.99','B224000','B224100','B224z00','B225.00','B22y.00','B22z.00','B22z.11','BB1K.00','BB1L.00','BB1M.00','BB1N.00','BB1P.00','BB5J.12','BB5R111','BB5S200','BB5S211','BB5S212','BB5S400','BBLA.11','BBLM.00','Byu2000','B22..','B221.','B2210','B2211','B221z','B222.','B2220','B2221','B222z','B223.','B2230','B2231','B223z','B224.','B2240','B2241','B224z','B225.','B22y.','B22z.','BB1K.','BB1L.','BB1M.','BB1N.','BB1P.','BB5S2','BB5S4','BBLM.','Byu20')
and EntryDate >= '2015-01-01'
and EntryDate <= '2020-05-29'
group by PatID, EntryDate
 UNION ALL 
-- melanoma
select PatID, EntryDate from SIR_ALL_Records_Narrow
where ReadCode in ('4M71.00','4M72.00','4M73.00','4M74.00','B32..00','B320.00','B321.00','B322.00','B322000','B322100','B322z00','B323.00','B323000','B323100','B323200','B323300','B323400','B323500','B323z00','B324.00','B324000','B324100','B324z00','B325.00','B325000','B325100','B325200','B325300','B325400','B325500','B325600','B325700','B325800','B325z00','B326.00','B326000','B326100','B326200','B326300','B326400','B326500','B326z00','B327.00','B327000','B327100','B327200','B327300','B327400','B327500','B327600','B327700','B327800','B327900','B327z00','B328.00','B329.00','B32A.00','B32B.00','B32C.00','B32D.00','B32E.00','B32F.00','B32G.00','B32H.00','B32J.00','B32y.00','B32y000','B32z.00','B509.00','BBE1.00','BBE1.11','BBE1.13','BBE1.14','BBE1000','BBE1100','BBE2.00','BBE4.00','BBEA.00','BBEC.00','BBEE.00','BBEG.00','BBEG.11','BBEG000','BBEH.00','BBEM.00','BBEP.00','BBEQ.00','BBEV.00','Byu4.00','Byu4000','Byu4100','4M71.','4M72.','4M73.','4M74.','B32..','B320.','B321.','B322.','B3220','B3221','B322z','B323.','B3230','B3231','B3232','B3233','B3234','B3235','B323z','B324.','B3240','B3241','B324z','B325.','B3250','B3251','B3252','B3253','B3254','B3255','B3256','B3257','B3258','B325z','B326.','B3260','B3261','B3262','B3263','B3264','B3265','B326z','B327.','B3270','B3271','B3272','B3273','B3274','B3275','B3276','B3277','B3278','B3279','B327z','B328.','B329.','B32A.','B32B.','B32C.','B32D.','B32E.','B32F.','B32G.','B32H.','B32J.','B32y.','B32y0','B32z.','B509.','BBE1.','BBE10','BBE11','BBE2.','BBE4.','BBEA.','BBEC.','BBEE.','BBEG.','BBEG0','BBEH.','BBEM.','BBEP.','BBEQ.','BBEV.','Byu4.','Byu40','Byu41')
and EntryDate >= '2015-01-01'
and EntryDate <= '2020-05-29'
group by PatID, EntryDate
 UNION ALL 
-- myeloma
select PatID, EntryDate from SIR_ALL_Records_Narrow
where ReadCode in ('4C53.00','B63..00','B63..99','B630.00','B630.11','B630.12','B630000','B630011','B630100','B630200','B630300','B630400','B631.00','B936.11','B936.12','BBn0.00','BBn0.11','BBn0.12','BBn0.13','BBn0.14','BBn2.00','BBn2.11','BBn2.12','BBn3.00','BBr3.00','BBr3000','BBr3z00','4C53.','B63..','B630.','B6300','B6301','B6302','B6303','B6304','B631.','BBn0.','BBn2.','BBn3.','BBr3.','BBr30','BBr3z')
and EntryDate >= '2015-01-01'
and EntryDate <= '2020-05-29'
group by PatID, EntryDate
 UNION ALL 
-- nhl cancer
select PatID, EntryDate from SIR_ALL_Records_Narrow
where ReadCode in ('4M20.00','4M21.00','4M22.00','4M23.00','B60..00','B600.00','B600000','B600100','B600200','B600300','B600400','B600500','B600600','B600700','B600800','B600z00','B601.00','B601000','B601100','B601200','B601300','B601400','B601500','B601600','B601700','B601800','B601z00','B602.00','B602.99','B602000','B602100','B602200','B602300','B602400','B602500','B602600','B602700','B602800','B602z00','B60y.00','B60z.00','B620.00','B620.11','B620000','B620100','B620200','B620300','B620400','B620500','B620600','B620700','B620800','B620z00','B621.00','B621000','B621100','B621200','B621300','B621400','B621500','B621600','B621700','B621800','B621z00','B622.00','B622.11','B622000','B622100','B622200','B622300','B622400','B622500','B622600','B622700','B622800','B622z00','B627.00','B627.11','B627000','B627100','B627200','B627300','B627400','B627500','B627600','B627700','B627800','B627A00','B627B00','B627C00','B627C11','B627D00','B627E00','B627G00','B627W00','B627X00','B628.00','B628000','B628100','B628200','B628300','B628400','B628500','B628600','B628700','B62E.00','B62E000','B62E100','B62E200','B62E300','B62Ew00','B62F.00','B62F.11','B62F000','B62F100','B62F200','B62Fy00','B62x.00','B62x000','B62x100','B62x200','B62x400','B62xX00','B62y.00','B62y000','B62y100','B62y200','B62y300','B62y400','B62y500','B62y600','B62y700','B62y800','B62yz00','B640000','B640011','BBg..00','BBg1.00','BBg1.11','BBg1000','BBg2.00','BBg2.11','BBg3.00','BBg4.00','BBg5.00','BBg6.00','BBg7.00','BBg8.00','BBg9.00','BBg9.11','BBg9.12','BBgA.00','BBgA.11','BBgB.00','BBgC.00','BBgC.11','BBgC.12','BBgD.00','BBgE.00','BBgF.00','BBgG.00','BBgG.11','BBgG.12','BBgG.13','BBgH.00','BBgJ.00','BBgK.00','BBgL.00','BBgM.00','BBgN.00','BBgP.00','BBgQ.00','BBgR.00','BBgS.00','BBgT.00','BBgV.00','BBgz.00','BBh..00','BBh0.00','BBh0.11','BBh1.00','BBh2.00','BBhz.00','BBk..00','BBk0.00','BBk0.11','BBk0.12','BBk0.13','BBk0.14','BBk1.00','BBk1.11','BBk1.12','BBk2.00','BBk2.11','BBk3.00','BBk4.00','BBk5.00','BBk6.00','BBk7.00','BBk7.11','BBk8.00','BBkz.00','BBl..00','BBl0.00','BBl1.00','BBlz.00','BBm0.00','BBm1.11','BBm5.00','BBm9.00','BBmD.00','BBmH.00','BBv0.00','BBv2.00','ByuD100','ByuD200','ByuD300','ByuDC00','ByuDD00','ByuDE00','ByuDF00','ByuDF11','4M20.','4M21.','4M22.','4M23.','B60..','B600.','B6000','B6001','B6002','B6003','B6004','B6005','B6006','B6007','B6008','B600z','B601.','B6010','B6011','B6012','B6013','B6014','B6015','B6016','B6017','B6018','B601z','B602.','B6020','B6021','B6022','B6023','B6024','B6025','B6026','B6027','B6028','B602z','B60y.','B60z.','B620.','B6200','B6201','B6202','B6203','B6204','B6205','B6206','B6207','B6208','B620z','B621.','B6210','B6211','B6212','B6213','B6214','B6215','B6216','B6217','B6218','B621z','B622.','B6220','B6221','B6222','B6223','B6224','B6225','B6226','B6227','B6228','B622z','B627.','B6270','B6271','B6272','B6273','B6274','B6275','B6276','B6277','B6278','B627A','B627B','B627C','B627D','B627E','B627G','B627W','B627X','B628.','B6280','B6281','B6282','B6283','B6284','B6285','B6286','B6287','B62E.','B62E0','B62E1','B62E2','B62E3','B62Ew','B62F.','B62F0','B62F1','B62F2','B62Fy','B62x.','B62x0','B62x1','B62x2','B62x4','B62xX','B62y.','B62y0','B62y1','B62y2','B62y3','B62y4','B62y5','B62y6','B62y7','B62y8','B62yz','B6400','BBg..','BBg1.','BBg10','BBg2.','BBg3.','BBg4.','BBg5.','BBg6.','BBg7.','BBg8.','BBg9.','BBgA.','BBgB.','BBgC.','BBgD.','BBgE.','BBgF.','BBgG.','BBgH.','BBgJ.','BBgK.','BBgL.','BBgM.','BBgN.','BBgP.','BBgQ.','BBgR.','BBgS.','BBgT.','BBgV.','BBgz.','BBh..','BBh0.','BBh1.','BBh2.','BBhz.','BBk..','BBk0.','BBk1.','BBk2.','BBk3.','BBk4.','BBk5.','BBk6.','BBk7.','BBk8.','BBkz.','BBl..','BBl0.','BBl1.','BBlz.','BBm0.','BBm5.','BBm9.','BBmD.','BBmH.','BBv0.','BBv2.','ByuD1','ByuD2','ByuD3','ByuDC','ByuDD','ByuDE','ByuDF')
and EntryDate >= '2015-01-01'
and EntryDate <= '2020-05-29'
group by PatID, EntryDate
 UNION ALL 
-- oesophageal cancer
select PatID, EntryDate from SIR_ALL_Records_Narrow
where ReadCode in ('B10..00','B100.00','B101.00','B102.00','B103.00','B103.99','B104.00','B104.99','B105.00','B105.99','B106.00','B107.00','B10y.00','B10z.00','B10z.11','B10..','B100.','B101.','B102.','B103.','B104.','B105.','B106.','B107.','B10y.','B10z.')
and EntryDate >= '2015-01-01'
and EntryDate <= '2020-05-29'
group by PatID, EntryDate
 UNION ALL 
-- oral cancer
select PatID, EntryDate from SIR_ALL_Records_Narrow
where ReadCode in ('B00..00','B00..11','B00..99','B000.00','B000000','B000100','B000z00','B001.00','B001000','B001100','B001z00','B002.00','B002000','B002100','B002200','B002300','B002z00','B003.00','B003000','B003100','B003200','B003300','B003z00','B004.00','B004000','B004100','B004200','B004300','B004z00','B005.00','B006.00','B007.00','B00y.00','B00z.00','B00z000','B00z100','B00zz00','B01..00','B01..99','B010.00','B010.11','B010000','B010z00','B011.00','B011000','B011100','B011z00','B012.00','B013.00','B013000','B013100','B013z00','B014.00','B015.00','B016.00','B017.00','B01y.00','B01z.00','B03..00','B03..99','B030.00','B031.00','B03y.00','B03z.00','B04..00','B040.00','B041.00','B042.00','B04y.00','B04z.00','B05..00','B050.00','B050.11','B051.00','B051000','B051100','B051200','B051300','B051z00','B052.00','B053.00','B054.00','B055.00','B055000','B055100','B055z00','B056.00','B05y.00','B05z.00','B062100','B062200','B062300','B200300','B550100','B00..','B000.','B0000','B0001','B000z','B001.','B0010','B0011','B001z','B002.','B0020','B0021','B0022','B0023','B002z','B003.','B0030','B0031','B0032','B0033','B003z','B004.','B0040','B0041','B0042','B0043','B004z','B005.','B006.','B007.','B00y.','B00z.','B00z0','B00z1','B00zz','B01..','B010.','B0100','B010z','B011.','B0110','B0111','B011z','B012.','B013.','B0130','B0131','B013z','B014.','B015.','B016.','B017.','B01y.','B01z.','B03..','B030.','B031.','B03y.','B03z.','B04..','B040.','B041.','B042.','B04y.','B04z.','B05..','B050.','B051.','B0510','B0511','B0512','B0513','B051z','B052.','B053.','B054.','B055.','B0550','B0551','B055z','B056.','B05y.','B05z.','B0621','B0622','B0623','B2003','B5501')
and EntryDate >= '2015-01-01'
and EntryDate <= '2020-05-29'
group by PatID, EntryDate
 UNION ALL 
-- ovarian cancer
select PatID, EntryDate from SIR_ALL_Records_Narrow
where ReadCode in ('B440.00','B440.11','BB5j200','BB80.00','BB80100','BB81100','BB81200','BB81400','BB81500','BB81800','BB81B00','BB81D00','BB81E00','BB81E11','BB81H00','BB81J00','BB81K00','BB81M00','BB82.00','BBC1100','BBC4.00','BBC6.00','BBC6100','BBC6111','BBCE.11','BBM0100','BBQ0.00','BBQ4.00','BBQA100','BBQA200','B440.','BB5j2','BB80.','BB801','BB811','BB812','BB814','BB815','BB818','BB81B','BB81D','BB81E','BB81H','BB81J','BB81K','BB81M','BB82.','BBC11','BBC4.','BBC6.','BBC61','BBM01','BBQ0.','BBQ4.','BBQA1','BBQA2')
and EntryDate >= '2015-01-01'
and EntryDate <= '2020-05-29'
group by PatID, EntryDate
 UNION ALL 
-- pancreatic cancer
select PatID, EntryDate from SIR_ALL_Records_Narrow
where ReadCode in ('B161100','B17..00','B170.00','B171.00','B172.00','B173.00','B174.00','B175.00','B17y.00','B17y000','B17yz00','B17z.00','BB5B.00','BB5B100','BB5B300','BB5B311','BB5B500','BB5B511','BB5B600','BB5C.00','BB5C000','BB5C011','BB5C100','BB5C111','BB5Cz00','BBLK.00','B1611','B17..','B170.','B171.','B172.','B173.','B174.','B175.','B17y.','B17y0','B17yz','B17z.','BB5B.','BB5B1','BB5B3','BB5B5','BB5B6','BB5C.','BB5C0','BB5C1','BB5Cz','BBLK.')
and EntryDate >= '2015-01-01'
and EntryDate <= '2020-05-29'
group by PatID, EntryDate
 UNION ALL 
-- prostate cancer
select PatID, EntryDate from SIR_ALL_Records_Narrow
where ReadCode in ('4M00.00','4M01.00','4M02.00','8AD0.00','B46..00','B834000','B834100','4M00.','4M01.','4M02.','8AD0.','B46..','B8340','B8341')
and EntryDate >= '2015-01-01'
and EntryDate <= '2020-05-29'
group by PatID, EntryDate
 UNION ALL 
-- stomach cancer
select PatID, EntryDate from SIR_ALL_Records_Narrow
where ReadCode in ('B11..00','B11..11','B110.00','B110.99','B110000','B110100','B110111','B110z00','B111.00','B111.99','B111000','B111100','B111z00','B112.00','B113.00','B113.99','B114.00','B114.99','B115.00','B115.99','B116.00','B116.99','B117.00','B118.00','B119.00','B11y.00','B11y000','B11y100','B11yz00','B11z.00','BB55.00','BB57.00','BB58.00','B11..','B110.','B1100','B1101','B110z','B111.','B1110','B1111','B111z','B112.','B113.','B114.','B115.','B116.','B117.','B118.','B119.','B11y.','B11y0','B11y1','B11yz','B11z.','BB55.','BB57.','BB58.')
and EntryDate >= '2015-01-01'
and EntryDate <= '2020-05-29'
group by PatID, EntryDate
 UNION ALL 
-- thyroid cancer
select PatID, EntryDate from SIR_ALL_Records_Narrow
where ReadCode in ('B53..00','B53..99','BB5c.00','BB5c200','BB5d.00','BB5d100','BB5f.00','BB5f100','BB5f111','BB5f200','BB5f300','BB5f600','BB5f700','BB9B.11','BB9B.12','BB9C.00','B53..','BB5c.','BB5c2','BB5d.','BB5d1','BB5f.','BB5f1','BB5f2','BB5f3','BB5f6','BB5f7','BB9C.')
and EntryDate >= '2015-01-01'
and EntryDate <= '2020-05-29'
group by PatID, EntryDate
 UNION ALL 
-- uterus cancer
select PatID, EntryDate from SIR_ALL_Records_Narrow
where ReadCode in ('B40..00','B43..00','B43..98','B43..99','B430.00','B430000','B430100','B430200','B430211','B430300','B430z00','B431.00','B431000','B431z00','B432.00','B43y.00','B43z.00','B43z.99','BB5j.00','BBL0.00','BBL5.00','B40..','B43..','B430.','B4300','B4301','B4302','B4303','B430z','B431.','B4310','B431z','B432.','B43y.','B43z.','BB5j.','BBL0.','BBL5.')
and EntryDate >= '2015-01-01'
and EntryDate <= '2020-05-29'
group by PatID, EntryDate
) sub 
group by EntryDate

PRINT 'Date,IncidenceOfCancer,PrevalenceOfCancer'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.EntryDate = d.date
order by date;
