## 🚀 Guía de Instalación y Ejecución

Para asegurar la correcta ejecución del proyecto, se recomienda utilizar el siguiente entorno de desarrollo:

### Requisitos del Sistema
* **Flutter SDK**: 3.41.5 (Channel Stable)
* **Dart SDK**: 3.11.3
* **Plataforma de prueba**: Android Emulator / iOS Simulator / Google Chrome

### Pasos para la Configuración Local

1.  **Clonar el repositorio:**
    ```bash
    git clone [https://github.com/alejogrande/flutter-frontend-test-btg.git](https://github.com/alejogrande/flutter-frontend-test-btg.git)
    cd btg_funds_app
    ```

2.  **Limpieza e instalación de dependencias:**
    ```bash
    flutter clean
    flutter pub get
    ```

3.  **Ejecutar el proyecto:**
    * **Para entorno Mobile:**
        ```bash
        flutter run
        ```
    * **Para entorno Web:**
        ```bash
        flutter run -d chrome
        ```

### 🧪 Pruebas Unitarias
El proyecto incluye pruebas para validar la lógica de los Casos de Uso y las reglas de negocio del Dominio (validación de saldos y montos mínimos). Para ejecutarlas, use el siguiente comando:
```bash
flutter test

# 🏗️ Arquitectura de Capa de Presentación (UI)

El proyecto implementa un patrón de **Desacoplamiento Funcional** y **Composición de Widgets**. Las vistas (Screens) no contienen lógica de cálculo ni validaciones complejas; estas responsabilidades se delegan a `AppFormatters` y `AppValidators`.

## 📂 Estructura de Módulos

Cada funcionalidad en `lib/presentation/features/` sigue esta convención:
* **`feature_screen.dart`**: Punto de entrada. Define el `Scaffold`, los `BlocBuilder` y la estructura de alto nivel.
* **`widgets/`**: Componentes locales extraídos (Átomos y Moléculas) para mejorar la legibilidad y facilitar pruebas unitarias de UI.

---

## 📋 Inventario de Componentes por Pantalla

### 1. 💰 Funds Explorer (`funds_list_screen.dart`)
Catálogo de inversión responsivo que adapta su rejilla según el dispositivo.

| Componente | Tipo | Responsabilidad |
| :--- | :--- | :--- |
| `FundGridCard` | Molécula | Renderiza la información del fondo. Calcula el retorno estimado visualmente. |
| `InvestmentBottomSheet` | Organismo | Formulario de captura. Maneja el padding dinámico del teclado (`viewInsets.bottom`). |
| `FundsErrorView` | Estado | Interfaz de error con callback de reintento (`onRetry`). |

### 2. 📜 Transaction History (`history_screen.dart`)
Historial detallado con métricas de rendimiento.

| Componente | Tipo | Responsabilidad |
| :--- | :--- | :--- |
| `HistoryStatsHeader` | Organismo | Resumen de inversión. Usa `LayoutBuilder` para alternar entre `Flex` vertical/horizontal. |
| `DetailedInvestmentCard` | Molécula | Card principal de transacción con acciones de desvinculación. |
| `HistoryStatusBadge` | Átomo | Indicador visual de estado (Activa vs Completada). |
| `HistoryInfoItem` | Átomo | Par etiqueta-valor estandarizado para datos técnicos. |

---

## 🛠️ Widgets Globales (`presentation/widgets/`)

Componentes reutilizables en toda la aplicación:
* **`CustomAppBar`**: Toolbar estandarizado. Soporta navegación automática (`Navigator.pop`) o personalizada mediante el parámetro `onBack` (ej. `NavigationCubit`).
* **`SmallInfoCard`**: Tarjetas de métricas rápidas con soporte para estados "Wide" (ancho extendido).

---

## 🚦 Flujo de Datos y Validaciones

Para mantener la UI limpia, se aplican las siguientes reglas:

1.  **Formateo**: Los widgets reciben `Entities` y usan `AppFormatters` para mostrar moneda (`toCurrency`), porcentajes o fechas.
2.  **Validación**: Las entradas de usuario se validan mediante `AppValidators`.
    * *Ejemplo*: `AppValidators.validateInvestmentAmount` centraliza la lógica de montos mínimos sin ensuciar el `onPressed` del botón.
3.  **Navegación**: Centralizada en la capa de `Navigation`, permitiendo que los componentes de UI sean agnósticos a la ruta actual.

---

## 🎨 Guía de Estilo Técnica

Se debe priorizar el uso de las constantes globales para mantener la armonía visual:
* **Espaciado**: Usar `AppSpacing` (xs, sm, md, lg, xl) en lugar de valores literales.
* **Bordes**: Usar `AppRadius` para consistencia en `Cards` y `Inputs`.
* **Colores**: Referenciar siempre `AppColors.primaryBlue` o `AppColors.success`.


## 🌐 Capa de Dominio (Business Logic)

Esta capa es el núcleo del sistema. Contiene las reglas de negocio puras, es independiente de Flutter y de cualquier implementación externa (APIs o Bases de Datos).

### 🧩 Entidades (`domain/entities/`)
Representan los modelos de datos de negocio con lógica de auto-cálculo:

* **`FundEntity`**: Atributos base de los fondos de inversión (Monto mínimo, tasa, categoría).
* **`TransactionEntity`**: Registro de movimientos. Incluye la propiedad calculada `isActive` para determinar si una inversión sigue vigente basándose en su `TransactionType` y `endDate`.
* **`InvestmentSummary`**: Entidad de consolidación. Utiliza el Factory Method `fromHistory` para procesar el historial completo y calcular en tiempo real:
    * Total invertido y recuperado.
    * Tasa promedio de rendimiento ponderada.
    * Ganancias estimadas totales.

### 🏛️ Repositorios (Interfaces)
Definen los contratos de comunicación que la capa de Datos debe implementar:

* **`FundRepository`**: Contrato para la obtención de fondos disponibles.
* **`AccountRepository`**: Contrato crítico que gestiona:
    * Consulta y actualización de balance.
    * Persistencia de transacciones.
    * Recuperación de historial.
    * Proceso de desvinculación (`unsubscribe`).

### 🚀 Casos de Uso (`domain/usecases/`)
Implementan la lógica de negocio específica mediante el patrón **Command** (usando el método `call`):

1. **`GetAvailableFundsUseCase`**: Orquestador para obtener la lista de productos financieros.
2. **`SubscribeToFundUseCase`**: Contiene las **Reglas de Validación Primarias**:
    * **Validación de Monto Mínimo**: Verifica que la inversión cumpla el piso requerido por el fondo.
    * **Validación de Saldo**: Cruza el monto solicitado contra el balance actual del usuario.
    * **Generación de ID Único**: Utiliza `Uuid()` para garantizar la trazabilidad de la transacción.
3. **`UnsubscribeFromFundUseCase`**: Gestiona el proceso de retiro de capital y cierre de participación en un fondo.


## 💾 Capa de Datos (Data & Infrastructure)

Esta capa se encarga de la comunicación con fuentes externas y de la persistencia, transformando datos crudos en objetos de dominio.

### 📊 Modelos (`data/models/`)
* **`FundModel`**: Extiende de `FundEntity` utilizando `super`. Implementa el Factory Method `fromJson` para la deserialización segura de tipos (`num` a `double`), garantizando que la aplicación no falle por inconsistencias en el formato de los números provenientes de la fuente de datos.

### 🔌 Fuentes de Datos (Data Sources)
* **`FundRemoteDataSource` (Interfaz)**: Define el contrato para la obtención de datos externos.
* **`FundMockDataSourceImpl`**: Implementación para pruebas y desarrollo. 
    * Simula una **latencia de red de 1 segundo** para validar los estados de carga (`Loading`) en la UI.
    * Contiene un set de datos quemados (MockData) que incluye fondos reales como *FPV_BTG_PACTUAL_RECAUDADORA* y *DEUDAPRIVADA*.

### 📁 Repositorios (Implementaciones)
* **`FundRepositoryImpl`**: Actúa como puente entre el `DataSource` y el `UseCase`, inyectando la dependencia del origen de datos.
* **`AccountRepositoryImpl`**: Gestiona el estado financiero en memoria durante la sesión:
    * **Manejo de Saldo**: Inicia con un balance de prueba de `$500.000`.
    * **Historial Inmutable**: Utiliza `List.unmodifiable` al exponer el historial para evitar manipulaciones accidentales desde la UI.
    * **Lógica de Desvinculación**: Al ejecutar `unsubscribe`, realiza una mutación atómica: reemplaza la transacción de suscripción por una de cancelación e incrementa el saldo actual con el monto recuperado.

---

## 🚦 Navegación y Enums

Para mantener la consistencia en toda la aplicación, se centralizaron las definiciones de estado y tipos:

* **`NavigationState`**: Gestiona la ruta activa mediante el enum `AppRoute` (home, explorer, history).
* **`TransactionType`**: Enum que define las operaciones permitidas: `subscription` (entrada a fondo) y `cancellation` (salida del fondo).

---