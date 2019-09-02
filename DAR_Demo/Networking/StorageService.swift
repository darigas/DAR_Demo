//
//  StorageService.swift
//  DAR_Demo
//
//  Created by Dariga Akhmetova on 8/23/19.
//  Copyright © 2019 Dariga Akhmetova. All rights reserved.
//

import Foundation
import FirebaseUI
import FirebaseAuth
import GoogleSignIn
import FirebaseDatabase
import FirebaseStorage

class StorageService {
    
    static func createReferenceGoogle(withEmail email: String, username: String, userID: String){
        ReferenceService.usersReference.observeSingleEvent(of: .value) { (snapshot) in 
            if snapshot.hasChild(userID) ==  false {
                ReferenceService.newUserReference(withEmail: email, username: username, userID: userID, success: {
                    print("New Google User")
                })
            }
        }
    }
    
    static func putProfileImage(withEmail email: String, username: String, userID: String, data: Data, success: @escaping() -> Void, failure: @escaping(Error) -> Void){
        let storage = Storage.storage().reference().child("profile_image").child(userID)
        
        storage.putData(data, metadata: nil) { (metadata, error) in
            if error != nil {
                failure(error!)
                return
            }
            storage.downloadURL(completion: { (url, error) in
                if let profileImageURL = url?.absoluteString {
                    ReferenceService.newUserReferenceWithImage(withEmail: email, username: username, userID: userID, profileImageURL: profileImageURL, success: {
                        success()
                    })
                }
            })
        }
    }
    
    static func getProfileInfo(success: @escaping(_ username: String, _ profileImageURL: String?) -> Void, failure: @escaping(Error) -> Void) {
        let userID = FirebaseService.currentUserID
        let reference = ReferenceService.usersReference
        
        reference.child(userID).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as! NSDictionary
            let username = value["username"] as! String
            if  value["profileImageURL"] != nil {
                let profileImageURL = value["profileImageURL"] as! String
                success(username, profileImageURL)
            }
            success(username, nil)
        }
    }
    
    static func changeProfileImage(data: Data, success: @escaping() -> Void, failure: @escaping(Error) -> Void){
        let userID = FirebaseService.currentUserID
        let storage = Storage.storage().reference().child("profile_image").child(userID)
        
        storage.putData(data, metadata: nil) { (metadata, error) in
            if error != nil {
                failure(error!)
            }
            storage.downloadURL(completion: { (url, error) in
                if let profileImageURL = url?.absoluteString {
                    let userID = FirebaseService.currentUserID
                    let reference = ReferenceService.usersReference
                    reference.child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                        let value = snapshot.value as! NSDictionary
                        let username = value["username"] as! String
                        reference.child(userID).setValue(["email": FirebaseService.currentUser.email, "username": username, "profileImageURL": profileImageURL])
                    })
                }
            })
        }
        success()
    }
}
