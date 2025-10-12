#!/bin/bash

# Script para configurar auto-login en contenedores LXC de Proxmox
# Repositorio: https://github.com/tu-usuario/proxmox-tools
# Estilo: Proxmox VE Helper Scripts

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'
BOLD='\033[1m'

# Variables globales
CONTAINER_ID=""
USERNAME="root"

# Función para limpiar pantalla
clear_screen() {
    clear
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}          ${BOLD}${MAGENTA}Proxmox LXC Auto-Login Configuration${NC}          ${CYAN}║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Función para mostrar mensajes
msg_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

msg_ok() {
    echo -e "${GREEN}[✓]${NC} $1"
}

msg_error() {
    echo -e "${RED}[✗]${NC} $1"
}

msg_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

# Función para header de sección
section_header() {
    echo ""
    echo -e "${BOLD}${CYAN}▶ $1${NC}"
    echo -e "${CYAN}──────────────────────────────────────────────────────────────${NC}"
}

# Función para mostrar spinner
spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " ${CYAN}[%c]${NC}  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# Verificar que estamos en Proxmox
check_proxmox() {
    if ! command -v pct &> /dev/null; then
        msg_error "Este script debe ejecutarse en el host de Proxmox VE"
        exit 1
    fi
}

# Listar contenedores
list_containers() {
    section_header "Contenedores LXC Disponibles"
    echo ""
    printf "%-8s %-20s %-15s %-10s\n" "ID" "NOMBRE" "ESTADO" "TIPO"
    echo "─────────────────────────────────────────────────────────────"
    
    pct list | tail -n +2 | while read -r line; do
        id=$(echo $line | awk '{print $1}')
        status=$(echo $line | awk '{print $2}')
        name=$(echo $line | awk '{print $3}')
        
        if [ "$status" == "running" ]; then
            status_color="${GREEN}running${NC}"
        else
            status_color="${RED}stopped${NC}"
        fi
        
        printf "%-8s %-20s %-25s %-10s\n" "$id" "$name" "$(echo -e $status_color)" "LXC"
    done
    echo ""
}

# Menú principal
show_main_menu() {
    clear_screen
    
    echo -e "${BOLD}Opciones disponibles:${NC}"
    echo ""
    echo -e "  ${GREEN}1)${NC} Configurar auto-login en contenedor"
    echo -e "  ${GREEN}2)${NC} Listar contenedores disponibles"
    echo -e "  ${GREEN}3)${NC} Instalar script en el sistema"
    echo -e "  ${GREEN}4)${NC} Ver información del script"
    echo -e "  ${RED}5)${NC} Salir"
    echo ""
    echo -ne "${BOLD}Selecciona una opción [1-5]:${NC} "
}

# Función para solicitar ID de contenedor
ask_container_id() {
    list_containers
    echo -ne "${BOLD}Ingresa el ID del contenedor:${NC} "
    read CONTAINER_ID
    
    if ! pct status $CONTAINER_ID &> /dev/null; then
        msg_error "El contenedor $CONTAINER_ID no existe"
        echo ""
        read -p "Presiona Enter para continuar..."
        return 1
    fi
    
    return 0
}

# Función para solicitar usuario
ask_username() {
    echo ""
    echo -ne "${BOLD}Ingresa el usuario para auto-login [root]:${NC} "
    read input_user
    
    if [ -z "$input_user" ]; then
        USERNAME="root"
    else
        USERNAME="$input_user"
    fi
    
    msg_info "Usuario seleccionado: ${BOLD}$USERNAME${NC}"
}

# Función para confirmar
ask_confirmation() {
    echo ""
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${BOLD}Configuración a aplicar:${NC}"
    echo -e "  • Contenedor: ${CYAN}$CONTAINER_ID${NC}"
    echo -e "  • Usuario: ${CYAN}$USERNAME${NC}"
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -ne "${BOLD}¿Continuar? (s/n):${NC} "
    read -n 1 -r
    echo ""
    
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        msg_warning "Operación cancelada"
        return 1
    fi
    return 0
}

