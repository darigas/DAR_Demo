//
//  ViewController.swift
//  DAR_Demo
//
//  Created by Dariga Akhmetova on 7/11/19.
//  Copyright © 2019 Dariga Akhmetova. All rights reserved.
//

import UIKit
import FirebaseUI
import EasyPeasy
import FirebaseAuth
import GoogleSignIn

class ViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    
    let loginLabel: UILabel = {
        let loginLabel = UILabel()
        loginLabel.textColor = .black
        loginLabel.text = "Добро пожаловать в MovieMate!"
        return loginLabel
    }()
    
    let signUpButton: CommonButton = {
        let signUpButton = CommonButton()
        signUpButton.titleText = "Зарегестрироваться"
        return signUpButton
    }()
    
    let signInButton: CommonButton = {
        let signInButton = CommonButton()
        signInButton.titleText = "Войти"
        return signInButton
    }()
    
    let googleSignInButton: CommonButton = {
        let googleSignInButton = CommonButton()
        googleSignInButton.titleText = "Войти с помощью Google"
        return googleSignInButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        super.viewWillAppear(true)
//
//        GIDSignIn.sharedInstance()?.delegate = self
//        GIDSignIn.sharedInstance()?.uiDelegate = self
        
        view.backgroundColor = .white
        
        view.addSubview(loginLabel)
        loginLabel.easy.layout(
            CenterX(),
            TopMargin(64)
        )
        
        view.addSubview(signUpButton)
        signUpButton.easy.layout(
            CenterX(),
            Width(250),
            Top(16).to(loginLabel)
        )
        signUpButton.addTarget(self, action: #selector(goToSignUp), for: .touchUpInside)
        
        view.addSubview(signInButton)
        signInButton.easy.layout(
            CenterX(),
            Width(250),
            Top(16).to(signUpButton)
        )
        signInButton.addTarget(self, action: #selector(goToSignIn), for: .touchUpInside)
        
        view.addSubview(googleSignInButton)
        googleSignInButton.easy.layout(
            CenterX(),
            Width(250),
            Top(16).to(signInButton)
        )
        googleSignInButton.addTarget(self, action: #selector(googleSignIn), for: .touchUpInside)
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error != nil){
            print(error.localizedDescription)
        }
        else{
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            print("User email address \(String(describing: email))")
            let controller = BottomNavigationController()
//            self.present(controller, animated: true)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print(error.localizedDescription)
    }
    
    @objc func goToSignUp(){
        let controller = SignUpViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func goToSignIn(){
        let controller = SignInViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func googleSignIn(){
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.uiDelegate = self
    }
}
