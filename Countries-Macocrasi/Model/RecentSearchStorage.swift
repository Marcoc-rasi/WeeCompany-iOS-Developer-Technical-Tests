//
//  RecentSearchStorage.swift
//  Countries-Macocrasi
//
//  Created by Marcos Uriel Martinez Ortiz on 23/02/24.
//

import Foundation

/// `RecentSearchStorage` is a utility class responsible for persisting and retrieving recent country searches.
/// It uses Property List (plist) files as the storage mechanism and leverages the `Codable` protocol for encoding and decoding the `CountrySearch` objects.
class RecentSearchStorage {
    /// The URL for the plist file where recent searches are saved.
    /// It dynamically generates the path to the `Documents` directory of the app and appends a specific filename for storing the searches.
    static let archiveURL: URL = {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("countrySearches").appendingPathExtension("plist")
    }()
    
    /// Saves an array of `CountrySearch` objects to a plist file.
    /// - Parameter searches: The array of `CountrySearch` objects to be saved.
    /// It tries to encode the array into a plist format and write it to the specified location.
    /// If an error occurs during this process, it prints an error message to the console.
    static func saveRecentSearches(_ searches: [CountrySearch]) {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(searches)
            try data.write(to: archiveURL)
        } catch {
            print("Error saving country searches: \(error)")
        }
    }
    
    /// Loads and returns an array of `CountrySearch` objects from the plist file.
    /// - Returns: An array of `CountrySearch` objects. If the file doesn't exist, or an error occurs during decoding, it returns an empty array.
    static func loadRecentSearches() -> [CountrySearch] {
        guard let data = try? Data(contentsOf: archiveURL) else { return [] }
        let decoder = PropertyListDecoder()
        do {
            return try decoder.decode([CountrySearch].self, from: data)
        } catch {
            print("Error loading country searches: \(error)")
            return []
        }
    }
}
