
-- Diagnoses
SELECT EntryDate, count(*) FROM DataFromSIR.dbo.journal
WHERE ReadCode like '[ABCDEFGHIJKLMNOPQRSTUVWXY]%'
	and ReadCode not like '[ABCDEFGHIJKLMNOPQRSTUVWXYZ][ABCDEFGHIJKLMNOPQRSTUVWXYZ][ABCDEFGHIJKLMNOPQRSTUVWXYZ][ABCDEFGHIJKLMNOPQRSTUVWXYZ]%'
	and (len(ReadCode)=5 OR Len(ReadCode)=7)
  and EntryDate >= '2010-01-01'
GROUP BY EntryDate
ORDER BY EntryDate

-- Medications
SELECT EntryDate, count(*) FROM DataFromSIR.dbo.journal
WHERE ReadCode like '[abcdefghijklmnopqrstuvwxyz]%'
  and EntryDate >= '2010-01-01'
GROUP BY EntryDate
ORDER BY EntryDate

-- Lab tests
SELECT EntryDate, count(*) FROM DataFromSIR.dbo.journal
WHERE ReadCode like '[4]%'
  and EntryDate >= '2010-01-01'
GROUP BY EntryDate
ORDER BY EntryDate

-- Observations / symptoms
SELECT EntryDate, count(*) FROM DataFromSIR.dbo.journal
WHERE ReadCode like '[12]%'
  and EntryDate >= '2010-01-01'
GROUP BY EntryDate
ORDER BY EntryDate

-- Diag procedures / radiology
SELECT EntryDate, count(*) FROM DataFromSIR.dbo.journal
WHERE ReadCode like '[35]%'
  and EntryDate >= '2010-01-01'
GROUP BY EntryDate
ORDER BY EntryDate

-- Procedures
SELECT EntryDate, count(*) FROM DataFromSIR.dbo.journal
WHERE ReadCode like '[678]%'
  and EntryDate >= '2010-01-01'
GROUP BY EntryDate
ORDER BY EntryDate

-- Admin
SELECT EntryDate, count(*) FROM DataFromSIR.dbo.journal
WHERE ReadCode like '[09]%'
  and EntryDate >= '2010-01-01'
GROUP BY EntryDate
ORDER BY EntryDate
