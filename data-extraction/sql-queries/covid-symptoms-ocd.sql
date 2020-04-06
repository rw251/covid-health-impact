--Just want the output, not the messages
SET NOCOUNT ON; 

--ocd

PRINT 'Year,Ocd'
select YEAR(EntryDate), count(*) as Ocd from (
	select PatID, EntryDate from SIR_ALL_Records_Narrow
	where ReadCode in ('E203.00','E203.11','E203000','E203100','E203z00','Eu42.00','Eu42.11','Eu42.12','Eu42000','Eu42100','Eu42200','Eu42y00','Eu42z00','Eu60513','Z522600','','E203.','E2030','E2031','E203z','Eu42.','Eu420','Eu421','Eu422','Eu42y','Eu42z','Z5226')
	and EntryDate >= '2000-01-01'
	group by PatID, EntryDate
) sub 
group by EntryDate
order by YEAR(EntryDate);
