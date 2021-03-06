//
//  MainViewController.swift
//  KarimBenhmida
//
//  Created by Karim Benhmida on 19/04/2015.
//  Copyright (c) 2015 Karim Benhmida. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIScrollViewDelegate {
    
    // ------------------------------ UI ------------------------------
    @IBOutlet weak var containerView: UIView!
    let overlayView = UIView()
    
    @IBOutlet weak var tabBarRect: UIView!
    @IBOutlet weak var tabBarRectLeftConstraint: NSLayoutConstraint!
    var tabBarIcons = [UIImageView]()
    var tabBarLabels = [UILabel]()
    
    let tabBarMenuColor = UIColor(red: 167/255, green: 181/255, blue: 207/255, alpha: 1.0)
    
    var scrollView = UIScrollView()
    
    // ------------------------- Controllers --------------------------
    var viewControllers = [UIViewController?](count: 4, repeatedValue: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.mainViewController = self
        
        // Overlay view for fadeIn animation
        overlayView.frame = CGRectMake(0, 60, self.view.frame.width, Globals.screenHeight-60)
        overlayView.backgroundColor = UIColor(red: 86/255, green: 106/255, blue: 143/255, alpha: 1)
        view.addSubview(overlayView)
        
        configureTabBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Adding top and bottom gradient to containerView
        let gradient = CAGradientLayer()
        let gradientHeight : CGFloat = 2.5
        gradient.frame = containerView.bounds;
        gradient.colors = [UIColor.clearColor().CGColor, UIColor.blackColor().CGColor, UIColor.blackColor().CGColor, UIColor.clearColor().CGColor];
        gradient.locations = [0.0, gradientHeight/containerView.bounds.size.height, CGFloat(1.0)-gradientHeight/containerView.bounds.size.height, 1.0];
        self.containerView.layer.mask = gradient;
        
        initScrollView()
        
        tabBarRectLeftConstraint.constant = scrollView.contentOffset.x/4
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animateWithDuration(0.4, animations: {
            self.overlayView.layer.opacity = 0.0;
            }, completion: { (value: Bool) in
                self.overlayView.removeFromSuperview()
        })
    }
    
    // MARK: TabBar Config
    
    @IBOutlet weak var tabBarIcon1: UIImageView!
    @IBOutlet weak var tabBarIcon2: UIImageView!
    @IBOutlet weak var tabBarIcon3: UIImageView!
    @IBOutlet weak var tabBarIcon4: UIImageView!
    
    @IBOutlet weak var tabBarTitle1: UILabel!
    @IBOutlet weak var tabBarTitle2: UILabel!
    @IBOutlet weak var tabBarTitle3: UILabel!
    @IBOutlet weak var tabBarTitle4: UILabel!
    
    func configureTabBar() {
        
        tabBarIcons = [tabBarIcon1, tabBarIcon2, tabBarIcon3, tabBarIcon4]
        tabBarLabels = [tabBarTitle1, tabBarTitle2, tabBarTitle3, tabBarTitle4]
        
        for (index,imageView) in enumerate(tabBarIcons) {
            imageView.image = imageView.image?.imageWithRenderingMode(.AlwaysTemplate)
            
            if index == 0 {
                imageView.tintColor = UIColor.whiteColor()
                tabBarLabels[index].textColor = UIColor.whiteColor()
            }
            else {
                imageView.tintColor = tabBarMenuColor
                tabBarLabels[index].textColor = tabBarMenuColor
            }
        }
        
    }
    
    @IBAction func didTapTabBarButton(sender: UIButton) {
        scrollView.setContentOffset(CGPointMake(CGFloat(sender.tag)*self.scrollView.frame.size.width, 0), animated: true)
        updateScrollToTop(sender.tag)
    }
    
    // MARK: Scroll View
    
    func initScrollView() {
        
        var frame: CGRect = CGRectMake(0, 0, 0, 0)
        
        self.scrollView.pagingEnabled = true
        scrollView.frame = containerView.bounds
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        
        for index in 0..<viewControllers.count {
            
            frame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
            frame.size = self.scrollView.frame.size
            
            var subView = viewControllerAtIndex(index)!.view as UIView
            
            if subView.isKindOfClass(UITableView) {
                var currentTableView = subView as! UITableView
                if index == 0 {
                    currentTableView.scrollsToTop = true
                }
                else {
                    currentTableView.scrollsToTop = false
                }
            }
            
            subView.frame = frame
            self.scrollView.addSubview(subView)
        }
        
        self.scrollView.contentSize = CGSizeMake(scrollView.frame.size.width*CGFloat(viewControllers.count), scrollView.frame.size.height)
        
        self.containerView.addSubview(scrollView)
    }
    
    func updateScrollToTop(tag: Int) {
        for index in 0..<viewControllers.count {
            
            let currentView = viewControllers[index]!.view
            
            if currentView.isKindOfClass(UITableView) {
                var currentTableView = currentView as! UITableView
                
                if index == tag {
                    currentTableView.scrollsToTop = true
                }
                else {
                    currentTableView.scrollsToTop = false
                }
            }
        }
    }
    
    func viewControllerAtIndex(index : Int) -> UIViewController? {
        if index >= viewControllers.count {
            return nil
        }
        
        var viewControllerAtCurrentIndex : UIViewController!
        
        if viewControllers[index] == nil {
            viewControllerAtCurrentIndex = self.storyboard?.instantiateViewControllerWithIdentifier("KBViewController"+String(index)) as! UIViewController
            
            viewControllers[index] = viewControllerAtCurrentIndex
        }
        else {
            viewControllerAtCurrentIndex = viewControllers[index]
        }
        
        return viewControllerAtCurrentIndex
    }
    
    // MARK: UIScrollView Delegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {

        // Updating the frame
        var translatedFrame = tabBarRect.frame
        translatedFrame.origin.x = scrollView.contentOffset.x/4
        tabBarRect.frame = translatedFrame
        
        // Updating the scrollToTop property
        if scrollView.contentOffset.x%self.view.frame.width == 0 {
            let tag = Int(scrollView.contentOffset.x/self.view.frame.width)
            updateScrollToTop(tag)
        }

        for (index,imageView) in enumerate(tabBarIcons) {
            let distance = fabs(imageView.center.x+CGFloat(index)*self.view.frame.width/4 - tabBarRect.center.x)
            if distance > self.view.frame.width/4 {
                imageView.tintColor = tabBarMenuColor
                tabBarLabels[index].textColor = tabBarMenuColor
            }
            else {
                imageView.tintColor = Globals.colorBetween(UIColor.whiteColor(), andColor: tabBarMenuColor, atPercent: distance/(self.view.frame.width/4))
                tabBarLabels[index].textColor = Globals.colorBetween(UIColor.whiteColor(), andColor: tabBarMenuColor, atPercent: distance/(self.view.frame.width/4))
            }
        }
        
    }

}
