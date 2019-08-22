//
//  FirebaseService.swift
//  DAR_Demo
//
//  Created by Dariga Akhmetova on 8/22/19.
//  Copyright © 2019 Dariga Akhmetova. All rights reserved.
//

import Foundation
import FirebaseUI
import FirebaseAuth
import GoogleSignIn
import FirebaseDatabase
import FirebaseStorage
import SVProgressHUD

class FirebaseService {
    static func signIn_(withEmail email: String, password: String, success: @escaping() -> Void, failure: @escaping(Error) -> Void){
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            if error != nil {
                failure(error!)
                return
            }
            success()
        }
    }
    
    static func signUp(withEmail email: String, password: String, username: String, image: UIImage?, success: @escaping() -> Void, failure: @escaping(Error) -> Void){
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            if error != nil {
                failure(error!)
                return
            }
            let userID = authDataResult?.user.uid
            
            let storage = Storage.storage().reference().child("profile_image").child(userID!)
            
            if let chosenImage = image {
                guard let imageData = chosenImage.jpegData(compressionQuality: 0.1) else {
                    return
                }
                StorageService.putProfileImage(withEmail: email, username: username, userID: userID!, data: imageData, success: {
                    success()
                }, failure: { (error) in
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                })
//                storage.putData(imageData, metadata: nil, completion: { (metadata, error) in
//                    if error != nil {
//                        failure(error!)
//                        return
//                    }
//                    storage.downloadURL(completion: { (url, error) in
//                        if let profileImageURL = url?.absoluteString {
//                            let database = Database.database().reference()
//                            let userReference = database.child("users")
//                            let newUserReference = userReference.child(userID!)
//                            newUserReference.setValue(["email": email, "username": username, "profileImageURL": profileImageURL])
//                        }
//                    })
//                })
            }
            else {
                ReferenceService.newUserReference(withEmail: email, username: username, userID: userID!, success: {
                    success()
                })
//                let database = Database.database().reference()
//                let userReference = database.child("users")
//                let newUserReference = userReference.child(userID!)
//                newUserReference.setValue(["email": email, "username": username, "profileImageURL":  nil])
            }
        }
//        success()
    }
    
    static func signOut(success: @escaping() -> Void, failure: @escaping(Error) -> Void){
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance()?.signOut()
        }
        catch let signOutError {
            failure(signOutError)
        }
        success()
    }
    
    static func resetPassword(success: @escaping() -> Void, failure: @escaping(Error) -> Void){
        Auth.auth().sendPasswordReset(withEmail: (Auth.auth().currentUser?.email)!) { (error) in
            if error != nil {
                failure(error!)
            }
            success()
        }
    }
    
    static func forgotPassword(withEmail email: String, success: @escaping() -> Void, failure: @escaping(Error) -> Void){
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error != nil {
                failure(error!)
            }
            success()
        }
    }
    
    static func sendEmailVerification(failure: @escaping(Error) -> Void){
        Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
            if error != nil {
                failure(error!)
            }
        })
    }
    
    static var currentUser: User {
        return Auth.auth().currentUser!
    }
    
    static var currentUserID: String {
        return Auth.auth().currentUser!.uid
    }
}
