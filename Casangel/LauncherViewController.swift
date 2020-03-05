//
//  LauncherViewController.swift
//  CasAngel
//
//  Created by Admin on 02/06/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import Alamofire

class LauncherViewController: UIViewController {
    
    var runAsDebug = true
    
    @IBOutlet weak var noInternetLabel: UILabel!
    @IBOutlet weak var retryBtn: UIButton!
    @IBOutlet weak var spinView: SpinnerView!
    
    @IBAction func retryToConnect() {
        self.loadInitialData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GlobalData.loadUserModel()
        GlobalData.loadProjectModel()
        loadInitialData()
    }
    
    
    func loadInitialData() {
        if self.spinView.isHidden  {
            self.spinView.isHidden = false
        }
        DispatchQueue.global(qos: .userInitiated).async(execute: {
            var loadedCount = 0
            let totalLoadCount = 5
            var tryCount = 0
            var params = Parameters(dictionaryLiteral: ("lang", "en-US"))
            APIClient.getAllCategories(args: params, completionHandler: { (categories: [CategoryDetails]?, success: Bool) in
                if success {
                    GlobalData.setCategories(categories: categories)
                    loadedCount = loadedCount + 1
                }
            })
            params = Parameters(dictionaryLiteral: ("lang", "en-US"), ("parent", "328"))
            APIClient.getPostCategories(args: params, completionHandler: { (categories: [PostCategory]?, success: Bool) in
                if success {
                    GlobalData.setPostCategories(categories: categories)
                    loadedCount = loadedCount + 1
                }
            })
            params = Parameters(dictionaryLiteral: ("lang", "en-US"), ("parent", "329"))
            APIClient.getPostCategories(args: params, completionHandler: { (categories: [PostCategory]?, success: Bool) in
                if success {
                    GlobalData.setInspireCategories(categories: categories)
                    loadedCount = loadedCount + 1
                }
            })
            params = Parameters(dictionaryLiteral: ("lang", "en-US"), ("categories", "332"), ("page", "1"), ("per_page", 100), ("_embed", "true"))
            APIClient.getAllPosts(args: params, completionHandler: { (posts: [PostDetails]?, success: Bool) in
                if success {
                    GlobalData.setTrends(trends: posts)
                }
            })
            APIClient.getHomeSlideImages{ (images: [String]?) in
                guard let images = images else {
                    return;
                }
                GlobalData.setHomeImages(images: images)
                loadedCount = loadedCount + 1
            }
            APIClient.getUserSettings{ (users: UserSettings?) in
                GlobalData.userSettings = users
                loadedCount = loadedCount + 1
            }
            while loadedCount < totalLoadCount {
                if tryCount > totalLoadCount {
                    DispatchQueue.main.async {
                        self.noInternetLabel.isHidden = false
                        self.retryBtn.isHidden = false
                        self.spinView.isHidden = true
                    }
                    if self.runAsDebug {
                        break
                    } else {
                        return
                    }
                }
                Thread.sleep(forTimeInterval: 2.0)
                tryCount = tryCount + 1
            }
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "GotoMain", sender: self)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = segue.destination
    }
}
