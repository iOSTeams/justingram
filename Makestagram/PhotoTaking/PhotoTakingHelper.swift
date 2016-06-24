//
//  PhotoTakingHelper.swift
//  Makestagram
//
//  Created by King Justin on 6/24/16.
//  Copyright © 2016 Make School. All rights reserved.
//

//
//Presenting the popover to allow the user to choose between taking a new photo or selecting one from the photo library.
//Depending on the user's selection, presenting the camera or photo library.
//Returning the image that the user has taken or selected.



import UIKit

typealias PhotoTakingHelperCallback = UIImage? -> Void

extension PhotoTakingHelper: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject!]!) {
        viewController.dismissViewControllerAnimated(false, completion: nil)
        
        callback(image)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
}

class PhotoTakingHelper : NSObject {
    
    weak var viewController: UIViewController!
    var callback: PhotoTakingHelperCallback
    var imagePickerController: UIImagePickerController?
    
    
    init(viewController: UIViewController, callback: PhotoTakingHelperCallback) {
        self.viewController = viewController
        self.callback = callback
        
        super.init()
        
        showPhotoSourceSelection()
    }
    


//    In the first line we set up the UIAlertController by providing it with a message and a preferredStyle. The UIAlertController can be used to present different types of popups.
//    
//    By choosing the .ActionSheet option we create a popup that gets displayed from the bottom edge of the screen.
//    
//    After the initial set up, we add different UIAlertActions to the alert controller, each action will result in one additional button on the popup.
//    
//    The first action is the default Cancel action; you should add this one to almost all of your alert controllers. It will add a "Cancel" button that allows the user to close the popup without any action.
//    The second option allows the user to pick an image from the library. We create a UIAlertAction for the library and add it to the UIAlertController. (The body of the action is empty right now, but we will add the code in the next section.)
//    The third action, allowing the user to take a new photo, is special because it should only be displayed if the device has access to a camera. We check if the current device has a rear camera by using the isCameraDeviceAvailable(_:) method. If the rear camera is available, we add an action to the alert controller that allows the user to take a new photo. (We will add code to the body of this action in the next section as well.)
//    
//    In the very last line we present the alertController. 
//    
//    As we discussed earlier,
//    
//    **view controllers can only be presented from other view controllers.**
//    
//    We use the reference that we've stored in the viewController property and call the presentViewController method on it. Now the popup will be displayed on whichever view controller is stored in the viewController property!
//    None of this code will run at this point - to test it we need to connect it to the TimelineViewController. Let's do that next! After we've connected the TimelineViewController and the PhotoTakingHelper, we will come back to complete this code so that we actually present the camera or the photo library when one of the two options is selected.
    
    
    
    
    func showPhotoSourceSelection() {
        //Allow users to choose between photo library or camera
        let alertController = UIAlertController(title: nil, message: "Where do you want to get your photos from?", preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        let photoLibraryAction = UIAlertAction(title: "Photo from library", style: .Default) { (action) in
            self.showImagePickerController(.PhotoLibrary)
        }
        
        alertController.addAction(photoLibraryAction)
        
        //Only show camera is rear is available
        if (UIImagePickerController.isCameraDeviceAvailable(.Rear)) {
            let cameraAction = UIAlertAction(title: "Photo from camera", style: .Default) { (action) in
                self.showImagePickerController(.Camera)
            }
            alertController.addAction(cameraAction)
        }
        
        viewController.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
//    In the first line, this method creates a UIImagePickerController. In the second line, we set the sourceType of that controller. Depending on the sourceType the UIImagePickerController will activate the camera and display a photo taking overlay - or will show the user's photo library. Our showImagePickerController method takes the sourceType as an argument and hands it on to the imagePickerController - that allows the caller of this method to specify whether the camera or the photo library should be used as an image source.
//    Once the imagePickerController is initialized and configured, we present it.
    
    func showImagePickerController(sourceType: UIImagePickerControllerSourceType) {
        imagePickerController = UIImagePickerController()
        imagePickerController!.sourceType = sourceType
        imagePickerController!.delegate = self
        self.viewController.presentViewController(imagePickerController!, animated: true, completion: nil)
    }
}

