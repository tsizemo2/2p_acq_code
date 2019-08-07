echo off

REM set expDate=%1
REM set parentDir=D:\Dropbox (HMS)\2P Data\Imaging Data\%expDate%\
REM set parentDir=C:\Users\Wilson Lab\Desktop\Michael\Data\%expDate%
set parentDir=C:\Users\Wilson Lab\Desktop\Michael\Data

for /D %%f in ("%parentDir%\2*") do (
	
	echo %%~nxf
	echo %%f
	
	
REM UPLOAD FILES
	"C:\Program Files (x86)\WinSCP\WinSCP.exe" /log="C:\Users\Wilson Lab\Desktop\Michael\2p_acq_code\WinSCP.log" /script="C:\Users\Wilson Lab\Desktop\Michael\2p_acq_code\Wombat-WinSCP-script.txt" /parameter "%%~nxf" "%%f"
	
	if %ERRORLEVEL% neq 0 (
	echo %ERRORLEVEL%
	goto WinSCP-error
	) else (
		echo Remote upload completed successfully
	)
	
REM COPY FILES
	set "serverPath=\\research.files.med.harvard.edu\Neurobio\Wilson Lab\Michael\2P Behavior Video\%%~nxf"
	echo %serverPath%
	if not exist "%serverPath%" mkdir "%serverPath%"
	xcopy "%%f\*"  "%serverPath%\"
	if errorlevel 1 goto copyError
	if errorlevel 4 goto copyError
	if errorlevel 5 goto copyError
	
	if not exist "E:\Michael\%%~nxf" mkdir "E:\Michael\%%~nxf"
	xcopy "%%f\*" "E:\Michael\%%~nxf\"
	if errorlevel 1 goto copyError
	if errorlevel 4 goto copyError
	if errorlevel 5 goto copyError
	
REM DELETE FILES
	rmdir "%%f" /s /q
	goto exit
	
	:WinSCP-error
	echo WinSCP reported error...aborting script
	goto exit
	
	:copyError
	echo There was an error copying to one of the two target destinations...skipping directory deletion.
	goto exit
	
	:exit
	exit /B 0
)


 