//
//  EditProfileViewController.swift
//  SMF
//
//  Created by Iris Inami on 2017-03-18.
//  Copyright © 2017 Iris Inami. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class EditProfileViewController: UIViewController {

    @IBOutlet weak var screenNameText: UITextField!
    @IBOutlet weak var accountidText: UITextField!
    @IBOutlet weak var descriptionText: UITextField!
    
    var database:FIRDatabaseReference!
    var uid = FIRAuth.auth()?.currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        database = FIRDatabase.database().reference()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func updateUserInfo(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Confirmation", message: "Are you sure you would like to update your account information?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in
            if((self.screenNameText.text?.characters.count)! > 0){
                self.database.child("users").child(self.uid!).child("screenname").setValue(self.screenNameText.text)
            }
            
            if((self.accountidText.text?.characters.count)! > 0){
                self.database.child("users").child(self.uid!).child("accountid").setValue(self.accountidText.text)
            }
            
            if((self.descriptionText.text?.characters.count)! > 0){
                self.database.child("users").child(self.uid!).child("shortdescription").setValue(self.descriptionText.text)
            }
            
            
            self.navigationController?.popViewController(animated: true)
            //self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 2]
        }));
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        
        self.present(alert, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
