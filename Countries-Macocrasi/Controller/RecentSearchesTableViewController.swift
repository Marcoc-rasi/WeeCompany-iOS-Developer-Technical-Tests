import UIKit

/// `RecentSearchesTableViewController` manages the display and interaction of a list showing recent country search queries.
class RecentSearchesTableViewController: UITableViewController {
    
    /// An array to store the names of recent searches.
    var recentSearches: [String] = []
    
    /// A delegate to handle selection actions on recent searches. It conforms to `RecentSearchesDelegate` to communicate selection events back to the delegating view controller.
    weak var delegate: RecentSearchesDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load recent searches from storage. If there are none, a default message is presented.
        recentSearches = loadRecentSearches()
        if recentSearches.isEmpty {
            recentSearches = ["No recent searches"]
        }
    }
    
    /// Loads recent searches from persistent storage and maps them to a string array for display.
    /// - Returns: An array of strings representing the names of countries that have been searched for recently.
    func loadRecentSearches() -> [String] {
        // Utilizes `RecentSearchStorage` to retrieve stored search objects and maps them to their country name strings.
        let searches = RecentSearchStorage.loadRecentSearches()
        return searches.map { $0.countryNameSearched }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Returns the count of recent searches to determine the number of rows needed in the table view.
        return recentSearches.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue a cell and set its text label to the corresponding recent search string.
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentSearchCell", for: indexPath)
        cell.textLabel?.text = recentSearches[indexPath.row]
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handles the selection of a recent search, informing the delegate of the selected search.
        let selectedSearch = recentSearches[indexPath.row]
        delegate?.didSelectRecentSearch(selectedSearch)
        
        // Dismisses the view controller after a selection is made, assuming this view controller is presented modally.
        dismiss(animated: true, completion: nil)
    }
}
