--Just want the output, not the messages
SET NOCOUNT ON; 

--populate table with all dates from 2015-01-01
IF OBJECT_ID('tempdb..#AllDates') IS NOT NULL DROP TABLE #AllDates;
CREATE TABLE #AllDates ([date] date);
declare @dt datetime = '2015-01-01'
declare @dtEnd datetime = '2020-06-02';
WHILE (@dt <= @dtEnd) BEGIN
    insert into #AllDates([date])
        values(@dt)
    SET @dt = DATEADD(day, 1, @dt)
END;

-- Populate incidence table - only count those occurrences
-- of the code where it is the first time the patient has had it
select FirstDiagnosis, count(*) as num into #Incidence from (
	select NHSNo, min(entrydate) as FirstDiagnosis from journal
	where ReadCode in ('4M71.00','4M72.00','4M73.00','4M74.00','B32..00','B320.00','B321.00','B322.00','B322000','B322100','B322z00','B323.00','B323000','B323100','B323200','B323300','B323400','B323500','B323z00','B324.00','B324000','B324100','B324z00','B325.00','B325000','B325100','B325200','B325300','B325400','B325500','B325600','B325700','B325800','B325z00','B326.00','B326000','B326100','B326200','B326300','B326400','B326500','B326z00','B327.00','B327000','B327100','B327200','B327300','B327400','B327500','B327600','B327700','B327800','B327900','B327z00','B328.00','B329.00','B32A.00','B32B.00','B32C.00','B32D.00','B32E.00','B32F.00','B32G.00','B32H.00','B32J.00','B32y.00','B32y000','B32z.00','B509.00','BBE1.00','BBE1.11','BBE1.13','BBE1.14','BBE1000','BBE1100','BBE2.00','BBE4.00','BBEA.00','BBEC.00','BBEE.00','BBEG.00','BBEG.11','BBEG000','BBEH.00','BBEM.00','BBEP.00','BBEQ.00','BBEV.00','Byu4.00','Byu4000','Byu4100','4M71.','4M72.','4M73.','4M74.','B32..','B320.','B321.','B322.','B3220','B3221','B322z','B323.','B3230','B3231','B3232','B3233','B3234','B3235','B323z','B324.','B3240','B3241','B324z','B325.','B3250','B3251','B3252','B3253','B3254','B3255','B3256','B3257','B3258','B325z','B326.','B3260','B3261','B3262','B3263','B3264','B3265','B326z','B327.','B3270','B3271','B3272','B3273','B3274','B3275','B3276','B3277','B3278','B3279','B327z','B328.','B329.','B32A.','B32B.','B32C.','B32D.','B32E.','B32F.','B32G.','B32H.','B32J.','B32y.','B32y0','B32z.','B509.','BBE1.','BBE10','BBE11','BBE2.','BBE4.','BBEA.','BBEC.','BBEE.','BBEG.','BBEG0','BBEH.','BBEM.','BBEP.','BBEQ.','BBEV.','Byu4.','Byu40','Byu41')
	and entrydate <= '2020-06-02'
	group by NHSNo
) sub 
where FirstDiagnosis >= '2015-01-01'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select entrydate, count(*) as num into #Prevalence from (
	select NHSNo, entrydate from journal
	where ReadCode in ('4M71.00','4M72.00','4M73.00','4M74.00','B32..00','B320.00','B321.00','B322.00','B322000','B322100','B322z00','B323.00','B323000','B323100','B323200','B323300','B323400','B323500','B323z00','B324.00','B324000','B324100','B324z00','B325.00','B325000','B325100','B325200','B325300','B325400','B325500','B325600','B325700','B325800','B325z00','B326.00','B326000','B326100','B326200','B326300','B326400','B326500','B326z00','B327.00','B327000','B327100','B327200','B327300','B327400','B327500','B327600','B327700','B327800','B327900','B327z00','B328.00','B329.00','B32A.00','B32B.00','B32C.00','B32D.00','B32E.00','B32F.00','B32G.00','B32H.00','B32J.00','B32y.00','B32y000','B32z.00','B509.00','BBE1.00','BBE1.11','BBE1.13','BBE1.14','BBE1000','BBE1100','BBE2.00','BBE4.00','BBEA.00','BBEC.00','BBEE.00','BBEG.00','BBEG.11','BBEG000','BBEH.00','BBEM.00','BBEP.00','BBEQ.00','BBEV.00','Byu4.00','Byu4000','Byu4100','4M71.','4M72.','4M73.','4M74.','B32..','B320.','B321.','B322.','B3220','B3221','B322z','B323.','B3230','B3231','B3232','B3233','B3234','B3235','B323z','B324.','B3240','B3241','B324z','B325.','B3250','B3251','B3252','B3253','B3254','B3255','B3256','B3257','B3258','B325z','B326.','B3260','B3261','B3262','B3263','B3264','B3265','B326z','B327.','B3270','B3271','B3272','B3273','B3274','B3275','B3276','B3277','B3278','B3279','B327z','B328.','B329.','B32A.','B32B.','B32C.','B32D.','B32E.','B32F.','B32G.','B32H.','B32J.','B32y.','B32y0','B32z.','B509.','BBE1.','BBE10','BBE11','BBE2.','BBE4.','BBEA.','BBEC.','BBEE.','BBEG.','BBEG0','BBEH.','BBEM.','BBEP.','BBEQ.','BBEV.','Byu4.','Byu40','Byu41')
	and entrydate >= '2015-01-01'
	and entrydate <= '2020-06-02'
	group by NHSNo, entrydate
) sub 
group by entrydate

PRINT 'Date,IncidenceOfMelanoma,PrevalenceOfMelanoma'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.entrydate = d.date
order by date;
