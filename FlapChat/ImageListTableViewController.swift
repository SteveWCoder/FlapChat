//
//  ImageListTableViewController.swift
//  FlapChat
//
//  Created by Steve Watson on 07/02/2015.
//  Copyright (c) 2015 Steve. All rights reserved.
//

import UIKit

class ImageListTableViewController: UITableViewController {
    
    
    // Array of PFObjects to hold the images the user has been sent
    var images = [PFObject]()
   
    
    
    // Go Back to Welcome Screen
    @IBAction func backButton(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

      

        
        setNavBarTextStyle ()
        
    }
    
    
    // Because the images are deleted from server, need to update the list every time view is being seen
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        images = Array()
        
        let query = PFQuery(className: "userPhotos")
        
        query.whereKey("sendTo", equalTo: PFUser.currentUser().username)
        
        query.findObjectsInBackgroundWithBlock { (photos, error) -> Void in
            
            if error == nil {
                
                if photos.count > 0 {
                    
                    for photo in photos as [PFObject] {
                        self.images.append(photo)
                    }
                    
                    self.tableView.reloadData()
                    // Hide Empty Rows
                    self.tableView.tableFooterView = UIView(frame:CGRectZero)
                }
                
            } else {
                println("Error: \(error)")
            }
            
        }
        
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return images.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("imageCell", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        
        let image = images[indexPath.row] as PFObject
        cell.textLabel?.text = image["title"] as? String
        cell.detailTextLabel?.text = image["username"] as? String

        return cell
    }

    // Style Title of Navigation Bar
    
    func setNavBarTextStyle () {
        
        let navBarStyle:NSMutableDictionary = NSMutableDictionary()
        navBarStyle.addEntriesFromDictionary(NSDictionary(object: UIFont(name: "HelveticaNeue-Thin", size: 21.0)!, forKey: NSFontAttributeName))
        
        self.navigationController?.navigationBar.titleTextAttributes = navBarStyle
        
        
    }



    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showImage" && segue.destinationViewController .isKindOfClass(fullScreenImageViewController) {
            
            let index = tableView.indexPathForSelectedRow()
            
            let cell = sender as UITableViewCell
            let FSIVC = segue.destinationViewController as fullScreenImageViewController
            FSIVC.image = images[index!.row]
            
        }
        
    }


}
