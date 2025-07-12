# LearnScience App

Aplicación educativa desarrollada en Flutter para apoyar el aprendizaje de estudiantes mediante juegos, evaluaciones, y materiales interactivos.

---

## 🌍 Tecnologías Utilizadas

- **Flutter**: Framework principal de desarrollo de la interfaz.
- **GetX**: Para manejo de estado y navegación.
- **Firebase Storage**: Almacenamiento de archivos multimedia (imágenes y sonidos).
- **SQL Server (API)**: Base de datos para usuarios, calificaciones, y cuestionarios.

---

## 📂 Estructura del Proyecto

```plaintext
lib/
├── components/         # Widgets reutilizables (botones, navbars, etc.)
├── controllers/        # Controladores GetX para manejar lógica y estado
├── models/             # Clases modelo para mapear los datos (Usuario, Persona, etc.)
├── pages/              # Pantallas principales de la app
├── requests/           # Clases de servicios para hacer peticiones HTTP
├── constants.dart      # Colores, estilos, textos y rutas comunes
├── enums.dart          # Enumeraciones usadas para estados y navegación
├── main.dart           # Punto de entrada de la aplicación
├── size_config.dart    # Utilidad para adaptar la UI según el tamaño de pantalla
└── theme.dart          # Configuración de temas claros y oscuros
```

---

## 🎮 Funcionalidades Principales

- Inicio de sesión y registro de usuarios.
- Juegos interactivos por asignatura:
  - Juego del Ahorcado
  - Juego de Relacionar Conceptos
  - Memorama
  - Sopa de Letras
- Evaluaciones con calificaciones automáticas.
- Configuraciones como tema oscuro y créditos.
- Alerta de soporte por WhatsApp si se necesita ayuda.

---

## 💪 Contribuciones

Cualquier colaboración es bienvenida. Puedes abrir un issue o un pull request. Para soporte directo, se incluye enlace a WhatsApp dentro de la app.

---

## 🚀 Autoría

Realizado por **Santiago Navarro** y **Duvan Lozano**

---

## 📅 Estado del Proyecto

En desarrollo ✅.

Se están afinando niveles de dificultad en juegos, validaciones visuales, y animaciones. También se está integrando almacenamiento de progreso por usuario.

