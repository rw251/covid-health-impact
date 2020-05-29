-- {{NAME_LOWER_SPACED}}
select NHSNo, EntryDate from journal
where ReadCode in ('{{CLINICAL_CODES}}')
and EntryDate >= '2015-01-01'
and EntryDate <= '{{REPORT_DATE}}'
group by NHSNo, EntryDate