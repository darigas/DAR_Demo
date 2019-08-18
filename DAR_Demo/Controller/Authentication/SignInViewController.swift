//
//  SignInViewController.swift
//  DAR_Demo
//
//  Created by Dariga Akhmetova on 7/14/19.
//  Copyright © 2019 Dariga Akhmetova. All rights reserved.
//

import UIKit
import EasyPeasy
import Firebase
import FirebaseAuth

class SignInViewController: UIViewController {
    
    let emailTextField: UITextField = {
        let emailTextField = UITextField()
        emailTextField.placeholder = "Электронный адрес"
        emailTextField.autocapitalizationType = .none
        emailTextField.borderStyle = .roundedRect
        emailTextField.font = CustomFont.marion
        emailTextField.textColor = CustomColor.violetDark
        return emailTextField
    }()
    
    let passwordTextField: UITextField = {
        let passwordTextField = UITextField()
        passwordTextField.placeholder = "Пароль"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.font = CustomFont.marion
        passwordTextField.textColor = CustomColor.violetDark
        return passwordTextField
    }()
    
    let signInButton: CommonButton = {
        let signInButton = CommonButton()
        signInButton.titleText = "Войти"
        return signInButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = CustomColor.sunset
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = CustomColor.violetLight
        
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        view.addSubview(emailTextField)
        emailTextField.easy.layout(
            CenterX(),
            Width(width - width / 8),
            Height(height / 24),
            Top(16).to(topLayoutGuide)
        )
        emailTextField.delegate = self
        
        view.addSubview(passwordTextField)
        passwordTextField.easy.layout(
            CenterX(),
            Width(width - width / 8),
            Height(height / 24),
            Top(16).to(emailTextField)
        )
        passwordTextField.delegate = self
        
        view.addSubview(signInButton)
        signInButton.easy.layout(
            CenterX(),
            Width(width - width / 8),
            Height(height / 24),
            Top(16).to(passwordTextField)
        )
        signInButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
    }
    
    @objc func signIn(){
        if (emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty){
            self.showAlert(message: "Необходимо заполнить все поля!")
        }
        else {
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if (error == nil){
                    if let user = user {
                        _ = user.user.displayName
                        let user_email = user.user.email
                        print(user_email!)
                    }
                    UserDefaults.standard.set(true, forKey: "loggedIn")
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = TabBarController()
                    appDelegate.window?.tintColor = CustomColor.violetLight
                }
                else {
                    if let errorCode = AuthErrorCode(rawValue: error!._code){
                        switch errorCode{
                        case .wrongPassword:
                            self.showAlert(message: "Invalid Password. Try Again!")
                        case .userNotFound:
                            self.showAlert(message: "User Not Found. Try Again!")
                        default:
                            self.showAlert(message: "Unexpected Error. Try Again!")
                        }
                    }
                }
            }
        }
    }
    
    func showAlert(message: String){
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        alert.view.tintColor = CustomColor.violetDark
        alert.setValue(NSAttributedString(string: alert.title!, attributes: [NSAttributedString.Key.font : CustomFont.marion, NSAttributedString.Key.foregroundColor : CustomColor.violetDark]), forKey: "attributedTitle")
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        action.setValue(CustomColor.violetDark, forKey: "titleTextColor")
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
