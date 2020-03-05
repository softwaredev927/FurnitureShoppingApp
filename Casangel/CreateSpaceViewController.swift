//
//  CreateSpaceViewController.swift
//  CasAngel
//
//  Created by Admin on 25/05/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import ObjectMapper
import SwiftyXML

class CreateSpaceViewController: StoreViewController, UIGestureRecognizerDelegate  {
    
    @IBOutlet var productsContainer: UIView? = nil
    @IBOutlet var imageView: UIImageView? = nil
    @IBOutlet var productSampleView: UIImageView? = nil
    var spaceImage: UIImage? = nil
    
    @IBOutlet weak var productDetailView: UIView!
    @IBOutlet weak var productPropLabel: UILabel!
    @IBOutlet weak var productPropDetailLabel: UITextView!
    @IBOutlet weak var addProductDlgSmImageCollectionView: UICollectionView!
    
    var smallImageCvDs: SmallImageCollectionViewDS?
    
    var projectModel: ProjectModel = ProjectModel.init()
    public var imagePath: String? = nil
    public var cameraPhoto: UIImage? = nil
    public var productViews: [DraggableImageView?] = [DraggableImageView?].init()
    var selectedProduct: DraggableImageView? = nil
    var lastPath: IndexPath? = nil
    var gestureCount = 0
    
    class ExtDragGestureRecognizer: UIPanGestureRecognizer {
        var vc: CreateSpaceViewController? = nil
        
