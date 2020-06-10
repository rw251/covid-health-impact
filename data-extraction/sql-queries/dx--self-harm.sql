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
	where ReadCode in ('K048.00','SL...97','SL...98','SL5..99','SL5y000','SL5y199','SL70511','SL83200','SL83x00','SL84.00','SL92.00','SL92100','SL97z00','SLHz.98','SLHz.99','SyuFF00','SyuFH00','SyuFJ00','SyuFK00','SyuFL00','SyuFd00','T....98','TK...97','TK...98','TK...99','TK01011','TK01200','TK01411','TK01500','TK01511','TK05.98','TK05.99','TK08.00','TK1..98','TK1..99','TK20.98','TK20.99','TK30.98','TK30.99','TK31.98','TK31.99','TK4..98','TK4..99','TK5..98','TK5..99','TK55.00','TK6..98','TK6..99','TK7..98','TK7..99','TKx0100','TKz..98','TKz..99','U200200','U200300','U200700','U201100','U201200','U201300','U201400','U201500','U201600','U201700','U201y00','U202100','U202200','U202300','U202500','U202600','U202700','U203.00','U203000','U203100','U203200','U203300','U203400','U203500','U203600','U203700','U203y00','U203z00','U204200','U204300','U204400','U204500','U204600','U204700','U205100','U205200','U205300','U205400','U205500','U205600','U205700','U206100','U206200','U206300','U206500','U206600','U206700','U207100','U207200','U207300','U207400','U207500','U207600','U207700','U207y00','U208100','U208200','U208300','U208500','U208600','U208700','U209100','U209500','U209700','U20A100','U20A200','U20A300','U20A500','U20A600','U20A700','U20B100','U20B300','U20B400','U20B500','U20B600','U20B700','U20C100','U20C200','U20C300','U20C400','U20C500','U20C600','U20C700','U20Cz00','U20y100','U20y300','U20y400','U20y500','U20y600','U20y700','U20yy00','U214.00','U223.00','U224.00','U225.00','U226.00','U227.00','U230.00','U231.00','U232.00','U233.00','U234.00','U235.00','U236.00','U237.00','U23y.00','U23z.00','U240.00','U243.00','U244.00','U245.00','U247.00','U24y.00','U24z.00','U251.00','U252.00','U253.00','U254.00','U255.00','U256.00','U257.00','U25y.00','U25z.00','U260.00','U261.00','U262.00','U263.00','U264.00','U265.00','U266.00','U267.00','U26y.00','U26z.00','U271.00','U272.00','U273.00','U275.00','U276.00','U277.00','U281.00','U283.00','U284.00','U285.00','U286.00','U287.00','U28y.00','U293.00','U297.00','U2A4.00','U2A5.00','U2A6.00','U2A7.00','U2Ay.00','U2B3.00','U2B5.00','U2B7.00','U2C0.00','U2C2.00','U2C3.00','U2C5.00','U2C6.00','U2C7.00','U2Cz.00','U2D1.00','U2D3.00','U2D5.00','U2D7.00','U2Dy.00','U2y2.00','U2y3.00','U2y4.00','U2y5.00','U2y7.00','U2z3.00','U2z4.00','U2z5.00','U2z6.00','U2z7.00','U400000','U400100','U400200','U400300','U400400','U400500','U400600','U400700','U400y00','U400z00','U401.00','U401000','U401100','U401200','U401300','U401400','U401500','U401600','U401700','U401y00','U401z00','U402000','U402100','U402200','U402300','U402400','U402500','U402600','U402700','U402y00','U403.00','U403000','U403100','U403200','U403300','U403400','U403500','U403600','U403700','U403y00','U403z00','U404000','U404100','U404200','U404400','U404500','U404600','U404700','U404y00','U404z00','U407.00','U407000','U407100','U407200','U407300','U407400','U407500','U407600','U407700','U407y00','U407z00','U408100','U408200','U408300','U408500','U408600','U408700','U408y00','U409300','U409500','U409600','U409700','U409y00','U40B000','U40B100','U40B200','U40B300','U40B500','U40B600','U40B700','U40C100','U40C200','U40C300','U40C400','U40C500','U40C600','U40C700','U40Cy00','U40Cz00','U40y100','U40y200','U40y300','U40y500','U40y700','U411.00','U412.00','U413.00','U414.00','U415.00','U416.00','U417.00','U41y.00','ZX...00','ZX...11','ZX1..00','ZX1..11','ZX1..12','ZX1..13','ZX1..14','ZX13.00','ZX13.11','ZX13100','ZX13200','ZX1H100','ZX1J.00','ZX1L.00','ZX1L100','ZX1L200','ZX1L300','ZX1L500','ZX1L600','ZX1L700','ZX1L800','ZX1L811','ZX1L900','ZX1L911','ZX1LA00','ZX1LB00','ZX1LC00','ZX1LD00','ZX1M.00','ZX1N.00','146A.00','146B.00','14K..00','14K0.00','14K1.00','1JP..00','SL...14','SL...15','SL...16','SL5..00','SL5..11','SL5..12','SL50.00','SL50.11','SL50.12','SL50000','SL50400','SL50500','SL50600','SL50700','SL50z00','SL51.00','SL51000','SL51100','SL51z00','SL52.00','SL52100','SL52200','SL52z00','SL53100','SL54200','SL54300','SL54400','SL5x.00','SL5xz00','SL5y.00','SL5y100','SL5y200','SL5yz00','SL5z.00','SL7..00','SL7..11','SL7..12','SL70.00','SL70400','SL70z00','SL76.00','SL7y.00','SL7z.00','SL7z.11','SL8..00','SL8..11','SL80.00','SL80z00','SL9..00','SL90.00','SL90000','SL90100','SL90200','SL90211','SL90300','SL90z00','SL91.00','SL91000','SL91100','SL91200','SL91300','SL91400','SL91z00','SL92000','SL92200','SL92z00','SL93.00','SL94.00','SL94000','SL94100','SL94200','SL94300','SL94400','SL94500','SL94600','SL94z00','SL95.00','SL95000','SL95z00','SL97.00','SL97.11','SL9y.00','SL9z.00','SLA..00','SLAy.00','SLAz.00','SLB..00','SLC0200','SLC0400','SLHyz00','SLHz.00','SLX..00','SLz..00','SyuF.00','SyuFA00','SyuFG00','SyuFM00','SyuFc00','TK...00','TK...11','TK...12','TK...13','TK...14','TK...15','TK...17','TK0..00','TK00.00','TK01.00','TK01000','TK01100','TK01300','TK01400','TK01z00','TK02.00','TK03.00','TK04.00','TK05.00','TK06.00','TK07.00','TK0z.00','TK1..00','TK10.00','TK11.00','TK1y.00','TK1z.00','TK2..00','TK20.00','TK21.00','TK2y.00','TK2z.00','TK3..00','TK30.00','TK31.00','TK3y.00','TK3z.00','TK4..00','TK5..00','TK50.00','TK51.00','TK52.00','TK53.00','TK54.00','TK5z.00','TK6..00','TK60.00','TK60100','TK60111','TK61.00','TK6z.00','TK7..00','TK70.00','TK71.00','TK72.00','TK7z.00','TKx..00','TKx0.00','TKx0000','TKx0z00','TKx1.00','TKx2.00','TKx3.00','TKx4.00','TKx5.00','TKx6.00','TKx7.00','TKxy.00','TKxz.00','TKy..00','TKz..00','TN3..00','TN3z.00','TN6..00','TN60.00','TN61.00','TN6z.00','TN84.00','U2...00','U2...11','U2...12','U2...13','U2...14','U2...15','U20..00','U20..11','U200.00','U200.11','U200.12','U200.13','U200000','U200100','U200400','U200500','U200600','U200y00','U200z00','U201.00','U201000','U201z00','U202.00','U202.11','U202.12','U202.13','U202.14','U202.15','U202.16','U202.17','U202.18','U202000','U202400','U202y00','U202z00','U204.00','U204.11','U204.12','U204.13','U204000','U204100','U204y00','U204z00','U205.00','U205000','U205y00','U205z00','U206.00','U206000','U206400','U206y00','U206z00','U207.00','U207000','U207z00','U208.00','U208000','U208400','U208y00','U208z00','U209.00','U209000','U209200','U209300','U209400','U209600','U209y00','U209z00','U20A.00','U20A.11','U20A000','U20A400','U20Ay00','U20Az00','U20B.00','U20B.11','U20B000','U20B200','U20By00','U20Bz00','U20C.00','U20C.11','U20C.12','U20C000','U20Cy00','U20y.00','U20y000','U20y200','U20yz00','U21..00','U210.00','U211.00','U213.00','U215.00','U216.00','U217.00','U21y.00','U21z.00','U22..00','U220.00','U221.00','U222.00','U22y.00','U22z.00','U23..00','U24..00','U241.00','U25..00','U250.00','U26..00','U27..00','U270.00','U274.00','U27y.00','U27z.00','U28..00','U280.00','U282.00','U28z.00','U29..00','U290.00','U291.00','U292.00','U294.00','U295.00','U296.00','U29y.00','U29z.00','U2A..00','U2A0.00','U2A1.00','U2A2.00','U2A3.00','U2Az.00','U2B..00','U2B0.00','U2B1.00','U2B2.00','U2B4.00','U2B6.00','U2By.00','U2Bz.00','U2C..00','U2C1.00','U2C4.00','U2Cy.00','U2D..00','U2D0.00','U2D2.00','U2D4.00','U2D6.00','U2Dz.00','U2E..00','U2y..00','U2y0.00','U2y1.00','U2y6.00','U2yy.00','U2yz.00','U2z..00','U2z0.00','U2z1.00','U2z2.00','U2zy.00','U2zz.00','U30..11','U40..00','U400.00','U402.00','U402z00','U404.00','U404300','U408.00','U408000','U408400','U408z00','U409.00','U409000','U409100','U409200','U409400','U409z00','U40B.00','U40B400','U40By00','U40Bz00','U40C.00','U40C000','U40y.00','U40y000','U40y400','U40y600','U40yy00','U40yz00','U41..00','U410.00','U41z.00','U72..00','U720.00','ZV15600','ZV1B200','','K048.','SL5y0','SL832','SL83x','SL84.','SL92.','SL921','SL97z','SyuFF','SyuFH','SyuFJ','SyuFK','SyuFL','SyuFd','TK012','TK015','TK08.','TK55.','TKx01','U2002','U2003','U2007','U2011','U2012','U2013','U2014','U2015','U2016','U2017','U201y','U2021','U2022','U2023','U2025','U2026','U2027','U203.','U2030','U2031','U2032','U2033','U2034','U2035','U2036','U2037','U203y','U203z','U2042','U2043','U2044','U2045','U2046','U2047','U2051','U2052','U2053','U2054','U2055','U2056','U2057','U2061','U2062','U2063','U2065','U2066','U2067','U2071','U2072','U2073','U2074','U2075','U2076','U2077','U207y','U2081','U2082','U2083','U2085','U2086','U2087','U2091','U2095','U2097','U20A1','U20A2','U20A3','U20A5','U20A6','U20A7','U20B1','U20B3','U20B4','U20B5','U20B6','U20B7','U20C1','U20C2','U20C3','U20C4','U20C5','U20C6','U20C7','U20Cz','U20y1','U20y3','U20y4','U20y5','U20y6','U20y7','U20yy','U214.','U223.','U224.','U225.','U226.','U227.','U230.','U231.','U232.','U233.','U234.','U235.','U236.','U237.','U23y.','U23z.','U240.','U243.','U244.','U245.','U247.','U24y.','U24z.','U251.','U252.','U253.','U254.','U255.','U256.','U257.','U25y.','U25z.','U260.','U261.','U262.','U263.','U264.','U265.','U266.','U267.','U26y.','U26z.','U271.','U272.','U273.','U275.','U276.','U277.','U281.','U283.','U284.','U285.','U286.','U287.','U28y.','U293.','U297.','U2A4.','U2A5.','U2A6.','U2A7.','U2Ay.','U2B3.','U2B5.','U2B7.','U2C0.','U2C2.','U2C3.','U2C5.','U2C6.','U2C7.','U2Cz.','U2D1.','U2D3.','U2D5.','U2D7.','U2Dy.','U2y2.','U2y3.','U2y4.','U2y5.','U2y7.','U2z3.','U2z4.','U2z5.','U2z6.','U2z7.','U4000','U4001','U4002','U4003','U4004','U4005','U4006','U4007','U400y','U400z','U401.','U4010','U4011','U4012','U4013','U4014','U4015','U4016','U4017','U401y','U401z','U4020','U4021','U4022','U4023','U4024','U4025','U4026','U4027','U402y','U403.','U4030','U4031','U4032','U4033','U4034','U4035','U4036','U4037','U403y','U403z','U4040','U4041','U4042','U4044','U4045','U4046','U4047','U404y','U404z','U407.','U4070','U4071','U4072','U4073','U4074','U4075','U4076','U4077','U407y','U407z','U4081','U4082','U4083','U4085','U4086','U4087','U408y','U4093','U4095','U4096','U4097','U409y','U40B0','U40B1','U40B2','U40B3','U40B5','U40B6','U40B7','U40C1','U40C2','U40C3','U40C4','U40C5','U40C6','U40C7','U40Cy','U40Cz','U40y1','U40y2','U40y3','U40y5','U40y7','U411.','U412.','U413.','U414.','U415.','U416.','U417.','U41y.','ZX...','ZX1..','ZX13.','ZX131','ZX132','ZX1H1','ZX1J.','ZX1L.','ZX1L1','ZX1L2','ZX1L3','ZX1L5','ZX1L6','ZX1L7','ZX1L8','ZX1L9','ZX1LA','ZX1LB','ZX1LC','ZX1LD','ZX1M.','ZX1N.','146A.','146B.','14K..','14K0.','14K1.','1JP..','SL5..','SL50.','SL500','SL504','SL505','SL506','SL507','SL50z','SL51.','SL510','SL511','SL51z','SL52.','SL521','SL522','SL52z','SL531','SL542','SL543','SL544','SL5x.','SL5xz','SL5y.','SL5y1','SL5y2','SL5yz','SL5z.','SL7..','SL70.','SL704','SL70z','SL76.','SL7y.','SL7z.','SL8..','SL80.','SL80z','SL9..','SL90.','SL900','SL901','SL902','SL903','SL90z','SL91.','SL910','SL911','SL912','SL913','SL914','SL91z','SL920','SL922','SL92z','SL93.','SL94.','SL940','SL941','SL942','SL943','SL944','SL945','SL946','SL94z','SL95.','SL950','SL95z','SL97.','SL9y.','SL9z.','SLA..','SLAy.','SLAz.','SLB..','SLC02','SLC04','SLHyz','SLHz.','SLX..','SLz..','SyuF.','SyuFA','SyuFG','SyuFM','SyuFc','TK...','TK0..','TK00.','TK01.','TK010','TK011','TK013','TK014','TK01z','TK02.','TK03.','TK04.','TK05.','TK06.','TK07.','TK0z.','TK1..','TK10.','TK11.','TK1y.','TK1z.','TK2..','TK20.','TK21.','TK2y.','TK2z.','TK3..','TK30.','TK31.','TK3y.','TK3z.','TK4..','TK5..','TK50.','TK51.','TK52.','TK53.','TK54.','TK5z.','TK6..','TK60.','TK601','TK61.','TK6z.','TK7..','TK70.','TK71.','TK72.','TK7z.','TKx..','TKx0.','TKx00','TKx0z','TKx1.','TKx2.','TKx3.','TKx4.','TKx5.','TKx6.','TKx7.','TKxy.','TKxz.','TKy..','TKz..','TN3..','TN3z.','TN6..','TN60.','TN61.','TN6z.','TN84.','U2...','U20..','U200.','U2000','U2001','U2004','U2005','U2006','U200y','U200z','U201.','U2010','U201z','U202.','U2020','U2024','U202y','U202z','U204.','U2040','U2041','U204y','U204z','U205.','U2050','U205y','U205z','U206.','U2060','U2064','U206y','U206z','U207.','U2070','U207z','U208.','U2080','U2084','U208y','U208z','U209.','U2090','U2092','U2093','U2094','U2096','U209y','U209z','U20A.','U20A0','U20A4','U20Ay','U20Az','U20B.','U20B0','U20B2','U20By','U20Bz','U20C.','U20C0','U20Cy','U20y.','U20y0','U20y2','U20yz','U21..','U210.','U211.','U213.','U215.','U216.','U217.','U21y.','U21z.','U22..','U220.','U221.','U222.','U22y.','U22z.','U23..','U24..','U241.','U25..','U250.','U26..','U27..','U270.','U274.','U27y.','U27z.','U28..','U280.','U282.','U28z.','U29..','U290.','U291.','U292.','U294.','U295.','U296.','U29y.','U29z.','U2A..','U2A0.','U2A1.','U2A2.','U2A3.','U2Az.','U2B..','U2B0.','U2B1.','U2B2.','U2B4.','U2B6.','U2By.','U2Bz.','U2C..','U2C1.','U2C4.','U2Cy.','U2D..','U2D0.','U2D2.','U2D4.','U2D6.','U2Dz.','U2E..','U2y..','U2y0.','U2y1.','U2y6.','U2yy.','U2yz.','U2z..','U2z0.','U2z1.','U2z2.','U2zy.','U2zz.','U40..','U400.','U402.','U402z','U404.','U4043','U408.','U4080','U4084','U408z','U409.','U4090','U4091','U4092','U4094','U409z','U40B.','U40B4','U40By','U40Bz','U40C.','U40C0','U40y.','U40y0','U40y4','U40y6','U40yy','U40yz','U41..','U410.','U41z.','U72..','U720.','ZV156','ZV1B2')
	and entrydate <= '2020-06-10'
	group by NHSNo
) sub 
where FirstDiagnosis >= '2009-12-28'
group by FirstDiagnosis

