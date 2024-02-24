//
//  CountrySearch.swift
//  Countries-Macocrasi
//
//  Created by Marcos Uriel Martinez Ortiz on 23/02/24.
//

import Foundation

/// `CountrySearch` represents a model for storing information related to a country search operation.
/// It conforms to `Codable` to easily encode and decode from and to data formats such as JSON, making it suitable for local storage or network transmission.
struct CountrySearch: Codable {
    /// Stores the name of the country that was searched.
    /// This property can be used to display recent searches or to perform repeat searches without retyping the country name.
    var countryNameSearched: String
}

