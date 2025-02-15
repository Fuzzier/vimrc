@ECHO OFF
REM @version 20240207

IF [%1] NEQ [] ( PUSHD %1 )
CALL :GitGcPruneIfPropery "%~1"
CALL :DoWork
IF [%1] NEQ [] ( POPD )
PAUSE
EXIT/B

:DoWork
REM For each sub-directory.
FOR /F "delims=" %%d IN ('DIR /B /AD-H') DO (
  REM Go into the sub-directory.
  PUSHD "%%~d"
  CALL :GitGcPruneIfPropery "%%~d"
  IF NOT ERRORLEVEL 1 (
    CALL :DoWork
  )
  POPD
)
EXIT /B

:GitGcPruneIfPropery
CALL :CheckGitDirectory %1
IF ERRORLEVEL 1 (
  EXIT /B 1
)
EXIT /B 0

:GitGcPrune
ECHO ====== %~1 ======
git gc
git prune
EXIT /B

:CheckGitDirectory
CALL :CheckGitBareRepository %1
IF ERRORLEVEL 1 ( EXIT /B 1 )
CALL :CheckGitWorkingDirectory %1
IF ERRORLEVEL 1 ( EXIT /B 1 )
EXIT /B 0

:CheckGitBareRepository
IF NOT EXIST "HEAD"    ( EXIT /B 0 )
IF NOT EXIST "objects" ( EXIT /B 0 )
IF NOT EXIST "refs"    ( EXIT /B 0 )
CALL :IsGitDirty objects
IF ERRORLEVEL 1 (
  CALL :GitGcPrune %1
)
EXIT /B 1

:CheckGitWorkingDirectory
IF NOT EXIST ".git"      ( EXIT /B 0 )
IF NOT EXIST ".git/HEAD" ( EXIT /B 0 )
CALL :IsGitDirty .git\objects
IF ERRORLEVEL 1 (
  PUSHD .git
  CALL :GitGcPrune %1
  POPD
)
EXIT /B 1

:IsGitDirty
REM Find folders with two charactors (other than `info` and `pack`)
DIR "%1" /B /AD 2>NUL | FINDSTR /R /C:"^..$" 1>NUL
IF ERRORLEVEL 1 ( EXIT /B 0 )
EXIT /B 1
