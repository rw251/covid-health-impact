-- Template for the groups of conditions
-- E.g. all malignant cancers, or all cvd

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
	-- atrial fibrillation
select NHSNo, min(EntryDate) as FirstDiagnosis from journal
where ReadCode in ('G573.00','G573z00','G573700','G573500','G573400','G573300','G573200','G573000','G573900','G573800','G573600','G573100','G573.','G573z','G5737','G5735','G5734','G5733','G5732','G5730','G5739','G5738','G5736','G5731')
and EntryDate <= '2020-06-05'
group by NHSNo
 UNION ALL 
-- coronary heart disease
select NHSNo, min(EntryDate) as FirstDiagnosis from journal
where ReadCode in ('G3...00','G3...12','G3...13','G3...11','G3z..00','G3y..00','G39..00','G38..00','G38z.00','G384.00','G383.00','G382.00','G381.00','G380.00','G35..00','G35X.00','G353.00','G351.00','G350.00','G34..00','G34z.00','G34z000','G34y.00','G34yz00','G34y100','G34y000','G344.00','G343.00','G342.00','G340.00','G340.11','G340.12','G340100','G340000','G33..00','G33z.00','G33zz00','G33z700','G33z600','G33z500','G33z400','G33z300','G33z200','G33z100','G33z000','G330.00','G330z00','G330000','G32..00','G32..11','G31..00','G31y.00','G31yz00','G31y300','G31y200','G31y100','G31y000','G312.00','G311.00','G311.11','G311.12','G311.13','G311.14','G311z00','G311500','G311400','G311300','G311200','G311100','G311000','G311011','G30..00','G30..11','G30..12','G30..13','G30..14','G30..15','G30..16','G30..17','G30z.00','G30y.00','G30yz00','G30y200','G30y100','G30y000','G30X.00','G30X000','G30B.00','G309.00','G308.00','G307.00','G307100','G307000','G306.00','G305.00','G304.00','G303.00','G302.00','G301.00','G301z00','G301100','G301000','G300.00','Gyu3.00','Gyu3300','Gyu3200','Gyu3000','Gyu3600','Gyu3500','Gyu3400','G3...','G3z..','G3y..','G39..','G38..','G38z.','G384.','G383.','G382.','G381.','G380.','G35..','G35X.','G353.','G351.','G350.','G34..','G34z.','G34z0','G34y.','G34yz','G34y1','G34y0','G344.','G343.','G342.','G340.','G3401','G3400','G33..','G33z.','G33zz','G33z7','G33z6','G33z5','G33z4','G33z3','G33z2','G33z1','G33z0','G330.','G330z','G3300','G32..','G31..','G31y.','G31yz','G31y3','G31y2','G31y1','G31y0','G312.','G311.','G311z','G3115','G3114','G3113','G3112','G3111','G3110','G30..','G30z.','G30y.','G30yz','G30y2','G30y1','G30y0','G30X.','G30X0','G30B.','G309.','G308.','G307.','G3071','G3070','G306.','G305.','G304.','G303.','G302.','G301.','G301z','G3011','G3010','G300.','Gyu3.','Gyu33','Gyu32','Gyu30','Gyu36','Gyu35','Gyu34')
and EntryDate <= '2020-06-05'
group by NHSNo
 UNION ALL 
-- heart failure
select NHSNo, min(EntryDate) as FirstDiagnosis from journal
where ReadCode in ('G58..11','G58..00','G583.00','G583.11','G583.12','G582.00','G58z.11','G58z.12','G58z.00','G584.00','G580.00','G580.11','G580.12','G580.14','G580.13','G580400','G580300','G580200','G580100','G580000','G581.13','G581.00','G581000','662i.00','662h.00','662g.00','662f.00','G1yz100','1O1..00','33BA.00','G58..','G583.','G582.','G58z.','G584.','G580.','G5804','G5803','G5802','G5801','G5800','G581.','G5810','662i.','662h.','662g.','662f.','G1yz1','1O1..','33BA.')
and EntryDate <= '2020-06-05'
group by NHSNo
 UNION ALL 
-- hypertension
select NHSNo, min(EntryDate) as FirstDiagnosis from journal
where ReadCode in ('G2...00','G2...11','G2z..00','G2y..00','G28..00','G26..00','G26..11','G25..00','G25..11','G251.00','G250.00','G24..00','G24z.00','G24zz00','G24z000','G244.00','G241.00','G241z00','G241000','G240.00','G240z00','G240000','G20..11','G20..00','G20..12','G20z.00','G20z.11','G203.00','G202.00','G201.00','G200.00','Gyu2.00','Gyu2100','Gyu2000','G2...','G2z..','G2y..','G28..','G26..','G25..','G251.','G250.','G24..','G24z.','G24zz','G24z0','G244.','G241.','G241z','G2410','G240.','G240z','G2400','G20..','G20z.','G203.','G202.','G201.','G200.','Gyu2.','Gyu21','Gyu20')
and EntryDate <= '2020-06-05'
group by NHSNo
 UNION ALL 
-- peripheral arterial disease
select NHSNo, min(EntryDate) as FirstDiagnosis from journal
where ReadCode in ('G73..12','G73..13','G73..00','G73..11','G73z.00','G73zz00','G73z000','G73z011','G73z012','G73y.00','G73yz00','G734.00','Gyu7400','G73..','G73z.','G73zz','G73z0','G73y.','G73yz','G734.','Gyu74')
and EntryDate <= '2020-06-05'
group by NHSNo
) sub 
where FirstDiagnosis >= '2009-12-29'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select EntryDate, count(*) as num into #Prevalence from (
	-- atrial fibrillation
