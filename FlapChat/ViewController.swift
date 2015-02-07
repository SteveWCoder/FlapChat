//
//  ViewController.swift
//  FlapChat
//
//  Created by Steve Watson on 07/02/2015.
//  Copyright (c) 2015 Steve. All rights reserved.
//


import UIKit





class ViewController: UIViewController {
    
    
    
    // Title and Username Labels
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    
    
    
    // Outlets for Buttons so they can be hidden/shown
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var logInButton: UIButton!
    
    
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var logOutButton: UIButton!
    
    
    
    // If user is already logged in or has returned form logging/signing in then display welcome
    
    func displayUser(user: PFUser) {
        userNameLabel.hidden = false
        userNameLabel.text = user.username
        logInButton.hidden = true
        signUpButton.hidden = true
        titleLabel.text = "Welcome to FlapChat"
        continueButton.hidden = false
        
        logOutButton.hidden = false
    }
    
    
    
    @IBAction func logOut(sender: AnyObject) {
        
        PFUser.logOut()
        var currentUser = PFUser.currentUser()
        
        
        userNameLabel.hidden = true
        logInButton.hidden = false
        signUpButton.hidden = false
        titleLabel.text = "FlapChat"
        continueButton.hidden = true
        
        logOutButton.hidden = true
    }
    
    
    
    

    
    // Depending if the user is signing up or logging in set up the variable in the loginviewcontroller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "signUp" {
            
            if segue.destinationViewController .isKindOfClass(logInViewController) {
                let signUp = segue.destinationViewController as logInViewController
                
                signUp.signUp = true
                
                
                
                
                
            }
            
        }
        
        if segue.identifier == "logIn" {
            
            if segue.destinationViewController .isKindOfClass(logInViewController) {
                let logIn = segue.destinationViewController as logInViewController
                logIn.signUp = false
            
                
            }
            
        }
    }
    
    // If user is coming back to this screen from login after signing up or it's startup display welcome
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if PFUser.currentUser() != nil {
            displayUser(PFUser.currentUser())
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Initially hide buttons and labels
        userNameLabel.hidden = true
        continueButton.hidden = true
        logOutButton.hidden = true
        
        
        
    }
    
    
    
}

