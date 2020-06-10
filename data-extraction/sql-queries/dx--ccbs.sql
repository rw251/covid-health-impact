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
	where ReadCode in ('bll..00','blll.00','bllk.00','bllj.00','blli.00','bllh.00','bllg.00','bllf.00','blle.00','blld.00','bllc.00','bllb.00','blla.00','bll9.00','bll8.00','bll7.00','bll6.00','bll5.00','bll4.00','bll3.00','bll2.00','bll1.00','bl8..00','bl8z.00','bl8y.00','bl8x.00','bl8w.00','bl8v.00','bl8u.00','bl8W.00','bl8V.00','bl8F.00','bl88.00','bl86.00','bl85.00','bl8t.00','bl8s.00','bl8r.00','bl8q.00','bl8p.00','bl8o.00','bl8n.00','bl8m.00','bl8l.00','bl8k.00','bl8j.00','bl8i.00','bl8h.00','bl8g.00','bl8f.00','bl8e.00','bl8d.00','bl8c.00','bl8b.00','bl8a.00','bl8Z.00','bl8Y.00','bl8X.00','bl8U.00','bl8T.00','bl8S.00','bl8R.00','bl8Q.00','bl8P.00','bl8O.00','bl8M.00','bl8L.00','bl8K.00','bl8J.00','bl8H.00','bl8G.00','bl8E.00','bl8D.00','bl8C.00','bl8B.00','bl8A.00','bl89.00','bl87.00','bl84.00','bl83.00','bl82.00','bl81.00','bl7..00','bl7z.00','bl7y.00','bl7x.00','bl7w.00','bl75.00','bl74.00','bl73.00','bl72.00','bl71.00','ble..00','ble2.00','ble1.00','ble5.00','ble4.00','ble3.00','blc..00','blc5.00','blc2.00','blc1.00','blct.00','blcs.00','blcr.00','blcq.00','blcp.00','blco.00','blcn.00','blcm.00','blcl.00','blck.00','blcj.00','blci.00','blch.00','blcg.00','blcf.00','blce.00','blcd.00','blcc.00','blcb.00','blca.00','blc9.00','blc8.00','blc7.00','blc6.00','blc4.00','blc3.00','blb..00','blb8.00','blb7.00','blb2.00','blb1.00','blb6.00','blb5.00','blb4.00','blb3.00','blh..00','blh3.00','blh1.00','blh4.00','blh2.00','dt1..00','dt15.00','dt13.00','dt11.00','dt16.00','dt14.00','dt12.00','dhbe.00','dhbd.00','dhbc.00','bll..','blll.','bllk.','bllj.','blli.','bllh.','bllg.','bllf.','blle.','blld.','bllc.','bllb.','blla.','bll9.','bll8.','bll7.','bll6.','bll5.','bll4.','bll3.','bll2.','bll1.','bl8..','bl8z.','bl8y.','bl8x.','bl8w.','bl8v.','bl8u.','bl8W.','bl8V.','bl8F.','bl88.','bl86.','bl85.','bl8t.','bl8s.','bl8r.','bl8q.','bl8p.','bl8o.','bl8n.','bl8m.','bl8l.','bl8k.','bl8j.','bl8i.','bl8h.','bl8g.','bl8f.','bl8e.','bl8d.','bl8c.','bl8b.','bl8a.','bl8Z.','bl8Y.','bl8X.','bl8U.','bl8T.','bl8S.','bl8R.','bl8Q.','bl8P.','bl8O.','bl8M.','bl8L.','bl8K.','bl8J.','bl8H.','bl8G.','bl8E.','bl8D.','bl8C.','bl8B.','bl8A.','bl89.','bl87.','bl84.','bl83.','bl82.','bl81.','bl7..','bl7z.','bl7y.','bl7x.','bl7w.','bl75.','bl74.','bl73.','bl72.','bl71.','ble..','ble2.','ble1.','ble5.','ble4.','ble3.','blc..','blc5.','blc2.','blc1.','blct.','blcs.','blcr.','blcq.','blcp.','blco.','blcn.','blcm.','blcl.','blck.','blcj.','blci.','blch.','blcg.','blcf.','blce.','blcd.','blcc.','blcb.','blca.','blc9.','blc8.','blc7.','blc6.','blc4.','blc3.','blb..','blb8.','blb7.','blb2.','blb1.','blb6.','blb5.','blb4.','blb3.','blh..','blh3.','blh1.','blh4.','blh2.','dt1..','dt15.','dt13.','dt11.','dt16.','dt14.','dt12.','dhbe.','dhbd.','dhbc.')
	and entrydate <= '2020-06-10'
	group by NHSNo
) sub 
where FirstDiagnosis >= '2009-12-28'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select entrydate, count(*) as num into #Prevalence from (
	select NHSNo, entrydate from journal
	where ReadCode in ('bll..00','blll.00','bllk.00','bllj.00','blli.00','bllh.00','bllg.00','bllf.00','blle.00','blld.00','bllc.00','bllb.00','blla.00','bll9.00','bll8.00','bll7.00','bll6.00','bll5.00','bll4.00','bll3.00','bll2.00','bll1.00','bl8..00','bl8z.00','bl8y.00','bl8x.00','bl8w.00','bl8v.00','bl8u.00','bl8W.00','bl8V.00','bl8F.00','bl88.00','bl86.00','bl85.00','bl8t.00','bl8s.00','bl8r.00','bl8q.00','bl8p.00','bl8o.00','bl8n.00','bl8m.00','bl8l.00','bl8k.00','bl8j.00','bl8i.00','bl8h.00','bl8g.00','bl8f.00','bl8e.00','bl8d.00','bl8c.00','bl8b.00','bl8a.00','bl8Z.00','bl8Y.00','bl8X.00','bl8U.00','bl8T.00','bl8S.00','bl8R.00','bl8Q.00','bl8P.00','bl8O.00','bl8M.00','bl8L.00','bl8K.00','bl8J.00','bl8H.00','bl8G.00','bl8E.00','bl8D.00','bl8C.00','bl8B.00','bl8A.00','bl89.00','bl87.00','bl84.00','bl83.00','bl82.00','bl81.00','bl7..00','bl7z.00','bl7y.00','bl7x.00','bl7w.00','bl75.00','bl74.00','bl73.00','bl72.00','bl71.00','ble..00','ble2.00','ble1.00','ble5.00','ble4.00','ble3.00','blc..00','blc5.00','blc2.00','blc1.00','blct.00','blcs.00','blcr.00','blcq.00','blcp.00','blco.00','blcn.00','blcm.00','blcl.00','blck.00','blcj.00','blci.00','blch.00','blcg.00','blcf.00','blce.00','blcd.00','blcc.00','blcb.00','blca.00','blc9.00','blc8.00','blc7.00','blc6.00','blc4.00','blc3.00','blb..00','blb8.00','blb7.00','blb2.00','blb1.00','blb6.00','blb5.00','blb4.00','blb3.00','blh..00','blh3.00','blh1.00','blh4.00','blh2.00','dt1..00','dt15.00','dt13.00','dt11.00','dt16.00','dt14.00','dt12.00','dhbe.00','dhbd.00','dhbc.00','bll..','blll.','bllk.','bllj.','blli.','bllh.','bllg.','bllf.','blle.','blld.','bllc.','bllb.','blla.','bll9.','bll8.','bll7.','bll6.','bll5.','bll4.','bll3.','bll2.','bll1.','bl8..','bl8z.','bl8y.','bl8x.','bl8w.','bl8v.','bl8u.','bl8W.','bl8V.','bl8F.','bl88.','bl86.','bl85.','bl8t.','bl8s.','bl8r.','bl8q.','bl8p.','bl8o.','bl8n.','bl8m.','bl8l.','bl8k.','bl8j.','bl8i.','bl8h.','bl8g.','bl8f.','bl8e.','bl8d.','bl8c.','bl8b.','bl8a.','bl8Z.','bl8Y.','bl8X.','bl8U.','bl8T.','bl8S.','bl8R.','bl8Q.','bl8P.','bl8O.','bl8M.','bl8L.','bl8K.','bl8J.','bl8H.','bl8G.','bl8E.','bl8D.','bl8C.','bl8B.','bl8A.','bl89.','bl87.','bl84.','bl83.','bl82.','bl81.','bl7..','bl7z.','bl7y.','bl7x.','bl7w.','bl75.','bl74.','bl73.','bl72.','bl71.','ble..','ble2.','ble1.','ble5.','ble4.','ble3.','blc..','blc5.','blc2.','blc1.','blct.','blcs.','blcr.','blcq.','blcp.','blco.','blcn.','blcm.','blcl.','blck.','blcj.','blci.','blch.','blcg.','blcf.','blce.','blcd.','blcc.','blcb.','blca.','blc9.','blc8.','blc7.','blc6.','blc4.','blc3.','blb..','blb8.','blb7.','blb2.','blb1.','blb6.','blb5.','blb4.','blb3.','blh..','blh3.','blh1.','blh4.','blh2.','dt1..','dt15.','dt13.','dt11.','dt16.','dt14.','dt12.','dhbe.','dhbd.','dhbc.')
	and entrydate >= '2009-12-28'
	and entrydate <= '2020-06-10'
	group by NHSNo, entrydate
) sub 
group by entrydate

PRINT 'Date,IncidenceOfCcbs,PrevalenceOfCcbs'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.entrydate = d.date
order by date;
