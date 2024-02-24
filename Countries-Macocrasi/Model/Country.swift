import Foundation

/// `Country` represents the data model for a country's information.
/// It conforms to `Codable` for easy encoding and decoding, facilitating network data handling or local data storage.
struct Country: Codable {
    /// Represents the name of the country, including common and official names.
    var name: Name
    /// Optional array of capitals. It's optional to account for countries without a capital or when data might be missing.
    var capital: [String]?
    /// A dictionary mapping currency codes to their corresponding `Currency` objects. Optional to handle countries without currencies or missing data.
    var currencies: [String: Currency]?
    /// Contains the URLs to the country's flags, specifically the PNG version.
    var flags: Flags
    /// Contains URLs to mapping services, like Google Maps, providing location data for the country.
    var maps: Maps

    /// `Name` is a nested struct within `Country` that stores both the common and official names of the country.
    /// This struct also conforms to `Codable` to support easy data serialization.
    struct Name: Codable {
        var common: String
        var official: String
    }

    /// `Currency` represents the currency information of a country, including the name and optional symbol.
    /// Like its parent struct, it conforms to `Codable`.
    struct Currency: Codable {
        var name: String
        var symbol: String?
    }

    /// `Flags` is a nested struct that holds URLs to the country's flag images, focusing on the PNG format.
    /// Adheres to `Codable` for straightforward conversion between object and data formats.
    struct Flags: Codable {
        var png: URL // Only the URL for the PNG image of the flag is stored for simplicity and specific use cases.
    }

    /// `Maps` contains URLs to various mapping services, currently only storing the Google Maps URL.
    /// It's designed to potentially expand to include more mapping service URLs in the future.
    struct Maps: Codable {
        var googleMaps: URL
    }
}
