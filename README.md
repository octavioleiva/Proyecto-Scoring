# Sistema de Scoring de Conductores

Este proyecto es una aplicación de escritorio desarrollada en **Pascal (Lazarus)**, diseñada para administrar de manera eficiente la información de conductores y sus respectivas infracciones de tránsito, implementando una lógica de scoring para evaluar la conducta vial.

## 📋 Características principales
* **Administración de Conductores:** Interfaz para gestionar el alta, edición y eliminación de perfiles de conductores.
* **Control de Infracciones:** Módulo dedicado a cargar y procesar infracciones vinculadas a cada conductor.
* **Sistema de Scoring:** Algoritmo que procesa las infracciones y calcula el estado actual del conductor.
* **Reportes:** Visualización de listados actualizados de la situación de los conductores.

## 🏗 Arquitectura
- **Backend:** Pascal (Lógica procedural)
- **Persistencia:** Archivos `.DAT` para almacenamiento local.
## Estructura del Proyecto

El proyecto está organizado en módulos (units) para separar la lógica de la interfaz y la gestión de datos:

| Archivo | Descripción |
| :--- | :--- |
| `project1.lpr` | Punto de entrada principal de la aplicación. |
| `abmc_conductores.pas` | Gestión de altas, bajas y modificaciones de los perfiles de conductores. |
| `amc_infracciones.pas` | Lógica para el registro, modificacion y consulta de infracciones. |
| `unit_scoring.pas` | Algoritmo central que calcula el puntaje según las infracciones. |
| `carga_t_inf_paradesc.pas` | Carga de Tipo de infracciones y sus respectivos puntos correspondientes.
| `validacion_datos_sco.pas` | Se encarga de validar todo los datos de entrada tanto en menu, como en la carga de datos (conductores, infracciones,etc.).
| `listados_sco.pas` | Genera los listados ordenados de cada uno (Conductores, Infracciones, etc.)
| `est_archinf.pas` | Genera estadisticas: rango etario con mas infracciones, infracciones entre dos fechas, etc.

## Instalación y Ejecución

### 1. Requisitos Previos
Necesitarás tener instalado el entorno de desarrollo **Lazarus** con el compilador **Free Pascal (FPC)**.

* **Windows:** Descarga el instalador desde [lazarus-ide.org](https://www.lazarus-ide.org/).
* **Linux:** Puedes instalarlo desde el gestor de paquetes de tu distribución (ej: `sudo apt install lazarus`).

### 2. Ejecución
Puedes ejecutar el proyecto de dos formas:

**A. Desde el IDE (Recomendado):**
1. Abre Lazarus.
2. Ve a **Proyecto > Abrir proyecto** y selecciona el archivo `project1.lpi`.
3. Presiona el botón verde de **Ejecutar** (o F9).

**B. Desde la terminal (Compilación manual):**
Si prefieres compilar desde la línea de comandos, usa:
```bash
fpc project1.lpr
---
*Desarrollado para la materia de Algoritmos - UTN.*
