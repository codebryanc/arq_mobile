# Análisis de la prueba

Nuevo proyecto para PinApp 

## Empezando

Este proyecto esta enfocado en resolver una prueba técnica para PinApp teniendo en cuenta lo siguiente:

- Debemos consumir https://www.themoviedb.org/ Esto nos permite leer peliculas actuales a partir de un API_KEY (después del registro)
- Elegimos mostrar las categorias de peliculas y el detalle de cada una

## Requerimientos

> Evaluamos

- Clean architecture + BLOC + Consumo de APIs con Dio + Firebase + Composición avanzada de widgets + SOLID + Claridad y orden del proyecto

> Entregable mínima

- Usamos Flutter (Dart) + Configura environments
- Clean architecture
    - Presentation (UI, Widgets, State Management) + Domain (Entities, UseCases) + Data (Repository, DataSources / DataStores)
- Splash leyendo datos desde Firebase (Realtime Database o remote Config)
    - Acá aprovechamos para hacer carga inicial de carga con temas como: Configuración de ambientes, Features toggles + Texto inicial
- Pantalla principal: Acá vemos las categorias
    - Cada categoría hay películas > Acá evaluamos listas dentro de otras (Performance + reutilización de widgets)
- Usamos Scheme ó Targets para configuraciones

## Detalle de película

> Al seleccionar una película ver 

- Carrusel de imágenes (página horizaontal con paginación)
- Título, calificación, resumen/descripción en HTML
- Lista de actores (nombres). Puede ser un horizontal collection view o lista simple.
- Botón fijo inferior "Recomendar"
    - Al tocar Recomendar: abrir un Modal (con la descipción de la película + Texto de un comentario + botón de confirmar con toast o alert de que sucedio)

## Técnico

- 3 comentarios donde tenemos SOLID
- Publicar en GitHub + Readme
- Tener data local, posible usar fuera de línea

## Dependencias

- Dio
- Firebase FlutterFire (Analytics + Remote Config o Realtime Database)
- BLoC

# DB

- SharedPrefences
- Hive

# Test 

- 80% minimo
- Widget
- Test de funcionalidad 