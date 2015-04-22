//
//  ProjectsViewController.swift
//  KarimBenhmida
//
//  Created by Karim Benhmida on 20/04/2015.
//  Copyright (c) 2015 Karim Benhmida. All rights reserved.
//

import UIKit

class ProjectsViewController: UITableViewController {
    
    var projectsData = [NSDictionary]()
    var projectsImages = [String:AnyObject]()
    var pictureOriginalHeight = CGFloat(0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 425.0;
        self.tableView.backgroundView = nil

        let path = NSBundle.mainBundle().pathForResource("data", ofType: "json")!
        let jsonData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil) as NSData!
        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
        projectsData = jsonResult["projects"] as! [NSDictionary]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return projectsData.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("projectCell", forIndexPath: indexPath) as! ProjectTableViewCell
        
        let projectName = projectsData[indexPath.row]["name"] as? String
        
        cell.projectTitle.text = projectName
        cell.projectDescription.text = projectsData[indexPath.row]["description"] as? String
        
        // Setting project image
        if projectsImages[projectName!] == nil {
            let projectImage = UIImage(named: "screen_"+projectName!.lowercaseString)
            if let image = projectImage {
                projectsImages[projectName!] = image
            }
            else {
                projectsImages[projectName!] = NSNumber(bool: false)
            }
        }
        
        cell.centeredButton.userInteractionEnabled = false
        cell.centeredButton.layer.opacity = 0
        
        // Setting project links
        let projectWebLink = projectsData[indexPath.row]["link-web"] as? String
        let projectAppStoreLink = projectsData[indexPath.row]["link-appstore"] as? String
        let projectLinkTag = projectsData[indexPath.row]["link-tag"] as? String
        
        cell.buttonsViewHeight.constant = 41
        cell.centeredButton.enabled = true
        cell.centeredButton.titleLabel!.font =  UIFont(name: "AvenirNext-Medium", size: 13)
        
        cell.webLink = projectWebLink
        cell.appStoreLink = projectAppStoreLink
        
        if projectWebLink != nil && projectLinkTag != nil && projectAppStoreLink != nil {
            cell.enableButton(cell.leftButton)
            cell.enableButton(cell.rightButton)
            cell.disableButton(cell.centeredButton)
            
            cell.leftButton.setTitle(projectLinkTag, forState: .Normal)
        }
        else if projectWebLink != nil && projectLinkTag != nil {
            cell.disableButton(cell.leftButton)
            cell.disableButton(cell.rightButton)
            cell.enableButton(cell.centeredButton)
            
            cell.centeredButton.setTitle(projectLinkTag, forState: .Normal)
        }
        else if projectLinkTag != nil {
            cell.disableButton(cell.leftButton)
            cell.disableButton(cell.rightButton)
            cell.enableButton(cell.centeredButton)
            
            cell.centeredButton.titleLabel!.font =  UIFont(name: "AvenirNext-Regular", size: 13)
            cell.centeredButton.setTitle(projectLinkTag, forState: .Normal)
            cell.centeredButton.enabled = false
        }
        else {
            cell.buttonsViewHeight.constant = 5
            cell.disableButton(cell.leftButton)
            cell.disableButton(cell.rightButton)
            cell.disableButton(cell.centeredButton)
        }
        
        cell.projectPicture.image = projectsImages[projectName!] as? UIImage
        
        return cell
    }

}
