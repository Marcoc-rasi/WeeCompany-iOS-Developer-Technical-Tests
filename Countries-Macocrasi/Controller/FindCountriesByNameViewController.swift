//
//  FindCountriesByNameViewController.swift
//  Countries-Macocrasi
//
//  Created by Marcos Uriel Martinez Ortiz on 23/02/24.
//

import UIKit

// Define a custom UIViewController class to search and display country information.
class FindCountriesByNameViewController: UIViewController, UISearchBarDelegate {

    // Outlets for UI elements to display country details and an interactive maps button.
    @IBOutlet weak var countryImageView: UIImageView!
    @IBOutlet weak var commonNameLabel: UILabel!
    @IBOutlet weak var officialNameLabel: UILabel!
    @IBOutlet weak var capitalLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var mapsButton: UIButton!
    
    // A nullable Country object to hold the details of the found country.
    var country: Country?
    // An array to keep track of recent country searches.
    var recentSearches: [CountrySearch] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load any saved recent searches at initialization.
        recentSearches = RecentSearchStorage.loadRecentSearches()
        
        // Initialize and configure a UISearchBar programmatically.
        let searchBar = UISearchBar()
        searchBar.delegate = self // Set the delegate to handle search bar events.
        searchBar.placeholder = "Search for a country" // Placeholder text to guide users.
        
