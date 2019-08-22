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
import Photos
import FirebaseStorage
import FirebaseDatabase
import SVProgressHUD

class ProfileViewController: UIViewController {

    var chosenImage: UIImage?
    var currentUsername: String?
    var currentProfileImageURL: String?
    var currentEmail: String?
    
    let signOutButton: CommonButton = {
        let signOutButton = CommonButton()
        signOutButton.titleText = "Выйти"
        return signOutButton
    }()
    
    let profileImage: UIImageView = {
        let profileImage = UIImageView()
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = UIScreen.main.bounds.width / 8
        profileImage.image = UIImage(named: "profile")?.withRenderingMode(.alwaysTemplate)
        profileImage.contentMode = UIView.ContentMode.center
        profileImage.backgroundColor = UIColor.lightGray
        return profileImage
    }()
    
    let resetPasswordButton: CommonButton = {
        let resetPasswordButton = CommonButton()
        resetPasswordButton.titleText = "Поменять пароль"
        return resetPasswordButton
    }()
    
    let usernameLabel: CommonLabel = {
        let usernameLabel = CommonLabel()
        return usernameLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        SVProgressHUD.show()
        
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        view.addSubview(profileImage)
        profileImage.easy.layout(
            CenterX(),
            Width(width / 4),
            Height(width / 4),
            Top(16).to(topLayoutGuide)
        )
        
        view.addSubview(usernameLabel)
        usernameLabel.easy.layout(
            CenterX(),
            Height(height / 24),
            Top(16).to(profileImage)
        )
        
        view.addSubview(signOutButton)
        signOutButton.easy.layout(
            CenterX(),
            Width(width - width / 8),
            Height(height / 24),
            Bottom(32).to(bottomLayoutGuide)
        )
        signOutButton.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        
        view.addSubview(resetPasswordButton)
        resetPasswordButton.easy.layout(
            CenterX(),
            Width(width - width / 8),
            Height(height / 24),
            Bottom(16).to(signOutButton)
        )
        resetPasswordButton.addTarget(self, action: #selector(resetPassword), for: .touchUpInside)
        
        let userID = Auth.auth().currentUser?.uid
        let reference = Database.database().reference()
        
        DispatchQueue.global(qos: .utility).async {
            // SEND REQUEST HERE
            StorageService.getProfileInfo(success: { (username, profileImageURL) in
                self.currentUsername = username
                if profileImageURL != nil {
                    self.currentProfileImageURL = profileImageURL
                    DispatchQueue.main.async { [weak self] in
                        // UPDATE UI HERE
                        self!.usernameLabel.text = self!.currentUsername
                        let url = NSURL(string: self!.currentProfileImageURL!)
                        if let data = try? Data(contentsOf: url as! URL) {
                            let image = UIImage(data: data)
                            self!.profileImage.contentMode = UIView.ContentMode.scaleToFill
                            self?.profileImage.image = image
                            SVProgressHUD.dismiss()
                        }
                    }
                }
                DispatchQueue.main.async { [weak self] in
                    SVProgressHUD.dismiss()
                    self!.usernameLabel.text = username
                }
            }, failure: { (error) in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            })
//            StorageService.getProfileInfo(success: { (username, profileImageURL) in
//                self.currentUsername = username
//                if profileImageURL != nil {
//                    self.currentProfileImageURL = profileImageURL
//                    DispatchQueue.main.async { [weak self] in
//                        // UPDATE UI HERE
//                        self!.usernameLabel.text = self!.currentUsername
//                        let url = NSURL(string: self!.currentProfileImageURL!)
//                        if let data = try? Data(contentsOf: url as! URL) {
//                            let image = UIImage(data: data)
//                            self!.profileImage.contentMode = UIView.ContentMode.scaleToFill
//                            self?.profileImage.image = image
//                            SVProgressHUD.dismiss()
//                        }
//                    }
//                }
//                DispatchQueue.main.async { [weak self] in
//                    SVProgressHUD.dismiss()
//                    self!.usernameLabel.text = username
//                }
//            }, failure: <#(Error) -> Void#>)
//            reference.child("users").child(userID!).observeSingleEvent(of: .value) { (snapshot) in
//                let value = snapshot.value as! NSDictionary
//                let username = value["username"] as! String
//                self.currentUsername = username
//                let email = value["email"] as! String
//                self.currentEmail = email
//                if value["profileImageURL"] != nil {
//                    let photoURL = value["profileImageURL"] as! String
//                    self.currentProfileImageURL = photoURL
//                    DispatchQueue.main.async { [weak self] in
//                        // UPDATE UI HERE
//                        if self!.currentProfileImageURL != nil {
//                            self!.usernameLabel.text = self!.currentUsername
//                            let url = NSURL(string: self!.currentProfileImageURL!)
//                            if let data = try? Data(contentsOf: url as! URL) {
//                                let image = UIImage(data: data)
//                                self!.profileImage.contentMode = UIView.ContentMode.scaleToFill
//                                self?.profileImage.image = image
//                                SVProgressHUD.dismiss()
//                            }
//                        }
//                    }
//                }
//                DispatchQueue.main.async { [weak self] in
//                    SVProgressHUD.dismiss()
//                    self!.usernameLabel.text = username
//                }
//            }
        }
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.handleSelectImageView))
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
    }
    
    @objc func signOut(){
        FirebaseService.signOut(success: {
            UserDefaults.standard.set(false, forKey: "loggedIn")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = UINavigationController(rootViewController: AuthenticationViewController())
        }) { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }
    }
    
    func showAlert(message: String){
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    @objc func handleSelectImageView() {
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
            PHPhotoLibrary.requestAuthorization { (status: PHAuthorizationStatus) in
                print("Requesting authorization")
            }
        }
        else {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.allowsEditing = true
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true)
            
        }
    }
    
    @objc func resetPassword() {
        FirebaseService.resetPassword(success: {
            self.showAlert(message: "Ссылка на сброс пароля была отправлена на ваш электронный адрес.")
        }) { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }
    }
}

extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard var selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        dismiss(animated: true, completion: nil)
        chosenImage = selectedImage
        profileImage.image = chosenImage
        
        if let currentUser = Auth.auth().currentUser {
            let userID = currentUser.uid
            let storage = Storage.storage().reference().child("profile_image").child(userID)
            let newPhoto = chosenImage
            let imageData = newPhoto!.jpegData(compressionQuality: 0.1 )
            storage.putData(imageData!, metadata: nil, completion: { (_, error) in
                if error != nil {
                    return
                }
                else {
                    storage.downloadURL(completion: { (url, error) in
                        if let profileImageURL = url?.absoluteString {
                            let database = Database.database().reference()
                            let userReference = database.child("users")
                            let newUserReference = userReference.child(userID)
                            
                            let userID = Auth.auth().currentUser?.uid
                            let reference = Database.database().reference()
                            reference.child("users").child(userID!).observeSingleEvent(of: .value) { (snapshot) in
                                let value = snapshot.value as! NSDictionary
                                let username = value["username"] as! String
                                newUserReference.setValue(["email": currentUser.email, "username": username, "profileImageURL": profileImageURL])
                            }
                        }
                    })
                }
            })
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

