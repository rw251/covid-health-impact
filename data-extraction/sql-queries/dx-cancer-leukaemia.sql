--Just want the output, not the messages
SET NOCOUNT ON; 

--populate table with all dates from 2009-12-29
IF OBJECT_ID('tempdb..#AllDates') IS NOT NULL DROP TABLE #AllDates;
CREATE TABLE #AllDates ([date] date);
declare @dt datetime = '2009-12-29'
declare @dtEnd datetime = '2020-06-05';
WHILE (@dt <= @dtEnd) BEGIN
    insert into #AllDates([date])
        values(@dt)
    SET @dt = DATEADD(day, 1, @dt)
END;

-- Populate incidence table - only count those occurrences
-- of the code where it is the first time the patient has had it
select FirstDiagnosis, count(*) as num into #Incidence from (
	select NHSNo, min(entrydate) as FirstDiagnosis from journal
	where ReadCode in ('B624.00','B624.11','B624.12','B624000','B624100','B624200','B624300','B624400','B624500','B624600','B624700','B624800','B624z00','B64..00','B64..11','B640.00','B640.99','B641.00','B641.11','B641.99','B641000','B641011','B641100','B641200','B641300','B642.00','B642.99','B64y.00','B64y000','B64y100','B64y200','B64y300','B64y311','B64y400','B64y411','B64y500','B64yz00','B64z.00','B65..00','B650.00','B650.99','B650000','B650100','B651.00','B651.11','B651.99','B651000','B651100','B651200','B651300','B651z00','B652.00','B652.99','B653.00','B653000','B653100','B653z00','B654.00','B65y.00','B65y000','B65y100','B65yz00','B65z.00','B66..00','B66..11','B66..12','B660.00','B660.99','B661.00','B661.99','B662.00','B662.99','B663.00','B66y.00','B66y000','B66yz00','B66z.00','B67..00','B67..98','B67..99','B670.00','B670.11','B671.00','B672.00','B672.11','B673.00','B674.00','B675.00','B675.11','B676.00','B677.00','B67y.00','B67y000','B67yz00','B67z.00','B67z.99','B68..00','B68..99','B680.00','B680.99','B681.00','B681.99','B682.00','B682.99','B68y.00','B68z.00','B68z.99','B69..00','B690.00','B691.00','B692.00','B693.00','B6y1.11','B6y1.12','BBr..00','BBr0.00','BBr0000','BBr0100','BBr0111','BBr0112','BBr0113','BBr0200','BBr0300','BBr0400','BBr0z00','BBr1.00','BBr1000','BBr1011','BBr1z00','BBr2.00','BBr2000','BBr2011','BBr2100','BBr2200','BBr2300','BBr2400','BBr2500','BBr2600','BBr2700','BBr2z00','BBr4.00','BBr4000','BBr4011','BBr4111','BBr4200','BBr4z00','BBr5.00','BBr5000','BBr5z00','BBr6.00','BBr6000','BBr6011','BBr6012','BBr6100','BBr6200','BBr6300','BBr6311','BBr6400','BBr6500','BBr6600','BBr6700','BBr6800','BBr6900','BBr6z00','BBr7.00','BBr7000','BBr7z00','BBr8.00','BBr8000','BBr8z00','BBr9.00','BBr9000','BBr9011','BBr9012','BBr9100','BBr9200','BBr9300','BBr9400','BBr9z00','BBrA.00','BBrA000','BBrA100','BBrA111','BBrA200','BBrA300','BBrA311','BBrA312','BBrA400','BBrA411','BBrA500','BBrA600','BBrA700','BBrA800','BBrAz00','BBrz.00','BBs..00','BBs1.00','ByuD500','ByuD600','ByuD700','ByuD800','ByuD900','B624.','B6240','B6241','B6242','B6243','B6244','B6245','B6246','B6247','B6248','B624z','B64..','B640.','B641.','B6410','B6411','B6412','B6413','B642.','B64y.','B64y0','B64y1','B64y2','B64y3','B64y4','B64y5','B64yz','B64z.','B65..','B650.','B6500','B6501','B651.','B6510','B6511','B6512','B6513','B651z','B652.','B653.','B6530','B6531','B653z','B654.','B65y.','B65y0','B65y1','B65yz','B65z.','B66..','B660.','B661.','B662.','B663.','B66y.','B66y0','B66yz','B66z.','B67..','B670.','B671.','B672.','B673.','B674.','B675.','B676.','B677.','B67y.','B67y0','B67yz','B67z.','B68..','B680.','B681.','B682.','B68y.','B68z.','B69..','B690.','B691.','B692.','B693.','BBr..','BBr0.','BBr00','BBr01','BBr02','BBr03','BBr04','BBr0z','BBr1.','BBr10','BBr1z','BBr2.','BBr20','BBr21','BBr22','BBr23','BBr24','BBr25','BBr26','BBr27','BBr2z','BBr4.','BBr40','BBr42','BBr4z','BBr5.','BBr50','BBr5z','BBr6.','BBr60','BBr61','BBr62','BBr63','BBr64','BBr65','BBr66','BBr67','BBr68','BBr69','BBr6z','BBr7.','BBr70','BBr7z','BBr8.','BBr80','BBr8z','BBr9.','BBr90','BBr91','BBr92','BBr93','BBr94','BBr9z','BBrA.','BBrA0','BBrA1','BBrA2','BBrA3','BBrA4','BBrA5','BBrA6','BBrA7','BBrA8','BBrAz','BBrz.','BBs..','BBs1.','ByuD5','ByuD6','ByuD7','ByuD8','ByuD9')
	and entrydate <= '2020-06-05'
	group by NHSNo
) sub 
where FirstDiagnosis >= '2009-12-29'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select entrydate, count(*) as num into #Prevalence from (
	select NHSNo, entrydate from journal
	where ReadCode in ('B624.00','B624.11','B624.12','B624000','B624100','B624200','B624300','B624400','B624500','B624600','B624700','B624800','B624z00','B64..00','B64..11','B640.00','B640.99','B641.00','B641.11','B641.99','B641000','B641011','B641100','B641200','B641300','B642.00','B642.99','B64y.00','B64y000','B64y100','B64y200','B64y300','B64y311','B64y400','B64y411','B64y500','B64yz00','B64z.00','B65..00','B650.00','B650.99','B650000','B650100','B651.00','B651.11','B651.99','B651000','B651100','B651200','B651300','B651z00','B652.00','B652.99','B653.00','B653000','B653100','B653z00','B654.00','B65y.00','B65y000','B65y100','B65yz00','B65z.00','B66..00','B66..11','B66..12','B660.00','B660.99','B661.00','B661.99','B662.00','B662.99','B663.00','B66y.00','B66y000','B66yz00','B66z.00','B67..00','B67..98','B67..99','B670.00','B670.11','B671.00','B672.00','B672.11','B673.00','B674.00','B675.00','B675.11','B676.00','B677.00','B67y.00','B67y000','B67yz00','B67z.00','B67z.99','B68..00','B68..99','B680.00','B680.99','B681.00','B681.99','B682.00','B682.99','B68y.00','B68z.00','B68z.99','B69..00','B690.00','B691.00','B692.00','B693.00','B6y1.11','B6y1.12','BBr..00','BBr0.00','BBr0000','BBr0100','BBr0111','BBr0112','BBr0113','BBr0200','BBr0300','BBr0400','BBr0z00','BBr1.00','BBr1000','BBr1011','BBr1z00','BBr2.00','BBr2000','BBr2011','BBr2100','BBr2200','BBr2300','BBr2400','BBr2500','BBr2600','BBr2700','BBr2z00','BBr4.00','BBr4000','BBr4011','BBr4111','BBr4200','BBr4z00','BBr5.00','BBr5000','BBr5z00','BBr6.00','BBr6000','BBr6011','BBr6012','BBr6100','BBr6200','BBr6300','BBr6311','BBr6400','BBr6500','BBr6600','BBr6700','BBr6800','BBr6900','BBr6z00','BBr7.00','BBr7000','BBr7z00','BBr8.00','BBr8000','BBr8z00','BBr9.00','BBr9000','BBr9011','BBr9012','BBr9100','BBr9200','BBr9300','BBr9400','BBr9z00','BBrA.00','BBrA000','BBrA100','BBrA111','BBrA200','BBrA300','BBrA311','BBrA312','BBrA400','BBrA411','BBrA500','BBrA600','BBrA700','BBrA800','BBrAz00','BBrz.00','BBs..00','BBs1.00','ByuD500','ByuD600','ByuD700','ByuD800','ByuD900','B624.','B6240','B6241','B6242','B6243','B6244','B6245','B6246','B6247','B6248','B624z','B64..','B640.','B641.','B6410','B6411','B6412','B6413','B642.','B64y.','B64y0','B64y1','B64y2','B64y3','B64y4','B64y5','B64yz','B64z.','B65..','B650.','B6500','B6501','B651.','B6510','B6511','B6512','B6513','B651z','B652.','B653.','B6530','B6531','B653z','B654.','B65y.','B65y0','B65y1','B65yz','B65z.','B66..','B660.','B661.','B662.','B663.','B66y.','B66y0','B66yz','B66z.','B67..','B670.','B671.','B672.','B673.','B674.','B675.','B676.','B677.','B67y.','B67y0','B67yz','B67z.','B68..','B680.','B681.','B682.','B68y.','B68z.','B69..','B690.','B691.','B692.','B693.','BBr..','BBr0.','BBr00','BBr01','BBr02','BBr03','BBr04','BBr0z','BBr1.','BBr10','BBr1z','BBr2.','BBr20','BBr21','BBr22','BBr23','BBr24','BBr25','BBr26','BBr27','BBr2z','BBr4.','BBr40','BBr42','BBr4z','BBr5.','BBr50','BBr5z','BBr6.','BBr60','BBr61','BBr62','BBr63','BBr64','BBr65','BBr66','BBr67','BBr68','BBr69','BBr6z','BBr7.','BBr70','BBr7z','BBr8.','BBr80','BBr8z','BBr9.','BBr90','BBr91','BBr92','BBr93','BBr94','BBr9z','BBrA.','BBrA0','BBrA1','BBrA2','BBrA3','BBrA4','BBrA5','BBrA6','BBrA7','BBrA8','BBrAz','BBrz.','BBs..','BBs1.','ByuD5','ByuD6','ByuD7','ByuD8','ByuD9')
	and entrydate >= '2009-12-29'
	and entrydate <= '2020-06-05'
	group by NHSNo, entrydate
) sub 
group by entrydate

PRINT 'Date,IncidenceOfLeukaemia,PrevalenceOfLeukaemia'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.entrydate = d.date
order by date;
