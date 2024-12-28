# Configuración del Servidor Web

Este documento detalla la configuración necesaria para implementar y personalizar un servidor web. Incluye las herramientas requeridas, los pasos a seguir para su instalación y una lista de repositorios relevantes para integraciones adicionales.

---

## Instalación de Entorno

En esta sección se enumeran las herramientas necesarias para configurar el entorno del servidor web. Se incluyen tanto las que ya están instaladas como aquellas pendientes por instalar. Cada elemento tiene una marca que indica su estado:

- `[x]` Elemento ya instalado.
- `[ ]` Elemento pendiente de instalación.

### Lista de Instalaciones

- [x] **Instalar Nginx**
  _Servidor web liviano y de alto rendimiento para servir aplicaciones web y contenido estático._
- [x] **Instalar NodeJS**
  _Entorno de ejecución para JavaScript del lado del servidor._
- [ ] **Instalar PHP**
  _Lenguaje de programación para desarrollo de aplicaciones web dinámicas._
- [ ] **Instalar Spring Boot**
  _Framework para construir aplicaciones basadas en Java con facilidad._
- [ ] **Instalar dotnet Nginx**
  _Configuración específica para ejecutar aplicaciones .NET en Nginx._

### Utilidades adicionales

- [x] **Minimizar repositorios**  
  _Optimización de las dependencias necesarias para reducir el peso del proyecto._
- [x] **Eliminar archivos de Git**

---

## Repositorios

Esta sección lista los repositorios relacionados que se han clonado o necesitan clonarse para el desarrollo del proyecto. Los repositorios incluyen herramientas o librerías útiles para mejorar las capacidades del servidor.

### Lista de Repositorios

