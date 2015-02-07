//
//  UserListTableViewController.swift
//  FlapChat
//
//  Created by Steve Watson on 18/01/2015.
//  Copyright (c) 2015 Steve. All rights reserved.
//

import UIKit

class UserListTableViewController: UITableViewController {

    // get the current user
    let user = PFUser.currentUser()
    
    
    // Array of usernames for the tableview
    var userList:[String] = Array()
    
    
    
    // Back to Welcome Screen
    
    @IBAction func backButton(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    

    

    
    // Get List of users and Display them
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    
        let userQuery = PFUser.query()
        
        // Get every user except current user
        
        userQuery.whereKey("username", notEqualTo: PFUser.currentUser().username)
        
        userQuery.findObjectsInBackgroundWithBlock { (users, error) -> Void in
            
            if error == nil {
                
                self.userList = Array()
                
                for user in users as [PFUser]{
                    
                    
                    self.userList.append(user.username)
                }
                
                
                self.tableView.reloadData()
                
                // Hide Empty Rows
                self.tableView.tableFooterView = UIView(frame:CGRectZero)
                
            } else {
                println("Error: \(error)")
            }
            
            
            
        }

        
        
        
    }
    
    
    // Style Title of Navigation Bar
    
    func setNavBarTextStyle () {
        
        let navBarStyle:NSMutableDictionary = NSMutableDictionary()
        navBarStyle.addEntriesFromDictionary(NSDictionary(object: UIFont(name: "HelveticaNeue-Thin", size: 21.0)!, forKey: NSFontAttributeName))
        
        self.navigationController?.navigationBar.titleTextAttributes = navBarStyle
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        setNavBarTextStyle ()
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return userList.count
    }

   
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("userCell", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        
        cell.textLabel?.text = userList[indexPath.row]

        return cell
    }
    
    // MARK: - Navigation
   
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  
        
        if segue.identifier == "sendImage" && segue.destinationViewController .isKindOfClass(UploadImageViewController) {
            
            // get the selected row in table view
            
            let index = tableView.indexPathForSelectedRow()!.row
            
            // Create new instance of UploadImageViewController
            let UIVC = segue.destinationViewController as UploadImageViewController
            
            
            // Send the new UploadImageViewController the name of the user that has been selected
            
            UIVC.sendUser = userList[index]
            
            
            
        }
        
        
        
    }

  


}
