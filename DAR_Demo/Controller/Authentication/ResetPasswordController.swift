//
//  ResetPasswordController.swift
//  DAR_Demo
//
//  Created by Dariga Akhmetova on 8/23/19.
//  Copyright © 2019 Dariga Akhmetova. All rights reserved.
//

import UIKit
import EasyPeasy
import SVProgressHUD

class ResetPasswordController: UIViewController {
    
    let emailTextField: UITextField = {
        let emailTextField = UITextField()
        emailTextField.placeholder = "Электронный адрес"
        emailTextField.autocapitalizationType = .none
        emailTextField.borderStyle = .roundedRect
        emailTextField.textColor = CustomColor.violetDark
        return emailTextField
    }()
    
    let resetButton: CommonButton = {
        let resetButton = CommonButton()
        resetButton.titleText = "Сбросить"
        return resetButton
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
        
        view.addSubview(resetButton)
        resetButton.easy.layout(
            CenterX(),
            Width(width - width / 8),
            Height(height / 24),
            Top(16).to(emailTextField)
        )
        resetButton.addTarget(self, action: #selector(reset), for: .touchUpInside)
    }
    
    @objc func reset() {
        FirebaseService.forgotPassword(withEmail: emailTextField.text!, success: {
            SVProgressHUD.showInfo(withStatus: "Ссылка на сброс пароля была отправлена на ваш электронный адрес.")
            self.navigationController?.popViewController(animated: true)
            SVProgressHUD.dismiss()
        }) { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }
    }
}

extension ResetPasswordController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
