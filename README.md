# The Movie App — PinApp Challenge

---

## Resumen

Prueba técnica para **PinApp** desarrollada en Flutter que consume [The Movie DB](https://www.themoviedb.org/).

- Explora películas agrupadas por categoría
- Ve el detalle de cada película: calificación, duración, géneros, actores e imágenes
- Recomienda una película dejando un comentario desde un modal
- Persiste la preferencia de vista (chips / lista) entre sesiones con SharedPreferences
- Localización completa en español vía ARB

---

## Arquitectura

Seguimos **Clean Architecture** con separación estricta en tres capas por feature.

```
Presentation  ──►  Domain  ◄──  Data
     │               │              │
  BLoC / UI    Entities        Repository Impl
  Pages        UseCases        DataSources
  Widgets      Repositories    Models
               (interfaces)
```

> La capa `Domain` no conoce a nadie. `Data` implementa sus contratos. `Presentation` solo consume `UseCases`.

Cada feature replica esta estructura:

```
feature/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/   ← interfaces
│   └── usecases/
└── presentation/
    ├── bloc/
    ├── pages/
    └── widgets/
```

---

## Tech Stack

| Capa | Tecnología |
|---|---|
| UI / Estado | Flutter + BLoC |
| Inyección de dependencias | GetIt |
| Networking | Dio |
| Persistencia local | SharedPreferences |
| Localización | flutter_localizations (ARB) |
| Tests | flutter_test + mocktail + bloc_test |

### Dependencias principales

```yaml
flutter_bloc: ^8.1.3
bloc: ^8.1.4
get_it: ^8.0.3
dio: ^5.7.0
shared_preferences: ^2.3.3
intl: ^0.20.2
flutter_native_splash: ^2.4.2

# dev
mocktail: ^1.0.4
bloc_test: ^9.1.7
flutter_lints: ^6.0.0
```

---

## Versión de Flutter

```
Flutter 3.38.9 · channel stable
Dart SDK ^3.10.8
```

---

## Cómo correr el proyecto

### 1. Clonar

```bash
git clone git@github.com:codebryanc/arq_mobile.git
cd arq_mobile
```

> Repositorio: https://github.com/codebryanc/arq_mobile

### 2. Instalar dependencias

```bash
flutter pub get
```

### 3. Correr en desarrollo

```bash
flutter run
```

### 4. Script de compilación iOS

Limpia, regenera localizaciones, formatea y compila para iOS:

```bash
chmod +x scripts/MACOS/iOS/clean_adn_build_iOS.sh
./scripts/MACOS/iOS/clean_adn_build_iOS.sh
```

### 5. Correr tests con cobertura

Ejecuta todos los tests y abre el reporte HTML (requiere `brew install lcov`):

```bash
chmod +x scripts/MACOS/test/run_all_test.sh
./scripts/MACOS/test/run_all_test.sh
```

---

## Endpoints utilizados

Base URL: `https://api.themoviedb.org/3`

> Requiere `api_key` obtenida al registrarse en TMDB. Todos los endpoints usan `language=es-ES`.

| Descripción | Endpoint |
|---|---|
| Películas populares | `GET /movie/popular?api_key={{API_KEY}}&language=es-ES` |
| Categorías | `GET /genre/movie/list?api_key={{API_KEY}}&language=es-ES` |
| Películas por categoría | `GET /discover/movie?api_key={{API_KEY}}&with_genres={id}&language=es-ES&page={n}` |
| Detalle de película | `GET /movie/{id}?api_key={{API_KEY}}&language=es-ES` |
| Actores (créditos) | `GET /movie/{id}/credits?api_key={{API_KEY}}&language=es-ES` |
| Imágenes de película | `GET /movie/{id}/images?api_key={{API_KEY}}` |

---

## Tests

- Unit tests: UseCases, Repositories, BLoCs
- Widget tests: componentes de UI
