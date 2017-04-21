//
//  ReplyMessageViewController.swift
//  SMF
//
//  Created by Iris Inami on 2017-03-24.
//  Copyright © 2017 Iris Inami. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ReplyMessageViewController: UIViewController {

    @IBOutlet weak var bodyText: UITextField!
    
    var threadid:String!
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
    
    @IBAction func createPost(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Confirmation", message: "Are you sure you would like to post this message?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in
            let post:FIRDatabaseReference = self.database.child("posts").child(self.threadid).childByAutoId()
            let postid = post.key
            
            if((self.bodyText.text?.characters.count)! > 0){
            self.database.child("posts").child(self.threadid).child(postid).child("userid").setValue(self.uid)
            self.database.child("posts").child(self.threadid).child(postid).child("content").setValue(self.bodyText.text)
            let timestamp = Int(Date().timeIntervalSince1970)
            self.database.child("posts").child(self.threadid).child(postid).child("unixstamp").setValue(timestamp)
            
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
