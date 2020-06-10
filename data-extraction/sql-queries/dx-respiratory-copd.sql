--Just want the output, not the messages
SET NOCOUNT ON; 

--populate table with all dates from 2009-12-28
IF OBJECT_ID('tempdb..#AllDates') IS NOT NULL DROP TABLE #AllDates;
CREATE TABLE #AllDates ([date] date);
declare @dt datetime = '2009-12-28'
declare @dtEnd datetime = '2020-06-10';
WHILE (@dt <= @dtEnd) BEGIN
    insert into #AllDates([date])
        values(@dt)
    SET @dt = DATEADD(day, 1, @dt)
END;

-- Populate incidence table - only count those occurrences
-- of the code where it is the first time the patient has had it
select FirstDiagnosis, count(*) as num into #Incidence from (
	select NHSNo, min(entrydate) as FirstDiagnosis from journal
	where ReadCode in ('H3...11','H3...00','H3B..00','H39..00','H38..00','H37..00','H36..00','H3z..00','H3z..11','H3y..00','H3y..11','H3A..00','H32..00','H32z.00','H32y.00','H32yz00','H32y200','H32y100','H32y000','H322.00','H321.00','H320.00','H320z00','H320300','H320200','H320100','H320000','H31..00','H31z.00','H31y.00','H31yz00','H31y100','H313.00','H312.00','H312z00','H312300','H312100','H312000','H312011','H311.00','H311z00','H311100','H311000','H310.00','H310z00','H310000','Hyu3000','Hyu3100','H464100','H464000','H583200','8H2R.00','H3...','H3B..','H39..','H38..','H37..','H36..','H3z..','H3y..','H3A..','H32..','H32z.','H32y.','H32yz','H32y2','H32y1','H32y0','H322.','H321.','H320.','H320z','H3203','H3202','H3201','H3200','H31..','H31z.','H31y.','H31yz','H31y1','H313.','H312.','H312z','H3123','H3121','H3120','H311.','H311z','H3111','H3110','H310.','H310z','H3100','Hyu30','Hyu31','H4641','H4640','H5832','8H2R.')
	and entrydate <= '2020-06-10'
	group by NHSNo
) sub 
where FirstDiagnosis >= '2009-12-28'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select entrydate, count(*) as num into #Prevalence from (
	select NHSNo, entrydate from journal
	where ReadCode in ('H3...11','H3...00','H3B..00','H39..00','H38..00','H37..00','H36..00','H3z..00','H3z..11','H3y..00','H3y..11','H3A..00','H32..00','H32z.00','H32y.00','H32yz00','H32y200','H32y100','H32y000','H322.00','H321.00','H320.00','H320z00','H320300','H320200','H320100','H320000','H31..00','H31z.00','H31y.00','H31yz00','H31y100','H313.00','H312.00','H312z00','H312300','H312100','H312000','H312011','H311.00','H311z00','H311100','H311000','H310.00','H310z00','H310000','Hyu3000','Hyu3100','H464100','H464000','H583200','8H2R.00','H3...','H3B..','H39..','H38..','H37..','H36..','H3z..','H3y..','H3A..','H32..','H32z.','H32y.','H32yz','H32y2','H32y1','H32y0','H322.','H321.','H320.','H320z','H3203','H3202','H3201','H3200','H31..','H31z.','H31y.','H31yz','H31y1','H313.','H312.','H312z','H3123','H3121','H3120','H311.','H311z','H3111','H3110','H310.','H310z','H3100','Hyu30','Hyu31','H4641','H4640','H5832','8H2R.')
	and entrydate >= '2009-12-28'
	and entrydate <= '2020-06-10'
	group by NHSNo, entrydate
) sub 
group by entrydate

PRINT 'Date,IncidenceOfCopd,PrevalenceOfCopd'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.entrydate = d.date
order by date;
