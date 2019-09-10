echo off

REM set expDate=%1
REM set parentDir=D:\Dropbox (HMS)\2P Data\Imaging Data\%expDate%\
REM set parentDir=C:\Users\Wilson Lab\Desktop\Michael\Data\%expDate%

set parentDir=C:\Users\Wilson Lab\Desktop\Michael\Data

for /D %%f in ("%parentDir%\2*") do (
	echo(
	echo Processing experiment:  %%~nxf
	echo Full directory path:  %%f
	echo(
	
REM UPLOAD FILES

	echo Uploading files to scratch2 server...
	"C:\Program Files (x86)\WinSCP\WinSCP.exe" /log="C:\Users\Wilson Lab\Desktop\Michael\2p_acq_code\WinSCP-logfile.log" /script="C:\Users\Wilson Lab\Desktop\Michael\2p_acq_code\Wombat-WinSCP-script.txt" /parameter "%%~nxf" "%%f"
	
	if %ERRORLEVEL% neq 0 (
	echo %ERRORLEVEL%
		echo WinSCP reported error! Resuming script.
		echo(
	) else (
		echo Remote upload completed successfully
		echo(
	)
	
REM COPY FILES
	if not exist "E:\Michael\%%~nxf" echo Creating new expDir "E:\Michael\%%~nxf" on the E drive...
	if not exist "E:\Michael\%%~nxf" mkdir "E:\Michael\%%~nxf"
	echo Copying files to the E drive...
	xcopy "%%f\*" "E:\Michael\%%~nxf\" /y
	if errorlevel 1 goto copyError
	if errorlevel 2 goto copyError
	if errorlevel 3 goto copyError
	if errorlevel 4 goto copyError
	if errorlevel 5 goto copyError
	echo Files copied to E drive successfully
	echo(
	
	echo Copying files to the neurobio server...
	echo ServerPath:  "\\research.files.med.harvard.edu\Neurobio\Wilson Lab\Michael\2P Behavior Video\%%~nxf"
	if not exist "\\research.files.med.harvard.edu\Neurobio\Wilson Lab\Michael\2P Behavior Video\%%~nxf" mkdir "\\research.files.med.harvard.edu\Neurobio\Wilson Lab\Michael\2P Behavior Video\%%~nxf"
	xcopy "%%f\*"  "\\research.files.med.harvard.edu\Neurobio\Wilson Lab\Michael\2P Behavior Video\%%~nxf\" /y
	if errorlevel 1 goto copyError
	if errorlevel 2 goto copyError
	if errorlevel 3 goto copyError
	if errorlevel 4 goto copyError
	if errorlevel 5 goto copyError
	echo Files copied to server successfully
	echo(
	
REM DELETE FILES
	REM echo [Would be deleting original files here normally]
	REM rmdir "%%f" /s /q
	REM echo Original exp dir removed

)

goto exit

REM :WinSCP-error
REM echo WinSCP reported error...aborting script
REM goto exit

:copyError
echo There was an error copying to one of the two target destinations...aborting transfer process.
goto exit

:exit
echo All experiment directories have been processed, exiting...
exit /B 0

 