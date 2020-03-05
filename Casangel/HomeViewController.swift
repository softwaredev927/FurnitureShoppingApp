//
//  FirstViewController.swift
//  CasAngel
//
//  Created by Admin on 21/05/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import ImageSlideshow

class HomeViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var imageSlideView: ImageSlideshow!
    @IBOutlet weak var btnParentView: UIView!
    
    var gesture = UILongPressGestureRecognizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.init(rgb: 0x444242)
        let titleView = self.navigationItem.titleView
        titleView?.backgroundColor = UIColor.init(rgb: 0x444242)
        
        btnParentView.viewWithTag(1)?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:))))
        btnParentView.viewWithTag(2)?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:))))
        btnParentView.viewWithTag(3)?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:))))
        btnParentView.viewWithTag(4)?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:))))
        
        var imageSources = [AlamofireSource].init()
        for img in GlobalData.getHomeImages() {
            if let imgSource = AlamofireSource.init(urlString: img) {
                imageSources.append(imgSource)
            }
        }
        imageSlideView.setImageInputs(imageSources)
        imageSlideView.slideshowInterval = 3
        imageSlideView.contentScaleMode = .scaleAspectFill
        imageSlideView.pageIndicator = nil
        imageSlideView.draggingEnabled = false
        
        let iv = UIImageView(image: .init(imageLiteralResourceName: "banner"))
        iv.contentMode = .scaleAspectFit
        iv.frame = .init(x: 0, y: 0, width: 120, height: 60)
        navigationItem.titleView = iv
    }
    
    func proceedWithCameraAccess(identifier: String){
    }
    var imagePickerController: UIImagePickerController? = nil
    @objc func handleTap(_ sender: UIGestureRecognizer? = nil) {
        // handle touch down and touch up events separately
        let iv = sender?.view as! UIView
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let taController = appDelegate.window?.rootViewController as! CustomTabBarController
        if iv.tag == 4 {
            taController.animateToTab(toIndex: CustomTabBarController.TabIndex.TabIndexStore.rawValue)
        } else if iv.tag == 3 {
            performSegue(withIdentifier: "ShowTrends", sender: self)
        } else if iv.tag == 1 {
            performSegue(withIdentifier: "ShowCamera", sender: self)
            /*if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.delegate = self
                imagePicker.sourceType = .camera;
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            } else if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary;
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController = UIImagePickerController()
                imagePickerController?.delegate = self
                imagePickerController?.sourceType = .camera
                
                self.present(imagePickerController!, animated: true, completion: nil)
            }else if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)  {
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }*/
        } else if iv.tag == 2 {
            performSegue(withIdentifier: "ShowDesignWay", sender: self)
        }
    }
    
    var cameraPhoto: UIImage? = nil
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCreateSpace" {
            let vc = segue.destination as! UINavigationController
            let csvc = vc.visibleViewController as! CreateSpaceViewController
            csvc.cameraPhoto = cameraPhoto
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let button = UIBarButtonItem(image: UIImage.init(named: "image_lib"), landscapeImagePhone: UIImage.init(named: "image_lib"), style: .plain, target: self, action: #selector(self.choosePicture(_:)))
        //viewController.navigationItem.rightBarButtonItem = button
        //viewController.navigationController?.navigationBar.isTranslucent = true
        //viewController.toolbarItems?[0] = button
    }
    
    @objc func choosePicture(_ sender: Any){
        if imagePickerController != nil {
            imagePickerController?.sourceType = .photoLibrary
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        cameraPhoto = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "ShowCreateSpace", sender: self)
    }
    
    func switchToDataTab(){
        
    }
    
    func switchToStoreTab(){
    }
}

