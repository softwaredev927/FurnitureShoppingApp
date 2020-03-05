//
//  ProfileViewController.swift
//  CasAngel
//
//  Created by Admin on 24/05/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet var avatorView: UIImageView? = nil
    @IBOutlet var fullnameView: UITextView? = nil
    @IBOutlet var usernameView: UITextView? = nil
    @IBOutlet var emailView: UITextView? = nil
    @IBOutlet var phoneView: UITextView? = nil
    @IBOutlet var addressView: UITextView? = nil
    @IBOutlet var cityView: UITextView? = nil
    
    override func viewDidLoad() {
        self.parent?.navigationItem.title = "Mi cuenta"
        let viewMyCreations = self.view.viewWithTag(21)
        viewMyCreations?.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.myCreationsClicked(_:))))
        let viewOrders = self.view.viewWithTag(22)
        viewOrders?.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.ordersClicked(_:))))
        
        let logoutBtn = UIButton(type: .custom)
        logoutBtn.setImage(UIImage.init(named: "baseline_exit")?.imageWithColor(color1: .white), for: .normal)
        logoutBtn.addTarget(self, action: #selector(self.logout), for: .primaryActionTriggered)
        let menuBtn = UIBarButtonItem.init(customView: logoutBtn)
        self.parent?.navigationItem.setRightBarButtonItems([menuBtn], animated: true)
        
        if GlobalData.getUserData() != nil && GlobalData.getUserData()?._user != nil {
            let user = GlobalData.getUserData()!._user!
            if user._avatar_url != nil {
                avatorView?.setImageFromUrl(urlStr: (user._picture?._data!._url)!)
            }
            fullnameView?.text = user._first_name! + " " + user._last_name!
            usernameView?.text = user._username
            emailView?.text = user._email
            if user._billing != nil {
                phoneView?.text = user._billing?._phone
                addressView?.text = user._billing?._address_1
                cityView?.text = user._billing?._city
            }
        }
    }
    
    @objc func myCreationsClicked(_ sender: UIGestureRecognizer) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let taController = appDelegate.window?.rootViewController as! CustomTabBarController
        taController.animateToTab(toIndex: CustomTabBarController.TabIndex.TabIndexMyCreations.rawValue)
    }
    
    @objc func ordersClicked(_ sender: UIGestureRecognizer) {
        self.performSegue(withIdentifier: "GotoOrders", sender: self)
    }
    
    @objc func logout() {
        GlobalData.saveUserData(userData: nil)
        self.gotoViewController("LoginViewController")
    }
    
    func gotoViewController(_ withIdentifier: String) {
        DispatchQueue.main.async {
            let parent = self.parent
            
            self.view.removeFromSuperview()
            self.removeFromParent()
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let signupView = storyboard.instantiateViewController(withIdentifier: withIdentifier)
            
            parent?.addChild(signupView)
            parent?.view.addSubview(signupView.view)
            
            signupView.didMove(toParent: parent)
        }
    }
}