-- Populate prevalence table - count all occurrences of the 
-- code irrespective of whether it is the first time the patient has had it
select entrydate, count(*) as num into #Prevalence from (
	select NHSNo, entrydate from journal
	where ReadCode in ('K048.00','SL...97','SL...98','SL5..99','SL5y000','SL5y199','SL70511','SL83200','SL83x00','SL84.00','SL92.00','SL92100','SL97z00','SLHz.98','SLHz.99','SyuFF00','SyuFH00','SyuFJ00','SyuFK00','SyuFL00','SyuFd00','T....98','TK...97','TK...98','TK...99','TK01011','TK01200','TK01411','TK01500','TK01511','TK05.98','TK05.99','TK08.00','TK1..98','TK1..99','TK20.98','TK20.99','TK30.98','TK30.99','TK31.98','TK31.99','TK4..98','TK4..99','TK5..98','TK5..99','TK55.00','TK6..98','TK6..99','TK7..98','TK7..99','TKx0100','TKz..98','TKz..99','U200200','U200300','U200700','U201100','U201200','U201300','U201400','U201500','U201600','U201700','U201y00','U202100','U202200','U202300','U202500','U202600','U202700','U203.00','U203000','U203100','U203200','U203300','U203400','U203500','U203600','U203700','U203y00','U203z00','U204200','U204300','U204400','U204500','U204600','U204700','U205100','U205200','U205300','U205400','U205500','U205600','U205700','U206100','U206200','U206300','U206500','U206600','U206700','U207100','U207200','U207300','U207400','U207500','U207600','U207700','U207y00','U208100','U208200','U208300','U208500','U208600','U208700','U209100','U209500','U209700','U20A100','U20A200','U20A300','U20A500','U20A600','U20A700','U20B100','U20B300','U20B400','U20B500','U20B600','U20B700','U20C100','U20C200','U20C300','U20C400','U20C500','U20C600','U20C700','U20Cz00','U20y100','U20y300','U20y400','U20y500','U20y600','U20y700','U20yy00','U214.00','U223.00','U224.00','U225.00','U226.00','U227.00','U230.00','U231.00','U232.00','U233.00','U234.00','U235.00','U236.00','U237.00','U23y.00','U23z.00','U240.00','U243.00','U244.00','U245.00','U247.00','U24y.00','U24z.00','U251.00','U252.00','U253.00','U254.00','U255.00','U256.00','U257.00','U25y.00','U25z.00','U260.00','U261.00','U262.00','U263.00','U264.00','U265.00','U266.00','U267.00','U26y.00','U26z.00','U271.00','U272.00','U273.00','U275.00','U276.00','U277.00','U281.00','U283.00','U284.00','U285.00','U286.00','U287.00','U28y.00','U293.00','U297.00','U2A4.00','U2A5.00','U2A6.00','U2A7.00','U2Ay.00','U2B3.00','U2B5.00','U2B7.00','U2C0.00','U2C2.00','U2C3.00','U2C5.00','U2C6.00','U2C7.00','U2Cz.00','U2D1.00','U2D3.00','U2D5.00','U2D7.00','U2Dy.00','U2y2.00','U2y3.00','U2y4.00','U2y5.00','U2y7.00','U2z3.00','U2z4.00','U2z5.00','U2z6.00','U2z7.00','U400000','U400100','U400200','U400300','U400400','U400500','U400600','U400700','U400y00','U400z00','U401.00','U401000','U401100','U401200','U401300','U401400','U401500','U401600','U401700','U401y00','U401z00','U402000','U402100','U402200','U402300','U402400','U402500','U402600','U402700','U402y00','U403.00','U403000','U403100','U403200','U403300','U403400','U403500','U403600','U403700','U403y00','U403z00','U404000','U404100','U404200','U404400','U404500','U404600','U404700','U404y00','U404z00','U407.00','U407000','U407100','U407200','U407300','U407400','U407500','U407600','U407700','U407y00','U407z00','U408100','U408200','U408300','U408500','U408600','U408700','U408y00','U409300','U409500','U409600','U409700','U409y00','U40B000','U40B100','U40B200','U40B300','U40B500','U40B600','U40B700','U40C100','U40C200','U40C300','U40C400','U40C500','U40C600','U40C700','U40Cy00','U40Cz00','U40y100','U40y200','U40y300','U40y500','U40y700','U411.00','U412.00','U413.00','U414.00','U415.00','U416.00','U417.00','U41y.00','ZX...00','ZX...11','ZX1..00','ZX1..11','ZX1..12','ZX1..13','ZX1..14','ZX13.00','ZX13.11','ZX13100','ZX13200','ZX1H100','ZX1J.00','ZX1L.00','ZX1L100','ZX1L200','ZX1L300','ZX1L500','ZX1L600','ZX1L700','ZX1L800','ZX1L811','ZX1L900','ZX1L911','ZX1LA00','ZX1LB00','ZX1LC00','ZX1LD00','ZX1M.00','ZX1N.00','146A.00','146B.00','14K..00','14K0.00','14K1.00','1JP..00','SL...14','SL...15','SL...16','SL5..00','SL5..11','SL5..12','SL50.00','SL50.11','SL50.12','SL50000','SL50400','SL50500','SL50600','SL50700','SL50z00','SL51.00','SL51000','SL51100','SL51z00','SL52.00','SL52100','SL52200','SL52z00','SL53100','SL54200','SL54300','SL54400','SL5x.00','SL5xz00','SL5y.00','SL5y100','SL5y200','SL5yz00','SL5z.00','SL7..00','SL7..11','SL7..12','SL70.00','SL70400','SL70z00','SL76.00','SL7y.00','SL7z.00','SL7z.11','SL8..00','SL8..11','SL80.00','SL80z00','SL9..00','SL90.00','SL90000','SL90100','SL90200','SL90211','SL90300','SL90z00','SL91.00','SL91000','SL91100','SL91200','SL91300','SL91400','SL91z00','SL92000','SL92200','SL92z00','SL93.00','SL94.00','SL94000','SL94100','SL94200','SL94300','SL94400','SL94500','SL94600','SL94z00','SL95.00','SL95000','SL95z00','SL97.00','SL97.11','SL9y.00','SL9z.00','SLA..00','SLAy.00','SLAz.00','SLB..00','SLC0200','SLC0400','SLHyz00','SLHz.00','SLX..00','SLz..00','SyuF.00','SyuFA00','SyuFG00','SyuFM00','SyuFc00','TK...00','TK...11','TK...12','TK...13','TK...14','TK...15','TK...17','TK0..00','TK00.00','TK01.00','TK01000','TK01100','TK01300','TK01400','TK01z00','TK02.00','TK03.00','TK04.00','TK05.00','TK06.00','TK07.00','TK0z.00','TK1..00','TK10.00','TK11.00','TK1y.00','TK1z.00','TK2..00','TK20.00','TK21.00','TK2y.00','TK2z.00','TK3..00','TK30.00','TK31.00','TK3y.00','TK3z.00','TK4..00','TK5..00','TK50.00','TK51.00','TK52.00','TK53.00','TK54.00','TK5z.00','TK6..00','TK60.00','TK60100','TK60111','TK61.00','TK6z.00','TK7..00','TK70.00','TK71.00','TK72.00','TK7z.00','TKx..00','TKx0.00','TKx0000','TKx0z00','TKx1.00','TKx2.00','TKx3.00','TKx4.00','TKx5.00','TKx6.00','TKx7.00','TKxy.00','TKxz.00','TKy..00','TKz..00','TN3..00','TN3z.00','TN6..00','TN60.00','TN61.00','TN6z.00','TN84.00','U2...00','U2...11','U2...12','U2...13','U2...14','U2...15','U20..00','U20..11','U200.00','U200.11','U200.12','U200.13','U200000','U200100','U200400','U200500','U200600','U200y00','U200z00','U201.00','U201000','U201z00','U202.00','U202.11','U202.12','U202.13','U202.14','U202.15','U202.16','U202.17','U202.18','U202000','U202400','U202y00','U202z00','U204.00','U204.11','U204.12','U204.13','U204000','U204100','U204y00','U204z00','U205.00','U205000','U205y00','U205z00','U206.00','U206000','U206400','U206y00','U206z00','U207.00','U207000','U207z00','U208.00','U208000','U208400','U208y00','U208z00','U209.00','U209000','U209200','U209300','U209400','U209600','U209y00','U209z00','U20A.00','U20A.11','U20A000','U20A400','U20Ay00','U20Az00','U20B.00','U20B.11','U20B000','U20B200','U20By00','U20Bz00','U20C.00','U20C.11','U20C.12','U20C000','U20Cy00','U20y.00','U20y000','U20y200','U20yz00','U21..00','U210.00','U211.00','U213.00','U215.00','U216.00','U217.00','U21y.00','U21z.00','U22..00','U220.00','U221.00','U222.00','U22y.00','U22z.00','U23..00','U24..00','U241.00','U25..00','U250.00','U26..00','U27..00','U270.00','U274.00','U27y.00','U27z.00','U28..00','U280.00','U282.00','U28z.00','U29..00','U290.00','U291.00','U292.00','U294.00','U295.00','U296.00','U29y.00','U29z.00','U2A..00','U2A0.00','U2A1.00','U2A2.00','U2A3.00','U2Az.00','U2B..00','U2B0.00','U2B1.00','U2B2.00','U2B4.00','U2B6.00','U2By.00','U2Bz.00','U2C..00','U2C1.00','U2C4.00','U2Cy.00','U2D..00','U2D0.00','U2D2.00','U2D4.00','U2D6.00','U2Dz.00','U2E..00','U2y..00','U2y0.00','U2y1.00','U2y6.00','U2yy.00','U2yz.00','U2z..00','U2z0.00','U2z1.00','U2z2.00','U2zy.00','U2zz.00','U30..11','U40..00','U400.00','U402.00','U402z00','U404.00','U404300','U408.00','U408000','U408400','U408z00','U409.00','U409000','U409100','U409200','U409400','U409z00','U40B.00','U40B400','U40By00','U40Bz00','U40C.00','U40C000','U40y.00','U40y000','U40y400','U40y600','U40yy00','U40yz00','U41..00','U410.00','U41z.00','U72..00','U720.00','ZV15600','ZV1B200','','K048.','SL5y0','SL832','SL83x','SL84.','SL92.','SL921','SL97z','SyuFF','SyuFH','SyuFJ','SyuFK','SyuFL','SyuFd','TK012','TK015','TK08.','TK55.','TKx01','U2002','U2003','U2007','U2011','U2012','U2013','U2014','U2015','U2016','U2017','U201y','U2021','U2022','U2023','U2025','U2026','U2027','U203.','U2030','U2031','U2032','U2033','U2034','U2035','U2036','U2037','U203y','U203z','U2042','U2043','U2044','U2045','U2046','U2047','U2051','U2052','U2053','U2054','U2055','U2056','U2057','U2061','U2062','U2063','U2065','U2066','U2067','U2071','U2072','U2073','U2074','U2075','U2076','U2077','U207y','U2081','U2082','U2083','U2085','U2086','U2087','U2091','U2095','U2097','U20A1','U20A2','U20A3','U20A5','U20A6','U20A7','U20B1','U20B3','U20B4','U20B5','U20B6','U20B7','U20C1','U20C2','U20C3','U20C4','U20C5','U20C6','U20C7','U20Cz','U20y1','U20y3','U20y4','U20y5','U20y6','U20y7','U20yy','U214.','U223.','U224.','U225.','U226.','U227.','U230.','U231.','U232.','U233.','U234.','U235.','U236.','U237.','U23y.','U23z.','U240.','U243.','U244.','U245.','U247.','U24y.','U24z.','U251.','U252.','U253.','U254.','U255.','U256.','U257.','U25y.','U25z.','U260.','U261.','U262.','U263.','U264.','U265.','U266.','U267.','U26y.','U26z.','U271.','U272.','U273.','U275.','U276.','U277.','U281.','U283.','U284.','U285.','U286.','U287.','U28y.','U293.','U297.','U2A4.','U2A5.','U2A6.','U2A7.','U2Ay.','U2B3.','U2B5.','U2B7.','U2C0.','U2C2.','U2C3.','U2C5.','U2C6.','U2C7.','U2Cz.','U2D1.','U2D3.','U2D5.','U2D7.','U2Dy.','U2y2.','U2y3.','U2y4.','U2y5.','U2y7.','U2z3.','U2z4.','U2z5.','U2z6.','U2z7.','U4000','U4001','U4002','U4003','U4004','U4005','U4006','U4007','U400y','U400z','U401.','U4010','U4011','U4012','U4013','U4014','U4015','U4016','U4017','U401y','U401z','U4020','U4021','U4022','U4023','U4024','U4025','U4026','U4027','U402y','U403.','U4030','U4031','U4032','U4033','U4034','U4035','U4036','U4037','U403y','U403z','U4040','U4041','U4042','U4044','U4045','U4046','U4047','U404y','U404z','U407.','U4070','U4071','U4072','U4073','U4074','U4075','U4076','U4077','U407y','U407z','U4081','U4082','U4083','U4085','U4086','U4087','U408y','U4093','U4095','U4096','U4097','U409y','U40B0','U40B1','U40B2','U40B3','U40B5','U40B6','U40B7','U40C1','U40C2','U40C3','U40C4','U40C5','U40C6','U40C7','U40Cy','U40Cz','U40y1','U40y2','U40y3','U40y5','U40y7','U411.','U412.','U413.','U414.','U415.','U416.','U417.','U41y.','ZX...','ZX1..','ZX13.','ZX131','ZX132','ZX1H1','ZX1J.','ZX1L.','ZX1L1','ZX1L2','ZX1L3','ZX1L5','ZX1L6','ZX1L7','ZX1L8','ZX1L9','ZX1LA','ZX1LB','ZX1LC','ZX1LD','ZX1M.','ZX1N.','146A.','146B.','14K..','14K0.','14K1.','1JP..','SL5..','SL50.','SL500','SL504','SL505','SL506','SL507','SL50z','SL51.','SL510','SL511','SL51z','SL52.','SL521','SL522','SL52z','SL531','SL542','SL543','SL544','SL5x.','SL5xz','SL5y.','SL5y1','SL5y2','SL5yz','SL5z.','SL7..','SL70.','SL704','SL70z','SL76.','SL7y.','SL7z.','SL8..','SL80.','SL80z','SL9..','SL90.','SL900','SL901','SL902','SL903','SL90z','SL91.','SL910','SL911','SL912','SL913','SL914','SL91z','SL920','SL922','SL92z','SL93.','SL94.','SL940','SL941','SL942','SL943','SL944','SL945','SL946','SL94z','SL95.','SL950','SL95z','SL97.','SL9y.','SL9z.','SLA..','SLAy.','SLAz.','SLB..','SLC02','SLC04','SLHyz','SLHz.','SLX..','SLz..','SyuF.','SyuFA','SyuFG','SyuFM','SyuFc','TK...','TK0..','TK00.','TK01.','TK010','TK011','TK013','TK014','TK01z','TK02.','TK03.','TK04.','TK05.','TK06.','TK07.','TK0z.','TK1..','TK10.','TK11.','TK1y.','TK1z.','TK2..','TK20.','TK21.','TK2y.','TK2z.','TK3..','TK30.','TK31.','TK3y.','TK3z.','TK4..','TK5..','TK50.','TK51.','TK52.','TK53.','TK54.','TK5z.','TK6..','TK60.','TK601','TK61.','TK6z.','TK7..','TK70.','TK71.','TK72.','TK7z.','TKx..','TKx0.','TKx00','TKx0z','TKx1.','TKx2.','TKx3.','TKx4.','TKx5.','TKx6.','TKx7.','TKxy.','TKxz.','TKy..','TKz..','TN3..','TN3z.','TN6..','TN60.','TN61.','TN6z.','TN84.','U2...','U20..','U200.','U2000','U2001','U2004','U2005','U2006','U200y','U200z','U201.','U2010','U201z','U202.','U2020','U2024','U202y','U202z','U204.','U2040','U2041','U204y','U204z','U205.','U2050','U205y','U205z','U206.','U2060','U2064','U206y','U206z','U207.','U2070','U207z','U208.','U2080','U2084','U208y','U208z','U209.','U2090','U2092','U2093','U2094','U2096','U209y','U209z','U20A.','U20A0','U20A4','U20Ay','U20Az','U20B.','U20B0','U20B2','U20By','U20Bz','U20C.','U20C0','U20Cy','U20y.','U20y0','U20y2','U20yz','U21..','U210.','U211.','U213.','U215.','U216.','U217.','U21y.','U21z.','U22..','U220.','U221.','U222.','U22y.','U22z.','U23..','U24..','U241.','U25..','U250.','U26..','U27..','U270.','U274.','U27y.','U27z.','U28..','U280.','U282.','U28z.','U29..','U290.','U291.','U292.','U294.','U295.','U296.','U29y.','U29z.','U2A..','U2A0.','U2A1.','U2A2.','U2A3.','U2Az.','U2B..','U2B0.','U2B1.','U2B2.','U2B4.','U2B6.','U2By.','U2Bz.','U2C..','U2C1.','U2C4.','U2Cy.','U2D..','U2D0.','U2D2.','U2D4.','U2D6.','U2Dz.','U2E..','U2y..','U2y0.','U2y1.','U2y6.','U2yy.','U2yz.','U2z..','U2z0.','U2z1.','U2z2.','U2zy.','U2zz.','U40..','U400.','U402.','U402z','U404.','U4043','U408.','U4080','U4084','U408z','U409.','U4090','U4091','U4092','U4094','U409z','U40B.','U40B4','U40By','U40Bz','U40C.','U40C0','U40y.','U40y0','U40y4','U40y6','U40yy','U40yz','U41..','U410.','U41z.','U72..','U720.','ZV156','ZV1B2')
	and entrydate >= '2009-12-28'
	and entrydate <= '2020-06-10'
	group by NHSNo, entrydate
) sub 
group by entrydate

PRINT 'Date,IncidenceOfSelfHarm,PrevalenceOfSelfHarm'
select [date], ISNULL(i.num, 0), ISNULL(p.num, 0) from #AllDates d 
	left outer join #Incidence i on i.FirstDiagnosis = d.date
	left outer join #Prevalence p on p.entrydate = d.date
order by date;
