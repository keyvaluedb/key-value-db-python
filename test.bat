@echo off

SET SELECTED=%1

if not "%SELECTED%" == "" (
    echo.
    echo %SELECTED%
    python test/%SELECTED%.py
    exit /b 0
)

echo.
echo test_util
python test/test_util.py

echo.
echo test_stream
python test/test_stream.py

echo.
echo test_konfiger
python test/test_konfiger.py

echo.
echo test_resolve
python test/test_resolve.py