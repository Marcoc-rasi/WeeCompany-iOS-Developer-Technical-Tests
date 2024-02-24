//
//  RecentSearchesProtocol.swift
//  Countries-Macocrasi
//
//  Created by Marcos Uriel Martinez Ortiz on 23/02/24.
//

import Foundation

/// Defines a protocol for handling selection events from a list of recent searches.
/// This protocol is designed to be adopted by classes that need to respond to the selection of a recent search query.
protocol RecentSearchesDelegate: AnyObject {
    /// Called when a recent search is selected from the list.
    /// - Parameter search: The search query string that was selected.
    func didSelectRecentSearch(_ search: String)
}

