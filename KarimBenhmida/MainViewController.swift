//
//  MainViewController.swift
//  KarimBenhmida
//
//  Created by Karim Benhmida on 19/04/2015.
//  Copyright (c) 2015 Karim Benhmida. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    var didLayoutSubviewsOnce = false
    var viewControllers : Array<UIViewController> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let gradient = CAGradientLayer()
        let gradientHeight : CGFloat = 20.0
        gradient.frame = containerView.bounds;
        gradient.colors = [UIColor.clearColor().CGColor, UIColor.blackColor().CGColor, UIColor.blackColor().CGColor, UIColor.clearColor().CGColor];
        gradient.locations = [0.0, gradientHeight/containerView.bounds.size.height, CGFloat(1.0)-gradientHeight/containerView.bounds.size.height, 1.0];
        
        
        self.containerView.layer.mask = gradient;
        
        if !didLayoutSubviewsOnce {
            
            var projectsVC = storyboard!.instantiateViewControllerWithIdentifier("projectsViewController") as! ProjectsViewController
            viewControllers.append(projectsVC)
            projectsVC.view.frame = containerView.bounds
            containerView.addSubview(projectsVC.view)
            
//            var tableView = UITableView(frame: containerView.bounds)
//            containerView.addSubview(tableView)
        }
        
        didLayoutSubviewsOnce = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
