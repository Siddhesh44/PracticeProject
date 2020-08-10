//
//  ThoughtsListTableVC.swift
//  PracticeProject
//
//  Created by Siddhesh jadhav on 07/08/20.
//  Copyright © 2020 infiny. All rights reserved.
//

import UIKit
import Firebase

class ThoughtsListTableVC: UIViewController {
    
    @IBOutlet weak var listTableView: UITableView!
    
    var user: User!
    var items: [UserItem] = []
    
    let ref = Database.database().reference(withPath: "Users Thoughts")
    var userRef: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Thoughts List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addThoughts))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(self.userLogout))
        
        listTableView.delegate = self
        listTableView.dataSource = self
        
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
            self.userRef = self.ref.child(user.uid)
        }
        
        
        ref.observe(.value, with: { (Snapshot) in
            var newItems: [UserItem] = []
            let child = Snapshot.childSnapshot(forPath: self.user.uid)
                print("child",child)
                    if let itemValue = UserItem(snapshot: child){
                    newItems.append(itemValue)
                }
                
            
            self.items = newItems
            print("items array",self.items)
            self.listTableView.reloadData()
        })
        
        
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
    
    @objc func addThoughts() {
        
        let alert = UIAlertController(title: "Have a Thought?",message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "What's in your mind?"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default){ _ in
            let textFieldInput = alert.textFields![0]
            
            let itemsRef = self.userRef!.childByAutoId()
            
            itemsRef.setValue(textFieldInput.text!)
            
        }
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .default)
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        present(alert, animated: true, completion: nil)
        
    }
}

extension ThoughtsListTableVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if items.isEmpty{
            return items.count
        }else{
            return items[0].item.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThougthsListCell", for: indexPath) as! ThougthsListCell
        if items.isEmpty{
            return cell
        } else{
            cell.textLabel?.text = items[0].item[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.userRef?.child(self.items[0].itemKeys[indexPath.row]).removeValue()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Edit?",message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = "\(self.items[0].item[indexPath.row])"
        }
        
        let updateAction = UIAlertAction(title: "Update", style: .default){ _ in
            let textFieldInput = alert.textFields![0]
            self.userRef?.updateChildValues([self.items[0].itemKeys[indexPath.row] : "\(textFieldInput.text!)"])
        }
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .default)
        
        alert.addAction(cancelAction)
        alert.addAction(updateAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}
