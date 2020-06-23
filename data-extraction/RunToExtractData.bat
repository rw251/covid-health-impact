@ECHO OFF

REM move to batch dir 
cd /d %~dp0

ECHO THIS WILL EXECUTE AGAINST DataFromSIR - use RunToExtractData2.bat for PatientSafety_Records db.
ECHO Are you sure you want to continue?
pause

ECHO You should have added an extra index. Have you?
ECHO you'll find it in the 'one-off-tasks' folder
pause

SET SMASH.DB=DataFromSIR

REM for each sql file execute against db
forfiles /p sql-queries /s /m dx*.sql /c "cmd /c sqlcmd -E -d %SMASH.DB% -i @path -W -s , -h -1 -o @fname"

REM each output file move to data directory and add a .txt extension
forfiles /p sql-queries /s /m dx* /c "cmd /c if not @ext==0x22sql0x22 move /y @path ../../../covid-health-data/@fname.txt"

pause