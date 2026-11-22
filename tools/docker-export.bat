@echo off
rem Export this project's Docker image to a .tar file.
rem Usage: tools\docker-export.bat [version^|latest] [out_dir]
rem   version : release tag, e.g. 1.2.0 (default: latest = highest X.Y.Z tag found locally)
rem   out_dir : output folder (default: ^<project^>\dist)
rem Image name = %%IMAGE_NAME%%, or the project folder name (lowercase, spaces -^> "-").
rem Output: ^<out_dir^>\^<name^>_^<version^>.tar
setlocal

for %%I in ("%~dp0..") do set "ROOT=%%~fI"
for %%I in ("%ROOT%") do set "NAME=%%~nxI"
if defined IMAGE_NAME set "NAME=%IMAGE_NAME%"
call :normalize_name
set "SAFE=%NAME::=_%"
set "SAFE=%SAFE:/=_%"

set "VERSION=%~1"
if "%VERSION%"=="" set "VERSION=latest"
set "OUT_DIR=%~2"
if "%OUT_DIR%"=="" set "OUT_DIR=%ROOT%\dist"

set "BEST="
if /i "%VERSION%"=="latest" call :find_latest_tag
if /i "%VERSION%"=="latest" if not defined BEST goto :no_tag
if /i "%VERSION%"=="latest" set "VERSION=%BEST%"

set "IMAGE=%NAME%:%VERSION%"
docker image inspect "%IMAGE%" >nul 2>&1
if errorlevel 1 (
  echo Image not found: %IMAGE% 1>&2
  exit /b 1
)

if not exist "%OUT_DIR%" mkdir "%OUT_DIR%"
set "FILE=%OUT_DIR%\%SAFE%_%VERSION%.tar"

echo Exporting %IMAGE% -^> %FILE%
docker save -o "%FILE%" "%IMAGE%"
if errorlevel 1 exit /b 1
echo Done.
exit /b 0

:no_tag
echo No release tag (X.Y.Z) found for image: %NAME% 1>&2
exit /b 1

:normalize_name
rem Lowercase (batch replace is case-insensitive) and spaces -> "-"
set "NAME=%NAME: =-%"
for %%L in (a b c d e f g h i j k l m n o p q r s t u v w x y z) do call set "NAME=%%NAME:%%L=%%L%%"
exit /b 0

:find_latest_tag
set "BEST="
set "BESTKEY="
for /f "delims=" %%T in ('docker images --filter dangling^=false --format "{{.Tag}}" "%NAME%" 2^>nul') do call :consider "%%T"
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
