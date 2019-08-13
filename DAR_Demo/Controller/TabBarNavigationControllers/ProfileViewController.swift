//
//  ProfileViewController.swift
//  DAR_Demo
//
//  Created by Dariga Akhmetova on 8/12/19.
//  Copyright © 2019 Dariga Akhmetova. All rights reserved.
//

import UIKit
import EasyPeasy
import Firebase
import FirebaseAuth
import GoogleSignIn

class ProfileViewController: ViewController {

    let signOutButton: CommonButton = {
        let signOutButton = CommonButton()
        signOutButton.titleText = "Выйти"
        return signOutButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(signOutButton)
        signOutButton.easy.layout(
            CenterX(),
            Width(150),
            Top(16).to(topLayoutGuide)
        )
        signOutButton.addTarget(self, action: #selector(signOut), for: .touchUpInside)
    }
    
    @objc func signOut(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            GIDSignIn.sharedInstance()?.signOut()
            let controller = ViewController()
            self.navigationController?.popToRootViewController(animated: true)
        }
        catch let signOutError as NSError {
            self.showAlert(message: signOutError.localizedDescription)
        }
    }
    
    func showAlert(message: String){
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}

extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
