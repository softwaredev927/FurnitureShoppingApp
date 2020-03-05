//
//  CustomNavViewController.swift
//  Casangel
//
//  Created by Admin on 24/08/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class CustomNavViewController: UINavigationController {
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = CGFloat(80)
        navigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: height)
    }
}

class CustomNavigationBar: UINavigationBar {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let newSize :CGSize = CGSize(width: self.frame.size.width,height: 120)
        return newSize
    }
}
