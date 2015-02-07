//
//  SignUpViewController.swift
//  FlapChat
//  Created by Steve Watson on 18/01/2015.
//  Copyright (c) 2015 Steve. All rights reserved.
//

import UIKit

class logInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    // Button Outlet so can change button text
    
    @IBOutlet weak var logButton: UIButton!
    

    @IBOutlet weak var userName: UITextField!
    

    
    @IBOutlet weak var password: UITextField!
    
    // Variable to determin if logging in or signing up
    var signUp = false
    
    // Sign Up Funtion
    
    @IBAction func signUp(sender: AnyObject) {
        
        // Check that username and password have been entered
        if userName.text == "" {
            alertUser("Please Enter a Username")
        } else if password.text == "" {
            alertUser("Please Enter a Password")
        } else {
            
            // Hide Keyboard
            self.view.endEditing(true)
            
            // If signing up then create new user on parse
            if signUp {
                
                let user = PFUser()
                user.username = userName.text
                user.password = password.text
                
                
                
                user.signUpInBackgroundWithBlock({ (sucess, error) -> Void in
                    if error == nil {
                       
                        // Succesful sign up return to welcome Screen
                        self.dismissViewControllerAnimated(true, completion: nil)
                        
                    } else {
                        if error.code == 202 {
                            self.alertUser("Username is Already Taken")
                        }
                    }
                })
                
            // Logging in so check password and username
            } else {
                
                PFUser.logInWithUsernameInBackground(userName.text, password: password.text, block: { (user, error) -> Void in
                    
                    if user != nil {
                        
                        // Successful log in return to welcome screen
                        self.dismissViewControllerAnimated(true, completion: nil)
                        
                    } else {
                        if error.code == 101 {
                            self.alertUser("Log In Details Invalid")
                        }
                    }
                    
                })
                
                
                
                
            }
        }
        
        
    }
    

    
    // Hide Keyboard if touch anywhere or hit return
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
    // Cancel Whole Signin/Login
    
    @IBAction func cancel(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    
    // Generic Alert Message Function
    
    func alertUser(message:String) {
        
        
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // TextField Delegate Setups
        userName.delegate = self
        password.delegate = self
        
        // Change Labels and Buttons depending if user is loggin in or signing up
        if signUp {
            titleLabel.text = "Sign Up to FlapChat"
            logButton.setTitle("Sign Up", forState: .Normal)
        } else {
            titleLabel.text = "Log in to FlapChat"
            logButton.setTitle("Log In", forState: .Normal)

        }

    }




}
