-- {{NAME_LOWER_SPACED}}
select PatID, EntryDate from SIR_ALL_Records_Narrow
where ReadCode in ('{{CLINICAL_CODES}}')
and EntryDate >= '2015-01-01'
and EntryDate <= '{{REPORT_DATE}}'
group by PatID, EntryDate