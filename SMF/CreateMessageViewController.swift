//
//  CreateMessageViewController.swift
//  SMF
//
//  Created by Iris Inami on 2017-03-23.
//  Copyright © 2017 Iris Inami. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class CreateMessageViewController: UIViewController {

    @IBOutlet weak var recipientsText: UITextField!
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
    
    
    
    @IBAction func sendMessage(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Confirmation", message: "Are you sure you would like to send this message?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in
            let message:FIRDatabaseReference = self.database.child("messages").childByAutoId()
            let messageid:String = message.key
            let tags = self.tagsText.text?.replacingOccurrences(of: " ", with: "").components(separatedBy: ",")
            let recipients = self.recipientsText.text?.replacingOccurrences(of: " ", with: "").components(separatedBy: ",")
            
            
            self.database.child("messages").child(messageid).child("userid").setValue(self.uid)
            
            self.database.child("messages").child(messageid).child("messagetitle").setValue(self.titleText.text)
            self.database.child("messages").child(messageid).child("recipients").child(self.uid!).setValue(true)
            self.database.child("usermessages").child(self.uid!).child(messageid).setValue(true)
            
            for(recipient) in recipients!{
                self.database.child("users").queryOrdered(byChild: "accountid").queryEqual(toValue: recipient).observeSingleEvent(of: FIRDataEventType.value, with: {(snapshot) in
                    for (d) in snapshot.children{
                        let userid = (d as! FIRDataSnapshot).key
                        self.database.child("messages").child(messageid).child("recipients").child(userid).setValue(true)
                        self.database.child("usermessages").child(userid).child(messageid).setValue(true)
                        break
                    }
                })
            }
            
            for(tag) in tags!{
                self.database.child("messages").child(messageid).child("messagetags").child(tag).setValue(true)
            }
            
            let post:FIRDatabaseReference = self.database.child("posts").child(messageid).childByAutoId()
            let postid:String = post.key
            
            self.database.child("posts").child(messageid).child(postid).child("userid").setValue(self.uid)
            self.database.child("posts").child(messageid).child(postid).child("content").setValue(self.bodyText.text)
            
            let timestamp:Int = Int(Date().timeIntervalSince1970)
            
            self.database.child("posts").child(messageid).child(postid).child("unixstamp").setValue(timestamp)
            self.database.child("messages").child(messageid).child("unixstamp").setValue(timestamp)
            
            self.navigationController?.popViewController(animated: true)
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
