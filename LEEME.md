# Países
Esta aplicación es una sofisticada aplicación de iOS diseñada para `buscar` y mostrar información detallada sobre los `países`. Aquí tienes una visión general profesional de su funcionalidad:

# Características Principales
- `Búsqueda de Países`: Los usuarios pueden buscar países por nombre a través de un `UISearchBar` integrado en la barra de navegación. La aplicación es compatible con versiones de iOS `11.0` y superiores con capacidades de búsqueda mejoradas, incluido un requisito de no capitalización para las entradas de búsqueda para mejorar la experiencia del usuario.
- `Búsquedas Recientes`: La aplicación mantiene un historial de búsquedas recientes, lo que permite a los usuarios revisitar rápidamente consultas anteriores. Esta característica mejora la usabilidad al reducir la necesidad de volver a escribir términos buscados con frecuencia.
- `Visualización de Detalles del País`: Tras una búsqueda exitosa, la aplicación presenta información detallada sobre el país, incluido su nombre común, nombre oficial, capital, moneda y bandera. Esta información se carga dinámicamente y se muestra en una interfaz fácil de usar.
- `Visualización Interactiva de la Bandera`: Los usuarios pueden interactuar con la imagen de la bandera del país para acceder a opciones adicionales, como ver la bandera en pantalla completa o abrirla en Safari para una inspección más detallada.
- `Navegación e Interacción del Usuario`: La aplicación emplea transiciones modales y segues para navegar entre diferentes vistas, incluida una vista de búsquedas recientes y un visor de imágenes en pantalla completa. Utiliza `UIAlertControllers` para proporcionar retroalimentación o acciones al usuario, como la opción de cancelar o proceder con ciertas operaciones.

# Aspectos Técnicos Destacados
- `Obtención Asincrónica de Datos`: La aplicación aprovecha el modelo de concurrencia de Swift para realizar solicitudes de red de forma asincrónica, obteniendo detalles de países e imágenes de banderas sin bloquear el hilo de la interfaz de usuario. Este enfoque garantiza una experiencia de usuario fluida y receptiva.
- `Manejo de Errores y Retroalimentación al Usuario`: Mediante el uso de bloques try-catch y `UIAlertControllers`, la aplicación maneja de manera sólida los errores (por ejemplo, fallas en la carga de imágenes o búsquedas sin resultados) e informa adecuadamente al usuario, manteniendo un alto nivel de usabilidad incluso cuando surgen problemas inesperados.
- `Diseño de IU Adaptativa`: La aplicación incluye consideraciones para diferentes tipos de dispositivos, como la implementación de controladores de presentación emergente para iPads para garantizar un diseño y patrones de interacción óptimos en todos los dispositivos iOS.
- `Organización y Modularidad del Código`: La funcionalidad está encapsulada dentro de métodos y extensiones bien definidos, siguiendo los principios de encapsulación y separación de preocupaciones. Esta modularidad facilita el mantenimiento del código y futuras mejoras.

# Arquitectura de la Aplicación

## Model
| Clase                    | Descripción                                                  |
|--------------------------|--------------------------------------------------------------|
| `Country.swift`          | Define la estructura de los datos relacionados con un país, incluyendo propiedades como nombre común, nombre oficial, capital, moneda, y bandera. |
| `CountrySearch.swift`    | Estructura para almacenar información sobre búsquedas de países realizadas por el usuario. |
| `RecentSearchStorage.swift` | Gestiona el almacenamiento y recuperación de las búsquedas recientes utilizando un sistema de almacenamiento persistente. |

## View
| Clase                        | Descripción                                                  |
|------------------------------|--------------------------------------------------------------|
| `AllCountriesTableViewCell`  | Celda personalizada para mostrar la lista de todos los países en una vista de tabla. |

## Controller
| Clase                               | Descripción                                                  |
|-------------------------------------|--------------------------------------------------------------|
| `AllCountriesTableViewController.swift` | Controlador de vista para mostrar una lista de todos los países en una tabla. |
| `DetailCountryViewController.swift`    | Controlador de vista para mostrar los detalles de un país específico. |
| `FindCountriesByNameViewController.swift` | Controlador de vista para buscar países por nombre. |
| `FullscreenImageViewController.swift`    | Controlador de vista para mostrar imágenes en pantalla completa. |
| `RecentSearchesTableViewController.swift` | Controlador de vista para mostrar una lista de búsquedas recientes. |

## Network
| Clase                   | Descripción                                                  |
|-------------------------|--------------------------------------------------------------|
| `ApiRequest.swift`      | Clase responsable de realizar solicitudes de red para obtener datos de países. |
| `NetworkMonitor.swift`  | Utilidad para monitorear la conectividad de red de la aplicación. |

## Protocol
| Clase                          | Descripción                                                  |
|--------------------------------|--------------------------------------------------------------|
| `RecentSearchesProtocol.swift` | Define un protocolo para delegar la selección de búsquedas recientes a un controlador de vista. |

