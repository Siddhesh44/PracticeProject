//
//  UserList.swift
//  PracticeProject
//
//  Created by Siddhesh jadhav on 10/08/20.
//  Copyright © 2020 infiny. All rights reserved.
//

import Foundation
import Firebase

struct UserList {
    let ref: DatabaseReference?
    let key: String
    var list: String
    
    init(key: String = "",item: String) {
        self.ref = nil
        self.key = key
        self.list = item
    }
    
    init?(snapshot: DataSnapshot) {
//        guard
//            let value = snapshot.value as? [String: String] else {
//                return nil
//        }
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.list = snapshot.value as? String ?? "null"//snapshot.value(forKey: key) as? String ?? "null"
        
    }
    
    
}
