//
//  Extensions.swift
//  CasAngel
//
//  Created by Admin on 02/06/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}

extension Double {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
    func toString() -> String {
        return String.init(format: "%f", self)
    }
}

extension String {
    func withCommas() -> String {
        if let myNumber = Double(self) {
            return myNumber.withCommas()
        }
        return ""
    }
}

extension CAShapeLayer {
    func drawCircleAtLocation(location: CGPoint, withRadius radius: CGFloat, andColor color: UIColor, filled: Bool) {
        fillColor = filled ? color.cgColor : UIColor.white.cgColor
        strokeColor = UIColor.clear.cgColor
        let origin = CGPoint(x: location.x - radius, y: location.y - radius)
        path = UIBezierPath(ovalIn: CGRect(origin: origin, size: CGSize(width: radius * 2, height: radius * 2))).cgPath
    }
}

class AdjustedNavigationBar: UINavigationBar {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let rightItems = topItem?.rightBarButtonItems, rightItems.count > 1 {
            for i in 0..<rightItems.count {
                let barButtonItem = rightItems[i]
                if let customView = barButtonItem.customView {
                    let frame = customView.frame
                    customView.frame = CGRect(x: UIApplication.shared.windows.last!.bounds.size.width-CGFloat(i+1)*44, y: frame.origin.y, width: frame.size.width, height: frame.size.height)
                }
                
            }
        }
    }
}

private var handle: UInt8 = 0
extension UIBarButtonItem {
    private var badgeLayer: CAShapeLayer? {
        if let b: AnyObject = objc_getAssociatedObject(self, &handle) as AnyObject? {
            return b as? CAShapeLayer
        } else {
            return nil
        }
    }
    
    func addBadge(number: Int, withOffset offset: CGPoint = CGPoint.zero, andColor color: UIColor = UIColor.red, andFilled filled: Bool = true) {
        guard let view = self.value(forKey: "view") as? UIView else { return }
        
        badgeLayer?.removeFromSuperlayer()
        
        // Initialize Badge
        let badge = CAShapeLayer()
        let radius = CGFloat(9)
        let location = CGPoint(x: view.frame.width - (radius + offset.x), y: (radius + offset.y))
        badge.drawCircleAtLocation(location: location, withRadius: radius, andColor: color, filled: filled)
        view.layer.addSublayer(badge)
        
        // Initialiaze Badge's label
        let label = CATextLayer()
        label.string = "\(number)"
        label.alignmentMode = CATextLayerAlignmentMode.center
        label.fontSize = 13
        label.frame = CGRect(origin: CGPoint(x: location.x - 12, y: offset.y), size: CGSize(width: 24, height: 24))
        label.foregroundColor = filled ? UIColor.white.cgColor : color.cgColor
        label.backgroundColor = UIColor.clear.cgColor
        label.contentsScale = UIScreen.main.scale
        badge.addSublayer(label)
        
        // Save Badge as UIBarButtonItem property
        objc_setAssociatedObject(self, &handle, badge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func updateBadge(number: Int) {
        if let text = badgeLayer?.sublayers?.filter({ $0 is CATextLayer }).first as? CATextLayer {
            text.string = "\(number)"
        }
    }
    
    func removeBadge() {
        badgeLayer?.removeFromSuperlayer()
    }
}

extension String{
    func checkIsDatePassed() -> Bool {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //replaceAll("[a-zA-Z]", " ")
        guard let regex = try? NSRegularExpression(pattern: "[a-zA-Z]", options: .caseInsensitive) else {
            return false
        }
        let dateGiven = regex.stringByReplacingMatches(in: self, options: [], range: NSRange(location: 0, length:  self.count), withTemplate: " ")
        let checkDate = dateFormatterGet.date(from: dateGiven)
        if checkDate == nil {
            return false
        }
        let compareResult = checkDate!.compare(Date())
        if compareResult == ComparisonResult.orderedDescending || compareResult == ComparisonResult.orderedSame {
            return false
        }
        return true
    }
    var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
        let emailTest  = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}


extension Date{
    func toString() -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatterGet.string(from: self)
    }
}

extension UIView {
    func getSelectedTextField() -> UITextField? {
        
        let totalTextFields = getTextFieldsInView(view: self)
        
        for textField in totalTextFields{
            if textField.isFirstResponder{
                return textField
            }
        }
        
        return nil
        
    }
    
    func getTextFieldsInView(view: UIView) -> [UITextField] {
        
        var totalTextFields = [UITextField]()
        
        for subview in view.subviews as [UIView] {
            if let textField = subview as? UITextField {
                totalTextFields += [textField]
            } else {
                totalTextFields += getTextFieldsInView(view: subview)
            }
        }
        
        return totalTextFields
    }}
