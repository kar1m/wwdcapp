//
//  MainViewController.swift
//  KarimBenhmida
//
//  Created by Karim Benhmida on 19/04/2015.
//  Copyright (c) 2015 Karim Benhmida. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var containerView: UIView!
    var didLayoutSubviewsOnce = false
    var viewControllers : Array<UIViewController> = []
    let overlayView = UIView()
    let swipeGestureRecognizer = UIPanGestureRecognizer()
    var originalFrame = CGRectZero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenRect = UIScreen.mainScreen().bounds;
        let screenWidth = screenRect.size.width;
        let screenHeight = screenRect.size.height;
        
        overlayView.frame = CGRectMake(0, 60, screenWidth, screenHeight-60)
        overlayView.backgroundColor = UIColor(red: 86/255, green: 106/255, blue: 143/255, alpha: 1)
        
        view.addSubview(overlayView)
        
        initSwipeGestureRecognizer()
        
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
            //originalFrame = over
            var projectsVC = storyboard!.instantiateViewControllerWithIdentifier("projectsViewController") as! ProjectsViewController
            viewControllers.append(projectsVC)
            projectsVC.view.frame = containerView.bounds
            containerView.addSubview(projectsVC.view)
            
        }
        
        didLayoutSubviewsOnce = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animateWithDuration(0.4, animations: {
            self.overlayView.layer.opacity = 0.0;
        }, completion: { (value: Bool) in
            self.overlayView.removeFromSuperview()
        })
    }
    
    func initSwipeGestureRecognizer() {
        swipeGestureRecognizer.addTarget(self, action: "swipeGestureHandler:")
        swipeGestureRecognizer.delegate = self;
        
        containerView.addGestureRecognizer(swipeGestureRecognizer)
    }
    
    func swipeGestureHandler(sender:UIPanGestureRecognizer){
        
        var translation = sender.translationInView(self.view).x
        
        let viewToTranslate = viewControllers[0].view
        
        viewToTranslate.frame = CGRectOffset(containerView.bounds, translation, 0)
        
        if translation > 0
        {
            // Right swipe
            //println("Right swipe")
        }
        else
        {
            // Left swipe
        }
        
        
        
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
