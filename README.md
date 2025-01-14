Monitorización del Sistema

Este repositorio contiene un conjunto de herramientas y configuraciones para implementar un sistema de monitorización en entornos Linux. El proyecto utiliza systemd y cron para gestionar y programar tareas, además de scripts personalizados para recopilar información sobre el estado del sistema.

Archivos principales

1. monitorizacion.sh

Un script en bash que realiza las siguientes tareas de supervisión:

Identifica los procesos que consumen más CPU y memoria.

Supervisa el espacio en disco, resaltando particiones con menos del 10% de espacio libre.

Analiza los registros del sistema (syslog y dmesg) en busca de errores.

Revisa los registros de autenticación para detectar accesos fallidos o sospechosos.

Enumera los últimos inicios de sesión y los intentos fallidos.

Lista los servicios en ejecución mediante systemctl.

Supervisa la carga del sistema (Load Average).

Muestra el uso básico de la red.

Los resultados de la supervisión se almacenan en el archivo de log ubicado en /var/log/monitorizacion.log.

2. monitorizacion.service

Archivo de unidad para systemd que define el servicio de monitorización. Este servicio ejecuta el script monitorizacion.sh para recopilar datos del sistema.

3. monitorizacion.timer

Archivo de temporizador para systemd que programa la ejecución del servicio monitorizacion.service. Se activa en intervalos regulares definidos en el archivo.

4. crontab

Archivo de configuración para cron que contiene:

Una tarea comentada que ejecuta el script de monitorización cada 5 minutos.

Una tarea activa que verifica cada 5 minutos si el temporizador monitorizacion.timer está funcionando y lo reinicia en caso de que no lo esté.

Instalación y Configuración

Paso 1: Clonar el repositorio

git clone https://github.com/DavidGambin/ASO2025.git
cd ASO2025

Paso 2: Configurar el script de monitorización

Asegúrate de que el archivo monitorizacion.sh tenga permisos de ejecución:

chmod +x monitorizacion.sh

Paso 3: Configurar systemd

Copia los archivos de servicio y temporizador a los directorios correspondientes:

sudo cp monitorizacion.service /etc/systemd/system/
sudo cp monitorizacion.timer /etc/systemd/system/

Recarga las configuraciones de systemd y habilita el temporizador:

sudo systemctl daemon-reload
sudo systemctl enable monitorizacion.timer
sudo systemctl start monitorizacion.timer

Paso 4: Configurar cron (opcional)

Edita el crontab para incluir las tareas:

sudo crontab -e

Agrega las siguientes líneas:

*/5 * * * * systemctl is-active monitorizacion.timer || systemctl restart monitorizacion.timer

Uso

Los registros de la supervisión se encuentran en /var/log/monitorizacion.log.

El temporizador de systemd garantiza que el script de monitorización se ejecute regularmente.

Comandos útiles

Verificar el estado del temporizador:

sudo systemctl status monitorizacion.timer

Verificar el estado del servicio:

sudo systemctl status monitorizacion.service

Detener el temporizador:

sudo systemctl stop monitorizacion.timer

Licencia

Este proyecto está bajo la licencia MIT. Consulta el archivo LICENSE para más información.

