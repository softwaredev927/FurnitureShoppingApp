//
//  MyCreationViewController.swift
//  CasAngel
//
//  Created by Admin on 25/05/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class CreationCell: UICollectionViewCell {
    @IBOutlet var nameTextView: UITextView? = nil
    @IBOutlet var dateTextView: UITextView? = nil
    @IBOutlet var imageView: UIImageView? = nil
    @IBOutlet var removeBtn: UIButton? = nil
    
    @IBAction func removeClicked() {
        GlobalData.removeProject(at: removeBtn!.tag)
    }
    var productViews: [DraggableImageView]? = [DraggableImageView].init()
}

class NewCreationCell: UICollectionViewCell {
    @IBOutlet var newButton: UIButton? = nil
}

class MyCreationViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    var thumbFiles: [URL]? = nil
    var currentSelectedImage: UIImage? = nil
    var selectedItem: Int = -1
    @IBOutlet var collectionView: UICollectionView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let collectionView = self.view.viewWithTag(1) as! UICollectionView?
        collectionView?.dataSource = self
        collectionView?.delegate = self
        loadThumbFiles()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let cc = thumbFiles?.count
        loadThumbFiles()
        //if (thumbFiles?.count)! > cc! {
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        //}
    }
    
    func loadThumbFiles() {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
            print(directoryContents)// if you want to filter the directory contents you can do like this:
            thumbFiles = directoryContents.filter{ $0.pathExtension == "png" }
        } catch {
            print(error)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (GlobalData.saveModel?.projects?.count)! + 1
    }
    
    
    func addProduct(container: UIView?, displayFrame: CGRect, urlStr: String) -> DraggableImageView? {
        let productView = DraggableImageView.init(image: UIImage.init(named: "chair_example"))
        productView.container = container
        productView.frame = displayFrame
        productView.isUserInteractionEnabled = false
        if urlStr != "" {
            productView.setImageFromUrl(urlStr: urlStr)
        }
        productView.layoutSubviews()
        container?.addSubview(productView)
        return productView
    }
    
    func updateProduct(container: UIView?, product: ProductModel) -> DraggableImageView? {
        let width = (container?.frame.width)!
        let height = (container?.frame.height)!
        let frame = CGRect.init(x: CGFloat((product.frameX)!), y: CGFloat((product.frameY)!),
                                width: CGFloat((product.frameWidth)!), height: CGFloat((product.frameHeight)!))
        let productView = addProduct(container: container, displayFrame: frame, urlStr: (product.productImgSrc)!)
        productView?.transform.a = CGFloat((product.transformA)!)
        productView?.transform.b = CGFloat((product.transformB)!)
        productView?.transform.c = CGFloat((product.transformC)!)
        productView?.transform.d = CGFloat((product.transformD)!)
        productView?.transform.tx = CGFloat((product.transformTx)!)// * width
        productView?.transform.ty = CGFloat((product.transformTy)!)// * height
        //productView?.transform = (productView?.transform.scaledBy(x: width, y: height))!
        productView?.initCorners()
        return productView
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cellName = ""
        print (indexPath)
        if indexPath.item == collectionView.numberOfItems(inSection: 0) - 1 {
            cellName = "new_creation_cell"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath) as! NewCreationCell
            return cell
        }else {
            cellName = "creation_cell"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName, for: indexPath) as! CreationCell
            let project = GlobalData.saveModel?.projects![indexPath.item]
            cell.nameTextView?.text = project?.projectName
            cell.dateTextView?.text = project?.projectDt
            cell.removeBtn?.tag = indexPath.item
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            cell.imageView?.image = UIImage.init(contentsOfFile: documentsDirectory.appendingPathComponent((project?.thumbFileName)!).path)
            /*for productView in (cell.productViews)! {
                productView.removeFromContainer()
            }
            cell.productViews?.removeAll()
            let width = (cell.imageView?.frame.width)!
            let height = (cell.imageView?.frame.height)!
            let displayWidth = CGFloat((project?.displayWidth)!)
            let displayHeight = CGFloat((project?.displayHeight)!)
            let container = UIView()
            //cell.imageView?.transform = (CGAffineTransform.identity.rotated(by: CGFloat(project!.rotationDegree!)))
            cell.imageView?.addSubview(container)
            container.frame = CGRect.init(x: 0, y: 0, width: displayWidth, height: displayHeight)
            container.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.0)
            for product in (project?.products)! {
                let productView = updateProduct(container: container, product: product)
                if (product.borderHidden)! {
                    productView?.hideSubViews()
                }
                cell.productViews?.append(productView!)
            }
            container.isUserInteractionEnabled = false
            container.center = CGPoint.init(x: width/2, y: height/2)
            container.transform = CGAffineTransform.identity.scaledBy(x: width/displayWidth, y: height/displayHeight)
            container.center = CGPoint.init(x: width/2, y: height/2)*/
            return cell
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCreateSpace" {
            let navController = segue.destination as! UINavigationController
            let createSpaceController = navController.visibleViewController as! CreateSpaceViewController
            createSpaceController.cameraPhoto = currentSelectedImage
            let jsonStr = GlobalData.saveModel?.projects?[self.selectedItem].toJSONString()
            createSpaceController.projectModel = ProjectModel.init(JSONString: jsonStr!)!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cc = (GlobalData.saveModel?.projects?.count)!
        if indexPath.item < cc {
            let cell = self.collectionView(collectionView, cellForItemAt: indexPath) as! CreationCell
            self.currentSelectedImage = cell.imageView?.image
            if indexPath.item < cc {
                self.selectedItem = indexPath.item
                self.performSegue(withIdentifier: "ShowCreateSpace", sender: self)
            }
        } else {
            self.performSegue(withIdentifier: "ShowCamera", sender: self)
        }
    }
    
    @IBAction func removeProject() {
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewSize = collectionView.frame.size.width - 6
        return CGSize(width: collectionViewSize/2, height: collectionViewSize*0.6)
    }
}
