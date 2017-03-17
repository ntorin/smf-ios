//
//  LoginUIViewController.swift
//  SMF
//
//  Created by Iris Inami on 2016-10-01.
//  Copyright © 2016 Iris Inami. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginUIViewController: UIViewController {
    
    
    @IBOutlet weak var loginEmail: UITextField!
    @IBOutlet weak var loginPass: UITextField!
    
    @IBAction func signIn(_ sender: AnyObject) {
        FIRAuth.auth()?.signIn(withEmail: loginEmail.text!, password: loginPass.text!) { (user, error) in
            if error != nil{
                print(error?.localizedDescription)
            }else{
                self.movetoHome()
            }
        }
    }
    @IBAction func registerUser(_ sender: AnyObject) {
        FIRAuth.auth()?.createUser(withEmail: loginEmail.text!, password: loginPass.text!) { (user, error) in
            if error != nil {
                print(error?.localizedDescription)
            }else{
                let ref = FIRDatabase.database().reference()
                ref.child("users").child((user?.uid)!).setValue(["email" : "test"])
                self.movetoHome()
            }
        }
    }
    
    func movetoHome() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "homeVC")
        self.present(vc!, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
