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

class LoginUIViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var loginEmail: UITextField!
    @IBOutlet weak var loginPass: UITextField!
    
    @IBAction func signIn(_ sender: AnyObject) {
        FIRAuth.auth()?.signIn(withEmail: loginEmail.text!, password: loginPass.text!) { (user, error) in
            if error != nil{
                print(error.debugDescription)
                self.showError(error: error!)
            }else{
                self.movetoHome()
            }
        }
    }
    @IBAction func registerUser(_ sender: AnyObject) {
        FIRAuth.auth()?.createUser(withEmail: loginEmail.text!, password: loginPass.text!) { (user, error) in
            if error != nil {
                print(error.debugDescription)
                self.showError(error: error!)
            }else{
                let ref = FIRDatabase.database().reference()
                ref.child("users").child((user?.uid)!).setValue(["email" : "test"])
                self.movetoHome()
            }
        }
    }
    
    func showError(error: Error){
        var message:String!
        var code = FIRAuthErrorCode(rawValue: error._code)
        switch(code!){
        case FIRAuthErrorCode.errorCodeInvalidEmail:
            message = "The email you entered is not valid."
        case FIRAuthErrorCode.errorCodeEmailAlreadyInUse:
            message = "This email is already in use."
        case FIRAuthErrorCode.errorCodeWrongPassword:
            message = "Invalid password."
        case FIRAuthErrorCode.errorCodeWeakPassword:
            message = "Password must be at least 6 characters."
        default:
            message = "An unknown error has occured. (\(Int((code?.rawValue)!)))";
        }
        
        
        
        if(loginPass.text?.isEmpty)!{
            message = "Password has not been entered."
        }
        
        if(loginEmail.text?.isEmpty)!{
            message = "Email has not been entered."
        }
        
        
        
        let alert = UIAlertController(title: "Oops!", message: "\(message!) Please try again.", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil));
        self.present(alert, animated: true, completion: nil)

    }
    
    func movetoHome() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "homeVC")
        self.present(vc!, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loginPass.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
