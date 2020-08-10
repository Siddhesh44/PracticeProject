//
//  LoginVC.swift
//  PracticeProject
//
//  Created by Siddhesh jadhav on 07/08/20.
//  Copyright © 2020 infiny. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
    
    
    @IBOutlet weak var loginEmailTxt: UITextField!
    @IBOutlet weak var loginPasswordTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                let storyBoard = UIStoryboard(name: "FirebaseStory", bundle: nil)
                let nextVC = storyBoard.instantiateViewController(withIdentifier: "ThoughtsListTableVC") as! ThoughtsListTableVC
                self.navigationController?.pushViewController(nextVC, animated: true)
                
                self.loginEmailTxt.text = nil
                self.loginPasswordTxt.text = nil
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        
        guard
            let email = loginEmailTxt.text,
            let password = loginPasswordTxt.text,
            email.count > 0,
            password.count > 0
            else {
                return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let error = error, user == nil {
                let alert = UIAlertController(title: "Sign In Failed",
                                              message: error.localizedDescription,
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func signUpBtnPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "New User?",
                                      message: "Register Here!",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            let emailField = alert.textFields![0]
            let passwordField = alert.textFields![1]
            
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { user, error in
                if error == nil {
                    Auth.auth().signIn(withEmail: self.loginEmailTxt.text!,
                                       password: self.loginPasswordTxt.text!)
                }
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        alert.addTextField { textEmail in
            textEmail.placeholder = "Enter your email"
        }
        
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}

extension LoginVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginEmailTxt {
            loginPasswordTxt.becomeFirstResponder()
        }
        if textField == loginPasswordTxt {
            textField.resignFirstResponder()
        }
        return true
    }
}

