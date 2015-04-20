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
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        var test = NSEC_PER_SEC
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            
            var scaleAnimation = POPBasicAnimation(propertyNamed: kPOPViewScaleXY);
            scaleAnimation.toValue = NSValue(CGPoint: CGPoint(x: 0.5, y: 0.5))
            scaleAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            scaleAnimation.duration = 0.5
            self.appLogo.pop_addAnimation(scaleAnimation, forKey: "scaleAnimation")
            
            var frameAnimation = POPBasicAnimation(propertyNamed: kPOPLayerPosition)
            frameAnimation.toValue = NSValue(CGPoint: CGPoint(x: self.appLogo.center.x, y: 43))
            frameAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            frameAnimation.duration = 0.5
            self.appLogo.layer.pop_addAnimation(frameAnimation, forKey: "frameAnimation")
            
            frameAnimation.completionBlock = { (POPAnimation, Bool) -> Void in
                self.performSegueWithIdentifier("goToApp", sender: self)
            }
        }
        
    }
    
}

