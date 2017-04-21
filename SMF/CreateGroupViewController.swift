//
//  CreateGroupViewController.swift
//  SMF
//
//  Created by Iris Inami on 2017-03-23.
//  Copyright © 2017 Iris Inami. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class CreateGroupViewController: UIViewController {

    @IBOutlet weak var groupNameText: UITextField!
    @IBOutlet weak var groupidText: UITextField!
    @IBOutlet weak var groupDescriptionText: UITextField!
    @IBOutlet weak var groupTagsText: UITextField!
    
    
    
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
    
    @IBAction func createGroup(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Confirmation", message: "Are you sure you would like to create this group?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in
            let group = self.database.child("groups").childByAutoId()
            let key = group.key
            
            let tags = self.groupTagsText.text?.replacingOccurrences(of: " ", with: "").components(separatedBy: ",")
            
            if((tags?.count)! > 0 && (self.groupNameText.text?.characters.count)! > 0 && (self.groupidText.text?.characters.count)! > 0 && (self.groupDescriptionText.text?.characters.count)! > 0){
            self.database.child("groups").child(key).child("groupname").setValue(self.groupNameText.text)
            self.database.child("groups").child(key).child("groupscreenid").setValue(self.groupidText.text)
            self.database.child("groups").child(key).child("creatorid").setValue(self.uid)
            self.database.child("groups").child(key).child("groupshortdescription").setValue(self.groupDescriptionText.text)
            self.database.child("groups").child(key).child("membercount").setValue(0)
            self.database.child("groups").child(key).child("postcount").setValue(0)
            
            for(tag) in tags!{
                self.database.child("groups").child(key).child("grouptags").child(tag).setValue(true)
            }
            
            let timestamp:Int = Int(Date().timeIntervalSince1970)
            self.database.child("groups").child(key).child("unixstamp").setValue(timestamp)
            
            self.navigationController?.popViewController(animated: true)
            }else{
                let error = UIAlertController(title: "Incomplete", message: "Parts of the form were incomplete. Please make sure that all fields are filled out properly.", preferredStyle: UIAlertControllerStyle.alert)
                error.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(error, animated:true, completion: nil)
            }
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
