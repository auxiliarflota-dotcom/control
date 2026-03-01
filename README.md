# Sistema de Control de Flota - Backup

Este archivo contiene una copia de seguridad del código de Google Apps Script utilizado para la integración con Google Sheets.

## Google Apps Script (Código Actual)

```javascript
/**
 * Función para guardar los datos enviados desde el formulario (POST)
 */
function doPost(e) {
  try {
    var ss = SpreadsheetApp.getActiveSpreadsheet();
    var sheet = ss.getSheetByName("Registros"); // <-- VERIFICA QUE TU HOJA SE LLAME ASÍ
    
    var datosRaw = e.parameter.datos;
    if (!datosRaw) {
      return ContentService.createTextOutput(JSON.stringify({ "status": "error", "message": "No se recibieron datos" }))
             .setMimeType(ContentService.MimeType.JSON);
    }
    
    var filas = datosRaw.split("||");
    var filasParaInsertar = [];
    
    for (var i = 0; i < filas.length; i++) {
        var columnas = filas[i].split("|");
        if (columnas.length < 5) continue;
        
        var fecha = columnas[0];
        var equipo = columnas[1];
        var ciudad = columnas[2];
        var area = columnas[3];
        var valor = parseFloat(columnas[4].replace(",", "."));
        
        filasParaInsertar.push([fecha, equipo, ciudad, area, valor]);
    }
    
    if (filasParaInsertar.length > 0) {
      sheet.getRange(sheet.getLastRow() + 1, 1, filasParaInsertar.length, 5).setValues(filasParaInsertar);
    }
    
    return ContentService.createTextOutput(JSON.stringify({ "status": "success" }))
           .setMimeType(ContentService.MimeType.JSON);
    
  } catch (err) {
    return ContentService.createTextOutput(JSON.stringify({ "status": "error", "message": err.message }))
           .setMimeType(ContentService.MimeType.JSON);
  }
}

/**
 * Función para obtener los últimos horómetros registrados (GET)
 */
function doGet(e) {
  try {
    if (e.parameter.action === "getLatest") {
      var ss = SpreadsheetApp.getActiveSpreadsheet();
      var nombreHoja = "Registros"; // <-- CAMBIA ESTO SI TU HOJA TIENE OTRO NOMBRE
      var sheet = ss.getSheetByName(nombreHoja);
      
      if (!sheet) {
        throw new Error("No se encontró la hoja llamada '" + nombreHoja + "'. Por favor verifica el nombre.");
      }
      
      var data = sheet.getDataRange().getValues();
      var latest = {};
      
      // Recorrer de abajo hacia arriba para encontrar el último valor de cada equipo
      for (var i = data.length - 1; i >= 1; i--) {
        var equipo = String(data[i][1]).trim(); // Asegurar que el equipo sea un texto limpio
        var valor = data[i][4];  // Columna E (Horómetro)
        
        if (equipo && latest[equipo] === undefined) {
          latest[equipo] = valor;
        }
      }
      
      return ContentService.createTextOutput(JSON.stringify(latest))
        .setMimeType(ContentService.MimeType.JSON);
    }
  } catch (err) {
    return ContentService.createTextOutput(JSON.stringify({ "scriptError": err.message }))
      .setMimeType(ContentService.MimeType.JSON);
  }
}
```

## Estructura del Proyecto
- `index.html`: Panel principal de navegación.
- `views/`: Carpeta que contiene las vistas del sistema.
  - `Subir_Horometros.html`: Gestión de horómetros con placeholders sincronizados.
  - `Consolidado_Novedades.html`: Registro de novedades y reportes Excel.
- `css/`: Estilos externos vinculados.
- `subir.bat`: Script de automatización para GitHub.
- `manifest.json`: Configuración para dispositivos móviles.

## Automatización de GitHub 🚀

Para subir tus cambios a GitHub de forma fácil, solo tienes que:
1.  Hacer doble clic en el archivo `subir.bat`.
2.  Escribir un mensaje breve sobre lo que cambiaste (ej: "Ajuste de iconos").
3.  Presionar **Enter**. El script hará el `add`, `commit` y `push` por ti automáticamente.

---
*Última actualización de backup: 28/02/2026 20:40*
