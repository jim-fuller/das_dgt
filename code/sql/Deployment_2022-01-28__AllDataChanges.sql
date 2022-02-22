USE [DGT]
GO

UPDATE s
SET [MetricNM]= 'Database Corruption'
FROM [dw].[FactDGTRuleSummary] AS s
WHERE [MetricNM]= 'Location Mal Formatted'		--Change to 'Database Corruption'


UPDATE s
SET SubjectAreaNM= 'AEMS/MERS'
FROM [dw].[FactDGTRuleSummary] AS s
WHERE SubjectAreaNM = 'CEQUIPBSE'		--Change to 'AEMS/MERS'


UPDATE s
SET ErrorMessage= 'Database Corruption'
FROM [dw].[FactDGTequipinv6914ErrorDetails] AS s
WHERE ErrorMessage= 'Location Mal Formatted'		--Change to 'Database Corruption'


UPDATE s
SET SubjectAreaNM= 'AEMS/MERS'
FROM [dw].[FactDGTequipinv6914ErrorDetails] AS s
WHERE SubjectAreaNM = 'CEQUIPBSE'		--Change to 'AEMS/MERS'

