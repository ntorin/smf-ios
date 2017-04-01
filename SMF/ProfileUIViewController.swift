//
//  ProfileUIViewController.swift
//  SMF
//
//  Created by Iris Inami on 2016-09-25.
//  Copyright © 2016 Iris Inami. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProfileUIViewController: UIViewController {
    
    
    @IBOutlet weak var screenid: UITextView!
    @IBOutlet weak var accountid: UITextView!
    @IBOutlet weak var accountdescription: UITextView!
    
    
    var database:FIRDatabaseReference!
    var uid = FIRAuth.auth()?.currentUser?.uid
    
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        database = FIRDatabase.database().reference()

        
        if self.revealViewController() != nil {
            //menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        
        self.database.child("users").child(uid!).observeSingleEvent(of: .value, with: {snapshot in
            self.screenid.text = snapshot.childSnapshot(forPath: "screenname").value as! String
            self.accountid.text = snapshot.childSnapshot(forPath: "accountid").value as! String
            self.accountdescription.text = snapshot.childSnapshot(forPath: "shortdescription").value as! String
        })
        
        /*self.database.child("users").child(uid!).observe(FIRDataEventType.childChanged, with: {snapshot in
            self.screenid.text = snapshot.childSnapshot(forPath: "screenname").value as! String
            self.accountid.text = snapshot.childSnapshot(forPath: "accountid").value as! String
            self.accountdescription.text = snapshot.childSnapshot(forPath: "shortdescription").value as! String
        }) */
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
