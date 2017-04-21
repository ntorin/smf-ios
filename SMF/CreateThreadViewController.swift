//
//  CreateThreadViewController.swift
//  SMF
//
//  Created by Iris Inami on 2017-03-18.
//  Copyright © 2017 Iris Inami. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class CreateThreadViewController: UIViewController {

    
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var bodyText: UITextField!
    @IBOutlet weak var tagsText: UITextField!
    
    
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
    
    @IBAction func createThread(_ sender: AnyObject) {
        print("pressed createThread")
        
        let alert = UIAlertController(title: "Confirmation", message: "Are you sure you would like to create this thread?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in
            let thread:FIRDatabaseReference = self.database.child("threads").childByAutoId()
            let threadid:String = thread.key
            let tags = self.tagsText.text?.replacingOccurrences(of: " ", with: "").components(separatedBy: ",")
            
            if((tags?.count)! > 0 && (self.titleText.text?.characters.count)! > 0 && (self.bodyText.text?.characters.count)! > 0){
            self.database.child("threads").child(threadid).child("userid").setValue(self.uid)
            self.database.child("threads").child(threadid).child("threadtitle").setValue(self.titleText.text)
            
            for(tag) in tags!{
                self.database.child("threads").child(threadid).child("threadtags").child(tag).setValue(true)
            }
            
            let post:FIRDatabaseReference = self.database.child("posts").child(threadid).childByAutoId()
            let postid:String = post.key
            
            self.database.child("posts").child(threadid).child(postid).child("userid").setValue(self.uid)
            self.database.child("posts").child(threadid).child(postid).child("content").setValue(self.bodyText.text)
            let timestamp:Int = Int(Date().timeIntervalSince1970)
            self.database.child("threads").child(threadid).child("unixstamp").setValue(timestamp)
            self.database.child("posts").child(threadid).child(postid).child("unixstamp").setValue(timestamp)
            
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