- [x] [**1. QRcoder**](https://github.com/andres-olarte396/dev-laoz-QRcoder)  
  _Generador de códigos QR para aplicaciones web o móviles._
- [x] [**2. HashGenerator**](https://github.com/andres-olarte396/dev-laoz-HashGenerator)  
  _Herramienta para generar y validar hashes criptográficos._
- [x] [**3. IconSelector**](https://github.com/andres-olarte396/dev-laoz-IconSelector)  
  _Librería para seleccionar y gestionar iconos personalizados._
- [x] [**4. URIComponent**](https://github.com/andres-olarte396/dev-laoz-URIComponent)  
  _Utilidad para codificar y decodificar componentes de URLs._
- [x] [**5. ConversorHEX-RGB**](https://github.com/andres-olarte396/dev-laoz-ConversorHEX-RGB)
  _interactiva que permite convertir colores entre los formatos HEX y RGB/HSLA, además de generar paletas de colores dinámicas (complementarios, monocromáticos y análogos)._
- [x] [**6. Slug Generator**](https://github.com/andres-olarte396/dev-laoz-SlugGenerator)
  _Utilidad simple que convierte texto en slugs (URLs amigables). Es útil para generar rutas limpias y comprensibles._
- [x] [**7. Password Generator**](https://github.com/andres-olarte396/dev-laoz-PassGenerator)
  _Utilidad que genera contraseñas seguras y aleatorias, con opciones personalizables para la longitud de la contraseña, inclusión de caracteres especiales, números y letras mayúsculas._
- [x] [**8. JWT Decoder**](https://github.com/andres-olarte396/dev-laoz-JWTDecoder)
  _Utilidad que permite decodificar JSON Web Tokens (JWT) para inspeccionar su contenido sin necesidad de la clave privada. Es útil para desarrolladores que trabajan con autenticación y autorización en aplicaciones web._
- [x] [**9. Git emojis**](https://github.com/developer-laoz396/dev-laoz-gitmojis)
  _Aplicación web sencilla que permite a los usuarios buscar y copiar emojis_
- [x] [**10. Base64 coder**](https://github.com/andres-olarte396/dev-laoz-B64coder)
  _Aplicación web simple que permite codificar y decodificar texto utilizando el formato Base64._
- [x] [**11. Custom Lorem Ipsum**](https://github.com/andres-olarte396/dev-laoz-CustomLoremIpsum)
  _Herramienta web que permite generar texto de ejemplo (Lorem Ipsum) en diferentes longitudes y estilos._
- [x] [**12. JSON to YAML**](https://github.com/andres-olarte396/dev-laoz-JSON-YAML)
  _Utilidad que permite convertir de JSON a YAML y de YAML a JSON de manera rápida y sencilla._
- [x] [**13. CSS Unit Conversor**](https://github.com/andres-olarte396/dev-laoz-CSSUnitConversor)
  __Utilidad que permite convertir entre diferentes unidades CSS, como píxeles (px), rem, em y porcentajes (%)._
- [x] [**14. Regex Tester**](https://github.com/andres-olarte396/dev-laoz-RegexTester)
  _Herramienta web para escribir, probar y verificar expresiones regulares._
- [x] [**15. Time Unix Conversor**](https://github.com/andres-olarte396/dev-laoz-TimeUnixConversor)
  _Utilidad que convierte timestamps Unix a fechas legibles y viceversa. Es útil para la depuración y manipulación de datos relacionados con tiempos._
- [x] [**16. Minificador JS CSS**](https://github.com/andres-olarte396/dev-laoz-Minificador-JS-CSS)
  _Utilidad que permite minificar y desminificar archivos de CSS y JavaScript. Es útil para mejorar el rendimiento de los sitios web al reducir el tamaño de los archivos._
- [x] [**17. XML JSON Validator**](https://github.com/andres-olarte396/dev-laoz-XML-JSON-Validator)
  _Utilidad que permite validar rápidamente estructuras JSON y XML. Es útil para desarrolladores que trabajan con APIs o archivos de configuración._
- [x] [**18. Currency Conversor**](https://github.com/andres-olarte396/dev-laoz-CurrencyConversor)
  _Este proyecto es una herramienta web que permite convertir entre diferentes tipos de monedas utilizando tasas de cambio actuales._
- [x] [**19. Emoji Search**](https://github.com/andres-olarte396/dev-laoz-EmojiSearch)
  _Esta herramienta permite buscar emojis mediante palabras clave o categorías. Carga los emojis desde un archivo JSON y los filtra en tiempo real._
- [x] [**20. Unit Conversor**](https://github.com/andres-olarte396/dev-laoz-UnitConversor)
  _Utilidad para realizar conversiones entre varios sistemas de numeración, tales como decimal, binario, octal, hexadecimal, y más._
- [x] [**21. Table to JSON**](https://github.com/andres-olarte396/dev-laoz-table-to-json)
  _Este proyecto permite extraer datos de tablas en un documento HTML, incluyendo los vínculos presentes en las celdas de las tablas. Los datos extraídos se muestran en formato JSON y pueden copiarse al portapapeles._
- [x] [**22. Data Calculator**](https://github.com/andres-olarte396/dev-laoz-DataCalculator)
  _Este proyecto es una página web simple que permite realizar las operaciones relacionadas con datos y velocidad._
- [x] [**23. HTML Project Base**](https://github.com/andres-olarte396/dev-laoz-HTML-Project-Base)
  _Esta plantilla es un proyecto básico en HTML, CSS y JavaScript que puede usarse como punto de partida para cualquier proyecto web._
- [x] [**24. Wave Art CSS**](https://github.com/andres-olarte396/dev-laoz-WaveArtCSS)
  _Proyecto modular diseñado para facilitar la creación de interfaces de usuario modernas, altamente responsivas, accesibles y personalizables. Este proyecto implementa las últimas tendencias en CSS._
- [x] [**25. Image viwer**](https://github.com/andres-olarte396/dev-laoz-image-viwer)
  _Este proyecto es un slider de imágenes dinámico construido con HTML, CSS y JavaScript. Permite a los usuarios navegar a través de una serie de imágenes con controles de navegación._
- [x] [**26. Network latency-simulator**](https://github.com/andres-olarte396/dev-laoz-network-latency-simulator)
  _Herramienta poderosa que te permite simular diversas condiciones de red, como velocidad, latencia y pérdida de paquetes._
- [x] [**27. Markdown viwer**](https://github.com/andres-olarte396/dev-laoz-markdown-viwer)
  _Aplicación web simple e interactiva que permite a los usuarios escribir, editar y visualizar texto en formato Markdown en tiempo real._
- [x] [**28. Markdown project**](https://github.com/andres-olarte396/dev-laoz-markdown-project)
  _Este proyecto genera un menú dinámico basado en archivos Markdown (.md) contenidos en un directorio._

- [x] [**29. API Gateway**](https://github.com/andres-olarte396/dev-laoz-api-gateway)
  _Este proyecto implementa un API Gateway que actúa como punto de entrada central para varios microservicios. El Gateway redirige las solicitudes a los microservicios correspondientes, incluyendo la API de autenticación para gestionar usuarios, roles y permisos._

- [x] [**30. API Autenticación**](https://github.com/andres-olarte396/dev-laoz-authentication-api)
  _La API de Autenticación permite gestionar la autenticación de usuarios, asignación de roles y permisos. Utiliza JWT (JSON Web Tokens) para la autenticación y MongoDB como base de datos para almacenar los usuarios y sus datos asociados._

- [x] [**31. API Autorización**](https://github.com/andres-olarte396/dev-laoz-authorization-api)
  _La Authorization API proporciona servicios para validar tokens JWT y verificar los permisos asociados a los usuarios. Es un componente esencial para implementar una arquitectura de microservicios segura._

- [x] [**32. API Usuarios**](https://github.com/andres-olarte396/dev-laoz-api-user)
  _La API de usuarios proporciona servicios para validar tokens JWT y verificar los permisos asociados a los usuarios. Es un componente esencial para implementar una arquitectura de microservicios segura._

---

## Cómo Usar Este Archivo

1. **Validar el estado de las instalaciones**  
   Revise los elementos pendientes en la sección de _Instalación de Entorno_. Realice las instalaciones siguiendo la prioridad de su proyecto.

2. **Clonar los repositorios necesarios**  
   Clonar únicamente los repositorios marcados como `[x]`. Si necesita integrar más herramientas, puede revisar repositorios adicionales y marcarlos como requeridos.

3. **Actualizar el archivo**  
   A medida que complete cada instalación o clonado, actualice las marcas (`[x]` o `[ ]`) para mantener el archivo sincronizado con el estado real del proyecto.

---

## Notas Adicionales

- Este archivo debe mantenerse actualizado por todos los colaboradores del proyecto.
- Se recomienda realizar auditorías periódicas de los repositorios para identificar dependencias obsoletas o innecesarias.
- Para agregar más herramientas o repositorios, siga la estructura documentada y detalle claramente su propósito.

---

**Última Actualización:** 17 de diciembre de 2024
