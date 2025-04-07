@echo off
REM Formato de fecha y hora sin caracteres inválidos
for /f "tokens=1-4 delims=/ " %%a in ("%date%") do (
    set DD=%%a
    set MM=%%b
    set YYYY=%%c
)
for /f "tokens=1-2 delims=: " %%a in ("%time%") do (
    set HH=%%a
    set MN=%%b
)

REM Quitar espacio inicial si la hora es de un solo dígito
if "%HH:~0,1%"==" " set HH=0%HH:~1,1%

set TIMESTAMP=%YYYY%%MM%%DD%_%HH%%MN%
set BACKUP_DIR="C:\Users\leome\OneDrive\Escritorio\DB_ERP_software\Backups"
set DB_NAME=FarmaciaEconofarma
set USER=postgres
set PGPASSWORD=12345

if not exist %BACKUP_DIR% mkdir %BACKUP_DIR%
"C:\Program Files\PostgreSQL\17\bin\pg_dump.exe" -U %USER% -d %DB_NAME% -F c -f "%BACKUP_DIR%\backup_%TIMESTAMP%.bak"

echo Backup realizado: backup_%TIMESTAMP%.bak
