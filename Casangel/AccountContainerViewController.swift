//
//  AccountContainerViewController.swift
//  CasAngel
//
//  Created by Admin on 05/06/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class AccountContainerViewController: UIViewController {
    
    public var pageType = 0
    
    override func viewDidLoad() {
        
        if pageType == 1 {
            //self.navigationItem.setRightBarButton(nil, animated: true)
            let backBtn = UIButton(type: .custom)
            backBtn.setImage(UIImage.init(named: "back"), for: .normal)
            backBtn.addTarget(self, action: #selector(self.goBack), for: .primaryActionTriggered)
            self.navigationItem.setLeftBarButton(UIBarButtonItem.init(customView: backBtn), animated: true)
        } else {
            
        }
        
        gotoViewController("SignupViewController")
    }
    
    @objc func goBack() {
        ShoppingCartViewController.alreadyRequestCheckup = false
        self.dismiss(animated: true, completion: nil)
    }
    
    func gotoViewController(_ withIdentifier: String) {
        DispatchQueue.main.async {           
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let signupView = storyboard.instantiateViewController(withIdentifier: withIdentifier)
            
            self.addChild(signupView)
            self.view.addSubview(signupView.view)
            
            signupView.didMove(toParent: self)
        }
    }
}
