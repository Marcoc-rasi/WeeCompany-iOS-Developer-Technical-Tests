# Countries
This application is a sophisticated iOS app designed for `searching` and displaying detailed information about `countries`. Here's a professional overview of its functionality:

# Core Features
- `Country Search`: Users can search for countries by name through a `UISearchBar` integrated into the navigation bar. The app supports iOS versions `11.0` and above with enhanced search capabilities, including a non-capitalization requirement for search inputs to improve user experience.
- `Recent Searches`: The app maintains a history of recent searches, allowing users to quickly revisit previous queries. This feature enhances usability by reducing the need to retype frequently searched terms.
- `Country Details Display`: Upon successful search, the app presents detailed information about the country, including its common name, official name, capital, currency, and flag. This information is dynamically loaded and displayed in a user-friendly interface.
- `Interactive Flag Viewing`: Users can interact with the country's flag image to access additional options, such as viewing the flag in full screen or opening it in Safari for a closer inspection.
- `Navigation and User Interaction`: The app employs modal transitions and segues to navigate between different views, including a recent searches view and a full-screen image viewer. It utilizes `UIAlertControllers` to provide feedback or actions to the user, such as the option to cancel or proceed with certain operations.

# Technical Highlights
- `Asynchronous Data Fetching`: The application leverages Swift's concurrency model to perform network requests asynchronously, fetching country details and flag images without blocking the UI thread. This approach ensures a smooth and responsive user experience.
- `Error Handling and User Feedback`: Through the use of try-catch blocks and `UIAlertControllers`, the app robustly handles errors (e.g., image loading failures or searches with no results) and informs the user appropriately, maintaining a high level of usability even when unexpected issues arise.
- `Adaptive UI Design`: The app includes considerations for different device types, such as implementing popover presentation controllers for iPads to ensure optimal layout and interaction patterns across all iOS devices.
- `Code Organization and Modularity`: The functionality is encapsulated within well-defined methods and extensions, following the principles of encapsulation and separation of concerns. This modularity facilitates code maintenance and future enhancements.


# Application Architecture

## Model
| Class                      | Description                                                  |
|----------------------------|--------------------------------------------------------------|
| `Country.swift`            | Defines the structure for country data, including properties such as common name, official name, capital, currency, and flag. |
| `CountrySearch.swift`      | Structure to store information about user-performed country searches. |
| `RecentSearchStorage.swift`| Manages the storage and retrieval of recent search data using a persistent storage system. |

## View
| Class                      | Description                                                  |
|----------------------------|--------------------------------------------------------------|
| `AllCountriesTableViewCell`| Custom table view cell for displaying a list of all countries in a table view. |

## Controller
| Class                                 | Description                                                  |
|---------------------------------------|--------------------------------------------------------------|
| `AllCountriesTableViewController.swift` | View controller for displaying a list of all countries in a table view. |
| `DetailCountryViewController.swift`      | View controller for displaying the details of a specific country. |
| `FindCountriesByNameViewController.swift` | View controller for searching countries by name. |
| `FullscreenImageViewController.swift`    | View controller for displaying images in full screen. |
| `RecentSearchesTableViewController.swift` | View controller for displaying a list of recent searches. |

## Network
| Class                     | Description                                                  |
|---------------------------|--------------------------------------------------------------|
| `ApiRequest.swift`        | Class responsible for making network requests to fetch country data. |
| `NetworkMonitor.swift`    | Utility for monitoring the application's network connectivity. |

## Protocol
| Class                            | Description                                                  |
|----------------------------------|--------------------------------------------------------------|
| `RecentSearchesProtocol.swift`   | Defines a protocol for delegating the selection of recent searches to a view controller. |
