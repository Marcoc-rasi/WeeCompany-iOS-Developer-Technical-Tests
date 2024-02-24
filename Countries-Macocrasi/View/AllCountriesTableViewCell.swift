import UIKit

/// `AllCountriesTableViewCell` is designed to display detailed information about a country within a table view cell.
/// It includes outlets for UI components like labels and an image view to show country data effectively.
class AllCountriesTableViewCell: UITableViewCell {

    @IBOutlet weak var countryImageView: UIImageView!
    @IBOutlet weak var commonNameLabel: UILabel!
    @IBOutlet weak var officialNameLabel: UILabel!
    @IBOutlet weak var capitalLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Perform any additional setup after loading the view, typically from a nib.
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state, if necessary.
    }
    
    /// Updates the cell's views with the data of a specific country, including its flag image.
    /// - Parameters:
    ///   - country: The `Country` object containing the data to display.
    ///   - image: The flag image of the country.
    func update(with country: Country, image: UIImage) {
        countryImageView.image = image
        commonNameLabel.text = "Common Name: \(country.name.common)"
        officialNameLabel.text = "Official Name: \(country.name.official)"
        capitalLabel.text = "Capital: \(country.capital?.joined(separator: ", ") ?? "Unknown")"
        
        if let currencies = country.currencies, let currency = currencies.values.first {
            currencyLabel.text = "Currency: \(currency.symbol ?? "Unknown") - \(currency.name)"
        } else {
            currencyLabel.text = "Currency: Unknown"
        }
        
        locationLabel.text = "Tap to view location"
    }
    
    /// Configures the cell to indicate that information about the country is unavailable.
    /// This method is called when there is an error fetching country data or the data is missing.
    func updateBad() {
        countryImageView.image = UIImage(systemName: "photo.on.rectangle")
        commonNameLabel.text = "Information unavailable"
        officialNameLabel.text = "Please try again later"
        capitalLabel.text = "Capital: N/A"
        currencyLabel.text = "Currency: N/A"
        locationLabel.text = "Location unavailable"
    }
}
