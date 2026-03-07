# Sistema de Control de Flota 🚛

Este proyecto es una herramienta para la gestión y control de flota, integrada con Google Sheets a través de Google Apps Script. Permite el registro de horómetros, novedades de operarios y bitácoras de mantenimiento.

## 🚀 Configuración del Proyecto

Para que el sistema funcione correctamente, se deben configurar las URLs de los servicios de Google Apps Script.

### Centralización de Variables
Todas las URLs de Google Apps Script se encuentran centralizadas en un solo lugar. Si necesitas actualizar los servicios, solo debes modificar el siguiente archivo:

📂 `js/config.js`

```javascript
const CONFIG = {
    WEB_APP_URL: "URL_DEL_SCRIPT_PRINCIPAL",
    BITACORA_APPSCRIPT_URL: "URL_DEL_SCRIPT_BITACORA"
};
```

---

## 🛠️ Estructura del Proyecto

### Vistas Principal y Formularios
- `index.html`: Panel de control principal y navegación.
- `views/Bitacora_Mantenimiento.html`: Registro de mantenimientos correctivos y preventivos.
- `views/Subir_Horometros.html`: Gestión diaria de horómetros.
- `views/Consolidado_Novedades.html`: Registro de novedades y generación de reportes Excel.

### Recursos y Estilos
- `css/`: Contiene los estilos visuales del proyecto (`bitacora.css`, `horometros.css`, `novedades.css`).
- `js/config.js`: **Archivo de configuración global (URLs).**
- `favicon.png`: Icono del sitio.
- `manifest.json`: Permite instalar la aplicación en dispositivos móviles.

### Backend (Google Apps Script)
Los códigos necesarios para configurar Google Sheets se encuentran en:
👉 **[Ver Códigos de Google Apps Script](APPS_SCRIPTS.md)**

---

## 🔼 Automatización de GitHub

Para subir tus cambios a la web de forma automática:
1.  Haz doble clic en `subir.bat`.
2.  Escribe qué cambiaste (ej: "Actualización de URLs").
3.  Presiona **Enter**.

---

## 📝 Notas de Versión
- **Centralización**: Ahora solo se cambia la URL en un archivo para todo el proyecto.
- **Validaciones**: Formularios con campos obligatorios para evitar errores de datos.
- **UI**: Diseño optimizado para lectura y uso en tablets/móviles con fuentes bold en campos críticos.

---
*Última actualización: 07/03/2026*
