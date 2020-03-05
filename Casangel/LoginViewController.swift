//
//  LoginViewController.swift
//  CasAngel
//
//  Created by Admin on 23/05/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class LoginViewController: UIViewController {
    
    @IBOutlet var userName: UITextField? = nil
    @IBOutlet var password: UITextField? = nil
    @IBOutlet var forgetPassword: UITextView? = nil
    
    override func viewDidLoad() {
        
        if GlobalData.getUserData() != nil && GlobalData.getUserData()?._user != nil {
            self.gotoViewController("ProfileViewController")
        }
        
        self.parent?.navigationItem.title = "Iniciar sesión"
        self.parent?.navigationItem.setRightBarButtonItems([], animated: true)
        let email = self.view.viewWithTag(1) as! UITextField
        email.leftViewMode = .always
        let emailIcon = UIImageView.init(image: UIImage.init(named: "account"))
        emailIcon.frame.size = CGSize.init(width: 25, height: 25)
        email.leftView = emailIcon
        email.borderStyle = .roundedRect
        
        let pwd = self.view.viewWithTag(2) as! UITextField
        pwd.leftViewMode = .always
        let pwdIcon = UIImageView.init(image: UIImage.init(named: "lock"))
        pwdIcon.frame.size = CGSize.init(width: 25, height: 25)
        pwd.leftView = pwdIcon
        pwd.borderStyle = .roundedRect
        
        let login = self.view.viewWithTag(3) as! UIButton
        login.layer.cornerRadius = 5
        login.addTarget(self, action: #selector(self.loginClicked), for: UIControl.Event.touchUpInside)
        
        let signup = self.view.viewWithTag(5) as! UITextView
        signup.isUserInteractionEnabled = true
        
        let tapSignup = UITapGestureRecognizer(target: self, action: #selector(self.signupClicked(_:)))
        signup.addGestureRecognizer(tapSignup)
        
        self.forgetPassword?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.forgetPwdClicked(_:))))
        
        self.hideKeyboardWhenTappedAround()
    }
    
    @objc func forgetPwdClicked(_ sender: Any) {
        let alertController = UIAlertController(title: "¿Olvidaste tu contraseña?", message: "", preferredStyle: .alert)
        var emailTextFild: UITextField? = nil
        //the confirm action taking the inputs
        let sendAction = UIAlertAction(title: "Enviar", style: .default) { (_) in
            if emailTextFild == nil || emailTextFild!.text! == "" {
                self.showToast(message: "Dirección de correo electrónico no válida")
                return
            }
            if !emailTextFild!.text!.isEmail  {
                self.showToast(message: "Este correo electrónico no es válido.")
                return
            }
            let email = emailTextFild!.text!
            self.showLoadingAnim(collectionView: self.view, alpha: 0.8, type: 1)
            DispatchQueue.global(qos: .userInitiated).async(execute: {
                APIClient.processForgotPassword(email: email, completionHandler: { (userData: UserData?, success: Bool) in
                    if success && userData?._status == "ok"  {
                        GlobalData.saveUserData(userData: userData)
                        self.hideLoadingAnim(collectionView: self.view)
                        self.showToast(message: userData!._msg!)
                        //self.gotoViewController("ProfileViewController")
                    } else {
                        self.hideLoadingAnim(collectionView: self.view)
                        self.showToast(message: "el envío de correo electrónico falló")
                    }
                })
            })
        }
        alertController.addTextField { (textField) in
            emailTextFild = textField
            emailTextFild?.keyboardType = .emailAddress
            self.forgotPwdField = emailTextFild
            textField.placeholder = "Dirección de correo electrónico: "
            textField.leftViewMode = .always
            textField.leftView = UIImageView.init(image: UIImage.init(named: "email"))
            textField.borderStyle = .roundedRect
            textField.addTarget(self, action: #selector(self.emailChangedForgotPassword), for: .editingChanged)
        }
        //alertController.hideKeyboardWhenTappedAround()
        alertController.addAction(sendAction)
        sendAction.isEnabled = false
        self.forgotPwdSendAction = sendAction
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion:{
            alertController.view.superview?.isUserInteractionEnabled = true
            alertController.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
        })
    }
    
    var forgotPwdField: UITextField? = nil
    var forgotPwdSendAction: UIAlertAction? = nil
    @objc func emailChangedForgotPassword() {
        if self.forgotPwdField != nil {
            if self.forgotPwdField!.text != "" && self.forgotPwdField!.text!.isEmail {
                if self.forgotPwdSendAction != nil {
                    self.forgotPwdSendAction?.isEnabled = true
                }
            }
        }
    }
    
    @objc func alertControllerBackgroundTapped()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func loginClicked() {
        let username = self.userName!.text!
        let password = self.password!.text!
        if username == "" || password == "" {
            self.showToast(message: "Nombre de usuario no válido")
            return
        }
        self.showLoadingAnim(collectionView: self.view, alpha: 0.8, type: 1, showString: "Iniciar sesión ...")
        DispatchQueue.global(qos: .userInitiated).async(execute: {
            APIClient.processLogin(args: Parameters.init(dictionaryLiteral: ("insecure","cool"), ("username", username), ("password", password)), completionHandler: { (userData: UserData?, success: Bool) in
                if success && userData?._status == "ok"  {
                    userData?._user?._password = password
                    GlobalData.saveUserData(userData: userData)
                    self.hideLoadingAnim(collectionView: self.view)
                    if (self.parent as! AccountContainerViewController).pageType == 1 {
                        ShoppingCartViewController.alreadyRequestCheckup = true
                        self.dismiss(animated: false, completion: nil)
                    } else {
                        self.gotoViewController("ProfileViewController")
                    }
                } else {
                    self.hideLoadingAnim(collectionView: self.view)
                    self.showToast(message: "user name or password invalid!")
                }
            })
        })
    }
    
    @objc func signupClicked(_ sender: UITapGestureRecognizer? = nil) {
        gotoViewController("SignupViewController")
    }
    
    func gotoViewController(_ withIdentifier: String) {
        DispatchQueue.main.async {
            let parent = self.parent
            
            self.view.removeFromSuperview()
            self.removeFromParent()
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let signupView = storyboard.instantiateViewController(withIdentifier: withIdentifier)
            
            parent?.addChild(signupView)
            parent?.view.addSubview(signupView.view)
            
            signupView.didMove(toParent: parent)
        }
    }
}
