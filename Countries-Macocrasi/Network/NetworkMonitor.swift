//
//  NetworkMonitor.swift
//  Countries-Macocrasi
//
//  Created by Marcos Uriel Martinez Ortiz on 24/02/24.
//

import Foundation
import Network

/// `NetworkMonitor` is a singleton class responsible for monitoring the network connectivity status.
/// It uses `NWPathMonitor` to listen for changes in network path status and provides a callback mechanism to notify observers about these changes.
class NetworkMonitor {
    /// Shared instance to be used for accessing `NetworkMonitor` functionalities.
    static let shared = NetworkMonitor()
    
    /// The `NWPathMonitor` used to monitor the network path changes.
    private var pathMonitor: NWPathMonitor?
    /// The dispatch queue on which the network path changes are processed.
    private let pathMonitorQueue = DispatchQueue(label: "NetworkMonitorQueue")
    
    /// A closure that is called when the network connectivity status changes.
    /// It passes a `Bool` indicating the connectivity status: `true` for connected and `false` for disconnected.
    var networkStatusChangeHandler: ((Bool) -> Void)?
    
    /// Private initializer to prevent instantiation outside of the `shared` instance and starts monitoring on initialization.
    private init() {
        startMonitoring()
    }
    
    /// Starts monitoring the network connectivity status.
    /// It first stops any existing monitoring to reset the state, then initializes a new `NWPathMonitor` and sets its path update handler to notify observers of connectivity changes.
    private func startMonitoring() {
        stopMonitoring() // Ensures that we're not adding multiple monitors.
        pathMonitor = NWPathMonitor()
        pathMonitor?.pathUpdateHandler = { [weak self] path in
            let status = path.status == .satisfied // `true` if there is an available path to the network that satisfies the requirements, `false` otherwise.
            self?.networkStatusChangeHandler?(status) // Notify the observer of the connectivity change.
        }
        pathMonitor?.start(queue: pathMonitorQueue) // Starts the path monitor on the specified queue.
    }
    
    /// Stops monitoring the network connectivity and cleans up the resources.
    /// It cancels the current `NWPathMonitor` if it exists and sets it to `nil` to release it.
    func stopMonitoring() {
        pathMonitor?.cancel() // Stops the path monitor from generating updates.
        pathMonitor = nil // Clears the path monitor to ensure it's deallocated.
    }
}
