//
//  DraggableImageView.swift
//  CasAngel
//
//  Created by Admin on 26/05/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import UIKit

class DraggableImageView: UIImageView {
    
    @IBOutlet var container: UIView? = nil
    var createSpaceViewController: CreateSpaceViewController?
    var panGesture = UIPanGestureRecognizer()
    let topLeft = UIView()
    let topRight = UIView()
    let topMiddle = UIView()
    let rightMiddle = UIView()
    let bottomMiddle = UIView()
    let bottomRight = UIView()
    
    let cancel = UIImageView()
    let okay = UIImageView()
    let border = UIView()
    var okayGetsture = UIGestureRecognizer()
    var cancelGesture = UIGestureRecognizer()
    var flipGesture = UIGestureRecognizer()
    
    var flip = UIImageView()
    var ahead = UIImageView()
    var behind = UIImageView()
    var isFlipped = false
    var zOrder = 0
    
    var productIndex = -1
    
    func initWithIcon(_ view: UIView, with image: String) {
        view.backgroundColor = UIColor.clear
        view.layer.borderWidth = 0
        view.layer.borderColor = UIColor.clear.cgColor
        view.frame.size = CGSize.init(width: 20, height: 20)
        view.layer.cornerRadius = 0
        let iv = view as! UIImageView
        iv.image = UIImage.init(named: image)
        view.isUserInteractionEnabled = true
        view.isHidden = self.isHidden
        container?.addSubview(view)
    }
    
    func initSubView(_ view: UIView) {
        view.backgroundColor = UIColor.black
        view.layer.borderWidth = 10
        view.layer.borderColor = UIColor.clear.cgColor
        view.isUserInteractionEnabled = false
        view.isHidden = self.isHidden
        container?.addSubview(view)
    }
    
