//
//  ProjectTableViewCell.swift
//  KarimBenhmida
//
//  Created by Karim Benhmida on 22/04/2015.
//  Copyright (c) 2015 Karim Benhmida. All rights reserved.
//

import UIKit
import StoreKit

class ProjectTableViewCell: UITableViewCell, SKStoreProductViewControllerDelegate {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var projectTitle: UILabel!
    @IBOutlet weak var projectPicture: UIImageView!
    @IBOutlet weak var projectDescription: UILabel!

    @IBOutlet weak var centeredButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    @IBOutlet weak var buttonsViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var pictureRightSpace: NSLayoutConstraint!
    @IBOutlet weak var pictureTopConstraint: NSLayoutConstraint!
    
    
    var appStoreLink : String?
    var webLink : String?
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        projectPicture.layer.borderColor = UIColor(rgba: "#A6A6A6").CGColor;
        projectPicture.layer.borderWidth = 0.5
        projectPicture.layer.masksToBounds = true
    }

    @IBAction func openWebLink() {
        if let existingWebLink = webLink {
            UIApplication.sharedApplication().openURL(NSURL(string: existingWebLink)!)
        }
    }
    
    @IBAction func openAppStoreLink() {
        if let existingAppStoreLink = appStoreLink {
            // Initialize Product View Controller
            let storeProductViewController = SKStoreProductViewController()
            
            // Configure View Controller
            storeProductViewController.delegate = self
            storeProductViewController.loadProductWithParameters([SKStoreProductParameterITunesItemIdentifier:existingAppStoreLink], completionBlock: { (result, error) -> Void in
                if error == nil {
                    self.appDelegate.mainViewController!.presentViewController(storeProductViewController, animated: true, completion: nil)
                }
                else {
                    UIApplication.sharedApplication().openURL(NSURL(string: "https://itunes.apple.com/us/app/showlist/id"+existingAppStoreLink)!)
                }
            })
        }
    }
    
    func productViewControllerDidFinish(viewController: SKStoreProductViewController!) {
        appDelegate.mainViewController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func enableButton(button: UIButton) {
        button.userInteractionEnabled = true
        button.layer.opacity = 1
    }
    
    func disableButton(button: UIButton) {
        button.userInteractionEnabled = false
        button.layer.opacity = 0
    }

}
