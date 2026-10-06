# Catbreeds

Catálogo de razas de gatos domésticos. Abres la app, recorres las razas, buscas por nombre y lees la ficha de la que te interesa. Los datos salen de [The Cat API](https://developers.thecatapi.com/).

El inicio espera a que llegue el catálogo y adelanta las primeras fotos. El listado filtra en memoria, sin otra petición. El detalle deja la foto quieta y desplaza solo el texto. El tema claro u oscuro sigue el brillo del teléfono. La interfaz está en inglés, igual que los nombres y las descripciones que manda el API.

## Con qué está hecha

| Pieza | Para qué |
| --- | --- |
| Flutter, canal stable | Las tres pantallas |
| `flutter_bloc` | La carga, el fallo y la búsqueda |
| `dio` | `GET /v1/breeds`, con tope de tiempo y la clave en el header |
| `cached_network_image` | Las fotos del API, decodificadas al tamaño de la tarjeta |
| `equatable` | Para que dos estados iguales no repinten la lista |

La letra es Plus Jakarta Sans, empaquetada con la app.

## Cómo está armada

Hay una sola feature y tres capas. La presentación pide datos al dominio. El dominio no conoce Flutter ni la red. Los datos implementan ese contrato y son los únicos que hablan con el API.

```
presentación  →  dominio  ←  datos
```

```
lib/
  main.dart                 compone el cliente, el repositorio y la app
  app.dart                  tema y rutas
  core/                     entorno, fallos, layout y cliente HTTP
  features/breeds/
    domain/                 Breed, el contrato y el filtro por nombre
    data/                   DTO, mapper, fuente remota y memoria de proceso
    presentation/           páginas, widgets y el BLoC
```

`main.dart` es el único archivo que conoce las tres capas. Si la URL o la clave llegan vacías, no crea el cliente y el inicio explica que falta el entorno.

Cada apertura vuelve a pedir el catálogo. Mientras la app sigue abierta, ese arreglo se queda en memoria: ir al detalle y volver no repite la petición. Un arrastre hacia abajo sí la repite.

## Arranque

1. Copiar `.env.example` a `.env`.
2. Poner una clave propia de The Cat API en `CAT_API_KEY`.
3. Correr:

```
flutter run --dart-define-from-file=.env
```

`.env` no se versiona. La URL y la clave entran al compilar, con `String.fromEnvironment`. Sin ellas, la app no llama al API.

El APK de release usa el mismo archivo:

```
flutter build apk --release --dart-define-from-file=.env
```

## Pruebas

```
flutter test
```

Cubren el mapeo del JSON, el filtro, las transiciones del BLoC y las pantallas: tarjeta, búsqueda vacía, error con reintento, foto fija en el detalle y el segundo mínimo del inicio. No abren un socket hacia el API.

La cobertura es un informe aparte. Dice qué líneas tocaron las pruebas y no corta el build:

```
flutter test --coverage
```

Queda en `coverage/lcov.info`.
