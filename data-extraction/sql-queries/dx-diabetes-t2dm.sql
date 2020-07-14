--Just want the output, not the messages
SET NOCOUNT ON; 

--populate table with all dates from 2009-12-28
IF OBJECT_ID('tempdb..#AllDates') IS NOT NULL DROP TABLE #AllDates;
CREATE TABLE #AllDates ([date] date);
declare @dt datetime = '2009-12-28'
declare @dtEnd datetime = '2020-07-14';
WHILE (@dt <= @dtEnd) BEGIN
    insert into #AllDates([date])
        values(@dt)
    SET @dt = DATEADD(day, 1, @dt)
END;

-- Populate incidence table - only count those occurrences
-- of the code where it is the first time the patient has had it
select FirstDiagnosis, count(*) as num into #Incidence from (
	select NHSNo, min(entrydate) as FirstDiagnosis from journal
	where ReadCode in ('C10D.00','C10F.00','C10F.11','C10FR00','C10FR11','C10FQ00','C10FQ11','C10FP00','C10FP11','C10FN00','C10FN11','C10FM00','C10FM11','C10FL00','C10FL11','C10FK00','C10FK11','C10FJ00','C10FJ11','C10FH00','C10FH11','C10FG00','C10FG11','C10FF00','C10FF11','C10FE00','C10FE11','C10FD00','C10FD11','C10FC00','C10FC11','C10FB00','C10FB11','C10FA00','C10FA11','C10F900','C10F911','C10F700','C10F711','C10F600','C10F611','C10F500','C10F511','C10F400','C10F411','C10F300','C10F311','C10F200','C10F211','C10F100','C10F111','C10F000','C10F011','C109.00','C109.11','C109.12','C109.13','C109K00','C109J00','C109J11','C109J12','C109H00','C109H12','C109H11','C109G00','C109G12','C109G11','C109F00','C109F12','C109F11','C109E00','C109E12','C109E11','C109D00','C109D12','C109D11','C109C00','C109C12','C109C11','C109B00','C109B12','C109B11','C109A00','C109A12','C109A11','C109900','C109912','C109911','C109700','C109712','C109711','C109600','C109612','C109611','C109500','C109512','C109511','C109400','C109412','C109411','C109300','C109312','C109311','C109200','C109212','C109211','C109100','C109112','C109111','C109000','C109012','C109011','C100100','C100112','C101100','C102100','C103100','C104100','C105100','C106100','C107100','C10y100','C10z100','C10D.','C10F.','C10FR','C10FQ','C10FP','C10FN','C10FM','C10FL','C10FK','C10FJ','C10FH','C10FG','C10FF','C10FE','C10FD','C10FC','C10FB','C10FA','C10F9','C10F7','C10F6','C10F5','C10F4','C10F3','C10F2','C10F1','C10F0','C109.','C109K','C109J','C109H','C109G','C109F','C109E','C109D','C109C','C109B','C109A','C1099','C1097','C1096','C1095','C1094','C1093','C1092','C1091','C1090','C1001','C1011','C1021','C1031','C1041','C1051','C1061','C1071','C10y1','C10z1')
	and entrydate <= '2020-07-14'
	group by NHSNo
) sub 
where FirstDiagnosis >= '2009-12-28'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select entrydate, count(*) as num into #Prevalence from (
	select NHSNo, entrydate from journal
	where ReadCode in ('C10D.00','C10F.00','C10F.11','C10FR00','C10FR11','C10FQ00','C10FQ11','C10FP00','C10FP11','C10FN00','C10FN11','C10FM00','C10FM11','C10FL00','C10FL11','C10FK00','C10FK11','C10FJ00','C10FJ11','C10FH00','C10FH11','C10FG00','C10FG11','C10FF00','C10FF11','C10FE00','C10FE11','C10FD00','C10FD11','C10FC00','C10FC11','C10FB00','C10FB11','C10FA00','C10FA11','C10F900','C10F911','C10F700','C10F711','C10F600','C10F611','C10F500','C10F511','C10F400','C10F411','C10F300','C10F311','C10F200','C10F211','C10F100','C10F111','C10F000','C10F011','C109.00','C109.11','C109.12','C109.13','C109K00','C109J00','C109J11','C109J12','C109H00','C109H12','C109H11','C109G00','C109G12','C109G11','C109F00','C109F12','C109F11','C109E00','C109E12','C109E11','C109D00','C109D12','C109D11','C109C00','C109C12','C109C11','C109B00','C109B12','C109B11','C109A00','C109A12','C109A11','C109900','C109912','C109911','C109700','C109712','C109711','C109600','C109612','C109611','C109500','C109512','C109511','C109400','C109412','C109411','C109300','C109312','C109311','C109200','C109212','C109211','C109100','C109112','C109111','C109000','C109012','C109011','C100100','C100112','C101100','C102100','C103100','C104100','C105100','C106100','C107100','C10y100','C10z100','C10D.','C10F.','C10FR','C10FQ','C10FP','C10FN','C10FM','C10FL','C10FK','C10FJ','C10FH','C10FG','C10FF','C10FE','C10FD','C10FC','C10FB','C10FA','C10F9','C10F7','C10F6','C10F5','C10F4','C10F3','C10F2','C10F1','C10F0','C109.','C109K','C109J','C109H','C109G','C109F','C109E','C109D','C109C','C109B','C109A','C1099','C1097','C1096','C1095','C1094','C1093','C1092','C1091','C1090','C1001','C1011','C1021','C1031','C1041','C1051','C1061','C1071','C10y1','C10z1')
	and entrydate >= '2009-12-28'
	and entrydate <= '2020-07-14'
	group by NHSNo, entrydate
) sub 
group by entrydate

PRINT 'Date,IncidenceOfT2dm,PrevalenceOfT2dm'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.entrydate = d.date
order by date;
