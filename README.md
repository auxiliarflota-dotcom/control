# Sistema de Control de Flota - Backup

Este archivo contiene una copia de seguridad del código de Google Apps Script utilizado para la integración con Google Sheets.

## Google Apps Script (Código Actual)

```javascript
/**
 * Función para recibir datos (POST)
 */
function doPost(e) {
  var action = e.parameter.action;
  
  if (action === "saveNovedades") {
    return saveNovedades(e);
  } else {
    // Por defecto, o si es para horómetros
    return saveHorometros(e);
  }
}

/**
 * Guarda las novedades en la hoja "Novedades"
 */
function saveNovedades(e) {
  try {
    var ss = SpreadsheetApp.getActiveSpreadsheet();
    var sheet = ss.getSheetByName("Novedades");
    
    // Si la hoja no existe, la crea con encabezados
    if (!sheet) {
      sheet = ss.insertSheet("Novedades");
      sheet.appendRow(["Fecha", "Operario", "Golpes", "Rayones", "Video 360", "Formato", "Digital", "Observación"]);
    }
    
    var datosRaw = e.parameter.datos;
    if (!datosRaw) {
      return ContentService.createTextOutput(JSON.stringify({ "status": "error", "message": "No se recibieron datos" }))
             .setMimeType(ContentService.MimeType.JSON);
    }
    
    var filasRaw = datosRaw.split("||");
    var filasParaInsertar = [];
    
    for (var i = 0; i < filasRaw.length; i++) {
        var columnas = filasRaw[i].split("|");
        // Aseguramos que tenga al menos los campos básicos
        if (columnas.length < 2) continue;
        
        filasParaInsertar.push([
          columnas[0] || "", // Fecha
          columnas[1] || "", // Operario
          columnas[2] || 0,  // Golpes
          columnas[3] || 0,  // Rayones
          columnas[4] || 0,  // Video 360
          columnas[5] || 0,  // Formato
          columnas[6] || 0,  // Digital
          columnas[7] || ""  // Observación
        ]);
    }
    
    if (filasParaInsertar.length > 0) {
      sheet.getRange(sheet.getLastRow() + 1, 1, filasParaInsertar.length, 8).setValues(filasParaInsertar);
    }
    
    return ContentService.createTextOutput(JSON.stringify({ "status": "success" }))
           .setMimeType(ContentService.MimeType.JSON);
    
  } catch (err) {
    return ContentService.createTextOutput(JSON.stringify({ "status": "error", "message": err.message }))
           .setMimeType(ContentService.MimeType.JSON);
  }
}

/**
 * Guarda los horómetros en la hoja "Registros"
 */
function saveHorometros(e) {
  try {
    var ss = SpreadsheetApp.getActiveSpreadsheet();
    var sheet = ss.getSheetByName("Registros");
    
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
 * Función para obtener datos (GET)
 */
function doGet(e) {
  try {
    var ss = SpreadsheetApp.getActiveSpreadsheet();
    var action = e.parameter.action;

    // 1. Obtener Metadatos (Equipos y Operarios)
    if (action === "getMetadata") {
      var sheetEquipos = ss.getSheetByName("Equipos");
      var sheetOperarios = ss.getSheetByName("OPI");

      var rawEquipos = sheetEquipos.getDataRange().getValues();
      var rawOperarios = sheetOperarios.getDataRange().getValues();

      var listaEquipos = [];
      for (var i = 1; i < rawEquipos.length; i++) {
        var estado = String(rawEquipos[i][3] || "").trim().toLowerCase();
        if (estado === "activo") { // Columna D: Estado
          listaEquipos.push({
            equipo: rawEquipos[i][0],
            ciudad: rawEquipos[i][1],
            area: rawEquipos[i][2]
          });
        }
      }

      var listaOperarios = [];
      for (var j = 1; j < rawOperarios.length; j++) {
        var estadoOp = String(rawOperarios[j][1] || "").trim().toLowerCase();
        if (estadoOp === "activo") { // Columna B: Estado
          listaOperarios.push(rawOperarios[j][0]); // Columna A: Nombre
        }
      }

      return ContentService.createTextOutput(JSON.stringify({
        equipos: listaEquipos,
        operarios: listaOperarios
      })).setMimeType(ContentService.MimeType.JSON);
    }

    // 2. Obtener últimos horómetros
    if (action === "getLatest") {
      var sheet = ss.getSheetByName("Registros");
      if (!sheet) throw new Error("No se encontró la hoja 'Registros'");
      
      var data = sheet.getDataRange().getValues();
      var latest = {};
      
      for (var i = data.length - 1; i >= 1; i--) {
        var equipo = String(data[i][1]).trim();
        var valor = data[i][4];
        if (equipo && latest[equipo] === undefined) {
          latest[equipo] = valor;
        }
      }
      return ContentService.createTextOutput(JSON.stringify(latest))
        .setMimeType(ContentService.MimeType.JSON);
    }

    // 3. Obtener novedades (Nuevo)
    if (action === "getNovedades") {
      var sheet = ss.getSheetByName("Novedades");
      if (!sheet) return ContentService.createTextOutput(JSON.stringify([])).setMimeType(ContentService.MimeType.JSON);
      
      var data = sheet.getDataRange().getValues();
      var resultados = [];
      
      for (var i = 1; i < data.length; i++) {
        resultados.push({
          fecha: data[i][0],
          operario: data[i][1],
          golpes: data[i][2],
          rayones: data[i][3],
          video360: data[i][4],
          formato: data[i][5],
          digital: data[i][6],
          observacion: data[i][7]
        });
      }
      return ContentService.createTextOutput(JSON.stringify(resultados))
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
