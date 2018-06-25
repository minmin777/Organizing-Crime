//
//  ViewController.swift
//  Book App
//
//  Created by Yasmine Ayad on 4/17/18.
//  Copyright © 2018 Yasmine Ayad. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import KeychainSwift

class ViewController: UIViewController{
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        let keyChain = DataService().keyChain
        if keyChain.get("uid") != nil {
            performSegue(withIdentifier: "SignIn", sender: nil)
        }
    }
    
    func CompleteSignIn(id: String){
        let keyChain = DataService().keyChain
        keyChain.set(id , forKey: "uid")
    }
    @IBAction func SignIn(_ sender: Any){
        if let email = emailField.text, let password = passwordField.text {
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if error == nil {
                    self.CompleteSignIn(id: user!.uid)
                    self.performSegue(withIdentifier: "SignIn", sender: nil)
                    print("success!")
                } else{
                    Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                        if error != nil{
                            print("can't sign in user")
                        } else{
                            self.CompleteSignIn(id: user!.uid)
                            self.performSegue(withIdentifier: "SignIn", sender: nil)
                            print("success!")
                        }
                    }
                }
            }
        }
    }
}