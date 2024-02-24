import Foundation
import UIKit

/// Defines errors that can occur while fetching country information or images.
enum CountryInfoError: Error {
    case itemNotFound // Indicates that the requested item was not found.
    case imageDataMissing // Indicates missing image data for a country's flag.
}

/// Handles network requests to fetch country information and images.
class APIRequestController {
    /// Fetches the complete list of countries from the API.
    /// - Returns: An array of `Country` objects.
    /// - Throws: `CountryInfoError.itemNotFound` if the data cannot be retrieved.
    func fetchCountryInfo() async throws -> [Country] {
        let url = URL(string: "https://restcountries.com/v3.1/all")!
        
        // Perform the network request asynchronously.
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Check for a successful HTTP status code.
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw CountryInfoError.itemNotFound
        }
        
        // Decode the JSON data into an array of Country objects.
        let jsonDecoder = JSONDecoder()
        let countries = try jsonDecoder.decode([Country].self, from: data)
        return countries
    }
    
    /// Fetches the flag image for a given URL.
    /// - Parameter url: The URL of the flag image.
    /// - Returns: A `UIImage` of the flag.
    /// - Throws: `CountryInfoError.imageDataMissing` if the image cannot be retrieved or decoded.
    func fetchFlagImage(from url: URL) async throws -> UIImage {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Check for a successful HTTP status code.
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw CountryInfoError.imageDataMissing
        }
        
        // Attempt to create a UIImage from the data.
        guard let image = UIImage(data: data) else {
            throw CountryInfoError.imageDataMissing
        }
        
        return image
    }
    
    /// Fetches country information along with their flag images.
    /// - Returns: An array of tuples containing a `Country` object and an optional `UIImage` of the flag.
    /// - Throws: Propagates errors from `fetchCountryInfo` or `fetchFlagImage`.
    func fetchInfoAndImages() async throws -> [(Country, UIImage?)] {
        var countriesAndImages: [(Country, UIImage?)] = []

        // Fetch the list of countries.
        let countries = try await fetchCountryInfo()

        // For each country, attempt to fetch its flag image.
        for country in countries {
            var flagImage: UIImage? = nil
            do {
                flagImage = try await fetchFlagImage(from: country.flags.png)
            } catch {
                print("Error fetching flag for country: \(country.name.common)")
                // Errors are caught here, allowing for flagImage to be nil if the image fetch fails.
            }
            countriesAndImages.append((country, flagImage))
        }

        return countriesAndImages
    }
    
    /// Fetches country information by name.
    /// - Parameter name: The name of the country to search for.
    /// - Returns: An array of `Country` objects matching the search query.
    /// - Throws: `URLError.badURL` if the URL is malformed, or `URLError.badServerResponse` for non-200 HTTP responses.
    func fetchCountryByName(_ name: String) async throws -> [Country] {
        // Construct the URL, ensuring special characters are correctly escaped.
        let urlString = "https://restcountries.com/v3.1/name/\(name)"
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
            throw URLError(.badURL)
        }
        
        // Perform the network request asynchronously.
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Optional: Check the HTTP status code here to handle different API responses.
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        // Decode the JSON response into an array of Country objects.
        let countries = try JSONDecoder().decode([Country].self, from: data)
        return countries
    }
}
