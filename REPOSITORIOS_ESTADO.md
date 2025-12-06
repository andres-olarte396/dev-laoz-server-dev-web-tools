# Estado de Repositorios de Utilidades

Este documento indica qué repositorios de utilidades están disponibles y cuáles necesitan ser clonados.

## ✅ Repositorios Disponibles y Montados

Los siguientes repositorios están montados en Nginx y **sus enlaces funcionan correctamente**:

1. **dev-laoz-WaveArtCSS** - Biblioteca de estilos CSS ✅
2. **dev-laoz-HTML-Project-Base** - Plantilla base HTML ✅
3. **dev-laoz-Minificador-JS-CSS** - Minificador de JavaScript y CSS ✅
4. **dev-laoz-image-viwer** - Visor de imágenes ✅
5. **dev-laoz-markdown-viwer** - Visor de Markdown ✅
6. **dev-laoz-markdown-project** - Generador de menú Markdown ✅

## ❌ Repositorios Mencionados en index.html pero NO Disponibles

Los siguientes repositorios NO están clonados localmente. Sus enlaces mostrarán error 404:

- dev-laoz-QRcoder
- dev-laoz-HashGenerator
- dev-laoz-IconSelector
- dev-laoz-URIComponent
- dev-laoz-ConversorHEX-RGB
- dev-laoz-SlugGenerator
- dev-laoz-PassGenerator
- dev-laoz-JWTDecoder
- dev-laoz-EmojiSearch (posiblemente dev-laoz-gitmojis)
- dev-laoz-B64coder
- dev-laoz-CustomLoremIpsum
- dev-laoz-JSON-YAML
- dev-laoz-CSSUnitConversor
- dev-laoz-RegexTester
- dev-laoz-TimeUnixConversor
- dev-laoz-XML-JSON-Validator
- dev-laoz-CurrencyConversor
- dev-laoz-gitmojis
- dev-laoz-UnitConversor
- dev-laoz-table-to-json
- dev-laoz-DataCalculator
- dev-laoz-network-latency-simulator
- dev-laoz-RandomName
- dev-laoz-MarkdownEditor
- dev-laoz-HTMLTableGenerator
- dev-laoz-Checksum
- dev-laoz-RandomDate
- dev-laoz-RegexCalc
- dev-laoz-LengthConverter

## 📋 Cómo Agregar Más Repositorios

Para que un repositorio aparezca en la web:

### Opción 1: Clonar Localmente

```bash
cd e:\MyRepos
git clone https://github.com/andres-olarte396/dev-laoz-QRcoder
```

Luego edita `docker-compose.yml` y agrega el volumen:

```yaml
nginx:
  volumes:
    # ... volúmenes existentes ...
    - ../dev-laoz-QRcoder:/var/www/html/dev-laoz-QRcoder:ro
```

Reinicia Nginx:

```bash
docker-compose up -d --force-recreate nginx
```

### Opción 2: Clonar Todos (Recomendado)

Si quieres clonar todos los repositorios mencionados en `CONFIGURATION.md`:

```bash
cd e:\MyRepos\dev-laoz-server-dev-web-tools
# Usar el script de Vagrant adaptado o clonar manualmente desde GitHub
```

Luego actualiza `docker-compose.yml` con todos los volúmenes.

## 🔄 Actualización Automática

Para automatizar esto, considera crear un script que:

1. Lea `CONFIGURATION.md`
2. Clone los repositorios marcados con `[x]`
3. Genere automáticamente la sección de volúmenes en `docker-compose.yml`

## 📝 Notas

- **Solo los repositorios clonados localmente** pueden montarse en Docker
- Los enlaces en `index.html` que apuntan a repositorios no clonados mostrarán error 404
- Puedes ocultar o comentar las utilidades que no tengas clonadas en `index.html`
- Los repositorios se montan en modo **read-only** (`"ro`) para seguridad
