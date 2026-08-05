@echo off
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "convert.ps1"
