# Reporte de Auditoría de Seguridad: API de Secretos

**Fecha:** 10 de Diciembre, 2025
**Objetivo:** Análisis exhaustivo de vulnerabilidades en `dev-laoz-api-secrets`.

---

## 1. Resumen Ejecutivo

La API implementa medidas de seguridad base (cifrado en reposo, restricción de IP, HTTPS), pero carece de controles de acceso a nivel de aplicación (Autenticación/Autorización) y presenta un defecto crítico en el diseño de la base de datos que limita su funcionalidad operacional.

**Nivel de Riesgo Global:** 🔴 **ALTO**

---

## 2. Hallazgos Críticos

### 🔴 2.1. Defecto de Diseño en Base de Datos (Denegación de Servicio)

**Ubicación:** `src/domain/models/secretModel.js`
**Hallazgo:** El esquema define las propiedades `key` y `app` como `unique: true` de forma individual.

```javascript
key: { type: String, required: true, unique: true },
app: { type: String, required: true, unique: true },
```

**Impacto:**

1. **Solo se puede guardar UN secreto por aplicación.** Si "frontend" guarda `API_KEY`, no puede guardar `DB_HOST`.
2. **Colisión de claves:** Si "App A" guarda `DB_PASSWORD`, "App B" **NO** podrá guardar su propia `DB_PASSWORD` porque el campo `key` debe ser único globalmente.
**Solución:** Eliminar `unique: true` de los campos individuales y crear un **índice compuesto** único: `{ app: 1, key: 1 }`.

### 🔴 2.2. Falta de Autenticación y Autorización

**Ubicación:** `src/app/routes/secretRoutes.js`
**Hallazgo:** No existe validación de identidad (API Key, JWT, mTLS) más allá de la IP de origen.
**Impacto:** **Movimiento Lateral Ilimitado.** Cualquier servicio dentro de la red Docker (o IP permitida) puede leer **TODOS** los secretos de **CUALQUIER** otra aplicación. Si un atacante compromete el servicio "frontend", puede solicitar los secretos del servicio "pagos" simplemente cambiando el parámetro de la URL.
**Solución:** Implementar autenticación mediante `mTLS` (Mutual TLS) o un sistema de Tokens (API Keys) rotativos.

---

## 3. Hallazgos Medios

### 🟠 3.1. Riesgo de Suplantación de IP (IP Spoofing)

**Ubicación:** `src/app/middlewares/ipRestrictionMiddleware.js`
**Hallazgo:** El middleware confía en el encabezado `x-forwarded-for`.

```javascript
const clientIp = req.headers['x-forwarded-for'] || ...
```

**Impacto:** Si el Gateway/Nginx no está configurado explícitamente para *limpiar* este encabezado de las peticiones entrantes desde internet, un atacante externo podría inyectar `X-Forwarded-For: 127.0.0.1` y la API confiaría en él.
**Solución:** Asegurar que Nginx (el borde) tenga `proxy_set_header X-Forwarded-For $remote_addr;` y **no confíe** en lo que envía el cliente.

### 🟠 3.2. Cifrado AES-CBC sin Integridad

**Ubicación:** `src/infrastructure/encryption/crypto.js`
**Hallazgo:** Se utiliza `aes-256-cbc`.
**Impacto:** Aunque seguro para confidencialidad, el modo CBC es vulnerable a ataques de "Padding Oracle" si no se manejan o mitigan los errores de descifrado correctamente, y no garantiza la integridad de los datos (no detecta si el texto cifrado fue alterado en la BD).
**Solución:** Migrar a `aes-256-gcm`, que provee autenticación e integridad (Authenticated Encryption).

---

## 4. Hallazgos Menores

### 🟡 4.1. Logging de Información Sensible (Metadatos)

**Ubicación:** `src/app/services/secretService.js`
**Hallazgo:** `console.log(key, app);`
**Impacto:** Aunque no se loguea el valor del secreto, loguear los nombres de las claves (ej: `INTERNAL_MASTER_KEY`) puede dar pistas a un atacante sobre la arquitectura interna.
**Solución:** Eliminar logs en producción.

---

## 5. Plan de Acción Recomendado

1. **Inmediato (Fix Operativo):** Corregir el esquema de Mongoose (`secretModel.js`) para permitir múltiples secretos por app.
2. **Corto Plazo (Seguridad):** Implementar autenticación básica (Header `X-API-Key` validado contra una lista hashed en variables de entorno).
3. **Mediano Plazo (Arquitectura):** Migrar a una solución de gestión de secretos dedicada como HashiCorp Vault si el volumen crece, o implementar mTLS estricto entre microservicios.
