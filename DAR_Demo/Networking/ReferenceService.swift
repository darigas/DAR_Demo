//
//  ReferenceService.swift
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

class ReferenceService {
    
    static var usersReference: DatabaseReference {
        let database = Database.database().reference()
        return database.child("users")
    }
    
    static func newUserReference(withEmail email: String, username: String, userID: String, success: @escaping() -> Void) {
        let database = Database.database().reference()
        let usersReference = database.child("users")
        let newUserReference = usersReference.child(userID)
        newUserReference.setValue(["email": email, "username": username, "profileImageURL": nil])
        success()
    }
    
    static func newUserReferenceWithImage(withEmail email: String, username: String, userID: String, profileImageURL: String, success: @escaping() -> Void) {
        let database = Database.database().reference()
        let usersReference = database.child("users")
        let newUserReference = usersReference.child(userID)
        newUserReference.setValue(["email": email, "username": username, "profileImageURL": profileImageURL])
        success()
    }
}
