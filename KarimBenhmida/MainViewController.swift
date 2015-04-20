//
//  MainViewController.swift
//  KarimBenhmida
//
//  Created by Karim Benhmida on 19/04/2015.
//  Copyright (c) 2015 Karim Benhmida. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIScrollViewDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    let screenHeight = UIScreen.mainScreen().bounds.size.height

    @IBOutlet weak var containerView: UIView!
    var didLayoutSubviewsOnce = false
    var viewControllers : Array<UIViewController> = []
    let overlayView = UIView()
    let swipeGestureRecognizer = UIPanGestureRecognizer()
    var originalFrame = CGRectZero
    
    var scrollViewIsDragging = false
    
    var tabBarRect : UIView!
    var tabBarRectOriginalFrame : CGRect!
    
    var pageViewController : UIPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overlayView.frame = CGRectMake(0, 60, screenWidth, screenHeight-60)
        overlayView.backgroundColor = UIColor(red: 86/255, green: 106/255, blue: 143/255, alpha: 1)
        
        view.addSubview(overlayView)
        
        pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        for v in pageViewController.view.subviews{
            if v.isKindOfClass(UIScrollView){
                (v as! UIScrollView).delegate = self
            }
        }
        
        // Tabbar rect
        tabBarRect = UIView(frame: CGRectMake(0, screenHeight-3.5, screenWidth/4, 3.5))
        tabBarRect.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(tabBarRect)
        
    }
    
    var shouldUpdateTabBarRectPosition = false
    var scrollSum = CGFloat(0)
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        scrollViewIsDragging = true
        if smallestDistance(tabBarRect.frame.origin.x) == CGFloat(0.0) {
            tabBarRectOriginalFrame = tabBarRect.frame
            shouldUpdateTabBarRectPosition = false
        }
        else {
            shouldUpdateTabBarRectPosition = true
            scrollSum = tabBarRect.frame.origin.x
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        println(scrollView.contentOffset.x)
        
        let xOffset = scrollView.contentOffset.x - screenWidth
        
        if shouldUpdateTabBarRectPosition {
            tabBarRect.frame = CGRectMake(scrollSum+xOffset/4, tabBarRect.frame.origin.y, tabBarRect.frame.size.width, tabBarRect.frame.size.height)
//            if xOffset >= CGFloat(0.0) {
//                tabBarRectOriginalFrame = CGRectOffset(tabBarRectOriginalFrame, -screenWidth/40, 0)
//            }
//            else {
//                tabBarRectOriginalFrame = CGRectOffset(tabBarRectOriginalFrame, screenWidth/40, 0)
//            }
        }
        else {
            if xOffset == 0 && !scrollViewIsDragging {
                var distance = smallestDistance(tabBarRect.frame.origin.x)
                tabBarRect.frame = CGRectOffset(tabBarRect.frame, distance, 0)
            }
            else {
                tabBarRect.frame = CGRectOffset(tabBarRectOriginalFrame, xOffset/4, 0)
                
            }
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollViewIsDragging = false
    }
    
    func smallestDistance(point : CGFloat) -> CGFloat {
        
        // Calculating closest distance
        var smallest = screenWidth
        var distance = screenWidth
        for i in 0..<4 {
            let difference = fabs((screenWidth/4)*CGFloat(i)-point)
            if difference <= smallest {
                smallest = difference
                distance = (screenWidth/4)*CGFloat(i)-point
            }
        }
        
        return distance
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! ProjectsViewController).pageIndex!
        index++
        if(index >= 4){
            return nil
        }
        return self.viewControllerAtIndex(index)
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! ProjectsViewController).pageIndex!
        if(index <= 0){
            return nil
        }
        index--
        return self.viewControllerAtIndex(index)
        
    }
    
    func viewControllerAtIndex(index : Int) -> UIViewController? {
//        if index >= self.viewControllers.count {
//            return nil
//        }
        
        if index >= 4 {
            return nil
        }
        let pageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("projectsViewController") as! ProjectsViewController
        pageContentViewController.pageIndex = index

        return pageContentViewController
    }
    

    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [AnyObject]) {
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
        
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
            projectsVC.pageIndex = 0
//            projectsVC.view.frame = containerView.bounds
//            containerView.addSubview(projectsVC.view)
            
            pageViewController.view.frame = containerView.bounds
            pageViewController.setViewControllers([projectsVC], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
            
            self.addChildViewController(pageViewController)
            containerView.addSubview(pageViewController.view)
            self.pageViewController.didMoveToParentViewController(self)
            
            
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
//        swipeGestureRecognizer.addTarget(self, action: "swipeGestureHandler:")
//        swipeGestureRecognizer.delegate = self;
//        
//        containerView.addGestureRecognizer(swipeGestureRecognizer)
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
