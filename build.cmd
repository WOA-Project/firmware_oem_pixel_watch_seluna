@echo off

echo.
echo.  _______        __  _____      _                  _             
echo. ^|  ___\ \      / / ^| ____^|_  _^| ^|_ _ __ __ _  ___^| ^|_ ___  _ __ 
echo. ^| ^|_   \ \ /\ / /  ^|  _^| \ \/ / __^| '__/ _` ^|/ __^| __/ _ \^| '__^|
echo. ^|  _^|   \ V  V /   ^| ^|___ ^>  ^<^| ^|_^| ^| ^| ^(_^| ^| ^(__^| ^|^| ^(_^) ^| ^|   
echo. ^|_^|      \_/\_/    ^|_____/_/\_\\__^|_^|  \__,_^|\___^|\__\___/^|_^|   
echo.                                                                 

REM Seluna Root Key Hash
set RKH=48F631ADEDF676192E79633EBA0F17983DE5B3CDE2F0A36180DA6E5830719867

set SOC=5100

echo.
echo Target: Seluna
echo SoC   : SW%SOC%
echo RKH   : %RKH% (Pixel Firmware Origin Attestation CA)
echo.

for /f %%f in ('dir /b /s extracted\*.mbn.unsigned') do (
    REM call :moveUnsigned %%f
)

for /f %%f in ('dir /b /s extracted\*_unsigned.mbn') do (
    REM call :moveUnsigned %%f
)

echo Checking MBN files validity... (This may take a while!)

for /f %%f in ('dir /b /s extracted\*.mbn') do (
    REM call :checkRKH %%f
)

echo Checking ELF files validity... (This may take a while!)

for /f %%f in ('dir /b /s extracted\*.elf') do (
    REM call :checkRKH %%f
)

echo Checking BIN files validity... (This may take a while!)

for /f %%f in ('dir /b /s extracted\*.bin') do (
    REM call :checkRKH %%f
)

echo Checking IMG files validity... (This may take a while!)

for /f %%f in ('dir /b /s extracted\*.img') do (
    REM call :checkRKH %%f
)

echo Cleaning up Output Directory...
rmdir /Q /S output

echo Cleaning up PIL Squasher Directory...
rmdir /Q /S pil-squasher

echo Cloning PIL Squasher...

git clone https://github.com/linux-msm/pil-squasher

echo Building PIL Squasher...

cd pil-squasher
bash.exe -c make
cd ..

mkdir output
mkdir output\Subsystems

mkdir output\Subsystems\ADSP
mkdir output\Subsystems\ADSP\ADSP

echo Converting Analog DSP Image...
bash.exe -c "./pil-squasher/pil-squasher ./output/Subsystems/ADSP/qcadsp%SOC%.mbn ./extracted/vendor/firmware/adsp.mdt"

echo Copying ADSP Protection Domain Registry Config files...
xcopy /qchky /-i extracted\vendor\firmware\adspr.jsn output\Subsystems\ADSP\adspr.jsn
xcopy /qchky /-i extracted\vendor\firmware\adspua.jsn output\Subsystems\ADSP\adspua.jsn

echo Copying ADSP lib files...
xcopy /qcheriky extracted\vendor\dsp\adsp output\Subsystems\ADSP\ADSP

echo Generating ADSP FASTRPC INF Configuration...
tools\SuBExtInfUpdater-ADSP.exe output\Subsystems\ADSP\ADSP > output\Subsystems\ADSP\inf_configuration.txt

mkdir output\Subsystems\IPA

xcopy /qchky /-i extracted\vendor\firmware\ipa_fws.elf output\Subsystems\IPA\ipa_fws.elf

mkdir output\Subsystems\MCFG
mkdir output\Subsystems\MCFG\MCFG

echo Generating MCFG TFTP INF Configuration...
tools\SuBExtInfUpdater-MCFG.exe extracted\vendor\rfs\msm\mpss\readonly\vendor\mbn output\Subsystems\MCFG\MCFG > output\Subsystems\MCFG\inf_configuration.txt

xcopy /qchky /-i extracted\modem\image\qdsp6m.qdb output\Subsystems\MCFG\qdsp6m.qdb

mkdir output\Subsystems\MPSS

echo Copying MPSS Protection Domain Registry Config files...
xcopy /qchky /-i extracted\modem\image\modemr.jsn output\Subsystems\MPSS\modemr.jsn

echo Converting Modem Processor Subsystem DSP Image...
bash.exe -c "./pil-squasher/pil-squasher ./output/Subsystems/MPSS/qcmpss%SOC%.mbn ./extracted/modem/image/modem.mdt"

mkdir output\Subsystems\VENUS

echo Copying Video Encoding Subsystem DSP Image...
xcopy /qchky /-i extracted\vendor\firmware\venus_v6.mbn output\Subsystems\VENUS\qcvss%SOC%.mbn

mkdir output\Subsystems\ZAP

echo Converting GPU ZAP Shader Micro Code DSP Image...
xcopy /qchky /-i extracted\vendor\firmware\a702_zap.elf output\Subsystems\ZAP\qcdxkmsuc%SOC%.mbn

mkdir output\Sensors
mkdir output\Sensors\Config

xcopy /qchky /-i extracted\vendor\etc\sensors\sns_reg_config output\Sensors\Config\sns_reg_config
xcopy /qcheriky extracted\vendor\etc\sensors\config output\Sensors\Config

echo Generating SLPI FASTRPC INF Configuration...
tools\SuBExtInfUpdater-SLPI.exe output\Sensors\Config > output\Sensors\inf_configuration.txt
move output\Sensors\inf_configuration.txt output\Sensors\Config\inf_configuration.txt

mkdir output\Audio
mkdir output\Audio\Cal

xcopy /qcheriky extracted\vendor\etc\acdbdata\nn_ns_models output\Audio\Cal
xcopy /qcheriky extracted\vendor\etc\acdbdata\nn_vad_models output\Audio\Cal
xcopy /qcheriky extracted\vendor\etc\acdbdata\monaco_idp_google output\Audio\Cal

mkdir output\TrEE

echo Converting hdcpsrm (n=hdcpsrm;p=8:c47728cf3e4089,5d:8,82:6004,b4;s=5e) QSEE Applet...
bash.exe -c "./pil-squasher/pil-squasher ./output/TrEE/hdcpsrm.mbn ./extracted/vendor/firmware/hdcpsrm.mdt"

REM START: Do we need those? They should already be loaded in UEFI.

REM TODO: Trim
echo Copying qcom.tz.uefisecapp (n=qcom.tz.uefisecapp;p=8:c47728cf3e4089,61,82:6004,b4) QSEE Applet...
xcopy /qchky /-i extracted\uefisecapp.img output\TrEE\uefisecapp.mbn

REM TODO: Trim
echo Copying keymaster64 (n=keymaster64;o=100;p=8:c47728cf3e4489,61,82:6024,b4,12d:1;s=96) QSEE Applet...
xcopy /qchky /-i extracted\keymaster.img output\TrEE\keymaster.mbn

REM END: Do we need those? They should already be loaded in UEFI.


mkdir output\UEFI

echo Extracting XBL Image...
tools\UEFIReader.exe extracted\XBL.img output\UEFI

mkdir output\UEFI\ImageFV

echo Extracting ImageFV Image...
tools\UEFIReader.exe extracted\imagefv.img output\UEFI\ImageFV

mkdir output\UEFI\ABL

echo Extracting ABL Image...
tools\UEFIReader.exe extracted\abl.img output\UEFI\ABL

echo Cleaning up PIL Squasher Directory...
rmdir /Q /S pil-squasher

REM TODO: Get list of supported PM resources from AOP directly
REM TODO: Extract QUP FW individual files
REM TODO: devcfg parser?

:eof
exit /b 0

:checkRKH
set x=INVALID
for /F "eol=; tokens=1-2 delims=" %%a in ('tools\RKHReader.exe %1 2^>^&1') do (set x=%%a)

echo.
echo File: %1
echo RKH : %x%
echo.
set directory=%~dp1
call set directory=%%directory:%cd%=%%

if %x%==%RKH% (
    exit /b 1
)

if %x%==FAIL! (
    exit /b 2
)

if %x%==EXCEPTION! (
    exit /b 2
)

echo %1 is a valid MBN file and is not production signed (%x%). Moving...
mkdir unsigned\%directory%
move %1 unsigned\%directory%
exit /b 0

:moveUnsigned
echo.
echo File: %1
echo.
set directory=%~dp1
call set directory=%%directory:%cd%=%%

echo %1 is a valid MBN file and is not signed. Moving...
mkdir unsigned\%directory%
move %1 unsigned\%directory%
exit /b 0