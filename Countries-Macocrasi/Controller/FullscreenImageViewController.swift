import UIKit

/// `FullscreenImageViewController` is designed to display an image in full screen mode.
/// It allows users to view an image stretched to the limits of the screen without distortion.
class FullscreenImageViewController: UIViewController {
   
    @IBOutlet weak var imageView: UIImageView! // Connects an image view from the storyboard for displaying the image.
    
    var image: UIImage? // Holds the image to be displayed in full screen.

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets the passed image to the image view when the view controller's view is loaded.
        imageView.image = image
        
        // Configures the image view to scale the image proportionally to fit the view's bounds.
        imageView.contentMode = .scaleAspectFit // Ensures the image fits without stretching or squashing.
    }
}