    func initCorners() {
        let sz = CGSize.init(width: 10, height: 10)
        let sz1 = CGSize.init(width: 20, height: 20)
        let sz2 = CGSize.init(width: 30, height: 52)
        let sz3 = CGSize.init(width: 54, height: 23)
        let x0: CGFloat = self.frame.origin.x
        let y0: CGFloat = self.frame.origin.y
        let x1 = x0 + self.frame.width
        let y1 = y0 + self.frame.height
        border.frame = CGRect.init(x: x0, y: y0, width: x1-x0, height: y1-y0)
        topLeft.frame = CGRect.init(origin: CGPoint.init(x: x0, y: y0), size: sz).offsetBy(dx: -sz.width/2, dy: -sz.height/2)
        topRight.frame = CGRect.init(origin: CGPoint.init(x: x1, y: y0), size: sz).offsetBy(dx: -sz.width/2, dy: -sz.height/2)
        topMiddle.frame = CGRect.init(origin: CGPoint.init(x: (x0+x1)/2, y: y0), size: sz).offsetBy(dx: -sz.width/2, dy: -sz.height/2)
        rightMiddle.frame = CGRect.init(origin: CGPoint.init(x: x1, y: (y0+y1)/2), size: sz).offsetBy(dx: -sz.width/2, dy: -sz.height/2)
        bottomMiddle.frame = CGRect.init(origin: CGPoint.init(x: (x0+x1)/2, y: y1), size: sz).offsetBy(dx: -sz.width/2, dy: -sz.height/2)
        bottomRight.frame = CGRect.init(origin: .init(x: x1, y: y1), size: sz).offsetBy(dx: -sz.width/2, dy: -sz.height/2)
        
        cancel.frame = CGRect.init(origin: CGPoint.init(x: x0, y: y1), size: sz1).offsetBy(dx: -sz1.width/2, dy: -sz1.height/2)
        okay.frame = CGRect.init(origin: CGPoint.init(x: x1, y: y1), size: sz1).offsetBy(dx: -sz1.width/2, dy: -sz1.height/2)
        okay.removeGestureRecognizer(okayGetsture)
        cancel.removeGestureRecognizer(cancelGesture)
        
        flip.frame = CGRect.init(origin: CGPoint.init(x: (x0+x1)/2, y: y0), size: sz2).offsetBy(dx: -sz2.width/2, dy: -sz2.height)
        
        ahead.frame = CGRect.init(origin: CGPoint.init(x: x0-2, y: y0-15), size: sz3).offsetBy(dx: 0, dy: -sz3.height)
        behind.frame = CGRect.init(origin: CGPoint.init(x: x1-sz3.width-2, y: y0-15), size: sz3).offsetBy(dx: 0, dy: -sz3.height)
        
        //okayGetsture = UITapGestureRecognizer.init(target: self, action: #selector(self.okayClicked(_:)))
        //okay.addGestureRecognizer(okayGetsture)
        cancelGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.cancelClicked(_:)))
        cancel.addGestureRecognizer(cancelGesture)
        
        flipGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.flipClicked(_:)))
        flip.addGestureRecognizer(flipGesture)
        
        ahead.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.aheadClicked(_:))))
        behind.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.behindClicked(_:))))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.borderWidth = 0
        layer.masksToBounds = false
        clipsToBounds = true
        isUserInteractionEnabled = true
        
        initSubView(border)
        border.backgroundColor = UIColor.clear
        border.layer.borderWidth = 2
        border.layer.borderColor = UIColor.black.cgColor
        initSubView(topLeft)
        initSubView(topRight)
        initSubView(topMiddle)
        initSubView(rightMiddle)
        initSubView(bottomMiddle)
        initSubView(bottomRight)
        
        initWithIcon(cancel, with: "cancel")
        //initWithIcon(okay, with: "okay")
        initWithIcon(flip, with: "flip")
        initWithIcon(ahead, with: "ic_triangle_up")
        initWithIcon(behind, with: "ic_triangle_down")
        
        initCorners()
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.clickedView(_:))))
        //panGesture = ExtPanGestureRecognizer(target: self, action: #selector(self.draggedView(_:)))
        //self.addGestureRecognizer(panGesture)
        
        //okayGetsture = UITapGestureRecognizer.init(target: self, action: #selector(self.okayClicked(_:)))
        //okay.addGestureRecognizer(okayGetsture)
        cancelGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.cancelClicked(_:)))
        cancel.addGestureRecognizer(cancelGesture)
        flipGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.flipClicked(_:)))
        flip.addGestureRecognizer(flipGesture)
        //self.rotatedArg = 0
        ahead.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.aheadClicked(_:))))
        behind.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.behindClicked(_:))))
    }
    
    @objc func clickedView(_ sender: UITapGestureRecognizer?) {
        if createSpaceViewController != nil {
            createSpaceViewController?.unselectOtherView(selected: self)
        }
        self.showSubViews()
    }
    
    @objc func okayClicked(_ sender: UIGestureRecognizer?) {
        if createSpaceViewController != nil {
            createSpaceViewController?.hideProductDetailView()
        }
        self.hideSubViews()
    }
    
    @objc func cancelClicked(_ sender: UIGestureRecognizer?) {
        if createSpaceViewController != nil {
            createSpaceViewController?.removeMe(selected: self)
        }
        self.removeFromContainer()
    }
    
    @objc func flipClicked(_ sender: UIGestureRecognizer?) {
        if createSpaceViewController != nil {
            createSpaceViewController?.flipMe(selected: self)
        }
    }
    
    @objc func aheadClicked(_ sender: UIGestureRecognizer?) {
        if createSpaceViewController != nil {
            createSpaceViewController?.goAhead(selected: self)
        }
    }
    
    @objc func behindClicked(_ sender: UIGestureRecognizer?) {
        if createSpaceViewController != nil {
            createSpaceViewController?.goBehind(selected: self)
        }
    }
    
    func removeFromContainer() {
        self.border.fadeAndRemove()
        self.topLeft.fadeAndRemove()
        self.topRight.fadeAndRemove()
        self.topMiddle.fadeAndRemove()
        self.rightMiddle.fadeAndRemove()
        self.bottomMiddle.fadeAndRemove()
        self.bottomRight.fadeAndRemove()
        
        //self.okay.fadeAndRemove()
        self.cancel.fadeAndRemove()
        self.flip.fadeAndRemove()
        self.ahead.fadeAndRemove()
        self.behind.fadeAndRemove()
        
        self.fadeAndRemove()
    }
    
    func hideSubViews() {
        self.border.fadeOut()
        self.topLeft.fadeOut()
        self.topRight.fadeOut()
        self.topMiddle.fadeOut()
        self.rightMiddle.fadeOut()
        self.bottomMiddle.fadeOut()
        self.bottomRight.fadeOut()
        
        //self.okay.fadeOut()
        self.cancel.fadeOut()
        self.flip.fadeOut()
        self.ahead.fadeOut()
        self.behind.fadeOut()
    }
    
    func showSubViews() {
        self.border.fadeIn()
        self.topLeft.fadeIn()
        self.topRight.fadeIn()
        self.topMiddle.fadeIn()
        self.rightMiddle.fadeIn()
        self.bottomMiddle.fadeIn()
        self.bottomRight.fadeIn()
        
        //self.okay.fadeIn()
        self.cancel.fadeIn()
        self.flip.fadeIn()
        self.ahead.fadeIn()
        self.behind.fadeIn()
    }
    
    
    func setZPosition(position: CGFloat) {
        self.layer.zPosition = position
        let halfPos = position + 0.5
        self.topLeft.layer.zPosition = halfPos
        self.topRight.layer.zPosition = halfPos
        self.topMiddle.layer.zPosition = halfPos
        self.rightMiddle.layer.zPosition = halfPos
        self.bottomMiddle.layer.zPosition = halfPos
        self.bottomRight.layer.zPosition = halfPos
        
        self.cancel.layer.zPosition = halfPos
        //self.okay.layer.zPosition = halfPos
        self.border.layer.zPosition = halfPos
        self.ahead.layer.zPosition = halfPos
        self.behind.layer.zPosition = halfPos
        self.flip.layer.zPosition = halfPos
    }
}
