--Just want the output, not the messages
SET NOCOUNT ON; 

--ocd



PRINT 'Year,Month,NewCasesOfOcd'
select YEAR(FirstDiagnosis), MONTH(FirstDiagnosis), count(*) from (
	select PatID, min(EntryDate) as FirstDiagnosis from SIR_ALL_Records_Narrow
	where ReadCode in ('E203.00','E203.11','E203000','E203100','E203z00','Eu42.00','Eu42.11','Eu42.12','Eu42000','Eu42100','Eu42200','Eu42y00','Eu42z00','Eu60513','Z522600','','E203.','E2030','E2031','E203z','Eu42.','Eu420','Eu421','Eu422','Eu42y','Eu42z','Z5226')
	group by PatID
) sub 
group by YEAR(FirstDiagnosis), MONTH(FirstDiagnosis)
order by YEAR(FirstDiagnosis), MONTH(FirstDiagnosis);
