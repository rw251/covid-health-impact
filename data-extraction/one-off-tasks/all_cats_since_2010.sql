
-- Diagnoses
SELECT EntryDate, count(*) FROM DataFromSIR.dbo.journal
WHERE ReadCode like '[ABCDEFGHIJKLMNOPQRSTUVWXY]%'
	and ReadCode not like '[ABCDEFGHIJKLMNOPQRSTUVWXYZ][ABCDEFGHIJKLMNOPQRSTUVWXYZ][ABCDEFGHIJKLMNOPQRSTUVWXYZ][ABCDEFGHIJKLMNOPQRSTUVWXYZ]%'
	and (len(ReadCode)=5 OR Len(ReadCode)=7)
  and EntryDate >= '2010-01-01'
GROUP BY EntryDate
ORDER BY EntryDate

SELECT entrydate, count(*) from (
select NHSNo, readcode, entrydate from DataFromSIR.dbo.journal
WHERE ReadCode like '[ABCDEFGHIJKLMNOPQRSTUVWXY]%'
	and ReadCode not like '[ABCDEFGHIJKLMNOPQRSTUVWXYZ][ABCDEFGHIJKLMNOPQRSTUVWXYZ][ABCDEFGHIJKLMNOPQRSTUVWXYZ][ABCDEFGHIJKLMNOPQRSTUVWXYZ]%'
	and (len(ReadCode)=5 OR Len(ReadCode)=7)
  and EntryDate >= '2010-01-01'
  group by NHSNo, readcode, entrydate
) sub
GROUP BY entrydate
ORDER BY entrydate

-- Medications
SELECT EntryDate, count(*) FROM DataFromSIR.dbo.journal
WHERE (
	ReadCode like '[abcdefghijklmnopqrstuvwxyz]%'
	or (len(ReadCode)>7
		and ReadCode not like 'PCSDT%'
		and ReadCode not like 'EMIS%'
		and ReadCode not like 'EGTON%'
		and ReadCode not like 'ALLERG%'
		and ReadCode not like 'CLEAT%'
		and ReadCode not like 'FUNDHB%'
		and ReadCode not like 'DEGRADE%'
		and ReadCode not like '^%'
		and ReadCode like '%[ABCDEFGHIJKLMNOPQRSTUVWXYZ]%')
	or
		(len(ReadCode)=7
		and ReadCode not like 'PCSDT%'
		and ReadCode not like 'EMIS%'
		and ReadCode not like 'EGTON%'
		and ReadCode not like 'ALLERG%'
		and ReadCode not like 'CLEAT%'
		and ReadCode not like 'FUNDHB%'
		and ReadCode not like 'DEGRADE%'
		and ReadCode like '[ABCDEFGHIJKLMNOPQRSTUVWXYZ][ABCDEFGHIJKLMNOPQRSTUVWXYZ][ABCDEFGHIJKLMNOPQRSTUVWXYZ][ABCDEFGHIJKLMNOPQRSTUVWXYZ0-9][ABCDEFGHIJKLMNOPQRSTUVWXYZ0-9][ABCDEFGHIJKLMNOPQRSTUVWXYZ0-9][ABCDEFGHIJKLMNOPQRSTUVWXYZ0-9]'
		and ReadCode not like '%00')
	or
		(len(ReadCode)=6
		and ReadCode not like 'PCSDT%'
		and ReadCode not like 'EMIS%'
		and ReadCode not like 'EGTON%'
		and ReadCode not like 'ALLERG%'
		and ReadCode not like 'CLEAT%'
		and ReadCode not like 'FUNDHB%'
		and ReadCode not like 'DEGRADE%'
		and ReadCode like '[ABCDEFGHIJKLMNOPQRSTUVWXYZ][ABCDEFGHIJKLMNOPQRSTUVWXYZ][ABCDEFGHIJKLMNOPQRSTUVWXYZ][ABCDEFGHIJKLMNOPQRSTUVWXYZ0-9][ABCDEFGHIJKLMNOPQRSTUVWXYZ0-9][ABCDEFGHIJKLMNOPQRSTUVWXYZ0-9]'
		and ReadCode not like '%00')
	)
  and EntryDate >= '2010-01-01'
GROUP BY EntryDate
ORDER BY EntryDate

