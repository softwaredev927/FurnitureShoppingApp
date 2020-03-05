//
//  CustomTabBarController.swift
//  CasAngel
//
//  Created by Admin on 22/05/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    public static var stopTab = false
    
    public enum TabIndex: Int {
        case TabIndexHome = 0
        case TabIndexStore
        case TabIndexMyCreations
        case TabIndexIdeas
        case TabIndexAccount
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initTabControllers()
        //setUpTabSplitter(tabBar: self.tabBar)
        //animateToTab(toIndex: TabIndex.TabIndexHome.rawValue)
    }
    
    func initTabControllers() {
        setUpViewController(viewController: (self.viewControllers?[0])!, title: "INICIO")
        setUpViewController(viewController: (self.viewControllers?[1])!, title: "TIENDA")
        setUpViewController(viewController: (self.viewControllers?[2])!, title: "MIS CREACIONES")
        setUpViewController(viewController: (self.viewControllers?[3])!, title: "IDEAS")
        setUpViewController(viewController: (self.viewControllers?[4])!, title: "MI CUENTA")
        
        self.tabBar.barTintColor = UIColor.init(rgb: 0x00444242)
        self.tabBar.tintColor = UIColor.init(rgb: 0xdaa949)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Century Gothic", size: 10)!], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Century Gothic", size: 10)!], for: .selected)
        self.tabBar.unselectedItemTintColor = UIColor.init(rgb: 0xffffff)
        //setUpTabSplitter(tabBar: tabBar)
        self.delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if CustomTabBarController.stopTab {
            return false
        }
        let fromView: UIView = tabBarController.selectedViewController!.view
        let toView  : UIView = viewController.view!
        if fromView == toView {
            return false
        }
        let toIndex = (self.viewControllers?.firstIndex(of: viewController))!
        animateToTab(toIndex: toIndex)
        return true
    }
    
    func animateToTab(toIndex: Int) {
        let tabViewControllers = viewControllers!
        let fromView = selectedViewController!.view!
        let toView = tabViewControllers[toIndex].view!
        let fromIndex = selectedIndex
        
        guard fromIndex != toIndex else {return}
        
        // Add the toView to the tab bar view
        fromView.superview!.addSubview(toView)
        
        // Position toView off screen (to the left/right of fromView)
        let screenWidth = UIScreen.main.bounds.size.width;
        let scrollRight = toIndex > fromIndex;
        let offset = (scrollRight ? screenWidth : -screenWidth)
        toView.center = CGPoint(x: fromView.center.x + offset, y: toView.center.y)
        
        // Disable interaction during animation
        view.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            
            // Slide the views by -offset
            fromView.center = CGPoint(x: fromView.center.x - offset, y: fromView.center.y);
            toView.center   = CGPoint(x: toView.center.x - offset, y: toView.center.y);
            
        }, completion: { finished in
            
            // Remove the old view from the tabbar view.
            fromView.removeFromSuperview()
            self.view.isUserInteractionEnabled = true
        })
        self.selectedIndex = toIndex
    }
    
    func setUpViewController(viewController: UIViewController, title: String) {
        let image = title.lowercased()
        let vc = viewController
        vc.accessibilityViewIsModal = false
        vc.tabBarItem.title = title
        //vc.tabBarItem.selectedImage = UIImage(named: image + "_s")
        //vc.tabBarItem.image = UIImage(named: image + "_u")?.imageWithInsets(insets: UIEdgeInsets.init(top: 4, left: 4, bottom: 4, right: 4))
        vc.tabBarItem.titlePositionAdjustment = UIOffset.init(horizontal: 0, vertical: -5)
    }
    
    func setUpTabSplitter(tabBar: UITabBar) {
        if let items = tabBar.items {
            let numItems = CGFloat(items.count)
            let itemSize = CGSize(width: tabBar.frame.width / numItems, height: tabBar.frame.height)
            for (index, _) in items.enumerated() {
                if index > 0 {
                    let xPosition = itemSize.width * CGFloat(index)
                    let separator = UIView(frame: CGRect(x: xPosition, y: 10, width: 1, height: 40))
                    separator.backgroundColor = UIColor.init(rgb: 0x858585)
                    tabBar.insertSubview(separator, at: 1)
                }
            }
        }
    }
}
