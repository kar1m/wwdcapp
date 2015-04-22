//
//  SkillsViewController.swift
//  KarimBenhmida
//
//  Created by Karim Benhmida on 22/04/2015.
//  Copyright (c) 2015 Karim Benhmida. All rights reserved.
//

import UIKit

class SkillsViewController: UITableViewController {

    var skillsData = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 125.0;
        self.tableView.backgroundView = nil

        let path = NSBundle.mainBundle().pathForResource("data", ofType: "json")!
        let jsonData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil) as NSData!
        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
        skillsData = jsonResult["skills"] as! [NSDictionary]
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
        return skillsData.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("skillCell", forIndexPath: indexPath) as! SkillTableViewCell

        cell.skillName.text = skillsData[indexPath.row]["name"] as? String
        
        let subSkills = skillsData[indexPath.row]["subskills"] as! [String]

        cell.skillsDetailsLabel.text = ""
        for (index,skill) in enumerate(subSkills) {
            cell.skillsDetailsLabel.text! += skill
            if index < subSkills.count-1 {
                cell.skillsDetailsLabel.text! += "\n"
            }
        }
        
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        
        var attrString = NSMutableAttributedString(string: cell.skillsDetailsLabel.text!)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        
        cell.skillsDetailsLabel.attributedText = attrString

        return cell
    }

}
