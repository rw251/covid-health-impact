--Just want the output, not the messages
SET NOCOUNT ON; 

--populate table with all dates from 2009-12-28
IF OBJECT_ID('tempdb..#AllDates') IS NOT NULL DROP TABLE #AllDates;
CREATE TABLE #AllDates ([date] date);
declare @dt datetime = '2009-12-28'
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
	where ReadCode in ('G3...00','G3...12','G3...13','G3...11','G3z..00','G3y..00','G39..00','G38..00','G38z.00','G384.00','G383.00','G382.00','G381.00','G380.00','G35..00','G35X.00','G353.00','G351.00','G350.00','G34..00','G34z.00','G34z000','G34y.00','G34yz00','G34y100','G34y000','G344.00','G343.00','G342.00','G340.00','G340.11','G340.12','G340100','G340000','G33..00','G33z.00','G33zz00','G33z700','G33z600','G33z500','G33z400','G33z300','G33z200','G33z100','G33z000','G330.00','G330z00','G330000','G32..00','G32..11','G31..00','G31y.00','G31yz00','G31y300','G31y200','G31y100','G31y000','G312.00','G311.00','G311.11','G311.12','G311.13','G311.14','G311z00','G311500','G311400','G311300','G311200','G311100','G311000','G311011','G30..00','G30..11','G30..12','G30..13','G30..14','G30..15','G30..16','G30..17','G30z.00','G30y.00','G30yz00','G30y200','G30y100','G30y000','G30X.00','G30X000','G30B.00','G309.00','G308.00','G307.00','G307100','G307000','G306.00','G305.00','G304.00','G303.00','G302.00','G301.00','G301z00','G301100','G301000','G300.00','Gyu3.00','Gyu3300','Gyu3200','Gyu3000','Gyu3600','Gyu3500','Gyu3400','G3...','G3z..','G3y..','G39..','G38..','G38z.','G384.','G383.','G382.','G381.','G380.','G35..','G35X.','G353.','G351.','G350.','G34..','G34z.','G34z0','G34y.','G34yz','G34y1','G34y0','G344.','G343.','G342.','G340.','G3401','G3400','G33..','G33z.','G33zz','G33z7','G33z6','G33z5','G33z4','G33z3','G33z2','G33z1','G33z0','G330.','G330z','G3300','G32..','G31..','G31y.','G31yz','G31y3','G31y2','G31y1','G31y0','G312.','G311.','G311z','G3115','G3114','G3113','G3112','G3111','G3110','G30..','G30z.','G30y.','G30yz','G30y2','G30y1','G30y0','G30X.','G30X0','G30B.','G309.','G308.','G307.','G3071','G3070','G306.','G305.','G304.','G303.','G302.','G301.','G301z','G3011','G3010','G300.','Gyu3.','Gyu33','Gyu32','Gyu30','Gyu36','Gyu35','Gyu34')
	and entrydate <= '2020-06-05'
	group by NHSNo
) sub 
where FirstDiagnosis >= '2009-12-28'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select entrydate, count(*) as num into #Prevalence from (
	select NHSNo, entrydate from journal
	where ReadCode in ('G3...00','G3...12','G3...13','G3...11','G3z..00','G3y..00','G39..00','G38..00','G38z.00','G384.00','G383.00','G382.00','G381.00','G380.00','G35..00','G35X.00','G353.00','G351.00','G350.00','G34..00','G34z.00','G34z000','G34y.00','G34yz00','G34y100','G34y000','G344.00','G343.00','G342.00','G340.00','G340.11','G340.12','G340100','G340000','G33..00','G33z.00','G33zz00','G33z700','G33z600','G33z500','G33z400','G33z300','G33z200','G33z100','G33z000','G330.00','G330z00','G330000','G32..00','G32..11','G31..00','G31y.00','G31yz00','G31y300','G31y200','G31y100','G31y000','G312.00','G311.00','G311.11','G311.12','G311.13','G311.14','G311z00','G311500','G311400','G311300','G311200','G311100','G311000','G311011','G30..00','G30..11','G30..12','G30..13','G30..14','G30..15','G30..16','G30..17','G30z.00','G30y.00','G30yz00','G30y200','G30y100','G30y000','G30X.00','G30X000','G30B.00','G309.00','G308.00','G307.00','G307100','G307000','G306.00','G305.00','G304.00','G303.00','G302.00','G301.00','G301z00','G301100','G301000','G300.00','Gyu3.00','Gyu3300','Gyu3200','Gyu3000','Gyu3600','Gyu3500','Gyu3400','G3...','G3z..','G3y..','G39..','G38..','G38z.','G384.','G383.','G382.','G381.','G380.','G35..','G35X.','G353.','G351.','G350.','G34..','G34z.','G34z0','G34y.','G34yz','G34y1','G34y0','G344.','G343.','G342.','G340.','G3401','G3400','G33..','G33z.','G33zz','G33z7','G33z6','G33z5','G33z4','G33z3','G33z2','G33z1','G33z0','G330.','G330z','G3300','G32..','G31..','G31y.','G31yz','G31y3','G31y2','G31y1','G31y0','G312.','G311.','G311z','G3115','G3114','G3113','G3112','G3111','G3110','G30..','G30z.','G30y.','G30yz','G30y2','G30y1','G30y0','G30X.','G30X0','G30B.','G309.','G308.','G307.','G3071','G3070','G306.','G305.','G304.','G303.','G302.','G301.','G301z','G3011','G3010','G300.','Gyu3.','Gyu33','Gyu32','Gyu30','Gyu36','Gyu35','Gyu34')
	and entrydate >= '2009-12-28'
	and entrydate <= '2020-06-05'
	group by NHSNo, entrydate
) sub 
group by entrydate

PRINT 'Date,IncidenceOfCoronaryHeartDisease,PrevalenceOfCoronaryHeartDisease'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.entrydate = d.date
order by date;
