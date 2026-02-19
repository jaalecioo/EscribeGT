# EscribeGT 📝

Aplicación móvil para estimular la actividad motriz de preescritura en niños de temprana edad, desarrollada como proyecto de tesis de graduación en la **Universidad Mariano Gálvez de Guatemala**.

---

## Descripción

EscribeGT es una herramienta educativa diseñada para tabletas Android que ayuda a niños entre 1 y 6 años a desarrollar sus habilidades motrices de preescritura mediante ejercicios de trazado repetitivos. La aplicación muestra un trazo de ejemplo y el niño lo replica en una pizarra digital, recibiendo una calificación automática basada en la comparación de ambos trazos.

Fue desarrollada como respuesta a la brecha educativa generada por la pandemia de COVID-19, que impidió a muchos niños asistir a los grados preescolares donde normalmente adquieren estas habilidades.

---

## Características principales

- Selección de rango de edad del usuario (1 a 6 años)
- Listado de ejercicios cargado dinámicamente desde base de datos
- Pizarra digital con soporte para lápiz y escritura táctil
- Herramientas de dibujo: pincel, borrador, deshacer, rehacer y limpiar
- Calificación automática por comparación de imágenes
- Sistema de puntaje con retroalimentación positiva:
  - 0% – 60% → Puede mejorar
  - 61% – 75% → Buen trabajo
  - 76% – 90% → Gran trabajo
  - 91% – 100% → Excelente
- Historial de puntajes por ejercicio

---

## Tecnologías utilizadas

| Tecnología | Uso |
|---|---|
| Flutter 3.41 | Framework principal de desarrollo |
| Dart 3.11 | Lenguaje de programación |
| Firebase Firestore | Base de datos NoSQL en la nube |
| Google Fonts | Tipografías (Handlee y Roboto) |
| Scribble | Pizarra de dibujo libre |
| package:image | Procesamiento y comparación de trazos |

---

## Requisitos del entorno de desarrollo

- Flutter 3.41+
- Dart 3.0+
- Android SDK (API 29+)
- Java JDK 17
- VS Code o Android Studio
- Proyecto de Firebase configurado

---

## Instalación y configuración

### 1. Clonar el repositorio

```bash
git clone https://github.com/jaalecioo/EscribeGT.git
cd EscribeGT
```

### 2. Instalar dependencias

```bash
flutter pub get
```

### 3. Configurar Firebase

Es necesario contar con un proyecto de Firebase y generar el archivo `firebase_options.dart` usando FlutterFire CLI:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

O bien, configurar manualmente las opciones de Firebase en `main.dart` con los datos de tu proyecto.

### 4. Ejecutar la aplicación

```bash
flutter run
```

---

## Estructura del proyecto

```
lib/
├── main.dart                  # Pantalla inicial (selección de edad)
├── firebase_options.dart      # Configuración de Firebase (no incluido en el repo)
├── screens/
│   ├── levels.dart            # Pantalla de selección de ejercicio
│   └── board.dart             # Pizarra de trazado y calificación
├── scoring/
│   ├── scoring_engine.dart    # Motor de comparación de trazos
│   └── scoring_config.dart    # Configuración de tolerancia por edad
├── utils/
│   └── image_utils.dart       # Utilidades de procesamiento de imagen
└── theme/
    └── app_theme.dart         # Colores y estilos globales
assets/
└── ejercicios/                # Imágenes de referencia de los ejercicios
android/
ios/
web/
```

---

## Resultado del experimento

La hipótesis planteada fue validada con una muestra de usuarios. Se observó una mejora progresiva en los puntajes obtenidos a medida que el usuario repite los ejercicios, siguiendo una función lineal con pendiente positiva:

| Iteración | Puntaje |
|---|---|
| 1 | 63 |
| 2 | 68 |
| 3 | 71 |
| 4 | 78 |
| 5 | 76 |
| 6 | 84 |
| 7 | 91 |
| **Promedio** | **75.86** |

---

## Autor

**Josue Avidan Alecio Ortiz**  
Licenciatura en Ingeniería en Sistemas de Información y Ciencias de la Computación  
Universidad Mariano Gálvez de Guatemala — Julio 2022

---

## Estado del proyecto

| Año | Evento |
|---|---|
| 2022 | Aplicación creada como proyecto de tesis de graduación |
| 2026 | Aplicación actualizada a una versión moderna (Flutter 3.41 / Dart 3.11) |

---

## Licencia

Proyecto académico. Todos los derechos reservados al autor.
