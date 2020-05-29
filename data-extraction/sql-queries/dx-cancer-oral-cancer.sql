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
	select NHSNo, min(entrydate) as FirstDiagnosis from journal
	where ReadCode in ('B00..00','B00..11','B00..99','B000.00','B000000','B000100','B000z00','B001.00','B001000','B001100','B001z00','B002.00','B002000','B002100','B002200','B002300','B002z00','B003.00','B003000','B003100','B003200','B003300','B003z00','B004.00','B004000','B004100','B004200','B004300','B004z00','B005.00','B006.00','B007.00','B00y.00','B00z.00','B00z000','B00z100','B00zz00','B01..00','B01..99','B010.00','B010.11','B010000','B010z00','B011.00','B011000','B011100','B011z00','B012.00','B013.00','B013000','B013100','B013z00','B014.00','B015.00','B016.00','B017.00','B01y.00','B01z.00','B03..00','B03..99','B030.00','B031.00','B03y.00','B03z.00','B04..00','B040.00','B041.00','B042.00','B04y.00','B04z.00','B05..00','B050.00','B050.11','B051.00','B051000','B051100','B051200','B051300','B051z00','B052.00','B053.00','B054.00','B055.00','B055000','B055100','B055z00','B056.00','B05y.00','B05z.00','B062100','B062200','B062300','B200300','B550100','B00..','B000.','B0000','B0001','B000z','B001.','B0010','B0011','B001z','B002.','B0020','B0021','B0022','B0023','B002z','B003.','B0030','B0031','B0032','B0033','B003z','B004.','B0040','B0041','B0042','B0043','B004z','B005.','B006.','B007.','B00y.','B00z.','B00z0','B00z1','B00zz','B01..','B010.','B0100','B010z','B011.','B0110','B0111','B011z','B012.','B013.','B0130','B0131','B013z','B014.','B015.','B016.','B017.','B01y.','B01z.','B03..','B030.','B031.','B03y.','B03z.','B04..','B040.','B041.','B042.','B04y.','B04z.','B05..','B050.','B051.','B0510','B0511','B0512','B0513','B051z','B052.','B053.','B054.','B055.','B0550','B0551','B055z','B056.','B05y.','B05z.','B0621','B0622','B0623','B2003','B5501')
	and entrydate <= '2020-05-29'
	group by NHSNo
) sub 
where FirstDiagnosis >= '2015-01-01'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select entrydate, count(*) as num into #Prevalence from (
	select NHSNo, entrydate from journal
	where ReadCode in ('B00..00','B00..11','B00..99','B000.00','B000000','B000100','B000z00','B001.00','B001000','B001100','B001z00','B002.00','B002000','B002100','B002200','B002300','B002z00','B003.00','B003000','B003100','B003200','B003300','B003z00','B004.00','B004000','B004100','B004200','B004300','B004z00','B005.00','B006.00','B007.00','B00y.00','B00z.00','B00z000','B00z100','B00zz00','B01..00','B01..99','B010.00','B010.11','B010000','B010z00','B011.00','B011000','B011100','B011z00','B012.00','B013.00','B013000','B013100','B013z00','B014.00','B015.00','B016.00','B017.00','B01y.00','B01z.00','B03..00','B03..99','B030.00','B031.00','B03y.00','B03z.00','B04..00','B040.00','B041.00','B042.00','B04y.00','B04z.00','B05..00','B050.00','B050.11','B051.00','B051000','B051100','B051200','B051300','B051z00','B052.00','B053.00','B054.00','B055.00','B055000','B055100','B055z00','B056.00','B05y.00','B05z.00','B062100','B062200','B062300','B200300','B550100','B00..','B000.','B0000','B0001','B000z','B001.','B0010','B0011','B001z','B002.','B0020','B0021','B0022','B0023','B002z','B003.','B0030','B0031','B0032','B0033','B003z','B004.','B0040','B0041','B0042','B0043','B004z','B005.','B006.','B007.','B00y.','B00z.','B00z0','B00z1','B00zz','B01..','B010.','B0100','B010z','B011.','B0110','B0111','B011z','B012.','B013.','B0130','B0131','B013z','B014.','B015.','B016.','B017.','B01y.','B01z.','B03..','B030.','B031.','B03y.','B03z.','B04..','B040.','B041.','B042.','B04y.','B04z.','B05..','B050.','B051.','B0510','B0511','B0512','B0513','B051z','B052.','B053.','B054.','B055.','B0550','B0551','B055z','B056.','B05y.','B05z.','B0621','B0622','B0623','B2003','B5501')
	and entrydate >= '2015-01-01'
	and entrydate <= '2020-05-29'
	group by NHSNo, entrydate
) sub 
group by entrydate

PRINT 'Date,IncidenceOfOralCancer,PrevalenceOfOralCancer'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.entrydate = d.date
order by date;
