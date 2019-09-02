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
import SVProgressHUD

class SignUpViewController: UIViewController {
    
    var chosenImage: UIImage?
    
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
    
    let usernameTextField: UITextField = {
        let usernameTextField = UITextField()
        usernameTextField.placeholder = "Имя пользователя"
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.textColor = CustomColor.violetDark
        return usernameTextField
    }()
    
    let signUpButton: CommonButton = {
        let signUpButton = CommonButton()
        signUpButton.titleText = "Зарегестрироваться"
        return signUpButton
    }()
    
    let profileImage: UIImageView = {
        let profileImage = UIImageView()
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = UIScreen.main.bounds.width / 8
        profileImage.image = UIImage(named: "profile")?.withRenderingMode(.alwaysTemplate)
        profileImage.contentMode = UIView.ContentMode.center
        profileImage.tintColor = CustomColor.violetDark
        profileImage.backgroundColor = .white
        return profileImage
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = CustomColor.violetLight
        view.backgroundColor = CustomColor.sunset
        
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        view.addSubview(profileImage)
        profileImage.easy.layout(
            CenterX(),
            Width(width / 4),
            Height(width / 4),
            Top(16).to(topLayoutGuide)
        )
        
        view.addSubview(emailTextField)
        emailTextField.easy.layout(
            CenterX(),
            Width(width - width / 8),
            Height(height / 24),
            Top(16).to(profileImage)
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
        
        view.addSubview(usernameTextField)
        usernameTextField.easy.layout(
            CenterX(),
            Width(width - width / 8),
            Height(height / 24),
            Top(16).to(passwordTextField)
        )
        usernameTextField.delegate = self
        
        view.addSubview(signUpButton)
        signUpButton.easy.layout(
            CenterX(),
            Width(width - width / 8),
            Height(height / 24),
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
                print("Requesting authorization.")
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
            self.showAlert(message: "Необходимо заполнить все поля!")
            return
        }
        else {
            SVProgressHUD.show()
            FirebaseService.signUp(withEmail: emailTextField.text!, password: passwordTextField.text!, username: usernameTextField.text!, image: self.chosenImage, success: {
                SVProgressHUD.dismiss()
                FirebaseService.sendEmailVerification(failure: { (error) in
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                })
                UserDefaults.standard.set(true, forKey: "loggedIn")
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = TabBarController()
                appDelegate.window?.tintColor = CustomColor.violetLight
            }) { (error) in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }
        }
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
