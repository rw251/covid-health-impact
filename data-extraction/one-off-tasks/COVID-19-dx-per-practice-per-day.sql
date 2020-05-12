
-- Get all the latest covid related codes and counts
select s.readcode, MAX(s.rubric) as description, MAX(s.count) as [count] from SIR_ReadCode_Rubric s inner join (
select readcode, max([count]) as num from SIR_ReadCode_Rubric
where (lower(rubric) like '%covid%' and lower(rubric) not like '%covidien%') or
(lower(rubric) like '%wuhan%') or
(lower(rubric) like '%ncov%' and lower(rubric) not like '%weincove%') or
(lower(rubric) like '%sars-cov%') or
(lower(rubric) like '%coronavirus%')
group by readcode) sub on sub.num = s.count and sub.readcode = s.readcode
group by s.readcode;
--save to disk

-- Get all the latest covid vulnerable patients codes and counts
select s.readcode, MAX(s.rubric) as description, MAX(s.count) as [count] from SIR_ReadCode_Rubric s inner join (
select readcode, max([count]) as num from SIR_ReadCode_Rubric
where readcode in ('1672211000006100','9d44.','9d44.00','Y228a','14Op.','14Op.00','14Oq.','14Oq.00','14Or.','14Or.00','1300561000000107','1300571000000100','1300591000000101','443999008')
group by readcode) sub on sub.num = s.count and sub.readcode = s.readcode
group by s.readcode;
--save to disk

--populate table with all dates from 2020-03-01
IF OBJECT_ID('tempdb..#AllDates') IS NOT NULL DROP TABLE #AllDates;
CREATE TABLE #AllDates ([date] date);
declare @dt datetime = '2020-03-01'
declare @dtEnd datetime = GETDATE();
WHILE (@dt <= @dtEnd) BEGIN
    insert into #AllDates([date])
        values(@dt)
    SET @dt = DATEADD(day, 1, @dt)
END;

-- for each date and each gp, number of incident cases
select a.date, practiceId, practiceListSize, sum(case when firstdx is null then 0 else 1 end) as newCases from #AllDates a
left outer join practiceListSizes pl on 1=1
left outer join (
select gpcode, firstdx from patients p inner join (
select PatID, min(EntryDate) as firstdx from SIR_ALL_Records_Narrow
where ReadCode in ('^ESCT1301230','H20y000','4J3R100','^ESCT1300228','^ESCT1300229','EMISNQCO303','A795.','A795100','A795200','^ESCT1301243','^ESCT1299074','^ESCT1301227','^ESCT1299113')
group by PatID ) minsub on minsub.PatID = p.patid
) sub on sub.firstdx = a.date and sub.gpcode = pl.practiceId COLLATE Latin1_General_100_CI_AI
group by practiceId,a.date, practiceListSize
order by practiceId, a.date

--save to disk

