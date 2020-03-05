//
//  TrendsViewController.swift
//  CasAngel
//
//  Created by Admin on 25/05/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class TrendViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView? = nil
    @IBOutlet var titleView: UILabel? = nil
    @IBOutlet var contentTextView: UILabel? = nil
}

class TrendsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var collectionView: UICollectionView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem?.target = self
        self.navigationItem.leftBarButtonItem?.action = #selector(backClicked(_:))
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
    }
    
    @objc func backClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GlobalData.getTrends()?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trend_cell", for: indexPath) as! TrendViewCell
        cell.imageView?.setImageFromUrl(urlStr: (GlobalData.getTrends()!)[indexPath.item]._jetpack_featured_media_url ?? "")
        cell.titleView?.text = (GlobalData.getTrends()!)[indexPath.item]._title?._rendered
        let content = (GlobalData.getTrends()!)[indexPath.item]._content?._rendered?.stripOutHtml()
        cell.contentTextView?.text = content
        
        cell.titleView?.sizeToFit()
        cell.contentTextView?.sizeToFit()
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        let title = (GlobalData.getTrends()!)[indexPath.item]._title?._rendered
        let content = (GlobalData.getTrends()!)[indexPath.item]._content?._rendered?.stripOutHtml()
        let strokeTextAttributes = [ NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)] as [NSAttributedString.Key : Any]
        let strokeTextAttributes1 = [ NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)] as [NSAttributedString.Key : Any]
        
        let attrTitle = NSAttributedString.init(string: title!, attributes: strokeTextAttributes)
        let attrContent = NSAttributedString.init(string: content!, attributes: strokeTextAttributes1)
        var totalHeight: CGFloat = 400
        totalHeight += attrTitle.boundingRect(with: CGSize.init(width: width, height: height), options: .usesLineFragmentOrigin, context: nil).height
        totalHeight += attrContent.boundingRect(with: CGSize.init(width: width, height: height), options: .usesLineFragmentOrigin, context: nil).height
        
        return CGSize.init(width: width, height: totalHeight)
    }
}


extension String {
    
    func stripOutHtml() -> String? {
        do {
            guard let data = self.data(using: .unicode) else {
                return nil
            }
            let attributed = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            return attributed.string
        } catch {
            return nil
        }
    }
}