# Función principal de configuración
configure_autologin() {
    clear_screen
    section_header "Configurar Auto-Login"
    echo ""
    
    # Solicitar ID de contenedor
    if ! ask_container_id; then
        return
    fi
    
    # Verificar estado del contenedor
    CONTAINER_STATUS=$(pct status $CONTAINER_ID | awk '{print $2}')
    if [ "$CONTAINER_STATUS" != "running" ]; then
        msg_warning "El contenedor $CONTAINER_ID no está corriendo"
        echo -ne "${BOLD}¿Quieres iniciarlo? (s/n):${NC} "
        read -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Ss]$ ]]; then
            msg_info "Iniciando contenedor $CONTAINER_ID..."
            pct start $CONTAINER_ID &
            spinner $!
            msg_ok "Contenedor iniciado"
            sleep 2
        else
            msg_error "El contenedor debe estar corriendo"
            read -p "Presiona Enter para continuar..."
            return
        fi
    fi
    
    # Solicitar usuario
    ask_username
    
    # Confirmar
    if ! ask_confirmation; then
        read -p "Presiona Enter para continuar..."
        return
    fi
    
    # Aplicar configuración
    section_header "Aplicando Configuración"
    echo ""
    
    msg_info "Creando directorio de configuración..."
    pct exec $CONTAINER_ID -- mkdir -p /etc/systemd/system/container-getty@1.service.d/ 2>/dev/null
    msg_ok "Directorio creado"
    
    msg_info "Creando archivo de override..."
    pct exec $CONTAINER_ID -- bash -c "cat > /etc/systemd/system/container-getty@1.service.d/override.conf << 'EOF'
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin $USERNAME --noclear --keep-baud 115200,38400,9600 pts/%I \$TERM
Type=idle
EOF" 2>/dev/null
    msg_ok "Archivo creado"
    
    msg_info "Recargando systemd..."
    pct exec $CONTAINER_ID -- systemctl daemon-reload 2>/dev/null
    msg_ok "Systemd recargado"
    
    msg_info "Habilitando servicio..."
    pct exec $CONTAINER_ID -- systemctl enable container-getty@1.service 2>/dev/null
    msg_ok "Servicio habilitado"
    
    echo ""
    msg_warning "Se requiere reiniciar el contenedor para aplicar cambios"
    echo -ne "${BOLD}¿Reiniciar ahora? (s/n):${NC} "
    read -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        msg_info "Reiniciando contenedor..."
        pct stop $CONTAINER_ID 2>/dev/null &
        spinner $!
        sleep 1
        pct start $CONTAINER_ID 2>/dev/null &
        spinner $!
        msg_ok "Contenedor reiniciado"
    else
        msg_warning "Reinicia manualmente con: pct stop $CONTAINER_ID && pct start $CONTAINER_ID"
    fi
    
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║${NC}              ${BOLD}✓ Configuración completada exitosamente${NC}           ${GREEN}║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    read -p "Presiona Enter para continuar..."
}

# Función para instalar script
install_script() {
    clear_screen
    section_header "Instalar Script en el Sistema"
    echo ""
    
    INSTALL_DIR="/usr/local/bin"
    SCRIPT_NAME="lxc-autologin"
    INSTALL_PATH="$INSTALL_DIR/$SCRIPT_NAME"
    
    msg_info "Directorio de instalación: ${CYAN}$INSTALL_DIR${NC}"
    msg_info "Nombre del comando: ${CYAN}$SCRIPT_NAME${NC}"
    echo ""
    
    if [ -f "$INSTALL_PATH" ]; then
        msg_warning "El script ya está instalado"
        echo -ne "${BOLD}¿Actualizar? (s/n):${NC} "
        read -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Ss]$ ]]; then
            return
        fi
    fi
    
    if [ ! -w "$INSTALL_DIR" ]; then
        msg_error "No tienes permisos para escribir en $INSTALL_DIR"
        msg_info "Ejecuta este script con sudo"
        read -p "Presiona Enter para continuar..."
        return
    fi
    
    msg_info "Instalando script..."
    
    if [ -f "$0" ] && [ "$0" != "$INSTALL_PATH" ]; then
        cp "$0" "$INSTALL_PATH"
        chmod +x "$INSTALL_PATH"
    else
        REPO_URL="https://raw.githubusercontent.com/tu-usuario/proxmox-tools/main/lxc-autologin.sh"
        if command -v wget &> /dev/null; then
            wget -qO "$INSTALL_PATH" "$REPO_URL" &
            spinner $!
        elif command -v curl &> /dev/null; then
            curl -fsSL "$REPO_URL" -o "$INSTALL_PATH" &
            spinner $!
        fi
        chmod +x "$INSTALL_PATH"
    fi
    
    msg_ok "Script instalado correctamente"
    echo ""
    msg_info "Ahora puedes usar: ${GREEN}${BOLD}lxc-autologin${NC}"
    echo ""
    read -p "Presiona Enter para continuar..."
}

