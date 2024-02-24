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
| `Country.swift`            | The `Country` struct represents the data model for a country's information, designed for easy encoding and decoding with the `Codable` protocol. It includes various properties such as `name`, `capital`, `currencies`, `flags`, and `maps`. **Name**: The nested `Name` struct stores both the common and official names of the country. **Currency**: The nested `Currency` struct represents the currency information of a country, including the name and optional symbol. **Flags**: The nested `Flags` struct holds URLs to the country's flag images, focusing on the PNG format. **Maps**: The `Maps` struct contains URLs to various mapping services, currently only storing the Google Maps URL. It's designed for potential expansion to include more mapping service URLs in the future. Through adherence to the `Codable` protocol, `Country` facilitates straightforward conversion between object and data formats, enabling seamless network data handling or local data storage. |
| `CountrySearch.swift`      | The `CountrySearch` class is a model designed to store information related to a country search operation. It implements the `Codable` protocol to enable easy encoding and decoding from and to data formats such as JSON, making it suitable for local storage or network transmission. This class contains a `countryNameSearched` property that stores the name of the searched country, facilitating the display of recent searches and the repetition of searches without the need to retype the country name. |
| `RecentSearchStorage.swift`| The `RecentSearchStorage` class serves as a utility for managing recent country searches, utilizing Property List (plist) files for storage and the `Codable` protocol for object encoding and decoding. It dynamically generates a URL for the plist file within the app's Documents directory. This class provides methods for both saving and loading recent searches. **Saving Recent Searches**: The `saveRecentSearches` method encodes an array of `CountrySearch` objects into a plist format and writes it to the specified location. In case of any error during this process, it provides informative error messages for debugging. **Loading Recent Searches**: The `loadRecentSearches` method retrieves an array of `CountrySearch` objects from the plist file. If the file doesn't exist or decoding encounters an error, it gracefully returns an empty array. Through these functionalities, `RecentSearchStorage` ensures efficient management and persistence of recent searches, contributing to enhanced usability and data integrity within the application. |

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
