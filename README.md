# Desarrollo Web con Estas Herramientas Útiles

En el mundo del desarrollo web, contar con herramientas eficientes puede marcar la diferencia en la productividad y en la calidad del trabajo final. En este artículo, un servidor equipado con una serie de herramientas que he desarrollado y que pueden facilitar diversas tareas cotidianas.

## Pre-requisitos

Antes de comenzar, asegúrate de tener instalados los siguientes programas:

- **Vagrant**: [Descargar Vagrant](https://www.vagrantup.com/downloads)
- **VirtualBox**: [Descargar VirtualBox](https://www.virtualbox.org/wiki/Downloads)

## Cómo Iniciar el Servidor con Vagrant

Para iniciar el servidor utilizando Vagrant, sigue estos pasos:

- Clona el repositorio del proyecto:

    ```sh
    git clone https://github.com/andres-olarte396/dev-laoz-server-dev-web-tools
    ```

- Navega al directorio del proyecto:

    ```shell
        cd dev-laoz-server-dev-web-tools
    ```

- Inicia Vagrant:

    ```shell
        vagrant up
    ```

- Accede al servidor

    ```shell
        vagrant ssh
    ```

- Navega al directorio del proyecto dentro de la máquina virtual:

    ```shell
        cd /vagrant
    ```

- Inicia el servidor de desarrollo (ajusta el comando según tu configuración):

    ```shell
        npm start
    ```

## Repositorios incluidos en el servidor

Estas herramientas están diseñadas para facilitar tareas comunes en el desarrollo web y pueden ayudar a mejorar tu productividad. Te invito a probar cada una de ellas y ver cómo pueden integrarse en tu flujo de trabajo diario.

### 1. Generador de Código QR

**Descripción**: Una herramienta sencilla para generar códigos QR a partir de una URL o texto. Ideal para compartir enlaces de manera rápida y efectiva.

- **Prueba el generador**: [Enlace al generador de QR](https://github.com/andres-olarte396/dev-laoz-QRcoder)

### 2. Mini-Ferramentas para Codificación de Color

**Descripción**: Una herramienta completa para trabajar con colores en diseño web, que incluye conversores y paletas de colores.

- **Explora las mini-ferramentas**: [Enlace a las mini-ferramentas de color](https://github.com/andres-olarte396/dev-laoz-HashGenerator)

### 3. Selector de Iconos

**Descripción**: Un buscador para encontrar rápidamente iconos de Font Awesome o Material Icons. Genera el HTML necesario para integrarlos en tus proyectos.

- **Accede al selector**: [Enlace al selector de iconos](https://github.com/andres-olarte396/dev-laoz-IconSelector)

### 4. Codificación y Decodificación de URI

**Descripción**: Una herramienta para codificar y decodificar URLs, útil para trabajar con parámetros de manera segura.

- **Visita la herramienta**: [Enlace a codificación/decodificación de URI](https://github.com/andres-olarte396/dev-laoz-URIComponent)

### 5. Conversor de Color

**Descripción**: Convierte colores entre formatos HEX y RGB/HSLA. Incluye una paleta de colores que muestra combinaciones útiles.

- **Utiliza el conversor**: [Enlace al conversor de color](https://github.com/andres-olarte396/dev-laoz-ConversorHEX-RGB)

### 6. Generador de Slugs

**Descripción**: Convierte texto en slugs (URLs amigables), ideal para crear rutas limpias para blogs o sitios web.

- **Genera slugs aquí**: [Enlace al generador de slugs](https://github.com/andres-olarte396/dev-laoz-SlugGenerator)

### 7. Generador de Contraseñas Seguras

**Descripción**: Crea contraseñas robustas con opciones de longitud y tipos de caracteres, asegurando la seguridad de tus cuentas.

- **Empieza a generar contraseñas**: [Enlace al generador de contraseñas](https://github.com/andres-olarte396/dev-laoz-PassGenerator)

### 8. Decodificador de JWT

**Descripción**: Decodifica JSON Web Tokens para inspeccionar su contenido sin necesidad de la clave privada.

- **Decodifica aquí**: [Enlace al decodificador de JWT](https://github.com/andres-olarte396/dev-laoz-JWTDecoder)

### 9. Buscador de Emojis

**Descripción**: Encuentra rápidamente el emoji adecuado a partir de un archivo JSON con todos los emojis de Git. Útil para proyectos web que necesitan íconos o visuales de emojis.

- **Prueba el buscador**: [Enlace al buscador de emojis](https://github.com/developer-laoz396/dev-laoz-gitmojis)

### 10. Codificador/Decodificador Base64

**Descripción**: Una herramienta para codificar y decodificar texto en formato Base64, útil para tareas como la transmisión de datos binarios en formato de texto.

- **Prueba la herramienta**: [Enlace al codificador/decodificador Base64](https://github.com/andres-olarte396/dev-laoz-B64coder)

### 11. Generador de Lorem Ipsum Personalizado

**Descripción**: Un generador de texto aleatorio que permite crear "dummy text" en diferentes longitudes y estilos para simular contenido en proyectos.

- **Genera texto aquí**: [Enlace al generador de Lorem Ipsum](https://github.com/andres-olarte396/dev-laoz-CustomLoremIpsum)

### 12. Conversor de JSON a YAML / YAML a JSON

**Descripción**: Una herramienta que convierte entre formatos JSON y YAML, útil para proyectos con archivos de configuración (Kubernetes, Docker Compose).

- **Utiliza el conversor**: [Enlace al conversor de JSON/YAML](https://github.com/andres-olarte396/dev-laoz-JSON-YAML)

### 13. Conversor de Unidades (px, rem, em, % para CSS)

**Descripción**: Convierte entre diferentes unidades de medida en CSS, como px, rem, em y %, facilitando diseños más responsivos.

- **Prueba el conversor de unidades**: [Enlace al conversor de unidades](https://github.com/andres-olarte396/dev-laoz-CSSUnitConversor)

### 14. Expresiones Regulares Tester

**Descripción**: Una herramienta para escribir, probar y verificar expresiones regulares en tiempo real, ayudando a ajustar las expresiones según sea necesario.

- **Accede al tester de expresiones regulares**: [Enlace al tester de expresiones regulares](https://github.com/andres-olarte396/dev-laoz-RegexTester)

### 15. Conversor de Tiempo Unix

**Descripción**: Una utilidad que convierte timestamps Unix a una fecha legible y viceversa, útil para depuración o manipulación de datos.

- **Utiliza el conversor de tiempo**: [Enlace al conversor de tiempo Unix](https://github.com/andres-olarte396/dev-laoz-TimeUnixConversor)

### 16. Minificador de JavaScript y CSS

**Descripción**: Herramientas para minificar y desminificar archivos CSS y JavaScript, mejorando el rendimiento o facilitando la análisis de archivos.

- **Prueba el minificador**: [Enlace al minificador de JavaScript y CSS](https://github.com/andres-olarte396/dev-laoz-Minificador-JS-CSS)

### 17. Validación de JSON y XML

**Descripción**: Un validador rápido para estructuras JSON o XML, útil cuando trabajas con APIs o archivos de configuración.

- **Valida aquí**: [Enlace al validador de JSON y XML](https://github.com/andres-olarte396/dev-laoz-XML-JSON-Validator)

### 18. Conversor de Monedas

**Descripción**: Una herramienta sencilla para convertir entre diferentes tipos de cambio usando APIs públicas, ideal para proyectos que requieren manejar monedas.

- **Prueba el conversor de monedas**: [Enlace al conversor de monedas](https://github.com/andres-olarte396/dev-laoz-CurrencyConversor).

### 19. Buscador de Emojis de Git

**Descripción**:  Encuentra rápidamente el emoji de Git adecuado a partir de un archivo JSON con todos los emojis de Git. Útil para proyectos web que necesitan íconos o visuales de emojis.

- **Prueba el buscador**: [Prueba el conversor de unidades](https://github.com/andres-olarte396/dev-laoz-EmojiSearch/)

### 20. Conversor de Unidades numéricas

**Descripción**: Esta aplicación web permite convertir números entre diferentes sistemas de numeración de forma rápida y sencilla. Soporta varias bases, incluyendo binario, decimal, octal, hexadecimal, ternario, quintal, vigesimal y BCD. Con solo ingresar un número en cualquier sistema, puedes ver automáticamente su equivalente en los demás, lo que facilita el  aprendizaje y la comprensión de diferentes sistemas numéricos.

- **Prueba el conversor de unidades**: [Enlace al conversor de sistemas de numeración](https://github.com/andres-olarte396/dev-laoz-UnitConversor)

### 21. Extractor de datos desde Tablas HTML

**Descripción**: Este proyecto permite extraer datos de tablas en un documento HTML, incluyendo los vínculos presentes en las celdas de las tablas. Los datos extraídos se muestran en formato JSON y pueden copiarse al portapapeles.

- **Míralo en GitHub**: [Enlace al extractor de datos](https://github.com/andres-olarte396/dev-laoz-table-to-json)

### 22. Calculadora de datos

**Descripción**: Este proyecto es una página web simple que permite realizar las siguientes operaciones relacionadas con datos y velocidad

  1. Conversión entre unidades de almacenamiento de datos: (Bytes, KB, MB, GB, TB).
  2. Conversión entre unidades de velocidad de datos: (bps, Kbps, Mbps, Gbps).
  3. Cálculo del tiempo de descarga: según el tamaño del archivo y la velocidad de descarga.

- **Míralo en GitHub**: [Enlace a la calculadora de datos](https://github.com/andres-olarte396/dev-laoz-DataCalculator)

### 23. Proyecto base de HTML

**Descripción**: Esta plantilla es un proyecto básico en HTML, CSS y JavaScript que puede usarse como punto de partida para cualquier proyecto web. Incluye una estructura mínima pero funcional que se puede personalizar según las necesidades del usuario.

- **Míralo en GitHub**: [Enlace al proyecto base de HTML](https://github.com/andres-olarte396/dev-laoz-HTML-Project-Base)

### 24. Biblioteca base de CSS

**Descripción**: Un proyecto modular diseñado para facilitar la creación de interfaces de usuario modernas, altamente responsivas, accesibles y personalizables. Este proyecto implementa las últimas tendencias en CSS, incluyendo CSS Grid, Flexbox, Consultas de Contenedores, Temas Oscuros y Claros, y muchas más herramientas avanzadas.

- **Prueba tus estilos aquí**: [Enlace al proyecto base de CSS](https://github.com/andres-olarte396/dev-laoz-WaveArtCSS)

### 25. Slider de Imágenes Dinámico

**Descripción**: Este proyecto es un slider de imágenes dinámico construido con HTML, CSS y JavaScript. Permite a los usuarios navegar a través de una serie de imágenes con controles de navegación.

- **Míralo en GitHub**: [Enlace al proyecto visor de Imágenes](https://github.com/andres-olarte396/dev-laoz-image-viwer)

### 26. Simulador de Velocidad de Red

**Descripción**: Una herramienta poderosa que te permite simular diversas condiciones de red, como velocidad, latencia y pérdida de paquetes. Este simulador es ideal para desarrolladores, ingenieros de QA y entusiastas de redes que deseen probar cómo funcionan sitios web o aplicaciones bajo diferentes escenarios de red.

- **Míralo en GitHub**: [Enlace al proyecto simulador de velocidad de red](https://github.com/andres-olarte396/dev-laoz-network-latency-simulator)

### 27. Visor de Markdown

**Descripción**: Una aplicación web simple e interactiva que permite a los usuarios escribir, editar y visualizar texto en formato Markdown en tiempo real. Es perfecta para aprender y practicar Markdown de manera intuitiva.

- **Míralo en GitHub**: [Enlace al proyecto visor de markdown](https://github.com/andres-olarte396/dev-laoz-markdown-viwer)
