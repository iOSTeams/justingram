//
//  Post.swift
//  Makestagram
//
//  Created by King Justin on 6/27/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation
import Parse
import Bond
// 1
class Post : PFObject, PFSubclassing {
    
    var image: Observable<UIImage?> = Observable(nil)
    var photoUploadTask: UIBackgroundTaskIdentifier?

    
    // 2
    @NSManaged var imageFile: PFFile?
    @NSManaged var user: PFUser?
    
    
    //MARK: PFSubclassing Protocol
    
    // 3
    static func parseClassName() -> String {
        return "Post"
    }
    
    // 4
    override init () {
        super.init()
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // inform Parse about this subclass
            self.registerSubclass()
        }
    }
    
//    func uploadPost() {
//        if let image = image {
//            // 1
//            let imageData = UIImageJPEGRepresentation(image, 0.8)!
//            let imageFile = PFFile(name: "image.jpg", data: imageData)!
//            
//            // 2
//            self.imageFile = imageFile
//            saveInBackground()
//        }
//    }
    
    
    func uploadPost() {
        if let image = image.value {
            guard let imageData = UIImageJPEGRepresentation(image, 0.8) else {return}
            guard let imageFile = PFFile(name: "image.jpg", data: imageData) else {return}
            
            // any uploaded post should be associated with the current user
            user = PFUser.currentUser()
            self.imageFile = imageFile
            
            // 1
            photoUploadTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
                UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
            }
            
            // 2
            saveInBackgroundWithBlock() { (success: Bool, error: NSError?) in
                // 3
                UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
            }
        }
    }
    
    func downloadImage() {
        // if image is not downloaded yet, get it
        // 1
        if (image.value == nil) {
            // 2
            imageFile?.getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
                if let data = data {
                    let image = UIImage(data: data, scale:1.0)!
                    // 3
                    self.image.value = image
                }
            }
        }
    }
    
}