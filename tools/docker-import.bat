@echo off
rem Load this project's Docker image from a .tar file.
rem Usage: tools\docker-import.bat [version^|latest] [dist_dir]
rem   version  : release to load, e.g. 1.2.0 (default: latest = highest X.Y.Z file found)
rem   dist_dir : folder with ^<name^>_^<version^>.tar[.gz] files (default: ^<project^>\dist)
rem Image name = %%IMAGE_NAME%%, or the project folder name (lowercase, spaces -^> "-").
setlocal

for %%I in ("%~dp0..") do set "ROOT=%%~fI"
for %%I in ("%ROOT%") do set "NAME=%%~nxI"
if defined IMAGE_NAME set "NAME=%IMAGE_NAME%"
call :normalize_name
set "SAFE=%NAME::=_%"
set "SAFE=%SAFE:/=_%"

set "VERSION=%~1"
if "%VERSION%"=="" set "VERSION=latest"
set "DIR=%~2"
if "%DIR%"=="" set "DIR=%ROOT%\dist"

if not exist "%DIR%\" (
  echo Folder not found: %DIR% 1>&2
  exit /b 1
)

set "BEST="
if /i "%VERSION%"=="latest" call :find_latest_file
if /i "%VERSION%"=="latest" if not defined BEST goto :no_file
if /i "%VERSION%"=="latest" set "VERSION=%BEST%"

set "FILE="
if exist "%DIR%\%SAFE%_%VERSION%.tar.gz" set "FILE=%DIR%\%SAFE%_%VERSION%.tar.gz"
if exist "%DIR%\%SAFE%_%VERSION%.tar" set "FILE=%DIR%\%SAFE%_%VERSION%.tar"
if not defined FILE (
  echo File not found: %DIR%\%SAFE%_%VERSION%.tar 1>&2
  exit /b 1
)

echo Loading %FILE%
docker load -i "%FILE%"
if errorlevel 1 exit /b 1
echo Done.
exit /b 0

:no_file
echo No release file (%SAFE%_X.Y.Z.tar) found in %DIR% 1>&2
exit /b 1

:normalize_name
rem Lowercase (batch replace is case-insensitive) and spaces -> "-"
set "NAME=%NAME: =-%"
for %%L in (a b c d e f g h i j k l m n o p q r s t u v w x y z) do call set "NAME=%%NAME:%%L=%%L%%"
exit /b 0

:find_latest_file
set "BEST="
set "BESTKEY="
for /f "delims=" %%F in ('dir /b /a-d "%DIR%\%SAFE%_*.tar*" 2^>nul') do call :consider_file "%%F"
exit /b 0

:consider_file
rem %1 = <name>_<version>.tar[.gz] -> <version>
set "F=%~1"
set "F=%F:.tar.gz=%"
set "F=%F:.tar=%"
call set "F=%%F:%SAFE%_=%%"
call :consider "%F%"
exit /b 0

:consider
rem Keep %1 in BEST if it is the highest X.Y.Z seen so far
set "CAND=%~1"
set "V=%CAND%"
if /i "%V:~0,1%"=="v" set "V=%V:~1%"
echo %V%| findstr /r /x "[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*" >nul || exit /b 0
for /f "tokens=1-3 delims=." %%a in ("%V%") do (
  set "PA=000000%%a"
  set "PB=000000%%b"
  set "PC=000000%%c"
)
set "KEY=%PA:~-6%.%PB:~-6%.%PC:~-6%"
if "%KEY%" GTR "%BESTKEY%" (
  set "BEST=%CAND%"
  set "BESTKEY=%KEY%"
)
exit /b 0
