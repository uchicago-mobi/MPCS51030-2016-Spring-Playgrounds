//
//  StyleViewController.swift
//  instaWatchItOnTv
//
//  Created by T. Andrew Binkowski on 5/8/16.
//  Copyright © 2016 The University of Chicago, Department of Computer Science. All rights reserved.
//

import UIKit

class StyleViewController: UIViewController {
  
  @IBAction func tapCamera(sender: UIBarButtonItem) {
    showPicker()
  }
  
  var originalImage: UIImage?
  var currentImage: UIImage? {
    didSet {
      bigImageView.image = currentImage
    }
  }
  
  let imagePicker = UIImagePickerController()
  
  @IBOutlet weak var bigImageView: UIImageView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    imagePicker.delegate = self
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(animated: Bool) {
    if originalImage == nil {
      print("Showing picker")
      
    }
    
  }
  
  func addImageToCloudKit(image: UIImage, thumbnail: UIImage) {
    print("Adding a item")
    
    CloudKitManager.sharedInstance.add(image, thumbnail: thumbnail) { (record, success) in
      if success == true {
        print("Success")
        // Update local data store
        
      }
    }
  }
  
  /// Show a UIImagePickerController.  The commented out code is so that we can 
  /// develop on the simulator, but won't forget to be robust in our handling
  /// of different devices
  func showPicker() {
    
    //if (UIImagePickerController.isSourceTypeAvailable(.Camera)) {
    //if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
    imagePicker.allowsEditing = false
    
    // This should be camera on device, but in simulator it will fail
    imagePicker.sourceType = .PhotoLibrary
    //imagePicker.cameraCaptureMode = .Photo

    presentViewController(imagePicker, animated: false, completion: {
      print("Presented")})
    //  } else {
    //    print("Rear camera doesn't exist")
    //  }
    //} else {
    //  print("Camera inaccessable")
    //}
  }
  
  
}


extension StyleViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

  /// User successfully picked an image
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    if let pickedImage:UIImage = (info[UIImagePickerControllerOriginalImage]) as? UIImage {
      print("We have an image!")

      // Update the view controllers properties because we will edit it them
      // from the presenting view controller
      originalImage = pickedImage
      currentImage = pickedImage

      // We can add the original to CloudKit here (if we want).  We probably
      // would want to wait until the user hasn't canceled the workflow
      addImageToCloudKit(pickedImage, thumbnail: pickedImage)

      // You could save the image to the photo library 
      //UIImageWriteToSavedPhotosAlbum()
      
      imagePicker.dismissViewControllerAnimated(true, completion: {
        // Anything you want to happen when the user saves an image
      })
    }
  }
  
  /// User cancelled the picker controller
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    print("User canceled image")
  }
  
  
}
