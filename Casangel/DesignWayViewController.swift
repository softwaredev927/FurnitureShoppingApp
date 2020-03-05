//
//  DesignWayViewController.swift
//  CasAngel
//
//  Created by Admin on 25/05/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class TemplateViewCell: UICollectionViewCell {
    @IBOutlet var overlayView: UIView? = nil
}

class DesignWayViewController: StoreViewController {
    
    var posts: [PostDetails]? = nil
    var lastSelected: IndexPath? = nil
    
    
    override func viewDidLoad() {
        //super.viewDidLoad()
        let catView = self.view.viewWithTag(1) as! UICollectionView
        categoriesView = catView
        self.categoriesAdapter.setCategoryType(type: 1)
        self.categoriesAdapter.tintColor = UIColor.black
        categoriesAdapter.setStoreViewController(vc: self)
        catView.dataSource = categoriesAdapter
        catView.delegate = categoriesAdapter
        categoriesAdapter.lastIndexPath = catView.indexPathForItem(at: CGPoint.init(x: 0, y: 0))
        
        categoriesAdapter.setStoreViewController(vc: self)
        productsView = self.view.viewWithTag(2) as? UICollectionView
        productsView?.dataSource = self
        productsView?.delegate = self
        self.initShadow()
        self.loadPosts()
        
    }
    
    func loadPosts() {
        self.showLoadingAnim(collectionView: self.productsView!)
        if GlobalData.getPostCategories() == nil {
            return
        }
        DispatchQueue.global(qos: .userInitiated).async(execute: {
            var idx = 0
            if self.categoriesAdapter.lastIndexPath != nil {
                idx = self.categoriesAdapter.lastIndexPath?.item ?? 0
            }
            let postCategoryId = GlobalData.getPostCategories()?[idx]._id
            let params = Parameters(dictionaryLiteral: ("lang", "en-US"), ("categories", postCategoryId), ("page", "1"), ("per_page", 100), ("embed", "true"))
            APIClient.getAllPosts(args: params, completionHandler: { (posts: [PostDetails]?, success: Bool) in
                if success {
                    self.posts = posts
                    DispatchQueue.main.async {
                        self.productsView?.reloadData()
                        self.hideLoadingAnim(collectionView: self.productsView!)
                    }
                }
            })
        })
    }
    
    override func setImage(imageView: UIImageView, index: Int, subIndex: Int = 0) {
        if self.posts == nil {
            return
        }
        let post = posts?[index]
        let urlStr = post?._jetpack_featured_media_url
        let url = URL(string: urlStr!.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
        let placeholderImage = UIImage(named: "placeholder")!
        
        let filter = AspectScaledToFillSizeFilter(
            size: imageView.frame.size
        )
        print("image loading started ", url)
        imageView.af_setImage(
            withURL: url!,
            placeholderImage: placeholderImage,
            filter: filter,
            imageTransition: .crossDissolve(0.2), completion: { (_ response: DataResponse<UIImage>) in
                //imageView.contentMode = .scaleAspectFit
                print("image loading finished")
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCreateSpace" {
            let vc = segue.destination as! UINavigationController
            if lastSelected != nil {
                let url = posts?[(lastSelected?.item)!]._jetpack_featured_media_url
                let csvc = vc.visibleViewController as! CreateSpaceViewController
                csvc.imagePath = url
            }
        }
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //self.performSegue(withIdentifier: "ShowCreateSpace", sender: self)
        let cell = collectionView.cellForItem(at: indexPath) as! TemplateViewCell
        DispatchQueue.main.async {
            cell.overlayView?.isHidden = false
            if self.lastSelected != nil {
                let lastCell = collectionView.cellForItem(at: self.lastSelected!) as! TemplateViewCell
                lastCell.overlayView?.isHidden = true
            }
            self.lastSelected = indexPath
        }
    }
    
    @IBAction func createSpace() {
        if lastSelected == nil {
            self.showToast(message: "por favor seleccione su plantilla")
            return
        }
        self.performSegue(withIdentifier: "ShowCreateSpace", sender: self)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}
