//
//  ExtImageView.swift
//  CasAngel
//
//  Created by Admin on 24/05/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

extension UIImage {
    func imageWithColor(color1: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color1.setFill()
        
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(origin: .zero, size: CGSize(width: self.size.width, height: self.size.height))
        context?.clip(to: rect, mask: self.cgImage!)
        context?.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func imageWithInsets(insets: UIEdgeInsets) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: self.size.width + insets.left + insets.right,
                   height: self.size.height + insets.top + insets.bottom), false, self.scale)
        let _ = UIGraphicsGetCurrentContext()
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithInsets
    }
    
    func rotate(radians: CGFloat) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: radians)).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

class BorderView: UIView {
    @IBInspectable var borderWidth: CGFloat = 1.0
    @IBInspectable var borderColor: UIColor = UIColor.white
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderWidth = borderWidth
        layer.masksToBounds = false
        layer.borderColor = borderColor.cgColor
        clipsToBounds = true
    }
}

class BorderImageView: UIImageView {
    @IBInspectable var borderWidth: CGFloat = 1.0
    @IBInspectable var borderColor: UIColor = UIColor.white
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderWidth = borderWidth
        layer.masksToBounds = false
        layer.borderColor = borderColor.cgColor
        clipsToBounds = true
    }
}

class RoundButton: UIButton {
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

extension UIImageView {
    func tintImageColor(color : UIColor) {
        self.image = self.image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        self.tintColor = color
    }
    
    func setImageFromUrlFit(urlStr: String) {
        if urlStr == "" {
            return
        }
        let url = URL(string: urlStr.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
        let placeholderImage = UIImage(named: "placeholder")!
        
        let filter = AspectScaledToFitSizeFilter(
            size: (self.frame.size)
        )
        
        self.af_setImage(
            withURL: url!,
            placeholderImage: placeholderImage,
            filter: filter,
            imageTransition: .crossDissolve(0.2), completion: { (_ response: DataResponse<UIImage>) in
                self.contentMode = .scaleAspectFit
        })
    }
    
    func setImageFromUrl(urlStr: String) {
        if urlStr == "" {
            return
        }
        let url = URL(string: urlStr.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
        let placeholderImage = UIImage(named: "placeholder")!
        
        let filter = AspectScaledToFillSizeFilter(
            size: (self.frame.size)
        )
        
        self.af_setImage(
            withURL: url!,
            placeholderImage: placeholderImage,
            filter: filter,
            imageTransition: .crossDissolve(0.2), completion: { (_ response: DataResponse<UIImage>) in
                self.contentMode = .scaleToFill
        })
    }
    
    func setImageFromUrl(urlStr: String, completionHandler: @escaping ()->Void) {
        if urlStr == "" {
            return
        }
        let url = URL(string: urlStr.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
        let placeholderImage = UIImage(named: "placeholder")!
        
        let filter = AspectScaledToFitSizeFilter(
            size: (self.frame.size)
        )
        
        self.af_setImage(
            withURL: url!,
            placeholderImage: placeholderImage,
            filter: filter,
            imageTransition: .crossDissolve(0.2), completion: { (_ response: DataResponse<UIImage>) in
                completionHandler()
        })
    }
}
extension UIView {
    func setSizeSmall() -> UIView {
        self.frame.size = CGSize.init(width: 25, height: 25)
        return self
    }
    func fadeIn() {
        self.isHidden = false
        // Move our fade out code from earlier
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.alpha = 1.0 // Instead of a specific instance of, say, birdTypeLabel, we simply set [thisInstance] (ie, self)'s alpha
        }, completion: nil)
    }

    func fadeOut() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: { (success: Bool) in
            self.isHidden = true
        })
    }
    
    func fadeAndRemove() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: { (success: Bool) in
            self.removeFromSuperview()
        })
    }
}

class ExtImageView: UIImageView {
    
    @IBInspectable var radius: CGFloat = 10
    @IBInspectable var borderWidth: CGFloat = 1.0
    @IBInspectable var borderColor: UIColor = UIColor.white
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderWidth = borderWidth
        layer.masksToBounds = false
        layer.borderColor = borderColor.cgColor
        if radius == -2 {
            layer.borderColor = UIColor.black.cgColor
            layer.borderWidth = 2.0
            let wh = min(self.frame.width/4, self.frame.height/4)
            self.layer.cornerRadius = wh*2
            let imageView = UIImageView(image: self.image)
            imageView.frame = CGRect.init(x: self.frame.origin.x, y: self.frame.origin.y + wh, width: self.frame.width - wh*2, height: self.frame.height - wh*2)
            imageView.contentMode = .scaleAspectFit
            self.image = nil
            self.addSubview(imageView)
        }else {
            if radius < 0{
                let wh = min(self.frame.width, self.frame.height)
                self.image = self.image?.imageWithColor(color1: self.tintColor).imageWithInsets(insets: UIEdgeInsets.init(top: 10, left: 10, bottom: 15, right: 10))
                self.frame = CGRect.init(x: self.frame.origin.x, y: self.frame.origin.y, width: wh, height: wh)
                self.layer.cornerRadius = wh/2
            }else {
                layer.cornerRadius = radius
            }
        }
        clipsToBounds = true
        isUserInteractionEnabled = true
    }
    
    var anim: CABasicAnimation? = nil
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        anim = CABasicAnimation.init(keyPath: "opacity")
        anim?.toValue = 1
        anim?.fromValue = 0.6
        anim?.duration = 0.5
        anim?.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.linear)
        anim?.isRemovedOnCompletion = true
        self.layer.add(anim!, forKey: "opacity")
        layer.opacity = 1
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
    }
    
    
}

extension UIView {
    
    func createImage() -> UIImage {
        
        let rect: CGRect = self.frame
        
        UIGraphicsBeginImageContext(rect.size)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        self.layer.render(in: context)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img!
    }
    
    func dropShadow() {
        self.layer.masksToBounds = true
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shadowRadius = 15
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 1
    }
}

class ScaledHeightImageView: UIImageView {
    
    override var intrinsicContentSize: CGSize {
        
        if let myImage = self.image {
            let myImageWidth = myImage.size.width
            let myImageHeight = myImage.size.height
            let myViewWidth = self.frame.size.width
            
            let ratio = myViewWidth/myImageWidth
            let scaledHeight = myImageHeight * ratio
            
            return CGSize(width: myViewWidth, height: scaledHeight)
        }
        
        return CGSize(width: -1.0, height: -1.0)
    }
    
}
