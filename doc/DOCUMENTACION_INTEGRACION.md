# Documentación de Integración y Cambios Recientes

## 1. Automatización de Repositorios ("Ecosistema Dinámico")

Hemos implementado un sistema para que el entorno de Docker descargue y monte automáticamente los repositorios necesarios al iniciar.

### ¿Cómo funciona?

1. **Configuración Central:** El archivo `CONFIGURATION.md` actúa como la fuente de verdad.
    - Marcar un repositorio con `[x]` le indica al sistema que debe estar presente.
2. **Servicio `repo-loader`:** Un nuevo contenedor en `docker-compose.yml` que:
    - Se inicia antes que los demás servicios.
    - Ejecuta `scripts/ensure_repos.sh`.
    - Lee `CONFIGURATION.md`, extrae las URLs y clona los repositorios faltantes en la carpeta padre (`../`).
3. **Montaje Global:**
    - Se modificó `docker-compose.yml` para montar el directorio padre completo (`..:/var/www/html`) en lugar de montar repositorio por repositorio.
    - **Beneficio:** Cualquier carpeta que exista en `e:\MyRepos` es accesible inmediatamente por el servidor web sin reconfigurar Docker.

### Cómo agregar un nuevo repositorio

1. Edite `CONFIGURATION.md`.
2. Agregue la entrada: `- [x] [Nombre](URL)`.
3. Reinicie el cargador: `docker-compose up --force-recreate repo-loader`.

---

## 2. API de Secretos (`api-secrets`)

Esta API gestiona claves de configuración de forma segura.

### Estado y Correcciones Realizadas

La API presentaba fallos en el inicio que fueron solucionados:

- **Dependencia Faltante:** Se agregó `ip-range-check` al `package.json`.
- **Sincronización de Build:** Se regeneró `package-lock.json` para corregir errores de `npm ci` durante la construcción del contenedor.
- **Certificados:** La API funciona sobre HTTPS (Puerto 3501) con certificados autofirmados generados automáticamente.

### Cómo Probar la API

Se ha creado un script automatizado en PowerShell: `test_secrets.ps1`.

**Ejecución:**

```powershell
.\test_secrets.ps1
```

**Flujo de la prueba:**

1. **Health Check:** `GET /api/health` -> Verifica que el servicio responda.
2. **Crear Secreto:** `POST /api/secrets` -> Crea una clave `DB_PASSWORD`.
3. **Obtener Secreto:** `POST /api/secrets/:app` -> Recupera y valida el valor.

---

## 3. Solución de Problemas (Troubleshooting)

### Error 500 / "Read-only file system"

**Síntoma:** El servidor web falla al iniciar con errores de montaje.
**Causa:** Conflicto al intentar montar el archivo `index.html` específico dentro de un volumen montado como "solo lectura" (`:ro`).
**Solución:** Se eliminó la restricción `:ro` del montaje padre en `docker-compose.yml`.

```yaml
volumes:
  - ..:/var/www/html  # Antes tenía :ro
```

### Error de Script / "crlf"

**Síntoma:** El contenedor `repo-loader` fallaba con errores tipo `not found` o caracteres extraños.
**Causa:** Scripts guardados con finales de línea de Windows (CRLF) ejecutándose en Linux (Alpine).
**Solución:** Se agregó un comando de limpieza al inicio del contenedor:

```yaml
command: ["sed -i 's/\\r$//' /scripts/*.sh && ..."]
```

### Repositorios que no cargan (Error 404)

Si un repositorio marcado en `CONFIGURATION.md` no se descarga (como `LengthConverter`), verifique:

1. Que la URL sea pública y correcta.
2. Que no requiera autenticación (si es privado, requiere configuración adicional de claves SSH).

---

## 4. Guía de Uso del API de Secretos (CRUD y Clientes)

Hasta el momento, la API soporta operaciones de **Creación** y **Lectura**.

> **Nota de Seguridad:** Todos los accesos a la API están restringidos por IP mediante el middleware `ipRestrictionMiddleware`. Asegúrese de que el cliente esté en una red permitida o dentro de la red de Docker.

### 4.1. Operaciones CRUD Disponibles

#### A. Crear un Secreto

Guarda un par clave-valor asociado a una aplicación específica.

- **Endpoint:** `POST /api/secrets`
- **Content-Type:** `application/json`
- **Body:**

    ```json
    {
      "key": "NOMBRE_DE_LA_VAR",
      "value": "valor_super_secreto",
      "app": "nombre-servicio"
    }
    ```

- **Respuesta (201 Created):**

    ```json
    {
      "key": "NOMBRE_DE_LA_VAR",
      "value": "valor_super_secreto",
      "app": "nombre-servicio"
    }
    ```

#### B. Obtener un Secreto

Recupera el valor de un secreto. Note que se usa el método `POST` (no `GET`) por seguridad para enviar la clave en el cuerpo del mensaje y evitar que quede en logs de URL.

- **Endpoint:** `POST /api/secrets/:app`
  - Donde `:app` es el nombre de la aplicación (ej: `nombre-servicio`).
- **Body:**

    ```json
    {
      "key": "NOMBRE_DE_LA_VAR"
    }
    ```

- **Respuesta (200 OK):**

    ```json
    {
      "key": "NOMBRE_DE_LA_VAR",
      "value": "valor_super_secreto",
      "app": "nombre-servicio"
    }
    ```

---

### 4.2. Ejemplos de Uso en Cliente

A continuación se muestra cómo consumir esta API desde diferentes entornos.

#### Ejemplo 1: JavaScript (Node.js / Fetch API)

Este snippet se puede usar dentro de otros microservicios Node.js en el ecosistema.

```javascript
const https = require('https');

// Dado que usamos certificados autofirmados internamente, necesitamos un agente que los acepte
// OJO: En producción real, usar certificados válidos.
const agent = new https.Agent({
  rejectUnauthorized: false
});

async function getSecret(appName, keyName) {
  try {
    const response = await fetch(`https://api-secrets:3501/api/secrets/${appName}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ key: keyName }),
      agent: agent // Importante para SSL interno
    });

    if (!response.ok) throw new Error(`Error ${response.status}`);
    
    const data = await response.json();
    console.log(`Secreto obtenido: ${data.value}`);
    return data.value;
  } catch (error) {
    console.error('Error obteniendo secreto:', error);
  }
}

// Uso
getSecret('mi-app', 'DB_PASSWORD');
```

#### Ejemplo 2: cURL (Terminal)

Útil para pruebas rápidas o scripts de shell.

**Crear:**

```bash
curl -k -X POST https://localhost:3501/api/secrets \
  -H "Content-Type: application/json" \
  -d '{"key": "API_KEY", "value": "12345", "app": "frontend"}'
```

*(La opción `-k` o `--insecure` es necesaria por el certificado autofirmado)*

**Obtener:**

```bash
curl -k -X POST https://localhost:3501/api/secrets/frontend \
  -H "Content-Type: application/json" \
  -d '{"key": "API_KEY"}'
```