        override init(target: Any?, action: Selector?) {
            super.init(target: target, action: action)
            vc = target as? CreateSpaceViewController
        }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
            super.touchesBegan(touches, with: event)
            if self.vc!.gestureCount > 0 {
                return
            }
            for touch in touches {
                for pv in vc!.productViews.reversed() {
                    if pv!.frame.contains(touch.location(in: vc?.productsContainer)) {
                        DispatchQueue.main.async {
                            self.vc?.unselectOtherView(selected: pv)
                            pv?.showSubViews()
                        }
                        break
                    }
                }
            }
        }
    }
    
    class ExtPinchGestureRecognizer: UIPinchGestureRecognizer {
        var vc: CreateSpaceViewController? = nil
        
        override init(target: Any?, action: Selector?) {
            super.init(target: target, action: action)
            vc = target as? CreateSpaceViewController
        }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
            super.touchesBegan(touches, with: event)
            if self.vc!.gestureCount > 0 {
                return
            }
            for touch in touches {
                for pv in vc!.productViews.reversed() {
                    if pv!.frame.contains(touch.location(in: vc?.productsContainer)) {
                        DispatchQueue.main.async {
                            self.vc?.unselectOtherView(selected: pv)
                            pv?.showSubViews()
                        }
                        break
                    }
                }
            }
        }
    }
    
    class ExtRotationGestureRecognizer: UIRotationGestureRecognizer {
        var vc: CreateSpaceViewController? = nil
        
        override init(target: Any?, action: Selector?) {
            super.init(target: target, action: action)
            vc = target as? CreateSpaceViewController
        }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
            super.touchesBegan(touches, with: event)
            if self.vc!.gestureCount > 0 {
                return
            }
            for touch in touches {
                for pv in vc!.productViews.reversed() {
                    if pv!.frame.contains(touch.location(in: vc?.productsContainer)) {
                        DispatchQueue.main.async {
                            self.vc?.unselectOtherView(selected: pv)
                            pv?.showSubViews()
                        }
                        break
                    }
                }
            }
        }
    }
    
    //MARK:- UIGestureRecognizerDelegate Methods
    func gestureRecognizer(_: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        self.categoriesAdapter.setCategoryType(type: 2)
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem?.target = self
        self.navigationItem.leftBarButtonItem?.action = #selector(backClicked(_:))
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(hidePromptView), userInfo: nil, repeats: false)
        productViews.removeAll()
        if self.projectModel.projectId != -1 {
            loadProject()
        } else {
            setImage()
        }
        let panGesture = ExtDragGestureRecognizer(target: self, action: #selector(self.draggedView(_:)))
        panGesture.delegate = self
        self.productsContainer?.addGestureRecognizer(panGesture)
        let pinchGesture = ExtPinchGestureRecognizer(target: self, action: #selector(self.scaledView(_:)))
        pinchGesture.delegate = self
        self.productsContainer?.addGestureRecognizer(pinchGesture)
        let roatationGesture = ExtRotationGestureRecognizer(target: self, action: #selector(self.rotatedView(_:)))
        roatationGesture.delegate = self
        pinchGesture.requiresExclusiveTouchType = true
        self.productsContainer?.addGestureRecognizer(roatationGesture)
        
        self.productsContainer?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.deselect(_:))))
        
        self.hideKeyboardWhenTappedAround()
        self.productsView?.backgroundColor = UIColor.white
        self.productsView?.layer.zPosition = 10000
    }
    
    @objc func deselect(_ sender: Any) {
        if let sel = selectedProduct {
            sel.hideSubViews()
        }
        self.hideProductDetailView()
    }
    
    func loadProject() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(projectModel.backgroundFileName!)
        self.spaceImage = UIImage.init(contentsOfFile: fileURL.path)
        self.imageView?.image = self.spaceImage?.rotate(radians: CGFloat(self.projectModel.rotationDegree!))
        for product in (self.projectModel.products)! {
            updateProduct(product: product)
        }
    }
    
    func getThumbFileName() -> String {
        let date = Date()
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy_MM_dd_HH_mm_ss"
        return "space_" + dateFormatterPrint.string(from: date) + ".png"
    }
    
    func unselectOtherView(selected: DraggableImageView?) {
        selectedProduct = selected
        selectedProduct?.showSubViews()
        for productView in self.productViews {
            if productView?.tag != selected?.tag && productView?.border.isHidden == false {
                productView?.hideSubViews()
            }
        }
    }
    
    func removeMe(selected: DraggableImageView?) {
        var idx = 0
        for productView in self.productViews {
            if productView?.tag == selected?.tag {
                self.productViews.remove(at: idx)
                break
            }
            idx = idx + 1
        }
        hideProductDetailView()
    }
    
    func flipMe(selected: DraggableImageView?) {
        selected?.isFlipped = !selected!.isFlipped
        let transform = (selected?.transform)!
        selected?.transform = transform.scaledBy(x: -1, y: 1)
        selected?.initCorners()
    }
    
    func goAhead(selected: DraggableImageView?) {
        var idx = 0
        for prodView in productViews {
            if prodView == selected {
                //productViews.remove(at: idx)
                break
            }
            idx += 1
        }
        if (idx < productViews.count-1) {
            let temp = productViews[idx+1]!.zOrder
            productViews[idx+1]?.zOrder = selected!.zOrder
            selected?.zOrder = temp
            
            selected?.setZPosition(position: CGFloat(selected!.zOrder))
            productViews[idx+1]?.setZPosition(position: CGFloat(productViews[idx+1]!.zOrder))
            
            productViews.remove(at: idx)
            productViews.insert(selected, at: idx+1)
            
            let v = projectModel.products![idx]
            projectModel.products![idx] = projectModel.products![idx+1]
            projectModel.products![idx+1] = v
        }
    }
    
    func goBehind(selected: DraggableImageView?) {
        var idx = 0
        for prodView in productViews {
            if prodView == selected {
                //productViews.remove(at: idx)
                break
            }
            idx += 1
        }
        if (idx > 0) {
            let temp = productViews[idx-1]!.zOrder
            productViews[idx-1]?.zOrder = selected!.zOrder
            selected?.zOrder = temp
            
            selected?.setZPosition(position: CGFloat(selected!.zOrder))
            productViews[idx-1]?.setZPosition(position: CGFloat(productViews[idx-1]!.zOrder))
            
            productViews.remove(at: idx)
            productViews.insert(selected, at: idx-1)
            
            let v = projectModel.products![idx]
            projectModel.products![idx] = projectModel.products![idx-1]
            projectModel.products![idx-1] = v
        }
    }
    
    @IBAction func rotateLeft() {
        DispatchQueue.main.async {
            self.projectModel.rotationDegree! -= Float.pi/2
            self.imageView?.image = self.spaceImage?.rotate(radians: CGFloat(self.projectModel.rotationDegree!))
        }
    }
    
    @IBAction func rotateRight() {
        DispatchQueue.main.async {
            self.projectModel.rotationDegree! += Float.pi/2
            self.imageView?.image = self.spaceImage?.rotate(radians: CGFloat(self.projectModel.rotationDegree!))
        }
    }
    
    @IBAction func applyProducts() {
        self.saveProject()
        if self.projectModel.products!.count == 0 {
            self.showToast(message: "Añadir productos")
            return
        }
        GlobalData.clearCarts()
        for product in self.projectModel.products! {
            GlobalData.addToCart(productId: product.productId!, productModel: product)
        }
        self.performSegue(withIdentifier: "GotoCart", sender: self)
    }
    
    func saveProject() {
        let df = DateFormatter()
        df.dateFormat = "dd MMMM yyyy"
        projectModel.projectDt = df.string(from: Date())
        projectModel.displayWidth = Float((self.productsContainer?.frame.width)!)
        projectModel.displayHeight = Float((self.productsContainer?.frame.height)!)
        var products: [ProductModel]? = [ProductModel].init()
        var idx = 0
        for productView in self.productViews {
            if !productView!.isHidden {
                //let product = ProductModel()
                let product = ((projectModel.products)!)[idx]
                let transform = (productView?.transform)!
                product.transformA = Double((transform.a))
                product.transformB = Double((transform.b))
                product.transformC = Double((transform.c))
                product.transformD = Double((transform.d))
                product.transformTx = Double((transform.tx)/* / width*/)
                product.transformTy = Double((transform.ty)/* / height*/)
                product.isFlipped = productView?.isFlipped
                if (productView?.border.isHidden)! {
                    product.borderHidden = true
                } else {
                    product.borderHidden = false
                }
                products?.append(product)
                //products?.append(product)
            }
            idx = idx + 1
        }
        projectModel.products = products
    }
    
    @IBAction func saveSpace() {
        if (projectModel.projectId)! >= 0 {
            let alertController = UIAlertController(title: "Save your project", message: "Please choose your save method", preferredStyle: .alert)
            
            //the confirm action taking the inputs
            let resaveAction = UIAlertAction(title: "RE-SAVE", style: .destructive) { (_) in
                if self.saveBitmaps() {
                    self.saveProject()
                    GlobalData.saveProject(project: self.projectModel)
                    self.showToast(message: "Salvar")
                }
            }
            //the confirm action taking the inputs
            let newsaveAction = UIAlertAction(title: "NEW-SAVE", style: .default) { (_) in
                let copyProject = ProjectModel.init(JSONString: (self.projectModel.toJSONString())!)
                copyProject?.projectId = -1
                self.projectModel = copyProject!
                if self.saveBitmaps() {
                    self.saveWithName()
                    self.showToast(message: "Salvar")
                }
            }
            alertController.addAction(resaveAction)
            alertController.addAction(newsaveAction)
            //finally presenting the dialog box
            self.present(alertController, animated: true, completion: nil)
        } else {
            if self.saveBitmaps() {
                self.saveWithName()
            }
        }
    }
    
    func saveBitmaps() -> Bool {
        // get the documents directory url
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = getThumbFileName()
        let thumbFileName = "thumb_" + fileName
        let backgroundFileName = "back_" + fileName
        let thumbFileURL = documentsDirectory.appendingPathComponent(thumbFileName)
        let backgroundFileURL = documentsDirectory.appendingPathComponent(backgroundFileName)
        let thumbData = self.productsContainer?.createImage().pngData()
        if let data = self.spaceImage!.pngData() {
            do {
                // writes the image data to disk
                try data.write(to: backgroundFileURL)
                try thumbData?.write(to: thumbFileURL)
                projectModel.thumbFileName = thumbFileName
                projectModel.backgroundFileName = backgroundFileName
                return true
            } catch {
                print("error saving file:", error)
            }
        }
        return false
    }
    
    func saveWithName() {
        let alertController = UIAlertController(title: "Input name", message: "", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            self.projectModel.projectName = alertController.textFields?[0].text
            self.saveProject()
            GlobalData.saveProject(project: self.projectModel)
            self.showToast(message: "Salvar")
        }
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            textField.placeholder = "Type your space name: "
        }
        alertController.addAction(confirmAction)
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setImage(iv: UIImageView, urlStr: String) {
        if urlStr == "" {
            return
        }
        let url = URL(string: urlStr.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
        let placeholderImage = UIImage(named: "placeholder")!
        
        let filter = AspectScaledToFitSizeFilter(
            size: iv.frame.size
        )
        
        iv.af_setImage(
            withURL: url!,
            placeholderImage: placeholderImage,
            filter: filter,
            imageTransition: .crossDissolve(0.2), completion: { (_ response: DataResponse<UIImage>) in
        })
    }
    
    func setImage() {
        if imagePath == nil {
            if cameraPhoto != nil {
                //self.projectModel.rotationDegree = 0
                self.spaceImage = cameraPhoto?.rotate(radians: CGFloat(-Float.pi/2))
                self.imageView?.image = self.spaceImage
            }
            return
        }
        //setImage(iv: self.imageView!, urlStr: self.imagePath!)
        let url = URL(string: self.imagePath!.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
        let placeholderImage = UIImage(named: "placeholder")!
        
        let filter = AspectScaledToFillSizeFilter(
            size: self.imageView!.frame.size
        )
        
        self.imageView!.af_setImage(
            withURL: url!,
            placeholderImage: placeholderImage,
            filter: filter,
            imageTransition: .crossDissolve(0.2), completion: { (_ response: DataResponse<UIImage>) in
                self.spaceImage = self.imageView!.image
        })
    }
    
    @objc func hidePromptView() {
        let transition: CATransition = CATransition.init()
        transition.duration = 0.2
        transition.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.linear)
        transition.type = CATransitionType.fade
        transition.repeatCount = 1
        let alertView = self.view.viewWithTag(10)
        alertView?.alpha = 0
        alertView?.layer.add(transition, forKey: nil)
    }
    
    func updateProduct(product: ProductModel) {
        let productView = addProduct(urlStr: product.productImgSrc!, isFirst: true)
        productView?.frame = CGRect.init(x: CGFloat((product.frameX)!), y: CGFloat((product.frameY)!),
            width: CGFloat((product.frameWidth)!), height: CGFloat((product.frameHeight)!))
        productView?.transform.a = CGFloat((product.transformA)!)
        productView?.transform.b = CGFloat((product.transformB)!)
        productView?.transform.c = CGFloat((product.transformC)!)
        productView?.transform.d = CGFloat((product.transformD)!)
        productView?.transform.tx = CGFloat((product.transformTx)!)// * width
        productView?.transform.ty = CGFloat((product.transformTy)!)// * height
        productView?.isFlipped = product.isFlipped!
        //productView?.transform = (productView?.transform.scaledBy(x: width, y: height))!
        if (product.borderHidden)! {
            productView?.hideSubViews()
        } else {
            productView?.showSubViews()
        }
    }
    
    func addProduct(urlStr: String, isFirst:Bool = false) -> DraggableImageView? {
        let productView = DraggableImageView.init(image: UIImage.init(named: "chair_example"))
        self.productsContainer?.addSubview(productView)
        productView.container = self.productsContainer
        productView.frame = (self.productSampleView?.frame)!
        productView.isUserInteractionEnabled = true
        productView.layoutSubviews()
        productView.tag = self.productViews.count
        productView.createSpaceViewController = self
        //if self.products != nil {
        if urlStr != "" {
            self.setImage(iv: productView, urlStr: urlStr)
        }
        //}else {
        //    productView.image = UIImage.init(named: "chair_example")
        //}
        var maxZPos: Int = 100
        for pv in self.productViews {
            if !isFirst {
                pv?.hideSubViews()
            }
            if pv!.zOrder > maxZPos {
                maxZPos = pv!.zOrder
            }
        }
        productView.setZPosition(position: CGFloat(maxZPos + 2))
        productView.zOrder = maxZPos + 2
        productView.initCorners()
        self.productViews.append(productView)
        return productView
    }
    
    func newProduct(index: Int, subIndex: Int) {
        var imgSrc = ""
        if products != nil && index < (products?.count)! {
            imgSrc = (self.products?[index]._images?[subIndex]._src)!
        }
        let productView = self.addProduct(urlStr: imgSrc)
        productView?.productIndex = index
        let product = ProductModel.init()
        product.productId = self.products?[index]._id
        product.productPrice = Double(self.products?[index]._price ?? "0")
        product.productImgSrc = imgSrc
        product.productName = self.products?[index]._name
        product.productValidationId = self.products?[index]._selected_variation
        product.productTaxClass = self.products?[index]._tax_class
        
        product.productCategoryId = self.products![index]._category_ids ?? ""
        product.frameX = Double((productView?.frame.origin.x)!)
        product.frameY = Double((productView?.frame.origin.y)!)
        product.frameWidth = Double((productView?.frame.size.width)!)
        product.frameHeight = Double((productView?.frame.size.height)!)
        product.transformA = 1
        product.transformB = 0
        product.transformC = 0
        product.transformD = 1
        product.transformTx = 0
        product.transformTy = 0
        self.projectModel.products?.append(product)
    }
    
    func showProductDetail(_ productIndex: Int) {
        productDetailView.isHidden = false
        self.smallImageCvDs = SmallImageCollectionViewDS(vc: self, argImages: self.products![productIndex]._images!)
        addProductDlgSmImageCollectionView.dataSource = self.smallImageCvDs
        addProductDlgSmImageCollectionView.delegate = self.smallImageCvDs
        addProductDlgSmImageCollectionView.reloadData()
        let product = self.products![productIndex]
        
        let htmlData = NSString(string: product._short_description!).data(using: String.Encoding.unicode.rawValue)
        let attributedString = try! NSAttributedString(data: htmlData!, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        self.productPropDetailLabel.attributedText = attributedString
        smImageSelected = false
    }
    
    func selectSmImg(index: Int) {
        if let lastPath = lastPath {
            newProduct(index: lastPath.item, subIndex: index)
            
            let idx = self.productViews.count-1
            self.setImage(iv: self.productViews[idx]!, urlStr: self.products![self.productViews[idx]!.productIndex]._images![index]._src!)
            smImageSelected = true
        }
    }
    
    var smImageSelected = false
    func hideProductDetailView() {
        productDetailView.isHidden = true
        smImageSelected = false
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 2
        cell?.layer.borderColor = UIColor.green.cgColor
        cell?.layer.cornerRadius = 0
        if lastPath != nil {
            collectionView.cellForItem(at: lastPath!)?.layer.borderWidth = 0
        }
        showProductDetail(indexPath.item)
        lastPath = indexPath
        //newProduct(index: indexPath.item)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath)
        if lastPath != nil && indexPath.elementsEqual(lastPath!) {
            cell.layer.borderWidth = 2
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.cornerRadius = 5
        } else {
            cell.layer.borderWidth = 0
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.cornerRadius = 5
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewSize = collectionView.frame.size.width - 6
        return CGSize(width: collectionViewSize/3, height: 180)
    }
    
    @objc func backClicked(_ sender: UIBarButtonItem) {
        if self.cameraPhoto != nil {
            self.dismiss(animated: false, completion: nil)
            //self.performSegue(withIdentifier: "GoHome", sender: self)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    @objc func draggedView(_ sender:UIPanGestureRecognizer){
        if selectedProduct == nil {
            return
        }
        if sender.state == .began {
            self.gestureCount = self.gestureCount + 1
        } else if sender.state == .ended {
            self.gestureCount = self.gestureCount - 1
        }
        let translation = sender.translation(in: selectedProduct)
        selectedProduct!.transform = selectedProduct!.transform.translatedBy(x: translation.x, y: translation.y)
        sender.setTranslation(CGPoint.zero, in: selectedProduct)
        selectedProduct?.initCorners()
    }
    
    @objc func scaledView(_ recognizer:UIPinchGestureRecognizer){
        if selectedProduct == nil {
            return
        }
        if recognizer.state == .began {
            self.gestureCount = self.gestureCount + 1
        } else if recognizer.state == .ended {
            self.gestureCount = self.gestureCount - 1
        }
        let transform = (selectedProduct?.transform)!
        selectedProduct?.transform = transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
        recognizer.scale = 1
        selectedProduct?.initCorners()
    }
    
    @objc func rotatedView(_ recognizer:UIRotationGestureRecognizer){
        if selectedProduct == nil {
            return
        }
        if recognizer.state == .began {
            self.gestureCount = self.gestureCount + 1
        } else if recognizer.state == .ended {
            self.gestureCount = self.gestureCount - 1
        }
        let transform = (selectedProduct?.transform)!
        //electedProduct?.rotatedArg = selectedProduct!.rotatedArg + recognizer.rotation
        selectedProduct?.transform = transform.rotated(by: recognizer.rotation)
        recognizer.rotation = 0
        selectedProduct?.initCorners()
    }
}

class SmallImageCollectionViewDS: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var storeVc: UIViewController
    var images: [ProductImages]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "smallImageCell", for: indexPath) as! SmallImageCVCell
        cell.imgPhoto.setImageFromUrl(urlStr: images[indexPath.item]._src!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if storeVc is CreateSpaceViewController {
            (storeVc as! CreateSpaceViewController).selectSmImg(index: indexPath.item)
        }
    }
    
    init(vc: UIViewController, argImages: [ProductImages]) {
        self.images = argImages
        self.storeVc = vc
    }
}

class SmallImageCVCell: UICollectionViewCell {
    @IBOutlet weak var imgPhoto: UIImageView!
}
