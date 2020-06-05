-- {{NAME_LOWER_SPACED}}
select NHSNo, EntryDate from journal
where ReadCode in ('{{CLINICAL_CODES}}')
and EntryDate >= '2009-12-29'
and EntryDate <= '{{REPORT_DATE}}'
group by NHSNo, EntryDate