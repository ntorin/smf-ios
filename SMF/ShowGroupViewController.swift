//
//  ShowGroupViewController.swift
//  SMF
//
//  Created by Iris Inami on 2017-03-23.
//  Copyright © 2017 Iris Inami. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ShowGroupViewController: UIViewController {

    
    
    @IBOutlet weak var groupname: UITextView!
    @IBOutlet weak var groupscreenid: UITextView!
    @IBOutlet weak var groupdescription: UITextView!
    
    var groupid:String!
    
    
    var database:FIRDatabaseReference!
    var uid = FIRAuth.auth()?.currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        database = FIRDatabase.database().reference()
        self.database.child("groups").child(groupid).observeSingleEvent(of: .value, with: {snapshot in
            self.groupname.text = snapshot.childSnapshot(forPath: "groupname").value as! String
            self.groupscreenid.text = snapshot.childSnapshot(forPath: "groupscreenid").value as! String
            self.groupdescription.text = snapshot.childSnapshot(forPath: "groupshortdescription").value as! String
        })
        
        
        /* self.database.child("groups").child(groupid).observe(.childChanged, with: {snapshot in
            self.groupname.text = snapshot.childSnapshot(forPath: "groupname").value as! String
            self.groupscreenid.text = snapshot.childSnapshot(forPath: "groupscreenid").value as! String
            self.groupdescription.text = snapshot.childSnapshot(forPath: "groupshortdescription").value as! String
        }) */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
