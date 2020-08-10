//
//  User.swift
//  PracticeProject
//
//  Created by Siddhesh jadhav on 09/08/20.
//  Copyright © 2020 infiny. All rights reserved.
//

import Foundation
import Firebase

struct User {
    
    let uid: String
    let email: String
    
    init(authData: Firebase.User) {
        uid = authData.uid
        email = authData.email!
    }
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
}

