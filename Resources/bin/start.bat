@echo off
title Tianji Microservices - Start
echo ========================================
echo   Tianji Academy Microservices - START
echo ========================================
echo.
echo Starting: Nacos ^> Elasticsearch ^> RabbitMQ ^> 13 services
echo It takes about 1-2 minutes. Do NOT close this window.
echo.
powershell -ExecutionPolicy Bypass -File "%~dp0start-all.ps1"
echo.
echo Done. Press any key to close.
pause
