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

        let path = NSBundle.mainBundle().pathForResource("data", ofType: "json")!
        let jsonData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil) as NSData!
        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
        projectsData = jsonResult["projects"] as! [(NSDictionary)]
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
        
        if projectsImages[projectName!] == nil {
            let projectImage = UIImage(named: "screen_"+projectName!.lowercaseString)
            if let image = projectImage {
                projectsImages[projectName!] = image
            }
            else {
                projectsImages[projectName!] = NSNumber(bool: false)
            }
        }
        
        cell.projectPicture.image = projectsImages[projectName!] as? UIImage
        
//        if projectsImages[projectName!]!.isKindOfClass(UIImage) {
//            cell.projectPicture.image = projectsImages[projectName!] as? UIImage
//            cell.pictureTopConstraint.constant = 16
//            //cell.pictureRightSpace.constant = 12
//            cell.projectPicture.setTranslatesAutoresizingMaskIntoConstraints(false)
//            
//        }
//        else {
//            cell.pictureTopConstraint.constant = 0
//            //cell.pictureRightSpace.constant = cell.containerView.frame.width-12
//            cell.projectPicture.setTranslatesAutoresizingMaskIntoConstraints(true)
//            var newFrame = cell.projectPicture.frame
//            newFrame.size.height = 10
//            cell.projectPicture.frame = newFrame;
//            
//        }
        

        return cell
    }

}
