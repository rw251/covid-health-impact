--Just want the output, not the messages
SET NOCOUNT ON; 

--populate table with all dates from 2015-01-01
IF OBJECT_ID('tempdb..#AllDates') IS NOT NULL DROP TABLE #AllDates;
CREATE TABLE #AllDates ([date] date);
declare @dt datetime = '2015-01-01'
declare @dtEnd datetime = '2020-05-05';
WHILE (@dt <= @dtEnd) BEGIN
    insert into #AllDates([date])
        values(@dt)
    SET @dt = DATEADD(day, 1, @dt)
END;

-- Populate incidence table - only count those occurrences
-- of the code where it is the first time the patient has had it
select FirstDiagnosis, count(*) as num into #Incidence from (
	select PatID, min(EntryDate) as FirstDiagnosis from SIR_ALL_Records_Narrow
	where ReadCode in ('H3...00','H31..00','H310.00','H310000','H310z00','H311.00','H311000','H311100','H311z00','H312.00','H312000','H312100','H312300','H312z00','H313.00','H31y.00','H31y100','H31yz00','H31z.00','H32..00','H320.00','H320000','H320100','H320200','H320300','H320z00','H321.00','H322.00','H32y.00','H32y000','H32y100','H32y200','H32yz00','H32z.00','H36..00','H37..00','H38..00','H39..00','H3A..00','H3B..00','H3y..00','H3z..00','H464000','H464100','H583200','Hyu3000','Hyu31','H3...','H31..','H310.','H3100','H310z','H311.','H3110','H3111','H311z','H312.','H3120','H3121','H3123','H312z','H313.','H31y.','H31y1','H31yz','H31z.','H32..','H320.','H3200','H3201','H3202','H3203','H320z','H321.','H322.','H32y.','H32y0','H32y1','H32y2','H32yz','H32z.','H36..','H37..','H38..','H39..','H3A..','H3B..','H3y..','H3z..','H4640','H4641','H5832','Hyu30')
	and EntryDate <= '2020-05-05'
	group by PatID
) sub 
where FirstDiagnosis >= '2015-01-01'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select EntryDate, count(*) as num into #Prevalence from (
	select PatID, EntryDate from SIR_ALL_Records_Narrow
	where ReadCode in ('H3...00','H31..00','H310.00','H310000','H310z00','H311.00','H311000','H311100','H311z00','H312.00','H312000','H312100','H312300','H312z00','H313.00','H31y.00','H31y100','H31yz00','H31z.00','H32..00','H320.00','H320000','H320100','H320200','H320300','H320z00','H321.00','H322.00','H32y.00','H32y000','H32y100','H32y200','H32yz00','H32z.00','H36..00','H37..00','H38..00','H39..00','H3A..00','H3B..00','H3y..00','H3z..00','H464000','H464100','H583200','Hyu3000','Hyu31','H3...','H31..','H310.','H3100','H310z','H311.','H3110','H3111','H311z','H312.','H3120','H3121','H3123','H312z','H313.','H31y.','H31y1','H31yz','H31z.','H32..','H320.','H3200','H3201','H3202','H3203','H320z','H321.','H322.','H32y.','H32y0','H32y1','H32y2','H32yz','H32z.','H36..','H37..','H38..','H39..','H3A..','H3B..','H3y..','H3z..','H4640','H4641','H5832','Hyu30')
	and EntryDate >= '2015-01-01'
	and EntryDate <= '2020-05-05'
	group by PatID, EntryDate
) sub 
group by EntryDate

PRINT 'Date,IncidenceOfCopd,PrevalenceOfCopd'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.EntryDate = d.date
order by date;
