@echo off
set "lp=%1\%COMPUTERNAME%" :: Saving path

IF "%1" == "" (
	echo �����^: sysinfo^.bat ^<���ࠧ�������^>
	pause
	goto:eof
	
) ELSE (
	mkdir "%1" 2> NUL
	mkdir "%lp%" 2> NUL
	mkdir "%lp%\Users" 2> NUL
	mkdir "%lp%\Policies" 2> NUL
	mkdir "%lp%\Network" 2> NUL
	mkdir "%lp%\Software" 2> NUL
	
	echo ���࠭���� ᫥����� ���ଠ��:
	
	echo ᢥ����� � ��⥬�...
	call:log "systeminfo" "%lp%\systeminfo.txt"
	
	echo ᢥ����� � ������...
	call:log "tasklist /v /fo list" "%lp%\Software\tasklist.txt"
	
	echo ᢥ����� � �㦡��...
	call:log "sc queryex" "%lp%\Software\services.txt"
	
	echo ᢥ����� �� ��⠭�������� �ਫ�������...
	.\soft\myuninst.exe /shtml %lp%\Software\installed.html
	
	echo ᢥ����� � ��⥬��� �����������...
	.\soft\wul.exe /shtml %lp%\Software\wul.html
	
	echo ������� ����⨪�...
	call:log "net accounts" "%lp%\Policies\Local.txt"
		
	echo ������� ����⨪�...
	call:log "net accounts /domain" "%lp%\Policies\Domain.txt"
	
	echo ���७�� ����⨪�...
	call:log "gpresult /z" "%lp%\Policies\Extended.txt"
	
	echo ᢥ����� �� ���� ������...
	call:log "net share" "%lp%\Network\share.txt"
	
	echo ᢥ����� � ���짮��⥫��...
	net user > %lp%\Users\_UserList.txt
	for /f "eol= tokens=*" %%i in (%lp%\Users\_UserList.txt) do @echo %%i >> %lp%\temp1.txt
	findstr /v /c:"������� �믮����� �ᯥ譮" %lp%\temp1.txt > %lp%\temp2.txt
	for /f "skip=2 tokens=1,2,3" %%i in (%lp%\temp2.txt) do (@net user %%i > %lp%\Users\%%i.txt && @net user %%j > %lp%\Users\%%j.txt && @net user %%k > %lp%\Users\%%k.txt)
	del /q /f %lp%\temp*
	
	echo ᢥ����� � ᥠ���...
	call:log "qwinsta" "%lp%\Users\_ActiveUsers.txt"
	
	echo ᢥ����� � �⥢�� �������...
	call:log "ipconfig /all" "%lp%\Network\adapters.txt"
	
	echo ������� DNS-���...
	call:log "ipconfig /displaydns" "%lp%\Network\DNSCache.txt"
	
	echo ⠡��� ������⨧�樨...
	call:log "netstat -r" "%lp%\Network\route.txt"
	
	echo ᢥ����� � �⥢�� ᮥ��������...
	call:log "netstat -nao" "%lp%\Network\connections.txt"
	
	echo ARP-⠡���...
	call:log "arp -a" "%lp%\Network\arp.txt"
	
	echo USB-���ன�⢠...
	.\soft\USBDeview.exe /DisplayDisconnected 1 /DisplayNoPortSerial 1 /DisplayNoDriver 1 /DisplayHubs 1 /shtml %lp%\USB.html
	
	pause
	goto:eof
)

::--------------------------------------------------------
::-- Function section starts below here
::--------------------------------------------------------
:: Function log <command> <PathToLog>
:log
%~1 > NUL 2> NUL > %~2 || %~1 > NUL 2> NUL 2>> %~2
goto:eof