SELECT entrydate, count(*) from (
select NHSNo, readcode, entrydate from DataFromSIR.dbo.journal
WHERE (
	ReadCode like '[abcdefghijklmnopqrstuvwxyz]%'
	or (len(ReadCode)>7
		and ReadCode not like 'PCSDT%'
		and ReadCode not like 'EMIS%'
		and ReadCode not like 'EGTON%'
		and ReadCode not like 'ALLERG%'
		and ReadCode not like 'CLEAT%'
		and ReadCode not like 'FUNDHB%'
		and ReadCode not like 'DEGRADE%'
		and ReadCode not like '^%'
		and ReadCode like '%[ABCDEFGHIJKLMNOPQRSTUVWXYZ]%')
	or
		(len(ReadCode)=7
		and ReadCode not like 'PCSDT%'
		and ReadCode not like 'EMIS%'
		and ReadCode not like 'EGTON%'
		and ReadCode not like 'ALLERG%'
		and ReadCode not like 'CLEAT%'
		and ReadCode not like 'FUNDHB%'
		and ReadCode not like 'DEGRADE%'
		and ReadCode like '[ABCDEFGHIJKLMNOPQRSTUVWXYZ][ABCDEFGHIJKLMNOPQRSTUVWXYZ][ABCDEFGHIJKLMNOPQRSTUVWXYZ][ABCDEFGHIJKLMNOPQRSTUVWXYZ0-9][ABCDEFGHIJKLMNOPQRSTUVWXYZ0-9][ABCDEFGHIJKLMNOPQRSTUVWXYZ0-9][ABCDEFGHIJKLMNOPQRSTUVWXYZ0-9]'
		and ReadCode not like '%00')
	or
		(len(ReadCode)=6
		and ReadCode not like 'PCSDT%'
		and ReadCode not like 'EMIS%'
		and ReadCode not like 'EGTON%'
		and ReadCode not like 'ALLERG%'
		and ReadCode not like 'CLEAT%'
		and ReadCode not like 'FUNDHB%'
		and ReadCode not like 'DEGRADE%'
		and ReadCode like '[ABCDEFGHIJKLMNOPQRSTUVWXYZ][ABCDEFGHIJKLMNOPQRSTUVWXYZ][ABCDEFGHIJKLMNOPQRSTUVWXYZ][ABCDEFGHIJKLMNOPQRSTUVWXYZ0-9][ABCDEFGHIJKLMNOPQRSTUVWXYZ0-9][ABCDEFGHIJKLMNOPQRSTUVWXYZ0-9]'
		and ReadCode not like '%00')
	)
  and EntryDate >= '2010-01-01'
  group by NHSNo, readcode, entrydate
) sub
GROUP BY entrydate
ORDER BY entrydate

-- Lab tests
SELECT EntryDate, count(*) FROM DataFromSIR.dbo.journal
WHERE ReadCode like '4%'
  and EntryDate >= '2010-01-01'
GROUP BY EntryDate
ORDER BY EntryDate

SELECT entrydate, count(*) from (
select NHSNo, readcode, entrydate from DataFromSIR.dbo.journal
WHERE ReadCode like '4%'
  and EntryDate >= '2010-01-01'
  group by NHSNo, readcode, entrydate
) sub
GROUP BY entrydate
ORDER BY entrydate


-- Observations / symptoms
SELECT EntryDate, count(*) FROM DataFromSIR.dbo.journal
WHERE ReadCode like '[12]%'
  and EntryDate >= '2010-01-01'
GROUP BY EntryDate
ORDER BY EntryDate

SELECT entrydate, count(*) from (
select NHSNo, readcode, entrydate from DataFromSIR.dbo.journal
WHERE ReadCode like '[12]%'
  and EntryDate >= '2010-01-01'
  group by NHSNo, readcode, entrydate
) sub
GROUP BY entrydate
ORDER BY entrydate

-- Diag procedures / radiology
SELECT EntryDate, count(*) FROM DataFromSIR.dbo.journal
WHERE ReadCode like '[35]%'
  and EntryDate >= '2010-01-01'
GROUP BY EntryDate
ORDER BY EntryDate

SELECT entrydate, count(*) from (
select NHSNo, readcode, entrydate from DataFromSIR.dbo.journal
WHERE ReadCode like '[35]%'
  and EntryDate >= '2010-01-01'
  group by NHSNo, readcode, entrydate
) sub
GROUP BY entrydate
ORDER BY entrydate

-- Procedures
SELECT EntryDate, count(*) FROM DataFromSIR.dbo.journal
WHERE ReadCode like '[678]%'
  and EntryDate >= '2010-01-01'
GROUP BY EntryDate
ORDER BY EntryDate

SELECT entrydate, count(*) from (
select NHSNo, readcode, entrydate from DataFromSIR.dbo.journal
WHERE ReadCode like '[678]%'
  and EntryDate >= '2010-01-01'
  group by NHSNo, readcode, entrydate
) sub
GROUP BY entrydate
ORDER BY entrydate

-- Admin
SELECT EntryDate, count(*) FROM DataFromSIR.dbo.journal
WHERE ReadCode like '[09]%'
  and EntryDate >= '2010-01-01'
GROUP BY EntryDate
ORDER BY EntryDate

SELECT entrydate, count(*) from (
select NHSNo, readcode, entrydate from DataFromSIR.dbo.journal
WHERE ReadCode like '[09]%'
  and EntryDate >= '2010-01-01'
  group by NHSNo, readcode, entrydate
) sub
GROUP BY entrydate
ORDER BY entrydate

