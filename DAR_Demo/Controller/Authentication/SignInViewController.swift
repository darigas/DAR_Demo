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
import SVProgressHUD

class SignInViewController: UIViewController {
    
    let emailTextField: UITextField = {
        let emailTextField = UITextField()
        emailTextField.placeholder = "Электронный адрес"
        emailTextField.autocapitalizationType = .none
        emailTextField.borderStyle = .roundedRect
        emailTextField.textColor = CustomColor.violetDark
        return emailTextField
    }()
    
    let passwordTextField: UITextField = {
        let passwordTextField = UITextField()
        passwordTextField.placeholder = "Пароль"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.textColor = CustomColor.violetDark
        return passwordTextField
    }()
    
    let signInButton: CommonButton = {
        let signInButton = CommonButton()
        signInButton.titleText = "Войти"
        return signInButton
    }()
    
    let forgotPasswordLabel: CommonLabel = {
        let forgotPasswordLabel = CommonLabel()
        forgotPasswordLabel.text = "Забыли пароль?"
        return forgotPasswordLabel
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
        
        view.addSubview(forgotPasswordLabel)
        forgotPasswordLabel.easy.layout(
            CenterX(),
            Height(height / 24),
            Top(16).to(signInButton)
        )
        
        let forgotPasswordLabelTap = UITapGestureRecognizer(target: self, action: #selector(forgotPasswordLabelTapped))
        forgotPasswordLabel.isUserInteractionEnabled = true
        forgotPasswordLabel.addGestureRecognizer(forgotPasswordLabelTap)
    }
    
    @objc func signIn(){
        if (emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty){
            self.showAlert(message: "Необходимо заполнить все поля!")
        }
        else {
            SVProgressHUD.show()
            FirebaseService.signIn_(withEmail: emailTextField.text!, password: passwordTextField.text!, success: {
                SVProgressHUD.dismiss()
                UserDefaults.standard.set(true, forKey: "loggedIn")
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = TabBarController()
                appDelegate.window?.tintColor = CustomColor.violetLight
            }) { (error) in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }
        }
    }
    
    @objc func forgotPasswordLabelTapped(){
        let controller = ResetPasswordController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func showAlert(message: String){
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        alert.view.tintColor = CustomColor.violetDark
        alert.setValue(NSAttributedString(string: alert.title!, attributes: [NSAttributedString.Key.foregroundColor : CustomColor.violetDark]), forKey: "attributedTitle")
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
