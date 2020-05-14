--Just want the output, not the messages
SET NOCOUNT ON; 

--populate table with all dates from 2015-01-01
IF OBJECT_ID('tempdb..#AllDates') IS NOT NULL DROP TABLE #AllDates;
CREATE TABLE #AllDates ([date] date);
declare @dt datetime = '2015-01-01'
declare @dtEnd datetime = '2020-05-14';
WHILE (@dt <= @dtEnd) BEGIN
    insert into #AllDates([date])
        values(@dt)
    SET @dt = DATEADD(day, 1, @dt)
END;

-- Populate incidence table - only count those occurrences
-- of the code where it is the first time the patient has had it
select FirstDiagnosis, count(*) as num into #Incidence from (
	select PatID, min(EntryDate) as FirstDiagnosis from SIR_ALL_Records_Narrow
	where ReadCode in ('daE..00','daE6.00','daE4.00','daE2.00','daE5.00','daE3.00','daE1.00','da7..00','da7w.00','da7q.00','da7Y.00','da7K.00','da7I.00','da79.00','da77.00','da75.00','da72.00','da71.00','da7v.00','da7u.00','da7t.00','da7s.00','da7r.00','da7p.00','da7o.00','da7n.00','da7m.00','da7l.00','da7k.00','da7j.00','da7i.00','da7h.00','da7g.00','da7f.00','da7e.00','da7d.00','da7c.00','da7b.00','da7a.00','da7Z.00','da7X.00','da7W.00','da7V.00','da7U.00','da7T.00','da7S.00','da7R.00','da7Q.00','da7P.00','da7O.00','da7N.00','da7M.00','da7L.00','da7J.00','da7H.00','da7G.00','da7F.00','da7E.00','da7D.00','da7C.00','da7B.00','da7A.00','da78.00','da76.00','da74.00','da73.00','da2..00','da2z.00','da2y.00','da24.00','da23.00','da22.00','da21.00','da5..00','da52.00','da51.00','da54.00','da53.00','daA..00','daA1.00','daA2.00','da6..00','da67.00','da65.00','da63.00','da61.00','da68.00','da66.00','da64.00','da62.00','da8..00','da85.00','da82.00','da81.00','da86.00','da84.00','da83.00','daB..00','daBz.00','daBy.00','daB7.00','daB5.00','daB3.00','daB1.00','daB8.00','daB6.00','daB4.00','daB2.00','da3..00','da34.00','da32.00','da33.00','da31.00','da1..11','da1..00','da1z.11','da1z.00','da1y.11','da1y.00','da12.00','da11.00','da4..00','da4E.00','da46.00','da43.00','da41.00','da4D.00','da4C.00','da4B.00','da4A.00','da49.00','da48.00','da47.00','da45.00','da44.00','da42.00','daC..00','daCA.00','daC7.00','daC5.00','daC3.00','daC1.00','daC9.00','daC8.00','daC6.00','daC4.00','daC2.00','da9..00','da9z.00','da95.00','da93.00','da91.00','da9A.00','da99.00','da98.00','da97.00','da96.00','da94.00','da92.00','daD..00','daD2.00','daD1.00','d7g..00','d7gz.00','d7g1.00','d7f..00','d7fz.00','d7fy.00','d7fx.00','d7f3.00','d7f2.00','d7f1.00','d7e..00','d7ez.00','d7ex.00','d7ew.00','d7e7.00','d7e5.00','d7e6.00','d7e4.00','d7e3.00','d7e2.00','d7e1.00','d7d..00','d7d4.00','d7d3.00','d7d2.00','d7d1.00','d7c..00','d7cy.00','d7c9.00','d7c8.00','d7c7.00','d7c6.00','d7c5.00','d7c4.00','d7c3.00','d7c2.00','d7c1.00','d7b..00','d7b3.00','d7b2.00','d7b1.00','d7b9.00','d7b8.00','d7b7.00','d7b6.00','d7b5.00','d7b4.00','d79..00','d79z.00','d79y.00','d794.00','d793.00','d792.00','d791.00','d77..00','d77z.00','d77y.00','d77x.00','d77w.00','d772.00','d771.00','d777.00','d776.00','d775.00','d774.00','d773.00','d78..00','d78z.00','d78y.00','d782.00','d781.00','d76..00','d76z.00','d76y.00','d76x.00','d76w.00','d766.00','d765.00','d764.00','d763.00','d762.00','d761.00','d75..11','d75..00','d75z.11','d75z.00','d75y.11','d75y.00','d75A.00','d759.00','d756.00','d755.00','d754.00','d753.00','d752.00','d751.00','d74..00','d74z.00','d741.00','d73..00','d73z.00','d73y.00','d73x.00','d73w.00','d73v.00','d73u.00','d73t.00','d73s.00','d73r.00','d739.00','d738.00','d737.00','d736.00','d735.00','d734.00','d733.00','d732.00','d731.00','d72..00','d72z.00','d72y.00','d722.00','d721.00','d7h..00','d7h4.00','d7h3.00','d7h2.00','d7h1.00','d7h8.00','d7h7.00','d7h6.00','d7h5.00','d71..00','d71z.00','d71y.00','d71w.00','d71v.00','d71u.00','d71j.00','d71i.00','d71h.00','d713.00','d712.00','d711.00','d71g.00','d71f.00','d71e.00','d71d.00','d71c.00','d71b.00','d71a.00','d719.00','d718.00','d717.00','d716.00','d715.00','d714.00','d53..00','d532.00','d531.00','d52..00','d52x.00','d52w.00','d52v.00','d52u.00','d52t.00','d52s.00','d52a.00','d529.00','d52C.00','d52B.00','d52A.00','d528.00','d527.00','d526.00','d525.00','d524.00','d523.00','d522.00','d521.00','d51..11','d51..00','d51z.00','d51y.11','d51y.00','d51x.00','d51w.11','d51w.00','d51v.11','d51v.00','d51u.11','d51u.00','d51t.00','d51s.00','d51a.00','d519.11','d519.00','d518.00','d517.00','d516.00','d515.00','d514.00','d513.00','d512.00','d511.00','d4h..00','d4hz.00','d4hy.00','d4hx.00','d4hw.00','d4hv.00','d4hu.00','d4ht.00','d4hs.00','d4hr.00','d4h9.00','d4hA.00','d4h8.00','d4h7.00','d4h6.00','d4h5.00','d4h4.00','d4h3.00','d4h2.00','d4h1.00','d4b..00','d4bz.00','d4by.00','d4bx.00','d4b6.00','d4b5.00','d4b4.00','d4b3.00','d4b2.00','d4b1.00','d46..00','d46z.00','d46y.00','d46x.00','d463.00','d462.00','d461.00','d45..11','d45..00','d45z.11','d45z.00','d451.00','d82..00','d82z.00','d82y.00','d822.00','d821.00','d84..00','d84z.00','d841.00','d81..00','d81z.00','d811.00','d85..00','d854.00','d852.00','d853.00','d851.00','d83..00','d83z.00','d831.00','dw2..00','dw2z.00','dw2y.00','dw2x.00','dw2w.00','dw2v.00','dw2u.00','dw2t.00','dw2s.00','dw28.00','dw27.00','dw26.00','dw25.00','dw24.00','dw23.00','dw22.00','dw21.00','gde..00','gdez.00','gdey.00','gdex.00','gdew.00','gde4.00','gde3.00','gde2.00','gde1.00','d917.00','d916.00','d915.00','d914.00','d913.00','d912.00','d911.00','m35..00','m351.00','m352.00','o58..00','o58z.00','o581.00','daE..','daE6.','daE4.','daE2.','daE5.','daE3.','daE1.','da7..','da7w.','da7q.','da7Y.','da7K.','da7I.','da79.','da77.','da75.','da72.','da71.','da7v.','da7u.','da7t.','da7s.','da7r.','da7p.','da7o.','da7n.','da7m.','da7l.','da7k.','da7j.','da7i.','da7h.','da7g.','da7f.','da7e.','da7d.','da7c.','da7b.','da7a.','da7Z.','da7X.','da7W.','da7V.','da7U.','da7T.','da7S.','da7R.','da7Q.','da7P.','da7O.','da7N.','da7M.','da7L.','da7J.','da7H.','da7G.','da7F.','da7E.','da7D.','da7C.','da7B.','da7A.','da78.','da76.','da74.','da73.','da2..','da2z.','da2y.','da24.','da23.','da22.','da21.','da5..','da52.','da51.','da54.','da53.','daA..','daA1.','daA2.','da6..','da67.','da65.','da63.','da61.','da68.','da66.','da64.','da62.','da8..','da85.','da82.','da81.','da86.','da84.','da83.','daB..','daBz.','daBy.','daB7.','daB5.','daB3.','daB1.','daB8.','daB6.','daB4.','daB2.','da3..','da34.','da32.','da33.','da31.','da1..','da1z.','da1y.','da12.','da11.','da4..','da4E.','da46.','da43.','da41.','da4D.','da4C.','da4B.','da4A.','da49.','da48.','da47.','da45.','da44.','da42.','daC..','daCA.','daC7.','daC5.','daC3.','daC1.','daC9.','daC8.','daC6.','daC4.','daC2.','da9..','da9z.','da95.','da93.','da91.','da9A.','da99.','da98.','da97.','da96.','da94.','da92.','daD..','daD2.','daD1.','d7g..','d7gz.','d7g1.','d7f..','d7fz.','d7fy.','d7fx.','d7f3.','d7f2.','d7f1.','d7e..','d7ez.','d7ex.','d7ew.','d7e7.','d7e5.','d7e6.','d7e4.','d7e3.','d7e2.','d7e1.','d7d..','d7d4.','d7d3.','d7d2.','d7d1.','d7c..','d7cy.','d7c9.','d7c8.','d7c7.','d7c6.','d7c5.','d7c4.','d7c3.','d7c2.','d7c1.','d7b..','d7b3.','d7b2.','d7b1.','d7b9.','d7b8.','d7b7.','d7b6.','d7b5.','d7b4.','d79..','d79z.','d79y.','d794.','d793.','d792.','d791.','d77..','d77z.','d77y.','d77x.','d77w.','d772.','d771.','d777.','d776.','d775.','d774.','d773.','d78..','d78z.','d78y.','d782.','d781.','d76..','d76z.','d76y.','d76x.','d76w.','d766.','d765.','d764.','d763.','d762.','d761.','d75..','d75z.','d75y.','d75A.','d759.','d756.','d755.','d754.','d753.','d752.','d751.','d74..','d74z.','d741.','d73..','d73z.','d73y.','d73x.','d73w.','d73v.','d73u.','d73t.','d73s.','d73r.','d739.','d738.','d737.','d736.','d735.','d734.','d733.','d732.','d731.','d72..','d72z.','d72y.','d722.','d721.','d7h..','d7h4.','d7h3.','d7h2.','d7h1.','d7h8.','d7h7.','d7h6.','d7h5.','d71..','d71z.','d71y.','d71w.','d71v.','d71u.','d71j.','d71i.','d71h.','d713.','d712.','d711.','d71g.','d71f.','d71e.','d71d.','d71c.','d71b.','d71a.','d719.','d718.','d717.','d716.','d715.','d714.','d53..','d532.','d531.','d52..','d52x.','d52w.','d52v.','d52u.','d52t.','d52s.','d52a.','d529.','d52C.','d52B.','d52A.','d528.','d527.','d526.','d525.','d524.','d523.','d522.','d521.','d51..','d51z.','d51y.','d51x.','d51w.','d51v.','d51u.','d51t.','d51s.','d51a.','d519.','d518.','d517.','d516.','d515.','d514.','d513.','d512.','d511.','d4h..','d4hz.','d4hy.','d4hx.','d4hw.','d4hv.','d4hu.','d4ht.','d4hs.','d4hr.','d4h9.','d4hA.','d4h8.','d4h7.','d4h6.','d4h5.','d4h4.','d4h3.','d4h2.','d4h1.','d4b..','d4bz.','d4by.','d4bx.','d4b6.','d4b5.','d4b4.','d4b3.','d4b2.','d4b1.','d46..','d46z.','d46y.','d46x.','d463.','d462.','d461.','d45..','d45z.','d451.','d82..','d82z.','d82y.','d822.','d821.','d84..','d84z.','d841.','d81..','d81z.','d811.','d85..','d854.','d852.','d853.','d851.','d83..','d83z.','d831.','dw2..','dw2z.','dw2y.','dw2x.','dw2w.','dw2v.','dw2u.','dw2t.','dw2s.','dw28.','dw27.','dw26.','dw25.','dw24.','dw23.','dw22.','dw21.','gde..','gdez.','gdey.','gdex.','gdew.','gde4.','gde3.','gde2.','gde1.','d917.','d916.','d915.','d914.','d913.','d912.','d911.','m35..','m351.','m352.','o58..','o58z.','o581.')
	and EntryDate <= '2020-05-14'
	group by PatID
) sub 
where FirstDiagnosis >= '2015-01-01'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select EntryDate, count(*) as num into #Prevalence from (
	select PatID, EntryDate from SIR_ALL_Records_Narrow
	where ReadCode in ('daE..00','daE6.00','daE4.00','daE2.00','daE5.00','daE3.00','daE1.00','da7..00','da7w.00','da7q.00','da7Y.00','da7K.00','da7I.00','da79.00','da77.00','da75.00','da72.00','da71.00','da7v.00','da7u.00','da7t.00','da7s.00','da7r.00','da7p.00','da7o.00','da7n.00','da7m.00','da7l.00','da7k.00','da7j.00','da7i.00','da7h.00','da7g.00','da7f.00','da7e.00','da7d.00','da7c.00','da7b.00','da7a.00','da7Z.00','da7X.00','da7W.00','da7V.00','da7U.00','da7T.00','da7S.00','da7R.00','da7Q.00','da7P.00','da7O.00','da7N.00','da7M.00','da7L.00','da7J.00','da7H.00','da7G.00','da7F.00','da7E.00','da7D.00','da7C.00','da7B.00','da7A.00','da78.00','da76.00','da74.00','da73.00','da2..00','da2z.00','da2y.00','da24.00','da23.00','da22.00','da21.00','da5..00','da52.00','da51.00','da54.00','da53.00','daA..00','daA1.00','daA2.00','da6..00','da67.00','da65.00','da63.00','da61.00','da68.00','da66.00','da64.00','da62.00','da8..00','da85.00','da82.00','da81.00','da86.00','da84.00','da83.00','daB..00','daBz.00','daBy.00','daB7.00','daB5.00','daB3.00','daB1.00','daB8.00','daB6.00','daB4.00','daB2.00','da3..00','da34.00','da32.00','da33.00','da31.00','da1..11','da1..00','da1z.11','da1z.00','da1y.11','da1y.00','da12.00','da11.00','da4..00','da4E.00','da46.00','da43.00','da41.00','da4D.00','da4C.00','da4B.00','da4A.00','da49.00','da48.00','da47.00','da45.00','da44.00','da42.00','daC..00','daCA.00','daC7.00','daC5.00','daC3.00','daC1.00','daC9.00','daC8.00','daC6.00','daC4.00','daC2.00','da9..00','da9z.00','da95.00','da93.00','da91.00','da9A.00','da99.00','da98.00','da97.00','da96.00','da94.00','da92.00','daD..00','daD2.00','daD1.00','d7g..00','d7gz.00','d7g1.00','d7f..00','d7fz.00','d7fy.00','d7fx.00','d7f3.00','d7f2.00','d7f1.00','d7e..00','d7ez.00','d7ex.00','d7ew.00','d7e7.00','d7e5.00','d7e6.00','d7e4.00','d7e3.00','d7e2.00','d7e1.00','d7d..00','d7d4.00','d7d3.00','d7d2.00','d7d1.00','d7c..00','d7cy.00','d7c9.00','d7c8.00','d7c7.00','d7c6.00','d7c5.00','d7c4.00','d7c3.00','d7c2.00','d7c1.00','d7b..00','d7b3.00','d7b2.00','d7b1.00','d7b9.00','d7b8.00','d7b7.00','d7b6.00','d7b5.00','d7b4.00','d79..00','d79z.00','d79y.00','d794.00','d793.00','d792.00','d791.00','d77..00','d77z.00','d77y.00','d77x.00','d77w.00','d772.00','d771.00','d777.00','d776.00','d775.00','d774.00','d773.00','d78..00','d78z.00','d78y.00','d782.00','d781.00','d76..00','d76z.00','d76y.00','d76x.00','d76w.00','d766.00','d765.00','d764.00','d763.00','d762.00','d761.00','d75..11','d75..00','d75z.11','d75z.00','d75y.11','d75y.00','d75A.00','d759.00','d756.00','d755.00','d754.00','d753.00','d752.00','d751.00','d74..00','d74z.00','d741.00','d73..00','d73z.00','d73y.00','d73x.00','d73w.00','d73v.00','d73u.00','d73t.00','d73s.00','d73r.00','d739.00','d738.00','d737.00','d736.00','d735.00','d734.00','d733.00','d732.00','d731.00','d72..00','d72z.00','d72y.00','d722.00','d721.00','d7h..00','d7h4.00','d7h3.00','d7h2.00','d7h1.00','d7h8.00','d7h7.00','d7h6.00','d7h5.00','d71..00','d71z.00','d71y.00','d71w.00','d71v.00','d71u.00','d71j.00','d71i.00','d71h.00','d713.00','d712.00','d711.00','d71g.00','d71f.00','d71e.00','d71d.00','d71c.00','d71b.00','d71a.00','d719.00','d718.00','d717.00','d716.00','d715.00','d714.00','d53..00','d532.00','d531.00','d52..00','d52x.00','d52w.00','d52v.00','d52u.00','d52t.00','d52s.00','d52a.00','d529.00','d52C.00','d52B.00','d52A.00','d528.00','d527.00','d526.00','d525.00','d524.00','d523.00','d522.00','d521.00','d51..11','d51..00','d51z.00','d51y.11','d51y.00','d51x.00','d51w.11','d51w.00','d51v.11','d51v.00','d51u.11','d51u.00','d51t.00','d51s.00','d51a.00','d519.11','d519.00','d518.00','d517.00','d516.00','d515.00','d514.00','d513.00','d512.00','d511.00','d4h..00','d4hz.00','d4hy.00','d4hx.00','d4hw.00','d4hv.00','d4hu.00','d4ht.00','d4hs.00','d4hr.00','d4h9.00','d4hA.00','d4h8.00','d4h7.00','d4h6.00','d4h5.00','d4h4.00','d4h3.00','d4h2.00','d4h1.00','d4b..00','d4bz.00','d4by.00','d4bx.00','d4b6.00','d4b5.00','d4b4.00','d4b3.00','d4b2.00','d4b1.00','d46..00','d46z.00','d46y.00','d46x.00','d463.00','d462.00','d461.00','d45..11','d45..00','d45z.11','d45z.00','d451.00','d82..00','d82z.00','d82y.00','d822.00','d821.00','d84..00','d84z.00','d841.00','d81..00','d81z.00','d811.00','d85..00','d854.00','d852.00','d853.00','d851.00','d83..00','d83z.00','d831.00','dw2..00','dw2z.00','dw2y.00','dw2x.00','dw2w.00','dw2v.00','dw2u.00','dw2t.00','dw2s.00','dw28.00','dw27.00','dw26.00','dw25.00','dw24.00','dw23.00','dw22.00','dw21.00','gde..00','gdez.00','gdey.00','gdex.00','gdew.00','gde4.00','gde3.00','gde2.00','gde1.00','d917.00','d916.00','d915.00','d914.00','d913.00','d912.00','d911.00','m35..00','m351.00','m352.00','o58..00','o58z.00','o581.00','daE..','daE6.','daE4.','daE2.','daE5.','daE3.','daE1.','da7..','da7w.','da7q.','da7Y.','da7K.','da7I.','da79.','da77.','da75.','da72.','da71.','da7v.','da7u.','da7t.','da7s.','da7r.','da7p.','da7o.','da7n.','da7m.','da7l.','da7k.','da7j.','da7i.','da7h.','da7g.','da7f.','da7e.','da7d.','da7c.','da7b.','da7a.','da7Z.','da7X.','da7W.','da7V.','da7U.','da7T.','da7S.','da7R.','da7Q.','da7P.','da7O.','da7N.','da7M.','da7L.','da7J.','da7H.','da7G.','da7F.','da7E.','da7D.','da7C.','da7B.','da7A.','da78.','da76.','da74.','da73.','da2..','da2z.','da2y.','da24.','da23.','da22.','da21.','da5..','da52.','da51.','da54.','da53.','daA..','daA1.','daA2.','da6..','da67.','da65.','da63.','da61.','da68.','da66.','da64.','da62.','da8..','da85.','da82.','da81.','da86.','da84.','da83.','daB..','daBz.','daBy.','daB7.','daB5.','daB3.','daB1.','daB8.','daB6.','daB4.','daB2.','da3..','da34.','da32.','da33.','da31.','da1..','da1z.','da1y.','da12.','da11.','da4..','da4E.','da46.','da43.','da41.','da4D.','da4C.','da4B.','da4A.','da49.','da48.','da47.','da45.','da44.','da42.','daC..','daCA.','daC7.','daC5.','daC3.','daC1.','daC9.','daC8.','daC6.','daC4.','daC2.','da9..','da9z.','da95.','da93.','da91.','da9A.','da99.','da98.','da97.','da96.','da94.','da92.','daD..','daD2.','daD1.','d7g..','d7gz.','d7g1.','d7f..','d7fz.','d7fy.','d7fx.','d7f3.','d7f2.','d7f1.','d7e..','d7ez.','d7ex.','d7ew.','d7e7.','d7e5.','d7e6.','d7e4.','d7e3.','d7e2.','d7e1.','d7d..','d7d4.','d7d3.','d7d2.','d7d1.','d7c..','d7cy.','d7c9.','d7c8.','d7c7.','d7c6.','d7c5.','d7c4.','d7c3.','d7c2.','d7c1.','d7b..','d7b3.','d7b2.','d7b1.','d7b9.','d7b8.','d7b7.','d7b6.','d7b5.','d7b4.','d79..','d79z.','d79y.','d794.','d793.','d792.','d791.','d77..','d77z.','d77y.','d77x.','d77w.','d772.','d771.','d777.','d776.','d775.','d774.','d773.','d78..','d78z.','d78y.','d782.','d781.','d76..','d76z.','d76y.','d76x.','d76w.','d766.','d765.','d764.','d763.','d762.','d761.','d75..','d75z.','d75y.','d75A.','d759.','d756.','d755.','d754.','d753.','d752.','d751.','d74..','d74z.','d741.','d73..','d73z.','d73y.','d73x.','d73w.','d73v.','d73u.','d73t.','d73s.','d73r.','d739.','d738.','d737.','d736.','d735.','d734.','d733.','d732.','d731.','d72..','d72z.','d72y.','d722.','d721.','d7h..','d7h4.','d7h3.','d7h2.','d7h1.','d7h8.','d7h7.','d7h6.','d7h5.','d71..','d71z.','d71y.','d71w.','d71v.','d71u.','d71j.','d71i.','d71h.','d713.','d712.','d711.','d71g.','d71f.','d71e.','d71d.','d71c.','d71b.','d71a.','d719.','d718.','d717.','d716.','d715.','d714.','d53..','d532.','d531.','d52..','d52x.','d52w.','d52v.','d52u.','d52t.','d52s.','d52a.','d529.','d52C.','d52B.','d52A.','d528.','d527.','d526.','d525.','d524.','d523.','d522.','d521.','d51..','d51z.','d51y.','d51x.','d51w.','d51v.','d51u.','d51t.','d51s.','d51a.','d519.','d518.','d517.','d516.','d515.','d514.','d513.','d512.','d511.','d4h..','d4hz.','d4hy.','d4hx.','d4hw.','d4hv.','d4hu.','d4ht.','d4hs.','d4hr.','d4h9.','d4hA.','d4h8.','d4h7.','d4h6.','d4h5.','d4h4.','d4h3.','d4h2.','d4h1.','d4b..','d4bz.','d4by.','d4bx.','d4b6.','d4b5.','d4b4.','d4b3.','d4b2.','d4b1.','d46..','d46z.','d46y.','d46x.','d463.','d462.','d461.','d45..','d45z.','d451.','d82..','d82z.','d82y.','d822.','d821.','d84..','d84z.','d841.','d81..','d81z.','d811.','d85..','d854.','d852.','d853.','d851.','d83..','d83z.','d831.','dw2..','dw2z.','dw2y.','dw2x.','dw2w.','dw2v.','dw2u.','dw2t.','dw2s.','dw28.','dw27.','dw26.','dw25.','dw24.','dw23.','dw22.','dw21.','gde..','gdez.','gdey.','gdex.','gdew.','gde4.','gde3.','gde2.','gde1.','d917.','d916.','d915.','d914.','d913.','d912.','d911.','m35..','m351.','m352.','o58..','o58z.','o581.')
	and EntryDate >= '2015-01-01'
	and EntryDate <= '2020-05-14'
	group by PatID, EntryDate
) sub 
group by EntryDate

PRINT 'Date,IncidenceOfAntidepressants,PrevalenceOfAntidepressants'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.EntryDate = d.date
order by date;
