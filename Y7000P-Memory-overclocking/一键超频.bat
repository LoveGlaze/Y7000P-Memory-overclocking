@echo off
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
echo Requesting administrative privileges... 
goto request
) else (goto init)

:request
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
set params = %*:"=""
echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
del "%temp%\getadmin.vbs"
exit /b

:init
echo ***************************************************
echo *                                                 *
echo *                  ��������                       *
echo *                                                 *
echo *  ʹ�ñ��ű��޸�bios�����𻵵ģ������ге������ *
echo *                                                 *
echo *           ֧��ת�أ�����ע������                *
echo * �̳�Դ��https://zhuanlan.zhihu.com/p/350391077  *                                                 *
echo ***************************************************
pause
pushd %~dp0
echo.
echo ���ڳ�ʼ�����ݹ�������
echo.
WDFInst.exe
if exist Backup/SaSetup_Original.txt (
	echo �Ѵ��� SaSetup �����ļ�
) else H2OUVE-W-CONSOLEx64.exe -gv Backup/SaSetup_Original.txt -n SaSetup

if exist Backup/PchSetup_Original.txt (
	echo �Ѵ��� PchSetup �����ļ�
) else H2OUVE-W-CONSOLEx64.exe -gv Backup/PchSetup_Original.txt -n PchSetup

if exist Backup/CpuSetup_Original.txt (
	echo �Ѵ���CpuSetup�����ļ�
) else H2OUVE-W-CONSOLEx64.exe -gv Backup/CpuSetup_Original.txt -n CpuSetup

echo.
goto start 


:start
cls
title ����������Y7000ϵ��һ���޸�BIOS����_V1.0
:menu
echo.
echo =============================================================
echo.
echo                 ��ѡ��Ҫ���еĲ���
echo.
echo =============================================================
echo.
echo  1�����ݵ�ǰ BIOS
echo.
echo  2������CpuSetup
echo.
echo  3������SaSetup
echo.
echo  0���˳�����
echo.
echo.

:sel
set sel=
set /p sel= ��ѡ��:  
IF NOT "%sel%"=="" SET sel=%sel:~0,1%
if /i "%sel%"=="0" goto ex
if /i "%sel%"=="1" goto BuckupBIOS
if /i "%sel%"=="2" goto SetCpu
if /i "%sel%"=="3" goto SetSa
echo ѡ����Ч������������
echo.
goto sel
echo.

:ex
choice /C yn /M "Y����������  N���Ժ�����"
if errorlevel 2 goto end
if errorlevel 1 goto restart

:restart
%systemroot%\system32\shutdown -r -t 0
:SetCpu
pushd %~dp0
WDFInst.exe
H2OUVE-W-CONSOLEx64.exe -gv CpuSetup_Original.txt -n CpuSetup
goto label
for /f "tokens=1,9" %%i in (CpuSetup_Original.txt) do if %%i==00000100: (
	if %%j == 02 ( 
		echo DVMT Pre-Allocated��Ϊ64M������Ҫ�޸�
		del CpuSetup_Original.txt
		pause
		goto start		
	)
)
:label
if exist "CpuSetup.txt" (
    echo ����д�롭��
    H2OUVE-W-CONSOLEx64.exe -sv CpuSetup.txt -n CpuSetup
) else (
    if exist "CpuSetup_Original.txt" (
		powershell -Command "(gc CpuSetup_Original.txt) -replace '000001B0: (.{20}) 00 00 (.*)', '000001B0: $1 01 01 $2' | Out-File CpuSetup_1.txt -Encoding ASCII"
		powershell -Command "(gc CpuSetup_1.txt) -replace '000001C0: (.{14}) 01 (.*)', '000001C0: $1 00 $2' | Out-File CpuSetup_2.txt -Encoding ASCII"
		powershell -Command "(gc CpuSetup_2.txt) -replace '00000100: (.{11}) 00 (.*)', '00000100: $1 AA $2' | Out-File CpuSetup.txt -Encoding ASCII"
		echo ����д�롭��
		H2OUVE-W-CONSOLEx64.exe -sv CpuSetup.txt -n CpuSetup
		del CpuSetup_Original.txt
		del CpuSetup_1.txt
		del CpuSetup_2.txt
		del CpuSetup.txt
	) else (
		echo �޷��ҵ� CpuSetup_Original.txt
	)
)
pause
goto start
:SetSa
pushd %~dp0
WDFInst.exe
H2OUVE-W-CONSOLEx64.exe -gv SaSetup_Original.txt -n SaSetup
goto label
for /f "tokens=1,9" %%i in (SaSetup_Original.txt) do if %%i==00000100: (
	if %%j == 02 ( 
		echo DVMT Pre-Allocated��Ϊ64M������Ҫ�޸�
		del SaSetup_Original.txt
		pause
		goto start		
	)
)
:label
if exist "SaSetup.txt" (
    echo ����д�롭��
    H2OUVE-W-CONSOLEx64.exe -sv SaSetup.txt -n SaSetup
) else (
    if exist "SaSetup_Original.txt" (
		powershell -Command "(gc SaSetup_Original.txt) -replace '00000000: (.{35}) 00 00 0A (.*)', '00000000: $1 01 00 0F $2' | Out-File SaSetup_1.txt -Encoding ASCII"
		powershell -Command "(gc SaSetup_1.txt) -replace '00000140: (.{26}) 00 (.*)', '00000140: $1 01 $2' | Out-File SaSetup_2.txt -Encoding ASCII"
		powershell -Command "(gc SaSetup_2.txt) -replace '00000010: (.{8}) (.*)', '00000010: 12 12 12 $2' | Out-File SaSetup.txt -Encoding ASCII"
		echo ����д�롭��
		H2OUVE-W-CONSOLEx64.exe -sv SaSetup.txt -n SaSetup
		del SaSetup_Original.txt
		del SaSetup_1.txt
		del SaSetup_2.txt
		del SaSetup.txt
	) else (
		echo �޷��ҵ� SaSetup_Original.txt
	)
)
pause
goto start