/*
-- not detected / excluded
4J3R200	2019-nCoV (novel coronavirus) not detected	9
^ESCT1301231	SARS-CoV-2 (severe acute respiratory syndrome coronavirus 2) not detected	2
^ESCT1299077	2019-nCoV (novel coronavirus) not detected	2
^ESCT1300244	COVID-19 excluded	14
^ESCT1300245	COVID-19 excluded by laboratory test	225
EMISNQEX59	Excluded 2019-nCoV (Wuhan) infection	29
1IP1.	COVID-19 excluded by laboratory test	1

-- test
43jS0	Coronavirus nucleic acid detection assay	1
4J3R.	2019-nCoV (novel coronavirus) serology	1
^ESCT1300234	Self-taken swab for SARS-CoV-2 (severe acute respiratory syndrome coronavirus 2) completed	2
EMISNQTE31	Tested for 2019-nCoV (novel coronavirus) infection	388
43jS1	Coronavirus ribonucleic acid detection assay	275
4JF6.	Taking of swab for SARS-CoV-2 (SARS coronavirus 2)	1
^ESCT1300236	Self-taken swab for SARS-CoV-2 (severe acute respiratory syndrome coronavirus 2) offered	1
^ESCT1300238	Swab for SARS-CoV-2 (severe acute respiratory syndrome coronavirus 2) taken by healthcare professional	1
43jS100	Coronavirus ribonucleic acid detection assay	1

--suspected
1JX..	Suspected coronavirus infection	77
^ESCT1299116	Suspected disease caused by 2019-nCoV (novel coronavirus)	588
^ESCT1301245	Suspected COVID-19	157
1JX1.	Suspected disease caused by 2019-nCoV (novel coronavirus)	182
EMISNQSU106	Suspected 2019-nCoV (Wuhan) infection	119
^ESCT1299041	Telephone consultation for suspected 2019-nCoV (novel coronavirus)	68
9N31200	Telephone consultation for suspected 2019-nCoV (novel corona	34

-- exposure
EMISNQEX58	Exposure to 2019-nCoV (Wuhan) infection	3
65PW.	Coronavirus contact	4
^ESCT1301217	Exposure to SARS-CoV-2 (severe acute respiratory syndrome coronavirus 2) infection	2
^ESCT1299035	Exposure to 2019-nCoV (novel coronavirus) infection	3
^ESCT1301218	Close exposure to SARS-CoV-2 (severe acute respiratory syndrome coronavirus 2) infection	3
65PW100	Exposure to 2019-nCoV (novel coronavirus) infection	10

-- dx
^ESCT1301230	SARS-CoV-2 (severe acute respiratory syndrome coronavirus 2) detected	7
H20y000	Severe acute respiratory syndrome - COVID19	1
4J3R100	2019-nCoV (novel coronavirus) detected	30
^ESCT1300228	COVID-19 confirmed by laboratory test	192
^ESCT1300229	COVID-19 confirmed using clinical diagnostic criteria	7
EMISNQCO303	Confirmed 2019-nCoV (novel coronavirus) infection	27
A795.	Coronavirus infection	33
A795100	Disease caused by 2019-nCoV (novel coronavirus)	25
A795200	COVID-19 confirmed by laboratory test	3
^ESCT1301243	COVID-19	15
^ESCT1299074	2019-nCoV (novel coronavirus) detected	1
^ESCT1301227	Pneumonia caused by SARS-CoV-2 (severe acute respiratory syndrome coronavirus 2)	1
^ESCT1299113	Disease caused by 2019-nCoV (novel coronavirus)	21

-- advice
^ESCT1301241	Advice given about SARS-CoV-2 (severe acute respiratory syndrome coronavirus 2) by telephone	2
8HkjC00	Signposting to CHMS (COVID-19 Home Management Service)	1
^ESCT1300255	Provision of advice, assessment or treatment limited due to COVID-19 pandemic	10
^ESCT1299104	Advice given about 2019-nCoV (novel coronavirus) infection	223
8CAO.	Advice given about 2019-nCoV (novel coronavirus) infection	791
8CAO100	Advice given about 2019-nCoV (novel coronavirus) by telephon	363
^ESCT1301239	Educated about SARS-CoV-2 (severe acute respiratory syndrome coronavirus 2) infection	10
^ESCT1301240	Advice given about SARS-CoV-2 (severe acute respiratory syndrome coronavirus 2) infection	350
^ESCT1299101	Educated about 2019-nCoV (novel coronavirus) infection	41
^ESCT1299107	Advice given about 2019-nCoV (novel coronavirus) by telephone	49

--risk categorisation
^ESCT1300222	High risk category for developing complication from COVID-19 infection	3437
^ESCT1300223	Moderate risk category for developing complication from COVID-19 infection	348
^ESCT1299080	High priority for 2019-nCoV (novel coronavirus) vaccination	1
14Oq.	Moderate risk category for developing complication COVID-19	2259
14Or.	High risk category for developing complication from COVID-19	3247
^ESCT1300224	Low risk category for developing complication from COVID-19 infection	68
*/