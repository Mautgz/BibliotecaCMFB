@echo off
echo Deteniendo Sistema de Biblioteca...

:: Navegar al directorio del proyecto
cd /d %~dp0

:: Detener los servicios de Docker
docker-compose down

echo Sistema detenido correctamente.
timeout /t 5 