@echo off
set "lp=%1\%COMPUTERNAME%" :: Saving path

IF "%1" == "" (
	echo Запуск^: sysinfo^.bat ^<Подразделение^>
	pause
	goto:eof
	
) ELSE (
	mkdir "%1" 2> NUL
	mkdir "%lp%" 2> NUL
	mkdir "%lp%\Users" 2> NUL
	mkdir "%lp%\Policies" 2> NUL
	mkdir "%lp%\Network" 2> NUL
	mkdir "%lp%\Software" 2> NUL
	
	echo Сохраняется следующая информация:
	
	echo сведения о системе...
	call:log "systeminfo" "%lp%\systeminfo.txt"
	
	echo сведения о процессах...
	call:log "tasklist /v /fo list" "%lp%\Software\tasklist.txt"
	
	echo сведения о службах...
	call:log "sc queryex" "%lp%\Software\services.txt"
	
	echo сведения об установленных приложениях...
	.\soft\myuninst.exe /shtml %lp%\Software\installed.html
	
	echo сведения о системных обновлениях...
	.\soft\wul.exe /shtml %lp%\Software\wul.html
	
	echo локальные политики...
	call:log "net accounts" "%lp%\Policies\Local.txt"
		
	echo доменные политики...
	call:log "net accounts /domain" "%lp%\Policies\Domain.txt"
	
	echo расширенные политики...
	call:log "gpresult /z" "%lp%\Policies\Extended.txt"
	
	echo сведения об общих ресурсах...
	call:log "net share" "%lp%\Network\share.txt"
	
	echo сведения о пользователях...
	net user > %lp%\Users\_UserList.txt
	for /f "eol= tokens=*" %%i in (%lp%\Users\_UserList.txt) do @echo %%i >> %lp%\temp1.txt
	findstr /v /c:"Команда выполнена успешно" %lp%\temp1.txt > %lp%\temp2.txt
	for /f "skip=2 tokens=1,2,3" %%i in (%lp%\temp2.txt) do (@net user %%i > %lp%\Users\%%i.txt && @net user %%j > %lp%\Users\%%j.txt && @net user %%k > %lp%\Users\%%k.txt)
	del /q /f %lp%\temp*
	
	echo сведения о сеансах...
	call:log "qwinsta" "%lp%\Users\_ActiveUsers.txt"
	
	echo сведения о сетевых адаптерах...
	call:log "ipconfig /all" "%lp%\Network\adapters.txt"
	
	echo локальный DNS-кэш...
	call:log "ipconfig /displaydns" "%lp%\Network\DNSCache.txt"
	
	echo таблица маршрутизации...
	call:log "netstat -r" "%lp%\Network\route.txt"
	
	echo сведения о сетевых соединениях...
	call:log "netstat -nao" "%lp%\Network\connections.txt"
	
	echo ARP-таблица...
	call:log "arp -a" "%lp%\Network\arp.txt"
	
	echo USB-устройства...
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

