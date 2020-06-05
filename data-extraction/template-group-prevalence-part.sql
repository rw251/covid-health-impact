-- {{NAME_LOWER_SPACED}}
select PatID, EntryDate from SIR_ALL_Records_Narrow
where ReadCode in ('{{CLINICAL_CODES}}')
and EntryDate >= '2009-12-29'
and EntryDate <= '{{REPORT_DATE}}'
group by PatID, EntryDate