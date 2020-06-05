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
	where ReadCode in ('bxd..00','bxd..','bxd1.00','bxd1.','bxd2.00','bxd2.','bxd3.00','bxd3.','bxd4.00','bxd4.','bxd5.00','bxd5.','bxd6.00','bxd6.','bxd7.00','bxd7.','bxd8.00','bxd8.','bxd9.00','bxd9.','bxdA.00','bxdA.','bxdB.00','bxdB.','bxdC.00','bxdC.','bxdD.00','bxdD.','bxdE.00','bxdE.','bxdF.00','bxdF.','bxdG.00','bxdG.','bxdH.00','bxdH.','bxdI.00','bxdI.','bxdJ.00','bxdJ.','bxdK.00','bxdK.','bxdu.00','bxdu.','bxdv.00','bxdv.','bxdw.00','bxdw.','bxdx.00','bxdx.','bxdy.00','bxdy.','bxdz.00','bxdz.','bxe..00','bxe..','bxe1.00','bxe1.','bxe2.00','bxe2.','bxe3.00','bxe3.','bxe4.00','bxe4.','bxe5.00','bxe5.','bxe6.00','bxe6.','bxe7.00','bxe7.','bxe8.00','bxe8.','bxg..00','bxg..','bxg1.00','bxg1.','bxg2.00','bxg2.','bxg3.00','bxg3.','bxg4.00','bxg4.','bxg5.00','bxg5.','bxg6.00','bxg6.','bxg7.00','bxg7.','bxg8.00','bxg8.','bxg9.00','bxg9.','bxgz.00','bxgz.','bxi..00','bxi..','bxi1.00','bxi1.','bxi2.00','bxi2.','bxi3.00','bxi3.','bxi4.00','bxi4.','bxi5.00','bxi5.','bxi6.00','bxi6.','bxi7.00','bxi7.','bxi8.00','bxi8.','bxi9.00','bxi9.','bxiA.00','bxiA.','bxiB.00','bxiB.','bxiy.00','bxiy.','bxiz.00','bxiz.','bxj..00','bxj..','bxj1.00','bxj1.','bxj2.00','bxj2.','bxj3.00','bxj3.','bxj4.00','bxj4.','bxj5.00','bxj5.','bxj6.00','bxj6.','bxj7.00','bxj7.','bxj8.00','bxj8.','bxj9.00','bxj9.','bxjz.00','bxjz.','bxk..00','bxk..','bxk1.00','bxk1.','bxk2.00','bxk2.','bxk3.00','bxk3.','bxk4.00','bxk4.','bxkw.00','bxkw.','bxkx.00','bxkx.','bxky.00','bxky.','bxkz.00','bxkz.','ATCH52120NEMIS','ATOR21782NEMIS','ATTA30130EMIS','ATTA30131EMIS','ATTA30132EMIS','ATTA6253NEMIS','CETA1911NEMIS','CETA30765EMIS','CETA30766EMIS','CETA30767EMIS','CRTA15074NEMIS','CRTA15075NEMIS','CRTA21336NEMIS','EZTA20280NEMIS','EZTA20281NEMIS','EZTA20282NEMIS','FLCA24125EMIS','FLCA24126EMIS','FLTA5289NEMIS','INTA20284NEMIS','INTA20285NEMIS','INTA20286NEMIS','LECA24121EMIS','LETA5290NEMIS','LICH52126NEMIS','LITA10719BRIDL','LITA10721BRIDL','LITA1910NEMIS','LITA30124EMIS','LITA30125EMIS','LITA30126EMIS','LITA30703EMIS','LITA30759EMIS','LITA30760EMIS','LITA30761EMIS','LITA6254NEMIS','PRTA10455HILLI','PRTA10456HILLI','PRTA30705EMIS','ROTA15069NEMIS','ROTA15071NEMIS','ROTA15072NEMIS','ROTA21335NEMIS','SIOR25476NEMIS','SIOR44786NEMIS','SITA10076BRIDL','SITA10078BRIDL','SITA16195NEMIS','SITA16196NEMIS','SITA16197NEMIS','SITA29406EMIS','SITA34996NEMIS','SITA3663NEMIS','ZOTA29404EMIS','ZOTA8622EGTON','ZOTA8623EGTON','bxd..','bxd1.','bxd2.','bxd3.','bxd4.','bxd5.','bxd6.','bxd7.','bxd8.','bxd9.','bxdA.','bxdB.','bxdC.','bxdD.','bxdE.','bxdF.','bxdG.','bxdH.','bxdI.','bxdJ.','bxdK.','bxdu.','bxdv.','bxdw.','bxdx.','bxdy.','bxdz.','bxe..','bxe1.','bxe2.','bxe3.','bxe4.','bxe5.','bxe6.','bxe7.','bxe8.','bxg..','bxg1.','bxg2.','bxg3.','bxg4.','bxg5.','bxg6.','bxg7.','bxg8.','bxg9.','bxgz.','bxi..','bxi1.','bxi2.','bxi3.','bxi4.','bxi5.','bxi6.','bxi7.','bxi8.','bxi9.','bxiA.','bxiB.','bxiy.','bxiz.','bxj..','bxj1.','bxj2.','bxj3.','bxj4.','bxj5.','bxj6.','bxj7.','bxj8.','bxj9.','bxjz.','bxk..','bxk1.','bxk2.','bxk3.','bxk4.','bxkw.','bxkx.','bxky.','bxkz.')
	and entrydate <= '2020-06-05'
	group by NHSNo
) sub 
where FirstDiagnosis >= '2009-12-28'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select entrydate, count(*) as num into #Prevalence from (
	select NHSNo, entrydate from journal
	where ReadCode in ('bxd..00','bxd..','bxd1.00','bxd1.','bxd2.00','bxd2.','bxd3.00','bxd3.','bxd4.00','bxd4.','bxd5.00','bxd5.','bxd6.00','bxd6.','bxd7.00','bxd7.','bxd8.00','bxd8.','bxd9.00','bxd9.','bxdA.00','bxdA.','bxdB.00','bxdB.','bxdC.00','bxdC.','bxdD.00','bxdD.','bxdE.00','bxdE.','bxdF.00','bxdF.','bxdG.00','bxdG.','bxdH.00','bxdH.','bxdI.00','bxdI.','bxdJ.00','bxdJ.','bxdK.00','bxdK.','bxdu.00','bxdu.','bxdv.00','bxdv.','bxdw.00','bxdw.','bxdx.00','bxdx.','bxdy.00','bxdy.','bxdz.00','bxdz.','bxe..00','bxe..','bxe1.00','bxe1.','bxe2.00','bxe2.','bxe3.00','bxe3.','bxe4.00','bxe4.','bxe5.00','bxe5.','bxe6.00','bxe6.','bxe7.00','bxe7.','bxe8.00','bxe8.','bxg..00','bxg..','bxg1.00','bxg1.','bxg2.00','bxg2.','bxg3.00','bxg3.','bxg4.00','bxg4.','bxg5.00','bxg5.','bxg6.00','bxg6.','bxg7.00','bxg7.','bxg8.00','bxg8.','bxg9.00','bxg9.','bxgz.00','bxgz.','bxi..00','bxi..','bxi1.00','bxi1.','bxi2.00','bxi2.','bxi3.00','bxi3.','bxi4.00','bxi4.','bxi5.00','bxi5.','bxi6.00','bxi6.','bxi7.00','bxi7.','bxi8.00','bxi8.','bxi9.00','bxi9.','bxiA.00','bxiA.','bxiB.00','bxiB.','bxiy.00','bxiy.','bxiz.00','bxiz.','bxj..00','bxj..','bxj1.00','bxj1.','bxj2.00','bxj2.','bxj3.00','bxj3.','bxj4.00','bxj4.','bxj5.00','bxj5.','bxj6.00','bxj6.','bxj7.00','bxj7.','bxj8.00','bxj8.','bxj9.00','bxj9.','bxjz.00','bxjz.','bxk..00','bxk..','bxk1.00','bxk1.','bxk2.00','bxk2.','bxk3.00','bxk3.','bxk4.00','bxk4.','bxkw.00','bxkw.','bxkx.00','bxkx.','bxky.00','bxky.','bxkz.00','bxkz.','ATCH52120NEMIS','ATOR21782NEMIS','ATTA30130EMIS','ATTA30131EMIS','ATTA30132EMIS','ATTA6253NEMIS','CETA1911NEMIS','CETA30765EMIS','CETA30766EMIS','CETA30767EMIS','CRTA15074NEMIS','CRTA15075NEMIS','CRTA21336NEMIS','EZTA20280NEMIS','EZTA20281NEMIS','EZTA20282NEMIS','FLCA24125EMIS','FLCA24126EMIS','FLTA5289NEMIS','INTA20284NEMIS','INTA20285NEMIS','INTA20286NEMIS','LECA24121EMIS','LETA5290NEMIS','LICH52126NEMIS','LITA10719BRIDL','LITA10721BRIDL','LITA1910NEMIS','LITA30124EMIS','LITA30125EMIS','LITA30126EMIS','LITA30703EMIS','LITA30759EMIS','LITA30760EMIS','LITA30761EMIS','LITA6254NEMIS','PRTA10455HILLI','PRTA10456HILLI','PRTA30705EMIS','ROTA15069NEMIS','ROTA15071NEMIS','ROTA15072NEMIS','ROTA21335NEMIS','SIOR25476NEMIS','SIOR44786NEMIS','SITA10076BRIDL','SITA10078BRIDL','SITA16195NEMIS','SITA16196NEMIS','SITA16197NEMIS','SITA29406EMIS','SITA34996NEMIS','SITA3663NEMIS','ZOTA29404EMIS','ZOTA8622EGTON','ZOTA8623EGTON','bxd..','bxd1.','bxd2.','bxd3.','bxd4.','bxd5.','bxd6.','bxd7.','bxd8.','bxd9.','bxdA.','bxdB.','bxdC.','bxdD.','bxdE.','bxdF.','bxdG.','bxdH.','bxdI.','bxdJ.','bxdK.','bxdu.','bxdv.','bxdw.','bxdx.','bxdy.','bxdz.','bxe..','bxe1.','bxe2.','bxe3.','bxe4.','bxe5.','bxe6.','bxe7.','bxe8.','bxg..','bxg1.','bxg2.','bxg3.','bxg4.','bxg5.','bxg6.','bxg7.','bxg8.','bxg9.','bxgz.','bxi..','bxi1.','bxi2.','bxi3.','bxi4.','bxi5.','bxi6.','bxi7.','bxi8.','bxi9.','bxiA.','bxiB.','bxiy.','bxiz.','bxj..','bxj1.','bxj2.','bxj3.','bxj4.','bxj5.','bxj6.','bxj7.','bxj8.','bxj9.','bxjz.','bxk..','bxk1.','bxk2.','bxk3.','bxk4.','bxkw.','bxkx.','bxky.','bxkz.')
	and entrydate >= '2009-12-28'
	and entrydate <= '2020-06-05'
	group by NHSNo, entrydate
) sub 
group by entrydate

PRINT 'Date,IncidenceOfStatin,PrevalenceOfStatin'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.entrydate = d.date
order by date;
