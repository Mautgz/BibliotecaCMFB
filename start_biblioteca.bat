@echo off
echo Iniciando Sistema de Biblioteca...

:: Esperar a que Docker Desktop esté listo
timeout /t 30

:: Navegar al directorio del proyecto
cd /d %~dp0

:: Iniciar los servicios de Docker
docker-compose up -d

:: Verificar que los servicios estén funcionando
echo Verificando servicios...
timeout /t 10

:: Mostrar estado de los contenedores
docker-compose ps

echo Sistema iniciado correctamente.
echo Puede acceder al sistema en:
echo - Frontend: http://localhost
echo - Chatbot: http://localhost:8080
echo - phpMyAdmin: http://localhost:8081

:: Mantener la ventana abierta
pause 