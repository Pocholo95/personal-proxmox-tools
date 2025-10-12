# 🛠️ Proxmox Tools

Colección de scripts útiles para administrar Proxmox VE, contenedores LXC y máquinas virtuales con interfaces interactivas al estilo Proxmox VE Helper Scripts.

<div align="center">

[![GitHub stars](https://img.shields.io/github/stars/tu-usuario/proxmox-tools?style=social)](https://github.com/tu-usuario/proxmox-tools/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/tu-usuario/proxmox-tools?style=social)](https://github.com/tu-usuario/proxmox-tools/network/members)
[![GitHub issues](https://img.shields.io/github/issues/tu-usuario/proxmox-tools)](https://github.com/tu-usuario/proxmox-tools/issues)
[![GitHub license](https://img.shields.io/github/license/tu-usuario/proxmox-tools)](https://github.com/tu-usuario/proxmox-tools/blob/main/LICENSE)

</div>

## 📋 Scripts Disponibles

| Script | Descripción | Uso Rápido |
|--------|-------------|------------|
| [lxc-autologin.sh](#-lxc-autologinsh) | Configurar auto-login en contenedores LXC | `bash <(wget -qLO - https://raw.githubusercontent.com/tu-usuario/proxmox-tools/main/lxc-autologin.sh)` |

## 🚀 Características

- ✨ **Interfaces interactivas** con menús visuales
- 🎨 **Diseño colorido** y fácil de usar
- ⚡ **Modo CLI** para automatización
- 💾 **Instalación permanente** opcional
- 🛡️ **Validaciones** de seguridad incorporadas
- 📖 **Documentación** detallada en cada script
- 🔄 **Feedback visual** durante operaciones

## 📦 Instalación

### Opción 1: Uso Directo (Sin Instalar)

Ejecuta cualquier script directamente desde GitHub:

```bash
bash <(wget -qLO - https://raw.githubusercontent.com/tu-usuario/proxmox-tools/main/<nombre-script>.sh)
```

### Opción 2: Clonar Repositorio

```bash
git clone https://github.com/tu-usuario/proxmox-tools.git
cd proxmox-tools
chmod +x *.sh
```

### Opción 3: Instalación Individual

Cada script puede instalarse de forma permanente en `/usr/local/bin/`:

```bash
bash <(wget -qLO - https://raw.githubusercontent.com/tu-usuario/proxmox-tools/main/<nombre-script>.sh) --install
```

## 📚 Documentación de Scripts

### 🔐 lxc-autologin.sh

Configura auto-login en contenedores LXC de Proxmox, eliminando la necesidad de ingresar usuario y contraseña.

**Uso Rápido:**
```bash
# Modo interactivo
bash <(wget -qLO - https://raw.githubusercontent.com/tu-usuario/proxmox-tools/main/lxc-autologin.sh)

# Modo CLI
bash <(wget -qLO - https://raw.githubusercontent.com/tu-usuario/proxmox-tools/main/lxc-autologin.sh) 104

# Con usuario específico
bash <(wget -qLO - https://raw.githubusercontent.com/tu-usuario/proxmox-tools/main/lxc-autologin.sh) 104 miusuario

# Instalar permanentemente
bash <(wget -qLO - https://raw.githubusercontent.com/tu-usuario/proxmox-tools/main/lxc-autologin.sh) --install
```

**Características:**
- ✅ Interfaz interactiva con menú visual
- 📊 Lista de contenedores disponibles
- 🔄 Spinner animado durante operaciones
- ⚠️ Validación de contenedor y estado
- 💾 Instalación opcional como comando

**Documentación completa:** [Ver en Wiki](../../wiki/lxc-autologin)

---

## 🔧 Requisitos

- Proxmox VE 7.x o superior
- Acceso root al host de Proxmox
- `wget` o `curl` instalado
- Bash 4.0 o superior

## 📖 Guía de Uso General

### Modo Interactivo

Todos los scripts ofrecen un menú interactivo cuando se ejecutan sin argumentos:

```bash
bash <(wget -qLO - https://raw.githubusercontent.com/tu-usuario/proxmox-tools/main/<script>.sh)
```

Esto mostrará un menú con opciones como:
1. Función principal del script
2. Listar recursos disponibles
3. Instalar script en el sistema
4. Ver información y ayuda
5. Salir

### Modo CLI

Para automatización o uso rápido, pasa argumentos directamente:

```bash
bash <(wget -qLO - https://raw.githubusercontent.com/tu-usuario/proxmox-tools/main/<script>.sh) [argumentos]
```

### Instalación Permanente

Para instalar cualquier script como comando del sistema:

```bash
# Con sudo si es necesario
bash <(wget -qLO - https://raw.githubusercontent.com/tu-usuario/proxmox-tools/main/<script>.sh) --install
```

Después podrás usar el comando directamente:
```bash
nombre-comando [argumentos]
```

## ⚠️ Consideraciones de Seguridad

- 🔒 Revisa siempre el código antes de ejecutar scripts de internet
- 🧪 Prueba primero en entornos de desarrollo
- 💾 Realiza backups antes de modificar configuraciones críticas
- 🔐 Ten cuidado con scripts que afectan la seguridad (como auto-login)
- 📝 Lee la documentación de cada script antes de usarlo

## 🐛 Troubleshooting

### Error: "pct: command not found"

**Solución:** Asegúrate de estar ejecutando el script en el **host de Proxmox**, no dentro de un contenedor.

### Error de permisos

**Solución:** Ejecuta con sudo o como root:
```bash
sudo bash <(wget -qLO - https://raw.githubusercontent.com/tu-usuario/proxmox-tools/main/<script>.sh)
```

### El menú no se ve bien

**Solución:** Asegúrate de usar una terminal con soporte de colores ANSI. Si el problema persiste, usa el modo CLI.

### Más ayuda

Para cada script específico, ejecuta:
```bash
bash <(wget -qLO - https://raw.githubusercontent.com/tu-usuario/proxmox-tools/main/<script>.sh) --help
```

## 🤝 Contribuciones

¡Las contribuciones son bienvenidas! Aquí hay algunas formas de ayudar:

1. 🐛 **Reportar bugs** - Abre un issue en GitHub
2. 💡 **Sugerir ideas** - Propón nuevos scripts o mejoras
3. 📝 **Mejorar documentación** - Ayuda a hacer más claro el README
4. 🔧 **Enviar pull requests** - Contribuye código

### ¿Cómo contribuir?

1. Fork el repositorio
2. Crea una rama (`git checkout -b feature/nuevo-script`)
3. Commit tus cambios (`git commit -am 'Agregar nuevo script'`)
4. Push a la rama (`git push origin feature/nuevo-script`)
5. Abre un Pull Request

### Lineamientos para nuevos scripts

Al crear un nuevo script para este repositorio:

- ✅ Incluir modo interactivo con menú
- ✅ Incluir modo CLI para automatización
- ✅ Usar colores para mejor UX
- ✅ Validar entradas y condiciones
- ✅ Incluir opción `--help`
- ✅ Incluir opción `--install`
- ✅ Documentar en el README
- ✅ Comentar el código adecuadamente

## 📝 Roadmap

Scripts planeados para futuras versiones:

### Contenedores LXC
- [ ] 💾 Backup automático y programado
- [ ] 📋 Clonación masiva con configuración
- [ ] 🔄 Actualización masiva de contenedores
- [ ] 📊 Monitoreo de recursos en tiempo real
- [ ] 🗂️ Gestión de templates

### Máquinas Virtuales
- [ ] 🖥️ Creación rápida de VMs
- [ ] 💿 Gestión de ISOs y templates
- [ ] 📸 Snapshots automatizados

### Networking
- [ ] 🌐 Configuración simplificada de redes
- [ ] 🔒 Gestión de firewall
- [ ] 🌉 Configuración de bridges

### Almacenamiento
- [ ] 💾 Gestión de storages
- [ ] 📊 Análisis de uso de disco
- [ ] 🧹 Limpieza de recursos no utilizados

### Sistema
- [ ] ⚙️ Configuración inicial de Proxmox
- [ ] 🔧 Mantenimiento automático
- [ ] 📈 Dashboard de estado del cluster

**¿Tienes una idea?** [Abre un issue](https://github.com/tu-usuario/proxmox-tools/issues/new) con la etiqueta `enhancement`.

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo [LICENSE](LICENSE) para más detalles.

## 👤 Autor

**Tu Nombre**
- GitHub: [@tu-usuario](https://github.com/tu-usuario)
- Repositorio: [proxmox-tools](https://github.com/tu-usuario/proxmox-tools)

## 🙏 Agradecimientos

- Inspirado en [Proxmox VE Helper Scripts](https://github.com/tteck/Proxmox) de tteck
- Comunidad de Proxmox VE
- Todos los contribuidores del proyecto

## 📞 Soporte

- 🐛 **Reportar bugs**: [GitHub Issues](https://github.com/tu-usuario/proxmox-tools/issues)
- 💬 **Discusiones**: [GitHub Discussions](https://github.com/tu-usuario/proxmox-tools/discussions)
- 📖 **Documentación**: [GitHub Wiki](https://github.com/tu-usuario/proxmox-tools/wiki)
- ⭐ **Si te es útil**: Dale una estrella al repositorio

## 🌟 Estrellas en el tiempo

[![Stargazers over time](https://starchart.cc/tu-usuario/proxmox-tools.svg)](https://starchart.cc/tu-usuario/proxmox-tools)

---

<div align="center">

**Hecho con ❤️ para la comunidad de Proxmox**

Si este proyecto te ayudó, considera darle una ⭐

</div>
