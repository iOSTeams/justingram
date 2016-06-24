
import UIKit

class TimelineViewController: UIViewController {
    
    var photoTakingHelper: PhotoTakingHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.delegate = self
    }
    
    func takePhoto() {
        print("take photo")
        // instantiate photo taking class, provide callback for when photo is selected
        photoTakingHelper = PhotoTakingHelper(viewController: self.tabBarController!, callback: { (image: UIImage?) in
            print("callback received")
        })
    }
}




// MARK: Tab Bar Delegate

extension TimelineViewController: UITabBarControllerDelegate {
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        if (viewController is PhotoViewController) {
            takePhoto()
            return false
        } else {
            return true
        }
    }
    

}