//
//  ViewController.swift
//  KarimBenhmida
//
//  Created by Karim Benhmida on 19/04/2015.
//  Copyright (c) 2015 Karim Benhmida. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var appLogo: UIImageView!
    var mainViewController: MainViewController?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Preloading the main view controller
        mainViewController = storyboard!.instantiateViewControllerWithIdentifier("mainViewController") as! MainViewController!
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animateWithDuration(0.5, delay: 0.8, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            
            // Logo transition
            var logoFrame = self.appLogo.frame
            let factor = CGFloat(2)
            let wdiff: CGFloat = (logoFrame.size.width-(logoFrame.size.width/factor))/2
            
            logoFrame.size.height /= factor
            logoFrame.size.width /= factor
            logoFrame.origin.x += wdiff
            logoFrame.origin.y = 30
            
            self.appLogo.frame = logoFrame
            
        }) { (success) -> Void in
            self.presentViewController(self.mainViewController!, animated: false, completion: nil)
        }
    }
    
}

