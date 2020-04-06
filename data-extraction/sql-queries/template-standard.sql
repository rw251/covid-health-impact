--Just want the output, not the messages
SET NOCOUNT ON; 

--{{SYMPTOM_LOWER_SPACED}}
{{!MAIN}}
PRINT 'Year,{{SYMPTOM_CAPITAL_NO_SPACE}}'
select YEAR(EntryDate), count(*) as {{SYMPTOM_CAPITAL_NO_SPACE}} from (
	select PatID, EntryDate from SIR_ALL_Records_Narrow
	where ReadCode in ('{{CLINICAL_CODES}}')
	and EntryDate >= '2000-01-01'
	group by PatID, EntryDate
) sub 
group by YEAR(EntryDate)
order by YEAR(EntryDate);
{{MAIN}}