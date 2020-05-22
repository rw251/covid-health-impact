-- {{NAME_LOWER_SPACED}}
select NHSNo, min(EntryDate) as FirstDiagnosis from journal
where ReadCode in ('{{CLINICAL_CODES}}')
and EntryDate <= '{{REPORT_DATE}}'
group by NHSNo