import UIKit

/// `DetailCountryViewController` displays detailed information about a selected country.
/// It includes the country's common and official names, capital, currency, and an image.
/// There's also a button to view the country's location on Google Maps.
class DetailCountryViewController: UIViewController {
    
    // MARK: - Outlets for UI Elements
    @IBOutlet weak var countryImageView: UIImageView! // Displays the country's flag or image.
    @IBOutlet weak var commonNameLabel: UILabel! // Label for the country's common name.
    @IBOutlet weak var officialNameLabel: UILabel! // Label for the country's official name.
    @IBOutlet weak var capitalLabel: UILabel! // Label for the country's capital city.
    @IBOutlet weak var currencyLabel: UILabel! // Label for the country's primary currency.
    @IBOutlet weak var mapsButton: UIButton! // Button to open the country's location in Google Maps.
    
    // MARK: - Properties
    var country: Country? // The country object containing all the detailed information.
    var countryImage: UIImage? // An optional image of the country, such as its flag.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup the UI elements with the country's information upon view loading.
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Ensure the UI is updated every time the view appears, accommodating any changes.
        setupUI()
    }
    
    /// Configures the UI elements with the country's information.
    /// It ensures that all labels are updated and the image view displays the country's image or a placeholder.
    func setupUI() {
        // Ensure a country object exists before attempting to update the UI.
        guard let country = country else { return }
        
        // Set the labels with the country's information, using placeholders for missing data.
        commonNameLabel.text = "Common Name: \(country.name.common)"
        officialNameLabel.text = "Official Name: \(country.name.official)"
        capitalLabel.text = "Capital: \(country.capital?.joined(separator: ", ") ?? "N/A")"
        
        // Display currency information, handling cases where it might be missing.
        if let currency = country.currencies?.values.first {
            currencyLabel.text = "Currency: \(currency.name) (\(currency.symbol ?? "N/A"))"
        } else {
            currencyLabel.text = "Currency: N/A"
        }
        
        // Set the image view with the country's flag or a default system image if none is available.
        countryImageView.image = countryImage ?? UIImage(systemName: "photo.on.rectangle")
    }
    
    /// Opens the country's location in Google Maps when the maps button is tapped.
    /// This function is connected to the button's action in the storyboard.
    @IBAction func mapsButtonTapped(_ sender: UIButton) {
        // Attempt to open the country's location in Google Maps, if a URL is available.
        if let mapsURL = country?.maps.googleMaps {
            UIApplication.shared.open(mapsURL, options: [:], completionHandler: nil)
        }
    }
    
    
    
    // This IBAction is triggered when the image is tapped.
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        // Create an action sheet alert to offer options related to the country's image.
        let alertController = UIAlertController(title: "Select Action", message: nil, preferredStyle: .actionSheet)
        
        // Option to open the country's flag image in Safari using its URL.
        let openInSafariAction = UIAlertAction(title: "Open in Safari", style: .default) { [weak self] _ in
            // Use the URL of the PNG image of the flag if available.
            if let url = self?.country?.flags.png {
                UIApplication.shared.open(url)
            }
        }
        
        // Option to view the image in fullscreen within the app.
        let viewFullscreenAction = UIAlertAction(title: "View Fullscreen Image", style: .default) { [weak self] _ in
            // Perform a segue to the FullscreenImageViewController, passing the image.
            self?.performSegue(withIdentifier: "showFullscreenImage", sender: self)
        }
        
        // Option to cancel and close the action sheet.
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        // Add all actions to the alert controller.
        alertController.addAction(openInSafariAction)
        alertController.addAction(viewFullscreenAction)
        alertController.addAction(cancelAction)
        
        // Provide support for iPad by configuring the popover presentation controller.
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.countryImageView
            popoverController.sourceRect = self.countryImageView.bounds
            popoverController.permittedArrowDirections = []
        }
        
        // Present the alert controller to the user.
        present(alertController, animated: true, completion: nil)
    }
    
    // Prepares for the segue to the FullscreenImageViewController.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Check the segue identifier to ensure it's the intended segue to show the fullscreen image.
        if segue.identifier == "showFullscreenImage",
           let destinationVC = segue.destination as? FullscreenImageViewController {
            // Pass the country image to the destination view controller.
            destinationVC.image = countryImage
        }
    }
}
