#!/bin/bash

# Ruta del archivo de log
LOG_FILE="/var/log/monitorizacion.log"

# Color azul para títulos (ANSI)
COLOR_TITLE="\033[1;34m"
COLOR_RESET="\033[0m"

# Función para añadir separadores destacados
separador() {
    echo -e "${COLOR_TITLE}======================================================================================${COLOR_RESET}" >> $LOG_FILE
    echo -e "${COLOR_TITLE}$(date)${COLOR_RESET}" >> $LOG_FILE
    echo -e "${COLOR_TITLE}======================================================================================${COLOR_RESET}" >> $LOG_FILE
}

# Función para supervisar los procesos que más consumen CPU y memoria
supervisar_recursos() {
    echo -e "\n${COLOR_TITLE}Procesos que más consumen CPU y memoria:${COLOR_RESET}" >> $LOG_FILE
    ps aux --sort=-%cpu,-%mem | head -n 6 >> $LOG_FILE
    echo -e "\n" >> $LOG_FILE
}

# Función para supervisar el espacio en disco (particiones con menos del 10% libre)
supervisar_espacio_disco() {
    echo -e "\n${COLOR_TITLE}Particiones con menos del 10% de espacio libre:${COLOR_RESET}" >> $LOG_FILE
    df -h | awk '$5+0 >= 90 {print $0}' >> $LOG_FILE
    echo -e "\n" >> $LOG_FILE
}

# Función para revisar los logs del sistema (syslog y dmesg)
revisar_logs_sistema() {
    echo -e "\n${COLOR_TITLE}Revisión de syslog y dmesg para errores:${COLOR_RESET}" >> $LOG_FILE
    grep -i "error" /var/log/syslog >> $LOG_FILE 2>/dev/null
    dmesg | grep -i "error" >> $LOG_FILE 2>/dev/null
    echo -e "\n" >> $LOG_FILE
}

# Función para revisar logs de autenticación
revisar_logs_autenticacion() {
    echo -e "\n${COLOR_TITLE}Revisión de logs de autenticación:${COLOR_RESET}" >> $LOG_FILE
    grep -E "Failed|Accepted|sudo|sshd" /var/log/auth.log >> $LOG_FILE 2>/dev/null
    echo -e "\n" >> $LOG_FILE
}

# Función para revisar sesiones de usuario (últimos inicios de sesión e intentos fallidos)
revisar_sesiones_usuario() {
    echo -e "\n${COLOR_TITLE}Revisión de sesiones de usuario:${COLOR_RESET}" >> $LOG_FILE
    last >> $LOG_FILE 2>/dev/null
    lastb >> $LOG_FILE 2>/dev/null
    echo -e "\n" >> $LOG_FILE
}

# Función para revisar el estado de los servicios críticos
revisar_estado_servicios() {
    echo -e "\n${COLOR_TITLE}Estado de los servicios en ejecución:${COLOR_RESET}" >> $LOG_FILE
    systemctl list-units --type=service --state=running >> $LOG_FILE
    echo -e "\n" >> $LOG_FILE
}

# Función para supervisar la carga del sistema (Load Average)
supervisar_carga_sistema() {
    echo -e "\n${COLOR_TITLE}Carga del sistema (Load Average):${COLOR_RESET}" >> $LOG_FILE
    uptime >> $LOG_FILE
    echo -e "\n" >> $LOG_FILE
}

# Función para supervisar el uso de la red (ancho de banda básico)
supervisar_red() {
    echo -e "\n${COLOR_TITLE}Uso básico de la red (interfaces activas):${COLOR_RESET}" >> $LOG_FILE
    ip -s link >> $LOG_FILE 2>/dev/null
    echo -e "\n" >> $LOG_FILE
}

# Ejecutar todas las funciones de monitoreo
separador
supervisar_recursos
supervisar_espacio_disco
revisar_logs_sistema
revisar_logs_autenticacion
revisar_sesiones_usuario
revisar_estado_servicios
supervisar_carga_sistema
supervisar_red

echo -e "\n${COLOR_TITLE}$(date) - Fin de la supervisión${COLOR_RESET}" >> $LOG_FILE
