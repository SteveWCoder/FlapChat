//
//  UploadImageViewController.swift
//  FlapChat
//
//  Created by Steve Watson on 19/01/2015.
//  Copyright (c) 2015 Steve. All rights reserved.
//

import UIKit

class UploadImageViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate, UITextFieldDelegate  {
    
    let imagePicker = UIImagePickerController()
    
    var imageSent = false
    
    // Variable to Hold the Name to send to
    
    var sendUser:String!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var myImageView: UIImageView!
    
    @IBOutlet weak var uploadBtn: UIButton!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBAction func upload(sender: AnyObject) {
        
        
        // Must have title so this checks
        if titleTextField.text != "" {
            
            
            titleTextField.resignFirstResponder()
            let imageData = UIImagePNGRepresentation(myImageView.image)
            
            let user = PFUser.currentUser().username as String
            
            // Create a TimeStamp
            let timeStamp = NSDate()
            
            // Get rid of all the extra stuff from NSDate
            
            var correctedStamp = "\(timeStamp)".stringByReplacingOccurrencesOfString(" ", withString: "", options: nil, range: nil)
            correctedStamp = correctedStamp.stringByReplacingOccurrencesOfString("-", withString: "", options: nil, range: nil)
            correctedStamp = correctedStamp.stringByReplacingOccurrencesOfString(":", withString: "", options: nil, range: nil)
            correctedStamp = correctedStamp.stringByReplacingOccurrencesOfString("+", withString: "", options: nil, range: nil)
            
            // Create a filename based on username and timestamp
            let filename = user + correctedStamp + ".png"
            let imageFile = PFFile(name:filename,data:imageData)
            var userPhoto = PFObject(className: "userPhotos")
            
            
            userPhoto["imageFile"] = imageFile
            userPhoto["sendTo"] = sendUser
            userPhoto["username"] = user
            userPhoto["title"] = titleTextField.text
            userPhoto["identifier"] = user + correctedStamp
            userPhoto.saveInBackground()
            
            userPhoto.saveInBackgroundWithBlock({ (sucess, error) -> Void in
                if error == nil {
                    
                    
                    if sucess {
                        self.imageSent = true
                        self.alertUser("Image was Sent")
                       
                        
                        
                    } else {
                        self.alertUser("Image was not Saved")
                    }
                    
                } else {
                    
                    self.alertUser("An Error Occurred, Please Try again")
                    
                }
            })
            
           
            
        } else {
            
            // They didn't enter a title so Alert Them
            alertUser("Please enter a Title")
        }
        
        
    }
    
    
    // Display Image Picker
    
    @IBAction func chooseImage(sender: AnyObject) {
        
        presentViewController(imagePicker, animated: true, completion: nil)
        
        
    }
    
    
    // Go Back to User List
    @IBAction func cancel(sender: AnyObject) {
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    // Generic Alert Display Function
    func alertUser(message:String) {
        
        let parent = self.presentingViewController
        
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            
            // Check if the image was sent and if so hide both alert and main view controller
            if !self.imageSent {
            
                alert.dismissViewControllerAnimated(true, completion:nil)
            } else {
                alert.dismissViewControllerAnimated(true, completion: nil)
                self.dismissViewControllerAnimated(true, completion: nil)
            }

            
                
            
           
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    
    func returnToList () {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        // Image has been chosen, hide image picker, display image, show upload button
        myImageView.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
        uploadBtn.hidden = false
        
    }
    
    
    
    // Hide Keyboard if touch anywhere or hit return
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
        return true
    }
    
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        titleTextField.resignFirstResponder()
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        
        // Delegate Set Up
        titleTextField.delegate = self
        
        imagePicker.delegate = self
    
        
        // Display Message to User
        titleLabel.text = "Send an Image to \(sendUser)"
        
        
        
        // Choose where can get images from - in my case using simulator, only from photo library
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        
        // I allow them to edit image
        imagePicker.allowsEditing = true
        
        
        
        // Hide Upload Button - it will be displayed when an image has been picked
        uploadBtn.hidden = true
        
        
    }
    
    
    
    
   
}
