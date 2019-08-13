//
//  SignUpViewController.swift
//  DAR_Demo
//
//  Created by Dariga Akhmetova on 7/14/19.
//  Copyright © 2019 Dariga Akhmetova. All rights reserved.
//

import UIKit
import EasyPeasy
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Photos

class SignUpViewController: UIViewController {
    
    var chosenImage: UIImage?
    
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
    
    let signUpButton: CommonButton = {
        let signUpButton = CommonButton()
        signUpButton.titleText = "Sign Up"
        return signUpButton
    }()
    
    let usernameTextField: UITextField = {
        let usernameTextField = UITextField()
        usernameTextField.placeholder = "Username"
        usernameTextField.borderStyle = .roundedRect
        return usernameTextField
    }()
    
    let profileImage: UIImageView = {
        let profileImage = UIImageView()
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = 50
        profileImage.image = UIImage(named: "profile")
        profileImage.backgroundColor = UIColor.lightGray
        return profileImage
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        view.backgroundColor = .yellow
        
//        func checkPermission() {
//            let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
//            switch photoAuthorizationStatus {
//            case .authorized:
//                print("Access is granted by user.")
//            case .notDetermined:
//                PHPhotoLibrary.requestAuthorization { (newStatus) in
//                    print("status is \(newStatus)")
//                    if newStatus == PHAuthorizationStatus.authorized {
//                        print("Authorized.")
//                    }
//                }
//            case .restricted:
//                print("User does not have access to photo album.")
//            case .denied:
//                print("User has denied the permission")
//            default:
//                print("Unknown problem.")
//            }
//        }
        
        view.addSubview(profileImage)
        profileImage.easy.layout(
            CenterX(),
            Width(100),
            Height(100),
            Top(16).to(topLayoutGuide)
        )
        
        view.addSubview(emailTextField)
        emailTextField.easy.layout(
            Width(400),
            Height(40),
            CenterX(),
            Top(16).to(profileImage)
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
        
        view.addSubview(usernameTextField)
        usernameTextField.easy.layout(
            Width(400),
            Height(40),
            CenterX(),
            Top(16).to(passwordTextField)
        )
        usernameTextField.delegate = self
        
        view.addSubview(signUpButton)
        signUpButton.easy.layout(
            CenterX(),
            Width(150),
            Top(16).to(usernameTextField)
        )
        
        signUpButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.handleSelectImageView))
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
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
    
    @objc func signUp(){
        if (emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty || usernameTextField.text!.isEmpty){
            self.showAlert(message: "Filling out all fields are obligatory!")
            return
        }
        else {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authResult, error) in
                if (error == nil){
                    
                    let userID = authResult?.user.uid
                    
                    let storage = Storage.storage().reference().child("profile_image").child(userID!)
                    if let profileImage = self.chosenImage {
                        let imageData = profileImage.jpegData(compressionQuality: 0.1 )
                        storage.putData(imageData!, metadata: nil, completion: { (_, error) in
                            if error != nil {
                                return
                            }
                            else {
                                storage.downloadURL(completion: { (url, error) in
                                    if let profileImageURL = url?.absoluteString {
                                        let database = Database.database().reference()
                                        let userReference = database.child("users")
                                        let newUserReference = userReference.child(userID!)
                                        newUserReference.setValue(["email": self.emailTextField.text!, "username": self.usernameTextField.text!, "profileImageURL": profileImageURL])
                                    }
                                })
                            }
                        })
                    }
                    UserDefaults.standard.set(true, forKey: "loggedIn")
//                    let controller = BottomNavigationController()
//                    self.navigationController?.pushViewController(controller, animated: true)
                }
                else {
                    self.showAlert(message: (error!.localizedDescription))
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

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard var selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        dismiss(animated: true, completion: nil)
        chosenImage = selectedImage
        profileImage.image = chosenImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
