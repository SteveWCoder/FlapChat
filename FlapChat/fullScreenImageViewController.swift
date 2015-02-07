//
//  fullScreenImageViewController.swift
//  FlapChat
//
//  Created by Steve Watson on 21/01/2015.
//  Copyright (c) 2015 Steve. All rights reserved.
//

import UIKit

class fullScreenImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var counter = 10
    
    var timer = NSTimer()
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    var image:PFObject!
    
    
    @IBAction func cancelButton(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        titleLabel.text = image["title"] as? String
        
        timerLabel.text = String(counter)
        
        
        let photoQuery = PFQuery(className: "userPhotos")
        photoQuery.whereKey("identifier", equalTo: image["identifier"])
        
        photoQuery.findObjectsInBackgroundWithBlock { (photoFile, error) -> Void in
            
            if error == nil {
                
                let imageFileData = photoFile[0] as PFObject
                let imageData = imageFileData.objectForKey("imageFile") as PFFile
                
                imageData.getDataInBackgroundWithBlock({ (data, error) -> Void in
                    if error == nil {
                        
                        
                        
                        
                        let image = UIImage(data: data)
                        
                        self.imageView.image = image
                        self.deleteImage()
                        self.startTimer()
                        
                    }
                })
                
                
                
            } else {

                println("Error is \(error)")
            }
            
            
                    }


    }


    

    func deleteImage() {
        
        image.deleteInBackground()
        
    }
    
    func startTimer() {
        
       timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("countDown"), userInfo: nil, repeats: true)
        
    }
    
    
    
    // Function called by timer
    func countDown() {
        
        if counter > 0 {
            counter--
            timerLabel.text = String(counter)
        } else {
            
            // Turn off timer and return to Image List
            timer.invalidate()
            self.dismissViewControllerAnimated(true, completion: nil)

        }
    }

}
