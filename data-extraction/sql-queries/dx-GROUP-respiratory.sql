-- Template for the groups of conditions
-- E.g. all malignant cancers, or all cvd

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
	-- asthma
select NHSNo, min(EntryDate) as FirstDiagnosis from journal
where ReadCode in ('663V300','663V200','663V100','663V000','H3B..00','H33..00','H33..11','H335.00','H334.00','H333.00','H332.00','H331.00','H331.11','H331z00','H331100','H331111','H331000','H330.00','H330.11','H330.12','H330.13','H330.14','H330z00','H330100','H330111','H330000','H330011','H33z.00','H33z200','H33z100','H33z111','H33zz00','H33zz11','H33zz12','H33z000','H33z011','173A.00','1O2..00','H312000','663V3','663V2','663V1','663V0','H3B..','H33..','H335.','H334.','H333.','H332.','H331.','H331z','H3311','H3310','H330.','H330z','H3301','H3300','H33z.','H33z2','H33z1','H33zz','H33z0','173A.','1O2..','H3120')
and EntryDate <= '2020-06-02'
group by NHSNo
 UNION ALL 
-- copd
select NHSNo, min(EntryDate) as FirstDiagnosis from journal
where ReadCode in ('H3...11','H3...00','H3B..00','H39..00','H38..00','H37..00','H36..00','H3z..00','H3z..11','H3y..00','H3y..11','H3A..00','H32..00','H32z.00','H32y.00','H32yz00','H32y200','H32y100','H32y000','H322.00','H321.00','H320.00','H320z00','H320300','H320200','H320100','H320000','H31..00','H31z.00','H31y.00','H31yz00','H31y100','H313.00','H312.00','H312z00','H312300','H312100','H312000','H312011','H311.00','H311z00','H311100','H311000','H310.00','H310z00','H310000','Hyu3000','Hyu3100','H464100','H464000','H583200','8H2R.00','H3...','H3B..','H39..','H38..','H37..','H36..','H3z..','H3y..','H3A..','H32..','H32z.','H32y.','H32yz','H32y2','H32y1','H32y0','H322.','H321.','H320.','H320z','H3203','H3202','H3201','H3200','H31..','H31z.','H31y.','H31yz','H31y1','H313.','H312.','H312z','H3123','H3121','H3120','H311.','H311z','H3111','H3110','H310.','H310z','H3100','Hyu30','Hyu31','H4641','H4640','H5832','8H2R.')
and EntryDate <= '2020-06-02'
group by NHSNo
) sub 
where FirstDiagnosis >= '2015-01-01'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select EntryDate, count(*) as num into #Prevalence from (
	-- asthma
select NHSNo, EntryDate from journal
where ReadCode in ('663V300','663V200','663V100','663V000','H3B..00','H33..00','H33..11','H335.00','H334.00','H333.00','H332.00','H331.00','H331.11','H331z00','H331100','H331111','H331000','H330.00','H330.11','H330.12','H330.13','H330.14','H330z00','H330100','H330111','H330000','H330011','H33z.00','H33z200','H33z100','H33z111','H33zz00','H33zz11','H33zz12','H33z000','H33z011','173A.00','1O2..00','H312000','663V3','663V2','663V1','663V0','H3B..','H33..','H335.','H334.','H333.','H332.','H331.','H331z','H3311','H3310','H330.','H330z','H3301','H3300','H33z.','H33z2','H33z1','H33zz','H33z0','173A.','1O2..','H3120')
and EntryDate >= '2015-01-01'
and EntryDate <= '2020-06-02'
group by NHSNo, EntryDate
 UNION ALL 
-- copd
select NHSNo, EntryDate from journal
where ReadCode in ('H3...11','H3...00','H3B..00','H39..00','H38..00','H37..00','H36..00','H3z..00','H3z..11','H3y..00','H3y..11','H3A..00','H32..00','H32z.00','H32y.00','H32yz00','H32y200','H32y100','H32y000','H322.00','H321.00','H320.00','H320z00','H320300','H320200','H320100','H320000','H31..00','H31z.00','H31y.00','H31yz00','H31y100','H313.00','H312.00','H312z00','H312300','H312100','H312000','H312011','H311.00','H311z00','H311100','H311000','H310.00','H310z00','H310000','Hyu3000','Hyu3100','H464100','H464000','H583200','8H2R.00','H3...','H3B..','H39..','H38..','H37..','H36..','H3z..','H3y..','H3A..','H32..','H32z.','H32y.','H32yz','H32y2','H32y1','H32y0','H322.','H321.','H320.','H320z','H3203','H3202','H3201','H3200','H31..','H31z.','H31y.','H31yz','H31y1','H313.','H312.','H312z','H3123','H3121','H3120','H311.','H311z','H3111','H3110','H310.','H310z','H3100','Hyu30','Hyu31','H4641','H4640','H5832','8H2R.')
and EntryDate >= '2015-01-01'
and EntryDate <= '2020-06-02'
group by NHSNo, EntryDate
) sub 
group by EntryDate

PRINT 'Date,IncidenceOfRespiratory,PrevalenceOfRespiratory'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.EntryDate = d.date
order by date;
