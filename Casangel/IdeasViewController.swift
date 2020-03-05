//
//  IdeasViewController.swift
//  CasAngel
//
//  Created by Admin on 25/05/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class IdeasCatAdapter: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var parentViewController: IdeasViewContoller? = nil
    var lastIndexPath: IndexPath? = nil
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if GlobalData.getInspireCategories() == nil {
            return 0
        }
        return (GlobalData.getInspireCategories()?.count)!
    }
    
    func setParentViewController(_ vc: IdeasViewContoller?) {
        self.parentViewController = vc
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "idea_cat_cell", for: indexPath)
        var color = UIColor.darkGray
        if indexPath.item % 3 == 2 {
            color = UIColor.lightGray
        } else if indexPath.item % 3 == 1 {
            color = UIColor.gray
        } else {
            color = UIColor.darkGray
        }
        cell.viewWithTag(1)?.backgroundColor = color
        let txtView = cell.viewWithTag(1) as! RoundTextView
        if GlobalData.getInspireCategories() == nil {
            return cell
        }
        txtView.text = ((GlobalData.getInspireCategories())!)[indexPath.item]._name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        lastIndexPath = indexPath
        if self.parentViewController != nil {
            self.parentViewController?.loadPosts()
        }
    }
}

class IdeaCatCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView? = nil
    @IBOutlet var textView: UILabel? = nil
}

class IdeasViewContoller: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var collectionView: UICollectionView? = nil
    var categoriesAdapter = IdeasCatAdapter()
    var posts: [PostDetails]? = nil
    var imageSize = [CGSize].init()
    
    override func viewDidLoad() {
        let catView = self.view.viewWithTag(1) as! UICollectionView
        catView.dataSource = categoriesAdapter
        catView.delegate = categoriesAdapter
        
        collectionView = self.view.viewWithTag(2) as? UICollectionView
        collectionView?.dataSource = self
        collectionView?.delegate = self
        categoriesAdapter.setParentViewController(self)
        loadPosts()
    }
    
    func loadPosts() {
        self.showLoadingAnim(collectionView: self.collectionView!)
        DispatchQueue.global(qos: .userInitiated).async(execute: {
            var idx = 0
            if self.categoriesAdapter.lastIndexPath != nil {
                idx = self.categoriesAdapter.lastIndexPath?.item ?? 0
            }
            let postCategoryId = GlobalData.getInspireCategories()?[idx]._id
            if postCategoryId == nil {
                return
            }
            let params = Parameters(dictionaryLiteral: ("lang", "en-US"), ("categories", postCategoryId!), ("page", "1"), ("per_page", 100), ("_embed", "true"))
            APIClient.getAllPosts(args: params, completionHandler: { (posts: [PostDetails]?, success: Bool) in
                if success {
                    self.posts = posts
                    self.imageSize = [CGSize].init(repeating: .init(width: 0, height: 0), count: self.posts!.count)
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                        self.hideLoadingAnim(collectionView: self.collectionView!)
                    }
                }
            })
        })
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if posts == nil {
            return 0
        } else {
            let count = (posts?.count)!
            if count < 2 {
                return count
            }else if count % 2 == 0 {
                return count + 2
            } else {
                return count + 1
            }
        }
    }
    
    func setImage(imageView: UIImageView, index: Int) {
        if self.posts == nil {
            return
        }
        let post = posts?[index]
        let urlStr = post?._jetpack_featured_media_url
        let url = URL(string: urlStr!.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
        let placeholderImage = UIImage(named: "placeholder")!
        
        let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
            size: imageView.frame.size,
            radius: 0
        )
        
        imageView.af_setImage(
            withURL: url!,
            placeholderImage: placeholderImage,
            filter: filter,
            imageTransition: .crossDissolve(0.2), completion: { (_ response: DataResponse<UIImage>) in
                imageView.contentMode = .scaleToFill
                imageView.layer.cornerRadius = 20
                self.imageSize[index] = response.value?.size ?? CGSize.init(width: 0, height: 0)
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: IdeaCatCell? = nil
        if self.posts != nil {
            let count = (self.posts?.count)!
            if count % 2 == 0 && indexPath.item == count + 1 {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "idea_cell_padding_bottom", for: indexPath) as? IdeaCatCell
                cell?.textView?.text = (self.posts!)[indexPath.item-2]._title?._rendered
                cell?.textView?.isHidden = false
                return cell!
            } else if count % 2 == 1 && count >= 3 && indexPath.item == count {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "idea_cell_top", for: indexPath) as? IdeaCatCell
                cell?.textView?.text = (self.posts!)[indexPath.item-2]._title?._rendered
                cell?.imageView?.isHidden = true
                cell?.textView?.isHidden = false
                return cell!
            } else if count % 2 == 0 && indexPath.item == count {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "idea_cell_padding_bottom", for: indexPath) as? IdeaCatCell
                cell?.textView?.isHidden = true
                return cell!
            } else if indexPath.item == 1 {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "idea_cell_padding", for: indexPath) as? IdeaCatCell
            } else if indexPath.item % 2 == 0 {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "idea_cell_bottom", for: indexPath) as? IdeaCatCell
                cell?.textView?.text = (self.posts!)[indexPath.item]._title?._rendered
                cell?.textView?.isHidden = false
            } else {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "idea_cell_top", for: indexPath) as? IdeaCatCell
                cell?.textView?.text = (self.posts!)[indexPath.item-2]._title?._rendered
                cell?.textView?.isHidden = false
            }
            setImage(imageView: (cell?.imageView)!, index: indexPath.item)
        } else {
            if indexPath.item == 1 {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "idea_cell_padding", for: indexPath) as? IdeaCatCell
            } else if indexPath.item % 2 == 0 {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "idea_cell_bottom", for: indexPath) as? IdeaCatCell
            } else {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "idea_cell_top", for: indexPath) as? IdeaCatCell
            }
        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  self.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: 5)
        let collectionViewSize = collectionView.frame.size.width - padding
        if self.posts != nil {
            let count = (self.posts?.count)!
            if count % 2 == 0 && indexPath.item >= count {
                return CGSize(width: collectionViewSize/2, height: 50)
            } else if indexPath.item == 1 {
                return CGSize(width: collectionViewSize/2, height: collectionViewSize*0.7)
            }
        }
        return CGSize(width: collectionViewSize/2, height: collectionViewSize*0.7)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item >= self.posts!.count {
            return
        }
        if self.imageSize[indexPath.item].width == 0 {
            self.showToast(message: "Please wait while images are loading")
            return
        }
        lastIndexPath = indexPath
        performSegue(withIdentifier: "ShowSelected", sender: self)
    }
    
    var lastIndexPath: IndexPath? = nil
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if lastIndexPath == nil || self.posts == nil {
            return
        }
        let vc = segue.destination as! IdeaSelectedViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.selectedImageSize = self.imageSize[lastIndexPath!.item]
        vc.selectedImageUrl = ((self.posts)!)[(lastIndexPath?.item)!]._jetpack_featured_media_url ?? ""
        vc.selectedImageText = ((self.posts)!)[(lastIndexPath?.item)!]._title?._rendered ?? ""
    }
}

class IdeaSelectedViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    public var selectedImageUrl: String = ""
    public var selectedImageText: String = ""
    public var selectedImageSize: CGSize = .init()
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        CustomTabBarController.stopTab = true
        self.view.isOpaque = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        let height = self.getHeight(index: 0).height + self.getHeight(index: 1).height + 50
        let delta = self.view.frame.height - height
        collectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: delta/2).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: delta/2).isActive = true
        
        self.backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.backClicked)))
    }
    
    @objc func backClicked() {
        CustomTabBarController.stopTab = false
        self.dismiss(animated: false, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let imgCell = collectionView.dequeueReusableCell(withReuseIdentifier: "image_cell", for: indexPath)
            let iv = imgCell.viewWithTag(1) as! UIImageView
            iv.setImageFromUrl(urlStr: self.selectedImageUrl)
            return imgCell
        } else {
            let textCell = collectionView.dequeueReusableCell(withReuseIdentifier: "text_cell", for: indexPath)
            let tv = textCell.viewWithTag(1) as! UILabel
            tv.text = self.selectedImageText
            tv.sizeToFit()
            return textCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.getHeight(index: indexPath.item)
    }
    
    func getHeight(index: Int) -> CGSize{
        if index == 0 {
            let rate = self.selectedImageSize.height/self.selectedImageSize.width
            print(rate)
            return CGSize.init(width: collectionView.frame.width, height: (collectionView.frame.width-60)*rate)
        } else{
            let width = collectionView.frame.width
            let height = collectionView.frame.height
            let strokeTextAttributes = [ NSAttributedString.Key.font : UIFont.systemFont(ofSize: 22)] as [NSAttributedString.Key : Any]
            let attrTitle = NSAttributedString.init(string: self.selectedImageText, attributes: strokeTextAttributes)
            let totalHeight: CGFloat = attrTitle.boundingRect(with: CGSize.init(width: width-20, height: height), options: .usesLineFragmentOrigin, context: nil).height
            return CGSize.init(width: width, height: totalHeight)
        }
    }
}
