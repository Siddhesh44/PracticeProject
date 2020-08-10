//
//  UserItem.swift
//  PracticeProject
//
//  Created by Siddhesh jadhav on 08/08/20.
//  Copyright © 2020 infiny. All rights reserved.
//

import Foundation
import Firebase

struct UserItem {
    let ref: DatabaseReference?
    let key: String
    var item: [String]
    var itemKeys: [String]
    
    
    init(key: String = "",item: String) {
        self.ref = nil
        self.key = key
        self.item = [item]
        self.itemKeys = []
    }
    
    init?(snapshot: DataSnapshot) {
        self.item = []
        self.itemKeys = []
        if let value = snapshot.value as? [String: String]{
            print("values",value)
            let keys = value.keys
            itemKeys.append(contentsOf: keys)
            for key in keys{
                self.item.append(value[key] ?? "undefined")
            }
        }
        self.ref = snapshot.ref
        self.key = snapshot.key
    }
    
    
}

