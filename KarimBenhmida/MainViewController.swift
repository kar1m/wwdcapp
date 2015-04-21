//
//  MainViewController.swift
//  KarimBenhmida
//
//  Created by Karim Benhmida on 19/04/2015.
//  Copyright (c) 2015 Karim Benhmida. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIScrollViewDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    // ------------------------------ UI ------------------------------
    @IBOutlet weak var containerView: UIView!
    var didLayoutSubviewsOnce = false
    let overlayView = UIView()
    var tabBarRect : UIView!
    
    // ------------------------- Controllers --------------------------
    var viewControllers = [UIViewController?](count: 4, repeatedValue: nil)
    var pageViewController : UIPageViewController!
    
    // ------------------------ Scroll manager ------------------------
    struct ScrollManager {
        var scrollSum = CGFloat(0) // Total scrolled
        
        var previousXOffset = CGFloat(0)
        var offsetCorrection = CGFloat(0)
        
        var increment = 0 // for debugging purposes
    }
    var scrollManager = ScrollManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Overlay view for fadeIn animation
        overlayView.frame = CGRectMake(0, 60, Globals.screenWidth, Globals.screenHeight-60)
        overlayView.backgroundColor = UIColor(red: 86/255, green: 106/255, blue: 143/255, alpha: 1)
        view.addSubview(overlayView)
        
        initPageViewController()
        
        // Tabbar rect
        tabBarRect = UIView(frame: CGRectMake(0, Globals.screenHeight-3.5, Globals.screenWidth/4, 3.5))
        tabBarRect.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(tabBarRect)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Adding top and bottom gradient to containerView
        let gradient = CAGradientLayer()
        let gradientHeight : CGFloat = 20.0
        gradient.frame = containerView.bounds;
        gradient.colors = [UIColor.clearColor().CGColor, UIColor.blackColor().CGColor, UIColor.blackColor().CGColor, UIColor.clearColor().CGColor];
        gradient.locations = [0.0, gradientHeight/containerView.bounds.size.height, CGFloat(1.0)-gradientHeight/containerView.bounds.size.height, 1.0];
        
        self.containerView.layer.mask = gradient;
        
        
        if !didLayoutSubviewsOnce {
            var projectsVC = viewControllerAtIndex(0)!
            
            pageViewController.view.frame = containerView.bounds
            pageViewController.setViewControllers([projectsVC], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
            
            self.addChildViewController(pageViewController)
            containerView.addSubview(pageViewController.view)
            self.pageViewController.didMoveToParentViewController(self)
            
            didLayoutSubviewsOnce = true
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animateWithDuration(0.4, animations: {
            self.overlayView.layer.opacity = 0.0;
            }, completion: { (value: Bool) in
                self.overlayView.removeFromSuperview()
        })
    }
    
    // MARK: UIScrollView Delegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let xOffset = scrollView.contentOffset.x - Globals.screenWidth
        
        let offsetDifference = fabs(scrollManager.previousXOffset-xOffset)
        if offsetDifference > Globals.screenWidth/2 {
            scrollManager.offsetCorrection += scrollManager.previousXOffset-(scrollManager.previousXOffset%(Globals.screenWidth/4))
        }
        
        scrollManager.scrollSum = xOffset+scrollManager.offsetCorrection
        println("\(++scrollManager.increment) \(scrollManager.scrollSum)")
        
        // Updating the frame
        var translatedFrame = tabBarRect.frame
        translatedFrame.origin.x = scrollManager.scrollSum/4
        tabBarRect.frame = translatedFrame
        
        scrollManager.previousXOffset = xOffset
    }
    
    // MARK: UIPageViewController Init + Data Source
    
    func initPageViewController() {
        pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        for v in pageViewController.view.subviews{
            if v.isKindOfClass(UIScrollView){
                (v as! UIScrollView).delegate = self
            }
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var index = viewControllers.find {$0 == viewController}!
        index++
        if(index >= viewControllers.count){
            return nil
        }
        return self.viewControllerAtIndex(index)
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        var index = viewControllers.find {$0 == viewController}!
        if(index <= 0){
            return nil
        }
        index--
        return self.viewControllerAtIndex(index)
        
    }
    
    func viewControllerAtIndex(index : Int) -> UIViewController? {
        if index >= viewControllers.count {
            return nil
        }
        
        var viewControllerAtCurrentIndex : UIViewController!
        
        if viewControllers[index] == nil {
            viewControllerAtCurrentIndex = self.storyboard?.instantiateViewControllerWithIdentifier("KBViewController"+String(0)) as! UIViewController
            
            viewControllers[index] = viewControllerAtCurrentIndex
        }
        else {
            viewControllerAtCurrentIndex = viewControllers[index]
        }

        return viewControllerAtCurrentIndex
    }
    
    // MARK: UIPageViewController Delegate
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [AnyObject]) {
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
        
    }

}
