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
import FirebaseDatabase
import FirebaseStorage
import SVProgressHUD

class AuthenticationViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    
    let loginLabel: CommonLabel = {
        let loginLabel = CommonLabel()
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
    
    let backgroundImage: UIImageView = {
        let backgroundImage = UIImageView()
        backgroundImage.image = UIImage(named: "cinema")?.withRenderingMode(.alwaysTemplate)
        backgroundImage.tintColor = CustomColor.violetLight
        backgroundImage.contentMode = UIView.ContentMode.center
        return backgroundImage
    }()
    
    let bottomView: UIImageView = {
        let bottomView = UIImageView()
        bottomView.backgroundColor = CustomColor.sunset
        bottomView.layer.cornerRadius = UIScreen.main.bounds.width * 1.5 / 2
        bottomView.clipsToBounds = true
        return bottomView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        view.addSubview(backgroundImage)
        backgroundImage.easy.layout(
            Top(0).to(topLayoutGuide),
            Left(),
            Right(),
            Height(height / 2)
        )
        
        view.addSubview(bottomView)
        bottomView.easy.layout(
            Width(width * 1.5),
            Height(width * 1.5),
            CenterX(),
            Top(-height / 8).to(backgroundImage)
        )
        
        view.addSubview(googleSignInButton)
        googleSignInButton.easy.layout(
            CenterX(),
            Width(width - width / 4),
            Height(height / 24),
            Bottom(128)
        )
        
        view.addSubview(signInButton)
        signInButton.easy.layout(
            CenterX(),
            Width(width - width / 4),
            Height(height / 24),
            Bottom(16).to(googleSignInButton)
        )
        
        view.addSubview(signUpButton)
        signUpButton.easy.layout(
            CenterX(),
            Width(width - width / 4),
            Height(height / 24),
            Bottom(16).to(signInButton)
        )
        
        view.addSubview(loginLabel)
        loginLabel.easy.layout(
            CenterX(),
            Height(height / 24),
            Bottom(16).to(signUpButton)
        )
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error != nil){
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }
        else{
            SVProgressHUD.show()
            let fullName = user.profile.name
            let email = user.profile.email
            
            guard let idToken = user.authentication.idToken else {return}
            guard let accessToken = user.authentication.accessToken else {return}
            let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            Auth.auth().signInAndRetrieveData(with: credentials) { (user, error) in
                if error != nil {
                    SVProgressHUD.showError(withStatus: error?.localizedDescription)
                }
                let userID = user?.user.uid
                StorageService.createReferenceGoogle(withEmail: email!, username: fullName!, userID: userID!, success: {
                    SVProgressHUD.dismiss()
                    UserDefaults.standard.set(true, forKey: "loggedIn")
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = TabBarController()
                    appDelegate.window?.tintColor = CustomColor.violetLight
                })
//
//                let database = Database.database().reference()
//                let userReference = database.child("users")
//                userReference.observeSingleEvent(of: .value, with: { (snapshot) in
//                    if snapshot.hasChild(userID!) {
//                        print("User logged in with Google Sign-In")
//                    }
//                    else {
//                        let newUserReference = userReference.child(userID!)
//                        newUserReference.setValue(["email": email, "username": fullName, "profileImageURL": nil])
//                    }
//                })
            }
//            UserDefaults.standard.set(true, forKey: "loggedIn")
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.window?.rootViewController = TabBarController()
//            appDelegate.window?.tintColor = CustomColor.violetLight
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        SVProgressHUD.showError(withStatus: error.localizedDescription)
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
        signUpButton.addTarget(self, action: #selector(goToSignUp), for: .touchUpInside)
        signInButton.addTarget(self, action: #selector(goToSignIn), for: .touchUpInside)
        googleSignInButton.addTarget(self, action: #selector(googleSignIn), for: .touchUpInside)
    }
}
