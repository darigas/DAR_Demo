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
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.autocapitalizationType = .none
        return emailTextField
    }()
    
    let passwordTextField: UITextField = {
        let passwordTextField = UITextField()
        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        return passwordTextField
    }()
    
    let signInButton: CommonButton = {
        let signInButton = CommonButton()
        signInButton.titleText = "Sign In"
        return signInButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .yellow
        self.navigationController?.isNavigationBarHidden = false
        
        view.addSubview(emailTextField)
        emailTextField.easy.layout(
            Width(400),
            Height(40),
            CenterX(),
            Top(16).to(topLayoutGuide)
        )
        emailTextField.delegate = self
        
        view.addSubview(passwordTextField)
        passwordTextField.easy.layout(
            Width(400),
            Height(40),
            CenterX(),
            Top(16).to(emailTextField)
        )
        passwordTextField.delegate = self
        
        view.addSubview(signInButton)
        signInButton.easy.layout(
            CenterX(),
            Width(150),
            Top(16).to(passwordTextField)
        )
        signInButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
    }
    
    @objc func signIn(){
        if (emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty){
            self.showAlert(message: "Filling out all fields are obligatory!")
        }
        else {
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if (error == nil){
                    if let user = user {
                        _ = user.user.displayName
                        let user_email = user.user.email
                        print(user_email!)
                    }
                    let controller = BottomNavigationController()
//                    self.present(controller, animated: true)
                    self.navigationController?.pushViewController(controller, animated: true)
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
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
