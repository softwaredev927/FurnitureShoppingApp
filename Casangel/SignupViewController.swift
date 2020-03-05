//
//  SignupViewController.swift
//  CasAngel
//
//  Created by Admin on 23/05/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
    //    @Field("first_name") String firstname,
    //    @Field("last_name") String lastname,
    //    @Field("username") String username,
    //    @Field("email") String email_address,
    //    @Field("password") String password,
    //    @Field("company") String company,
    //    @Field("address_1") String address1,
    //    @Field("address_2") String address2,
    //    @Field("city") String city,
    //    @Field("state") String state,
    //    @Field("phone") String phone,
    //    @Field("nonce") String nonce);
    @IBOutlet var firstName: UITextField? = nil
    @IBOutlet var lastName: UITextField? = nil
    @IBOutlet var userName: UITextField? = nil
    @IBOutlet var email: UITextField? = nil
    @IBOutlet var password: UITextField? = nil
    @IBOutlet var company: UITextField? = nil
    @IBOutlet var state: UITextField? = nil
    @IBOutlet var phone: UITextField? = nil
    
    @IBOutlet var stackView: UIStackView? = nil
    @IBOutlet var logoView: UIImageView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.parent?.navigationItem.title = "Regístrate"
        let scrollView = self.view.viewWithTag(20) as! UIScrollView
        scrollView.contentSize = CGSize.init(width: scrollView.frame.width, height: 780)
        
        let login = self.view.viewWithTag(15) as! UIButton
        login.isUserInteractionEnabled = true
        
        let tapLogin = UITapGestureRecognizer(target: self, action: #selector(self.loginClicked(_:)))
        login.addGestureRecognizer(tapLogin)
        
        addLeftView(tag: 1, icon: "account")
        addLeftView(tag: 2, icon: "person")
        addLeftView(tag: 3, icon: "person")
        addLeftView(tag: 4, icon: "person")
        addLeftView(tag: 5, icon: "email")
        addLeftView(tag: 6, icon: "lock")
        //addLeftView(tag: 7, icon: "location")
        //addLeftView(tag: 8, icon: "location")
        addLeftView(tag: 9, icon: "person_android")
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)        
        
        if let userSettings = GlobalData.userSettings {
            if (userSettings.rate_app != "1") {
                (self.view.viewWithTag(4) as! UITextField).placeholder = "Número de identificación (Opcional)"
                (self.view.viewWithTag(7) as! UITextField).placeholder = "Dirección (Opcional)"
                (self.view.viewWithTag(8) as! UITextField).placeholder = "Ciudad (Opcional)"
                (self.view.viewWithTag(9) as! UITextField).placeholder = "Teléfono (Opcional)"
            }
        }
    }
    
    var keyboardMoveHeight: CGFloat = 0
    var keyboardHeight: CGFloat = 0
    @objc func keyboardWillShow(notification: NSNotification) {
        let scrollView = self.view.viewWithTag(20) as! UIScrollView
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.keyboardHeight = keyboardSize.height
            let field = scrollView.getSelectedTextField()
            if field != nil && field!.tag > 5 && keyboardHeight == 0 {
                keyboardMoveHeight = keyboardHeight - CGFloat((11 - field!.tag)*20)
                DispatchQueue.main.async {
                    scrollView.transform = scrollView.transform.translatedBy(x: 0, y: -self.keyboardHeight)
                    scrollView.layoutSubviews()
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let scrollView = self.view.viewWithTag(20) as! UIScrollView
        if keyboardHeight != 0 {
            DispatchQueue.main.async {
                scrollView.transform = scrollView.transform.translatedBy(x: 0, y: self.keyboardMoveHeight)
                self.keyboardMoveHeight = 0
                scrollView.layoutSubviews()
            }
        }
    }
    
    func addLeftView(tag: Int, icon: String) {
        let field = self.view.viewWithTag(tag) as! UITextField
        field.leftViewMode = .always
        field.leftView = UIImageView.init(image: UIImage.init(named: icon)).setSizeSmall()
        field.delegate = self
    }
    
    func gotoProfilePage(){
        DispatchQueue.main.async {
            let parent = self.parent
            
            self.view.removeFromSuperview()
            self.removeFromParent()
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let signupView = storyboard.instantiateViewController(withIdentifier: "ProfileViewController")
            
            parent?.addChild(signupView)
            parent?.view.addSubview(signupView.view)
            
            signupView.didMove(toParent: parent)
        }
    }
    
    func gotoLoginPage(){
        DispatchQueue.main.async {
            let parent = self.parent
            
            self.view.removeFromSuperview()
            self.removeFromParent()
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let signupView = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
            
            parent?.addChild(signupView)
            parent?.view.addSubview(signupView.view)
            
            signupView.didMove(toParent: parent)
        }
    }
    
    @IBAction func loginClicked(_ sender: UITapGestureRecognizer? = nil) {
        gotoLoginPage()
    }
    
    @IBAction func signupClicked(_ sender: UITapGestureRecognizer? = nil) {
        let params = RegistrationParam()
        params._username = self.userName!.text!
        params._first_name = self.firstName!.text!
        params._last_name = self.lastName!.text!
        params._email = self.email!.text!
        params._company = self.company!.text!
        params._phone = self.phone!.text!
        //params._state = self.state!.text!
        params._password = self.password!.text!
        if params.notCompleted() {
            self.showToast(message: "campos vacíos o inválidos")
            return
        }
        self.showLoadingAnim(collectionView: self.view, alpha: 0.8, type: 1, showString: "Regístrate ...")
        DispatchQueue.global(qos: .userInitiated).async(execute: {
            APIClient.getNonce(completionHandler: { (nonce: Nonce?, success: Bool) in
                if !success || nonce == nil || nonce?._nonce == nil {
                    self.hideLoadingAnim(collectionView: self.view)
                    return
                }
                params._nonce = nonce!._nonce!
                APIClient.processRegistration(args: params.toParameter(), completionHandler: { (userData: UserData?, success: Bool) in
                    if success && userData?._status == "ok" {
                        userData?._user?._password = self.password?.text
                        GlobalData.saveUserData(userData: userData)
                        self.hideLoadingAnim(collectionView: self.view)
                        self.gotoLoginPage()
                    }else {
                        self.hideLoadingAnim(collectionView: self.view)
                        if success {
                            self.showToast(message: userData!._error!)
                        } else {
                            self.showToast(message: "connection failed")
                        }
                    }
                })
            })
        })
    }
}

extension SignupViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ field: UITextField) {
        let scrollView = self.view.viewWithTag(20) as! UIScrollView
        
        if self.keyboardHeight != 0 && field.tag > 5 {
            let d = keyboardHeight - CGFloat((11 - field.tag)*20)
            let delta = d - keyboardMoveHeight
            keyboardMoveHeight = d
            DispatchQueue.main.async {
                scrollView.transform = scrollView.transform.translatedBy(x: 0, y: -delta)
                scrollView.layoutSubviews()
            }
        }
    }
}
