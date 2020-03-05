//
//  ExtEditField.swift
//  CasAngel
//
//  Created by Admin on 23/05/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit


class RoundLabel: UILabel {
    @IBInspectable var borderWidth: CGFloat = 1.0
    @IBInspectable var borderColor: UIColor = UIColor.white
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
}

class RoundTextView: UITextView {
    @IBInspectable var radius: CGFloat = 0
    @IBInspectable var borderWidth: CGFloat = 1.0
    @IBInspectable var borderColor: UIColor = UIColor.white
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderWidth = borderWidth
        layer.masksToBounds = false
        layer.cornerRadius = radius
        layer.borderColor = borderColor.cgColor
        clipsToBounds = true
    }
}

class ExtEditField: UITextField {
    
    let padding = UIEdgeInsets(top: 4, left: 5, bottom: 4, right: 5)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return super.textRect(forBounds: bounds).inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return super.editingRect(forBounds: bounds).inset(by: padding)
    }
    
    override open func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return super.leftViewRect(forBounds: bounds).inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10))
    }
}
