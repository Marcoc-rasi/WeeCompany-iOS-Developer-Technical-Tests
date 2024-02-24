import UIKit

/// `AllCountriesTableViewController` manages the display of countries and their information in a table view.
/// It fetches country data including images and updates the UI accordingly.
class AllCountriesTableViewController: UITableViewController {
    
    // Controller for making API requests to fetch country data and images.
    let apiRequestController = APIRequestController()
    
    // Array to store tuples of country data and their corresponding images.
    var countriesAndImages: [(Country, UIImage?)] = []
    
    // Flags to manage network status and UI updates.
    var isConnectedToInternet: Bool = true
    var isDataLoading: Bool = true
    var hasLostConnection: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Start monitoring network changes and load initial data.
        observeNetworkChanges()
        loadData()
    }
    
    /// Fetches country data and images, then updates the UI.
    /// Marks the beginning and end of data loading to manage UI state.
    func loadData() {
        isDataLoading = true // Indicate that data loading has started.
        Task {
            do {
                let fetchedData = try await apiRequestController.fetchInfoAndImages()
                DispatchQueue.main.async {
                    self.updateUI(with: fetchedData)
                    self.isDataLoading = false // Data loading finished successfully.
                }
            } catch {
                DispatchQueue.main.async {
                    // On error, show default cells and display an alert.
                    self.updateUI(with: []) // Show default cells if there's an error.
                    self.showAlert(title: "Error", message: "Could not fetch country data. Please check your internet connection.")
                    self.isDataLoading = false // Data loading finished with an error.
                }
            }
        }
    }
    
    /// Updates the table view UI with the fetched country data.
    /// - Parameter data: An array of tuples containing `Country` objects and optional `UIImage` objects.
    func updateUI(with data: [(Country, UIImage?)]) {
        self.countriesAndImages = data
        self.tableView.reloadData() // Reload the table view to display the new data.
    }
    
    /// Displays an alert with a specified title and message.
    /// - Parameters:
    ///   - title: The title of the alert.
    ///   - message: The message of the alert.
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true) // Present the alert to the user.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Ensures there's always at least one cell to display default or error state.
        return max(countriesAndImages.count, 1)
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue and cast the cell as AllCountriesTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as! AllCountriesTableViewCell
        
        // Check if the countriesAndImages array is empty to decide on the cell's content
        if countriesAndImages.isEmpty {
            // If no data is available, configure the cell to display default unavailable information
            cell.updateBad()
        } else {
            // Extract country and its optional image for the cell at indexPath
            let (country, image) = countriesAndImages[indexPath.row]
            // Configure the cell with the country's information and image
            cell.update(with: country, image: image ?? UIImage(systemName: "photo.on.rectangle") ?? UIImage())
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        // Allow selection only if there is an internet connection and data is not loading
        return isConnectedToInternet && !isDataLoading ? indexPath : nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect the row after it has been selected for a cleaner UI feedback
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Prepare for the segue to the DetailCountryViewController with necessary data
        if segue.identifier == "showDetail",
           let destinationVC = segue.destination as? DetailCountryViewController,
           let indexPath = tableView.indexPathForSelectedRow,
           isConnectedToInternet && !isDataLoading { // Ensure there's an internet connection and data is not loading
            // Pass the selected country and its image to the detail view controller
            let (selectedCountry, selectedImage) = countriesAndImages[indexPath.row]
            destinationVC.country = selectedCountry
            destinationVC.countryImage = selectedImage
        }
    }
    
    private func observeNetworkChanges() {
        // Setup a network status change handler to respond to connectivity changes
        NetworkMonitor.shared.networkStatusChangeHandler = { [weak self] isConnected in
            DispatchQueue.main.async {
                if isConnected {
                    // If connection is restored, optionally show an alert if there was a previous loss of connection
                    if self?.hasLostConnection == true {
                        self?.showAlert(title: "Internet Restored", message: "Your internet connection has been restored.")
                    }
                    // Attempt to load data again
                    self?.loadData()
                } else {
                    // If connection is lost, show an alert and update the UI to reflect the lack of connection
                    self?.showAlert(title: "No Internet", message: "Check your connection and try again.")
                    self?.isDataLoading = false
                    self?.updateUI(with: [])
                    self?.hasLostConnection = true
                }
                // Update the internet connection status
                self?.isConnectedToInternet = isConnected
            }
        }
    }
}