# Función para mostrar información
show_info() {
    clear_screen
    section_header "Información del Script"
    echo ""
    echo -e "${BOLD}Nombre:${NC} Proxmox LXC Auto-Login"
    echo -e "${BOLD}Versión:${NC} 1.0.0"
    echo -e "${BOLD}Repositorio:${NC} ${CYAN}https://github.com/tu-usuario/proxmox-tools${NC}"
    echo ""
    echo -e "${BOLD}Descripción:${NC}"
    echo "  Configura auto-login en contenedores LXC de Proxmox VE,"
    echo "  eliminando la necesidad de ingresar usuario y contraseña."
    echo ""
    echo -e "${BOLD}Uso desde línea de comandos:${NC}"
    echo -e "  ${GREEN}lxc-autologin <container_id> [username]${NC}"
    echo ""
    echo -e "${BOLD}Instalación rápida:${NC}"
    echo -e "  ${CYAN}bash <(wget -qLO - https://raw.githubusercontent.com/tu-usuario/proxmox-tools/main/lxc-autologin.sh)${NC}"
    echo ""
    echo -e "${BOLD}⚠️  Consideraciones de seguridad:${NC}"
    echo "  • El auto-login elimina una capa de seguridad"
    echo "  • Úsalo solo en entornos de desarrollo o laboratorio"
    echo "  • No recomendado para contenedores en producción"
    echo ""
    read -p "Presiona Enter para continuar..."
}

# Función para modo CLI (sin menú)
run_cli_mode() {
    check_proxmox
    
    if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
        echo "Uso: $0 [opciones]"
        echo ""
        echo "Opciones:"
        echo "  <container_id> [username]    Configurar auto-login (modo CLI)"
        echo "  --install                     Instalar script en /usr/local/bin"
        echo "  --help, -h                    Mostrar esta ayuda"
        echo "  (sin argumentos)              Mostrar menú interactivo"
        exit 0
    fi
    
    if [ "$1" == "--install" ]; then
        INSTALL_DIR="/usr/local/bin"
        SCRIPT_NAME="lxc-autologin"
        INSTALL_PATH="$INSTALL_DIR/$SCRIPT_NAME"
        
        if [ ! -w "$INSTALL_DIR" ]; then
            msg_error "No tienes permisos. Ejecuta: sudo $0 --install"
            exit 1
        fi
        
        if [ -f "$0" ]; then
            cp "$0" "$INSTALL_PATH"
        else
            wget -qO "$INSTALL_PATH" "https://raw.githubusercontent.com/tu-usuario/proxmox-tools/main/lxc-autologin.sh"
        fi
        chmod +x "$INSTALL_PATH"
        msg_ok "Script instalado en $INSTALL_PATH"
        msg_info "Usa: lxc-autologin <container_id>"
        exit 0
    fi
    
    CONTAINER_ID=$1
    USERNAME=${2:-root}
    
    if ! pct status $CONTAINER_ID &> /dev/null; then
        msg_error "El contenedor $CONTAINER_ID no existe"
        exit 1
    fi
    
    CONTAINER_STATUS=$(pct status $CONTAINER_ID | awk '{print $2}')
    if [ "$CONTAINER_STATUS" != "running" ]; then
        msg_warning "Iniciando contenedor..."
        pct start $CONTAINER_ID
        sleep 3
    fi
    
    msg_info "Configurando auto-login para contenedor $CONTAINER_ID (usuario: $USERNAME)..."
    
    pct exec $CONTAINER_ID -- mkdir -p /etc/systemd/system/container-getty@1.service.d/
    pct exec $CONTAINER_ID -- bash -c "cat > /etc/systemd/system/container-getty@1.service.d/override.conf << 'EOF'
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin $USERNAME --noclear --keep-baud 115200,38400,9600 pts/%I \$TERM
Type=idle
EOF"
    pct exec $CONTAINER_ID -- systemctl daemon-reload
    pct exec $CONTAINER_ID -- systemctl enable container-getty@1.service
    
    msg_info "Reiniciando contenedor..."
    pct stop $CONTAINER_ID
    sleep 2
    pct start $CONTAINER_ID
    
    msg_ok "Auto-login configurado exitosamente"
    exit 0
}

# Función principal del menú interactivo
main_menu() {
    check_proxmox
    
    while true; do
        show_main_menu
        read option
        
        case $option in
            1)
                configure_autologin
                ;;
            2)
                clear_screen
                list_containers
                read -p "Presiona Enter para continuar..."
                ;;
            3)
                install_script
                ;;
            4)
                show_info
                ;;
            5)
                clear_screen
                echo -e "${GREEN}¡Hasta luego!${NC}"
                echo ""
                exit 0
                ;;
            *)
                msg_error "Opción inválida"
                sleep 1
                ;;
        esac
    done
}

# Punto de entrada
if [ $# -eq 0 ]; then
    # Modo interactivo (sin argumentos)
    main_menu
else
    # Modo CLI (con argumentos)
    run_cli_mode "$@"
fi
