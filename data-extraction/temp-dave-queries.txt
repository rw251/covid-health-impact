
--Top diagnoses in 6 weeks from March 2019
-- Number of Dx codes
select rc as ReadCode, count(*) as num into #marchDiagnoses from (
	-- Get first Dx for each 5 byte code for each patient
	select PatID, left(ReadCode,5) as rc, min(EntryDate) as firstDx from SIR_ALL_Records_Narrow
	where left(ReadCode,5) like '[ABCDEFGHIJKLMNOPQRSTUVWXY]____'
	and ReadCode not like '[ABCDEFGHIJKLMNOPQRSTUVWXYZ][ABCDEFGHIJKLMNOPQRSTUVWXYZ][ABCDEFGHIJKLMNOPQRSTUVWXYZ][ABCDEFGHIJKLMNOPQRSTUVWXYZ]%'
	and (len(ReadCode)=5 OR Len(ReadCode)=7)
	group by PatID, left(ReadCode,5)
) sub
where firstDx>= '2019-03-01'
and firstDx < '2019-04-12'
group by rc
order by count(*) desc

-- link to most frequent rubric for each readcode
select m.ReadCode, num, rubric from #marchDiagnoses m inner join (
select s1.readcode, max(s1.rubric) as rubric from SIR_ReadCode_Rubric s1 inner join (
select readcode, MAX(count) as maxcount from SIR_ReadCode_Rubric
group by readcode) s2 on s1.readcode = s2.readcode and s1.count = s2.maxcount
group by  s1.readcode
) s on s.readcode = m.ReadCode
where num > 5
order by num desc;

-- save output


select ReadCode, count(*) num into #preMarch from SIR_ALL_Records_Narrow
where EntryDate < '2020-03-01'
group by ReadCode
select ReadCode, count(*) num into #postMarch from SIR_ALL_Records_Narrow
where EntryDate >= '2020-03-01'
group by ReadCode


select m.ReadCode, num, rubric from #preMarch m inner join (
select s1.readcode, max(s1.rubric) as rubric from SIR_ReadCode_Rubric s1 inner join (
select readcode, MAX(count) as maxcount from SIR_ReadCode_Rubric
group by readcode) s2 on s1.readcode = s2.readcode and s1.count = s2.maxcount
group by  s1.readcode
) s on s.readcode = m.ReadCode
where num > 5
order by num desc

--save output

select m.ReadCode, num, rubric from #postMarch m inner join (
select s1.readcode, max(s1.rubric) as rubric from SIR_ReadCode_Rubric s1 inner join (
select readcode, MAX(count) as maxcount from SIR_ReadCode_Rubric
group by readcode) s2 on s1.readcode = s2.readcode and s1.count = s2.maxcount
group by  s1.readcode
) s on s.readcode = m.ReadCode
--where s.readcode not in ('OLTR.')
where num > 5
order by num desc

--save output