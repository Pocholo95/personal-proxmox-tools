# 🛠️ Proxmox Tools

Colección de scripts útiles para administrar Proxmox VE y contenedores LXC.

## 📋 Scripts Disponibles

### lxc-autologin.sh

Script para configurar auto-login en contenedores LXC de Proxmox, eliminando la necesidad de ingresar usuario y contraseña cada vez que accedes al contenedor.

**Características:**
- ✅ Configuración automática de auto-login
- ✅ Soporte para cualquier usuario (por defecto: root)
- ✅ Validación de contenedor y estado
- ✅ Instalación de alias para uso rápido
- ✅ Mensajes con colores para mejor legibilidad

## 🚀 Instalación Rápida

```bash
# Clonar el repositorio
git clone https://github.com/tu-usuario/proxmox-tools.git
cd proxmox-tools

# Dar permisos de ejecución
chmod +x lxc-autologin.sh

# Instalar alias (opcional pero recomendado)
./lxc-autologin.sh --install-alias
```

## 📖 Uso

### Configurar auto-login

```bash
# Con usuario root (por defecto)
./lxc-autologin.sh 104

# Con un usuario específico
./lxc-autologin.sh 104 miusuario
```

### Usando el alias (después de instalarlo)

```bash
# Una vez instalado el alias, puedes usar:
lxc-autologin 104
lxc-autologin 105 admin
```

### Opciones disponibles

```bash
./lxc-autologin.sh --help              # Mostrar ayuda
./lxc-autologin.sh --install-alias     # Instalar alias en el sistema
./lxc-autologin.sh <container_id>      # Configurar auto-login con root
./lxc-autologin.sh <container_id> user # Configurar auto-login con usuario específico
```

## ⚙️ Cómo Funciona

El script configura systemd dentro del contenedor LXC para que el servicio `container-getty@1` inicie sesión automáticamente con el usuario especificado. 

**Cambios realizados:**
1. Crea el directorio `/etc/systemd/system/container-getty@1.service.d/`
2. Crea un archivo `override.conf` con la configuración de auto-login
3. Recarga systemd y habilita el servicio
4. Reinicia el contenedor para aplicar los cambios

## ⚠️ Consideraciones de Seguridad

**Importante:** El auto-login elimina una capa de seguridad del contenedor. 

**Recomendaciones:**
- Úsalo solo en entornos de desarrollo o laboratorio
- No uses auto-login en contenedores con datos sensibles
- En producción, considera usar claves SSH en lugar de auto-login
- Asegura el acceso al host de Proxmox con autenticación fuerte

## 🔧 Requisitos

- Proxmox VE (probado en versiones 7.x y 8.x)
- Contenedor LXC con systemd (Ubuntu, Debian, etc.)
- Acceso root al host de Proxmox

## 🐛 Troubleshooting

### El contenedor sigue pidiendo login

Verifica que el servicio esté activo:
```bash
pct enter <container_id>
systemctl status container-getty@1.service
```

### El script no encuentra el contenedor

Asegúrate de:
- Estar ejecutando el script en el host de Proxmox (no dentro del contenedor)
- Que el ID del contenedor sea correcto
- Que el contenedor exista: `pct list`

### El alias no funciona

Recarga tu shell:
```bash
source ~/.bashrc  # o ~/.zshrc si usas zsh
```

O abre una nueva terminal.

## 🤝 Contribuciones

¡Las contribuciones son bienvenidas! Si tienes ideas para más scripts útiles o mejoras:

1. Fork el repositorio
2. Crea una rama para tu feature (`git checkout -b feature/nuevo-script`)
3. Commit tus cambios (`git commit -am 'Agregar nuevo script'`)
4. Push a la rama (`git push origin feature/nuevo-script`)
5. Abre un Pull Request

## 📝 To-Do

- [ ] Script para backup automático de contenedores
- [ ] Script para clonar contenedores con configuración personalizada
- [ ] Script para gestión de snapshots
- [ ] Script para monitoreo de recursos de contenedores

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## 👤 Autor

Tu Nombre - [@tu-usuario](https://github.com/tu-usuario)

## 🌟 Dame una estrella

Si este proyecto te fue útil, ¡considera darle una estrella en GitHub! ⭐
