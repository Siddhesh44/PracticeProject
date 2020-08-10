//
//  firebaseVC.swift
//  PracticeProject
//
//  Created by Siddhesh jadhav on 10/08/20.
//  Copyright © 2020 infiny. All rights reserved.
//

import UIKit
import Firebase

class firebaseVC: UIViewController {
    
    var user: User!
    var lists: [UserList] = []
    
    let ref = Database.database().reference(withPath: "List")
    var userRef: DatabaseReference?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addList))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(self.userLogout))
        
        
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
            print("User id",user.uid)
        }
        
        ref.observe(.value) { (SnapShot) in
            print("SnapShot",SnapShot)
            var newList: [UserList] = []
            for child in SnapShot.children{
                print("child",child)
                
                if let child = child.self as? DataSnapshot{
                    if let listValue = UserList(snapshot: child){
                        newList.append(listValue)
                    }
                }
            }
            self.lists = newList
            print("List arrat",self.lists)
            self.tableView.reloadData()
        }
        
    }
    
    
    @objc func userLogout() {
        let user = Auth.auth().currentUser!
        let onlineRef = Database.database().reference(withPath: "online/\(user.uid)")
        
        onlineRef.removeValue { (error, _) in
            
            if let error = error {
                print("Removing online failed: \(error)")
                return
            }
            
            do {
                try Auth.auth().signOut()
                self.navigationController?.popViewController(animated: true)
            } catch (let error) {
                print("Auth sign out failed: \(error)")
            }
        }
    }
    
    @objc func addList() {
        
        let alert = UIAlertController(title: "Add To List",message: "", preferredStyle: .alert)
        
        alert.addTextField()
        
        let saveAction = UIAlertAction(title: "Save", style: .default){ _ in
            let textFieldInput = alert.textFields![0]
            
            let listRef = self.ref.childByAutoId()
            
            listRef.setValue(textFieldInput.text!)
        }
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .default)
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        present(alert, animated: true, completion: nil)
        
    }
}


extension firebaseVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! listCell
        cell.textLabel?.text = lists[indexPath.row].list
        return cell
    }
    
    
}
