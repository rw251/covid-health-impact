-- {{NAME_LOWER_SPACED}}
select PatID, min(EntryDate) as FirstDiagnosis from SIR_ALL_Records_Narrow
where ReadCode in ('{{CLINICAL_CODES}}')
and EntryDate <= '{{REPORT_DATE}}'
group by PatID