        // Customize the search bar's appearance and behavior based on the iOS version.
        if #available(iOS 11.0, *) {
            // For iOS 11 and later, use the integrated navigationItem.searchController.
            navigationItem.searchController = UISearchController(searchResultsController: nil)
            navigationItem.searchController?.searchBar.delegate = self
            navigationItem.hidesSearchBarWhenScrolling = false // Keep the search bar visible.
            navigationItem.searchController?.searchBar.autocapitalizationType = .none // Disable automatic capitalization.
        } else {
            // For older iOS versions, manually adjust the search bar and set it as the navigation item's title view.
            if let textField = searchBar.value(forKey: "searchField") as? UITextField {
                textField.autocapitalizationType = .none // Disable automatic capitalization.
            }
            searchBar.sizeToFit() // Ensure the search bar fits within the available space.
            navigationItem.titleView = searchBar // Set the search bar as the title view.
        }
        
        configureInitialState() // Call a custom method to set the initial state of the UI.
    }

    
    
    
    // Sets the initial visual state of the UI components when the view loads or after a search with no results.
    func configureInitialState() {
        // Hide UI elements related to country details to present a clean state for new searches.
        countryImageView.isHidden = true
        commonNameLabel.text = "Please search for a country" // Provide guidance to the user.
        officialNameLabel.isHidden = true
        capitalLabel.isHidden = true
        currencyLabel.isHidden = true
        mapsButton.isHidden = true // Hide the maps button until a country is found.
    }

    // Handles the event when the search button on the keyboard is clicked.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            searchBar.resignFirstResponder() // Dismiss the keyboard if the search text is empty.
            return
        }
        
        searchBar.resignFirstResponder() // Dismiss the keyboard to show the results.
        performSearch(with: searchText) // Initiate the search with the provided text.
    }

    // Asynchronously performs a search for a country with the given name and updates the UI accordingly.
    func performSearch(with name: String) {
        Task {
            do {
                // Attempt to fetch country details using an asynchronous network request.
                let countries = try await APIRequestController().fetchCountryByName(name)
                guard let country = countries.first else {
                    // If no countries are found, reset the UI to its initial state and possibly inform the user.
                    DispatchQueue.main.async {
                        self.configureInitialState() // Optionally show a message to the user indicating no results.
                    }
                    return
                }
                // Update the UI on the main thread with the details of the found country.
                DispatchQueue.main.async {
                    self.updateUI(with: country)
                    // Check if the search is already present in recent searches to avoid duplicates.
                    if !self.recentSearches.contains(where: { $0.countryNameSearched == name }) {
                        // Save the new search only if it's not a duplicate.
                        let search = CountrySearch(countryNameSearched: name)
                        self.recentSearches.append(search)
                        RecentSearchStorage.saveRecentSearches(self.recentSearches)
                    }
                }
            } catch {
                // Handle any errors during the search, reset the UI, and possibly alert the user.
                DispatchQueue.main.async {
                    self.configureInitialState()
                    self.showNoResultsAlert() // This method presumably informs the user of the failure.
                }
                print("Error during search: \(error)")
            }
        }
    }


    
    // Updates the user interface with details of the specified country.
    func updateUI(with country: Country) {
        self.country = country // Assign the country object to the class's `country` property for later use.

        // Unhide UI elements and update them with the country's information.
        countryImageView.isHidden = false // Show the country image view.
        commonNameLabel.text = "Common Name: \(country.name.common)" // Display the country's common name.
        officialNameLabel.isHidden = false // Show the label for the official name.
        officialNameLabel.text = "Official Name: \(country.name.official)" // Set the country's official name.
        capitalLabel.isHidden = false // Make the capital label visible.
        capitalLabel.text = "Capital: \(country.capital?.joined(separator: ", ") ?? "N/A")" // Display the capital(s), or "N/A" if unavailable.
        currencyLabel.isHidden = false // Show the currency label.
        // Handle the possibility of missing currency information.
        if let currency = country.currencies?.values.first {
            currencyLabel.text = "Currency: \(currency.name) (\(currency.symbol ?? "N/A"))" // Display the first found currency and symbol.
        } else {
            currencyLabel.text = "Currency: N/A" // Indicate that currency information is not available.
        }
        mapsButton.isHidden = false // Ensure the maps button is visible for interaction.
        
        // Asynchronously load and display the country's flag image.
        Task {
            await loadCountryImage(country.flags.png) // Assumes `loadCountryImage` is an async method you've defined elsewhere.
        }
    }

    // Handles the event when the maps button is tapped by the user.
    @IBAction func mapsButtonTapped(_ sender: UIButton) {
        // Attempt to open the country's location in Google Maps if the URL is available.
        if let mapsURL = country?.maps.googleMaps { // Safely unwrap the Google Maps URL of the country.
            UIApplication.shared.open(mapsURL, options: [:], completionHandler: nil) // Open the URL using the default application, typically Google Maps.
        }
    }

    
    // Handles the tap gesture on the country's flag image.
    @IBAction func imageViewTapped(_ sender: UITapGestureRecognizer) {
        // Initialize an action sheet to offer different actions to the user.
        let alertController = UIAlertController(title: "Select Action", message: nil, preferredStyle: .actionSheet)

        // Action to open the flag image in Safari using the image's URL.
        let openInSafariAction = UIAlertAction(title: "Open in Safari", style: .default) { [weak self] _ in
            // Safely unwrap the URL of the country's flag and open it in Safari.
            if let url = self?.country?.flags.png {
                UIApplication.shared.open(url) // Utilizes the shared application instance to open the URL.
            }
        }

        // Action to view the flag image in full screen within the app.
        let viewFullscreenAction = UIAlertAction(title: "View Fullscreen Image", style: .default) { [weak self] _ in
            // Triggers a segue to a view controller designed for displaying the image in full screen.
            self?.performSegue(withIdentifier: "findShowFullscreenImage", sender: self)
        }

        // Action to dismiss the action sheet without performing any operations.
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        // Add all actions to the alertController.
        alertController.addAction(openInSafariAction)
        alertController.addAction(viewFullscreenAction)
        alertController.addAction(cancelAction)

        // Ensure proper display on iPad by configuring the popover presentation.
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.countryImageView // Anchor the popover to the countryImageView.
            popoverController.sourceRect = self.countryImageView.bounds // Set the anchor rectangle.
            popoverController.permittedArrowDirections = [] // Disable arrow directions for a modal presentation style.
        }

        // Present the configured action sheet to the user.
        present(alertController, animated: true, completion: nil)
    }

    // Prepares for the segue based on the identifier.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "findShowFullscreenImage",
           let destinationVC = segue.destination as? FullscreenImageViewController,
           let image = countryImageView.image { // Conditionally unwrap the image from the UIImageView.
            // Pass the image to the destination view controller for full-screen display.
            destinationVC.image = image
        } else if segue.identifier == "RecentSearchesViewController" {
            // Handle the segue to the Recent Searches view controller.
            if let recentSearchesVC = segue.destination as? RecentSearchesTableViewController {
                // Set the current view controller as the delegate of the Recent Searches view controller.
                recentSearchesVC.delegate = self
            }
        }
    }



    // Asynchronously loads an image from a given URL and updates the UI.
    func loadCountryImage(_ url: URL) async {
        do {
            // Attempt to fetch the image data from the URL.
            let (data, _) = try await URLSession.shared.data(from: url)
            // Convert the data into a UIImage object.
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    // Update the countryImageView on the main thread with the fetched image.
                    self.countryImageView.image = image
                }
            }
        } catch {
            // Handle errors in image loading and set a default image indicating failure.
            print("Error loading image: \(error)")
            DispatchQueue.main.async {
                self.countryImageView.image = UIImage(systemName: "photo.on.rectangle")
            }
        }
    }

    // Displays an alert indicating that no results were found for the search.
    func showNoResultsAlert() {
        // Initialize an alert controller with a title and message.
        let alertController = UIAlertController(title: "No Results", message: "No country found with that name. Please try another search.", preferredStyle: .alert)
        // Create an OK action to dismiss the alert.
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            // Optional: Implement any actions to take when the user taps "OK".
        }
        alertController.addAction(okAction)
        // Present the alert controller to the user.
        present(alertController, animated: true)
    }

    // Triggers a modal transition to the Recent Searches view controller when the bar button is tapped.
    @IBAction func recentsBarButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "RecentSearchesViewController", sender: self)
    }
 
    
    
}


// MARK: - RecentSearchesDelegate
// Extension to handle selections from the recent searches list.
extension FindCountriesByNameViewController: RecentSearchesDelegate {
    func didSelectRecentSearch(_ search: String) {
        // Perform a search using the selected recent search term.
        performSearch(with: search)
    }
}