select NHSNo, EntryDate from journal
where ReadCode in ('G573.00','G573z00','G573700','G573500','G573400','G573300','G573200','G573000','G573900','G573800','G573600','G573100','G573.','G573z','G5737','G5735','G5734','G5733','G5732','G5730','G5739','G5738','G5736','G5731')
and EntryDate >= '2009-12-29'
and EntryDate <= '2020-06-05'
group by NHSNo, EntryDate
 UNION ALL 
-- coronary heart disease
select NHSNo, EntryDate from journal
where ReadCode in ('G3...00','G3...12','G3...13','G3...11','G3z..00','G3y..00','G39..00','G38..00','G38z.00','G384.00','G383.00','G382.00','G381.00','G380.00','G35..00','G35X.00','G353.00','G351.00','G350.00','G34..00','G34z.00','G34z000','G34y.00','G34yz00','G34y100','G34y000','G344.00','G343.00','G342.00','G340.00','G340.11','G340.12','G340100','G340000','G33..00','G33z.00','G33zz00','G33z700','G33z600','G33z500','G33z400','G33z300','G33z200','G33z100','G33z000','G330.00','G330z00','G330000','G32..00','G32..11','G31..00','G31y.00','G31yz00','G31y300','G31y200','G31y100','G31y000','G312.00','G311.00','G311.11','G311.12','G311.13','G311.14','G311z00','G311500','G311400','G311300','G311200','G311100','G311000','G311011','G30..00','G30..11','G30..12','G30..13','G30..14','G30..15','G30..16','G30..17','G30z.00','G30y.00','G30yz00','G30y200','G30y100','G30y000','G30X.00','G30X000','G30B.00','G309.00','G308.00','G307.00','G307100','G307000','G306.00','G305.00','G304.00','G303.00','G302.00','G301.00','G301z00','G301100','G301000','G300.00','Gyu3.00','Gyu3300','Gyu3200','Gyu3000','Gyu3600','Gyu3500','Gyu3400','G3...','G3z..','G3y..','G39..','G38..','G38z.','G384.','G383.','G382.','G381.','G380.','G35..','G35X.','G353.','G351.','G350.','G34..','G34z.','G34z0','G34y.','G34yz','G34y1','G34y0','G344.','G343.','G342.','G340.','G3401','G3400','G33..','G33z.','G33zz','G33z7','G33z6','G33z5','G33z4','G33z3','G33z2','G33z1','G33z0','G330.','G330z','G3300','G32..','G31..','G31y.','G31yz','G31y3','G31y2','G31y1','G31y0','G312.','G311.','G311z','G3115','G3114','G3113','G3112','G3111','G3110','G30..','G30z.','G30y.','G30yz','G30y2','G30y1','G30y0','G30X.','G30X0','G30B.','G309.','G308.','G307.','G3071','G3070','G306.','G305.','G304.','G303.','G302.','G301.','G301z','G3011','G3010','G300.','Gyu3.','Gyu33','Gyu32','Gyu30','Gyu36','Gyu35','Gyu34')
and EntryDate >= '2009-12-29'
and EntryDate <= '2020-06-05'
group by NHSNo, EntryDate
 UNION ALL 
-- heart failure
select NHSNo, EntryDate from journal
where ReadCode in ('G58..11','G58..00','G583.00','G583.11','G583.12','G582.00','G58z.11','G58z.12','G58z.00','G584.00','G580.00','G580.11','G580.12','G580.14','G580.13','G580400','G580300','G580200','G580100','G580000','G581.13','G581.00','G581000','662i.00','662h.00','662g.00','662f.00','G1yz100','1O1..00','33BA.00','G58..','G583.','G582.','G58z.','G584.','G580.','G5804','G5803','G5802','G5801','G5800','G581.','G5810','662i.','662h.','662g.','662f.','G1yz1','1O1..','33BA.')
and EntryDate >= '2009-12-29'
and EntryDate <= '2020-06-05'
group by NHSNo, EntryDate
 UNION ALL 
-- hypertension
select NHSNo, EntryDate from journal
where ReadCode in ('G2...00','G2...11','G2z..00','G2y..00','G28..00','G26..00','G26..11','G25..00','G25..11','G251.00','G250.00','G24..00','G24z.00','G24zz00','G24z000','G244.00','G241.00','G241z00','G241000','G240.00','G240z00','G240000','G20..11','G20..00','G20..12','G20z.00','G20z.11','G203.00','G202.00','G201.00','G200.00','Gyu2.00','Gyu2100','Gyu2000','G2...','G2z..','G2y..','G28..','G26..','G25..','G251.','G250.','G24..','G24z.','G24zz','G24z0','G244.','G241.','G241z','G2410','G240.','G240z','G2400','G20..','G20z.','G203.','G202.','G201.','G200.','Gyu2.','Gyu21','Gyu20')
and EntryDate >= '2009-12-29'
and EntryDate <= '2020-06-05'
group by NHSNo, EntryDate
 UNION ALL 
-- peripheral arterial disease
select NHSNo, EntryDate from journal
where ReadCode in ('G73..12','G73..13','G73..00','G73..11','G73z.00','G73zz00','G73z000','G73z011','G73z012','G73y.00','G73yz00','G734.00','Gyu7400','G73..','G73z.','G73zz','G73z0','G73y.','G73yz','G734.','Gyu74')
and EntryDate >= '2009-12-29'
and EntryDate <= '2020-06-05'
group by NHSNo, EntryDate
) sub 
group by EntryDate

PRINT 'Date,IncidenceOfCardiovascular,PrevalenceOfCardiovascular'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.EntryDate = d.date
order by date;
