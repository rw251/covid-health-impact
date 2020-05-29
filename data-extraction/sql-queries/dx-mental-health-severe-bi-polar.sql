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
	select PatID, min(EntryDate) as FirstDiagnosis from SIR_ALL_Records_Narrow
	where ReadCode in ('E11..99','E110.99','Eu30213','ZRby100','13Y3.00','146D.00','1S42.00','212V.00','46P3.00','6657.00','6657.11','6657.12','665B.00','665J.00','665K.00','9Ol5.00','9Ol6.00','9Ol7.00','E11..00','E11..11','E11..12','E11..13','E110.00','E110.11','E110000','E110100','E110200','E110300','E110400','E110500','E110600','E110z00','E111.00','E111000','E111100','E111200','E111300','E111400','E111500','E111600','E111z00','E114.00','E114.11','E114000','E114100','E114200','E114300','E114400','E114500','E114600','E114z00','E115.00','E115.11','E115000','E115100','E115200','E115300','E115400','E115500','E115600','E115z00','E116.00','E116000','E116100','E116200','E116300','E116400','E116500','E116600','E116z00','E117.00','E117000','E117100','E117200','E117300','E117400','E117500','E117600','E117z00','E11y.00','E11y000','E11y100','E11y200','E11y300','E11yz00','E11z.00','E11z000','E11z100','E11z200','E11zz00','Eu3..00','Eu30.00','Eu30.11','Eu30000','Eu30100','Eu30200','Eu30211','Eu30212','Eu30y00','Eu30z00','Eu30z11','Eu31.00','Eu31.11','Eu31.12','Eu31.13','Eu31000','Eu31100','Eu31200','Eu31300','Eu31400','Eu31500','Eu31600','Eu31700','Eu31800','Eu31900','Eu31911','Eu31y00','Eu31y11','Eu31y12','Eu31z00','Eu33213','Eu33312','Eu34.00','Eu34000','Eu34011','Eu34012','Eu34013','Eu34y00','Eu34z00','Eu3y.00','Eu3y000','Eu3y011','Eu3y100','Eu3yy00','Eu3z.00','Eu3z.11','ZV11111','ZV11112','ZRby1','13Y3.','146D.','1S42.','212V.','46P3.','6657.','665B.','665J.','665K.','9Ol5.','9Ol6.','9Ol7.','E11..','E110.','E1100','E1101','E1102','E1103','E1104','E1105','E1106','E110z','E111.','E1110','E1111','E1112','E1113','E1114','E1115','E1116','E111z','E114.','E1140','E1141','E1142','E1143','E1144','E1145','E1146','E114z','E115.','E1150','E1151','E1152','E1153','E1154','E1155','E1156','E115z','E116.','E1160','E1161','E1162','E1163','E1164','E1165','E1166','E116z','E117.','E1170','E1171','E1172','E1173','E1174','E1175','E1176','E117z','E11y.','E11y0','E11y1','E11y2','E11y3','E11yz','E11z.','E11z0','E11z1','E11z2','E11zz','Eu3..','Eu30.','Eu300','Eu301','Eu302','Eu30y','Eu30z','Eu31.','Eu310','Eu311','Eu312','Eu313','Eu314','Eu315','Eu316','Eu317','Eu318','Eu319','Eu31y','Eu31z','Eu34.','Eu340','Eu34y','Eu34z','Eu3y.','Eu3y0','Eu3y1','Eu3yy','Eu3z.')
	and EntryDate <= '2020-05-29'
	group by PatID
) sub 
where FirstDiagnosis >= '2015-01-01'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select EntryDate, count(*) as num into #Prevalence from (
	select PatID, EntryDate from SIR_ALL_Records_Narrow
	where ReadCode in ('E11..99','E110.99','Eu30213','ZRby100','13Y3.00','146D.00','1S42.00','212V.00','46P3.00','6657.00','6657.11','6657.12','665B.00','665J.00','665K.00','9Ol5.00','9Ol6.00','9Ol7.00','E11..00','E11..11','E11..12','E11..13','E110.00','E110.11','E110000','E110100','E110200','E110300','E110400','E110500','E110600','E110z00','E111.00','E111000','E111100','E111200','E111300','E111400','E111500','E111600','E111z00','E114.00','E114.11','E114000','E114100','E114200','E114300','E114400','E114500','E114600','E114z00','E115.00','E115.11','E115000','E115100','E115200','E115300','E115400','E115500','E115600','E115z00','E116.00','E116000','E116100','E116200','E116300','E116400','E116500','E116600','E116z00','E117.00','E117000','E117100','E117200','E117300','E117400','E117500','E117600','E117z00','E11y.00','E11y000','E11y100','E11y200','E11y300','E11yz00','E11z.00','E11z000','E11z100','E11z200','E11zz00','Eu3..00','Eu30.00','Eu30.11','Eu30000','Eu30100','Eu30200','Eu30211','Eu30212','Eu30y00','Eu30z00','Eu30z11','Eu31.00','Eu31.11','Eu31.12','Eu31.13','Eu31000','Eu31100','Eu31200','Eu31300','Eu31400','Eu31500','Eu31600','Eu31700','Eu31800','Eu31900','Eu31911','Eu31y00','Eu31y11','Eu31y12','Eu31z00','Eu33213','Eu33312','Eu34.00','Eu34000','Eu34011','Eu34012','Eu34013','Eu34y00','Eu34z00','Eu3y.00','Eu3y000','Eu3y011','Eu3y100','Eu3yy00','Eu3z.00','Eu3z.11','ZV11111','ZV11112','ZRby1','13Y3.','146D.','1S42.','212V.','46P3.','6657.','665B.','665J.','665K.','9Ol5.','9Ol6.','9Ol7.','E11..','E110.','E1100','E1101','E1102','E1103','E1104','E1105','E1106','E110z','E111.','E1110','E1111','E1112','E1113','E1114','E1115','E1116','E111z','E114.','E1140','E1141','E1142','E1143','E1144','E1145','E1146','E114z','E115.','E1150','E1151','E1152','E1153','E1154','E1155','E1156','E115z','E116.','E1160','E1161','E1162','E1163','E1164','E1165','E1166','E116z','E117.','E1170','E1171','E1172','E1173','E1174','E1175','E1176','E117z','E11y.','E11y0','E11y1','E11y2','E11y3','E11yz','E11z.','E11z0','E11z1','E11z2','E11zz','Eu3..','Eu30.','Eu300','Eu301','Eu302','Eu30y','Eu30z','Eu31.','Eu310','Eu311','Eu312','Eu313','Eu314','Eu315','Eu316','Eu317','Eu318','Eu319','Eu31y','Eu31z','Eu34.','Eu340','Eu34y','Eu34z','Eu3y.','Eu3y0','Eu3y1','Eu3yy','Eu3z.')
	and EntryDate >= '2015-01-01'
	and EntryDate <= '2020-05-29'
	group by PatID, EntryDate
) sub 
group by EntryDate

PRINT 'Date,IncidenceOfBiPolar,PrevalenceOfBiPolar'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.EntryDate = d.date
order by date;
