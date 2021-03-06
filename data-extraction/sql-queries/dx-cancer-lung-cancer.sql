--Just want the output, not the messages
SET NOCOUNT ON; 

--populate table with all dates from 2009-12-28
IF OBJECT_ID('tempdb..#AllDates') IS NOT NULL DROP TABLE #AllDates;
CREATE TABLE #AllDates ([date] date);
declare @dt datetime = '2009-12-28'
declare @dtEnd datetime = '2020-09-10';
WHILE (@dt <= @dtEnd) BEGIN
    insert into #AllDates([date])
        values(@dt)
    SET @dt = DATEADD(day, 1, @dt)
END;

-- Populate incidence table - only count those occurrences
-- of the code where it is the first time the patient has had it
select FirstDiagnosis, count(*) as num into #Incidence from (
	select NHSNo, min(entrydate) as FirstDiagnosis from journal
	where ReadCode in ('B22..00','B221.00','B221000','B221100','B221z00','B222.00','B222.11','B222.99','B222000','B222100','B222z00','B223.00','B223.99','B223000','B223100','B223z00','B224.00','B224.99','B224000','B224100','B224z00','B225.00','B22y.00','B22z.00','B22z.11','BB1K.00','BB1L.00','BB1M.00','BB1N.00','BB1P.00','BB5J.12','BB5R111','BB5S200','BB5S211','BB5S212','BB5S400','BBLA.11','BBLM.00','Byu2000','B22..','B221.','B2210','B2211','B221z','B222.','B2220','B2221','B222z','B223.','B2230','B2231','B223z','B224.','B2240','B2241','B224z','B225.','B22y.','B22z.','BB1K.','BB1L.','BB1M.','BB1N.','BB1P.','BB5S2','BB5S4','BBLM.','Byu20')
	and entrydate <= '2020-09-10'
	group by NHSNo
) sub 
where FirstDiagnosis >= '2009-12-28'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select entrydate, count(*) as num into #Prevalence from (
	select NHSNo, entrydate from journal
	where ReadCode in ('B22..00','B221.00','B221000','B221100','B221z00','B222.00','B222.11','B222.99','B222000','B222100','B222z00','B223.00','B223.99','B223000','B223100','B223z00','B224.00','B224.99','B224000','B224100','B224z00','B225.00','B22y.00','B22z.00','B22z.11','BB1K.00','BB1L.00','BB1M.00','BB1N.00','BB1P.00','BB5J.12','BB5R111','BB5S200','BB5S211','BB5S212','BB5S400','BBLA.11','BBLM.00','Byu2000','B22..','B221.','B2210','B2211','B221z','B222.','B2220','B2221','B222z','B223.','B2230','B2231','B223z','B224.','B2240','B2241','B224z','B225.','B22y.','B22z.','BB1K.','BB1L.','BB1M.','BB1N.','BB1P.','BB5S2','BB5S4','BBLM.','Byu20')
	and entrydate >= '2009-12-28'
	and entrydate <= '2020-09-10'
	group by NHSNo, entrydate
) sub 
group by entrydate

PRINT 'Date,IncidenceOfLungCancer,PrevalenceOfLungCancer'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.entrydate = d.date
order by date;
