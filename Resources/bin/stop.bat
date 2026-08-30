@echo off
title Tianji Microservices - Stop
echo ========================================
echo   Tianji Academy Microservices - STOP
echo ========================================
echo.
echo Stopping: Frontend ^> Services ^> RabbitMQ ^> ES ^> Nacos
echo Keeping: MySQL / Redis
echo.
powershell -ExecutionPolicy Bypass -File "%~dp0stop-all.ps1"
echo.
echo Done. Press any key to close.
pause
