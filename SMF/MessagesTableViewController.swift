//
//  MessagesTableViewController.swift
//  SMF
//
//  Created by Iris Inami on 2016-09-25.
//  Copyright © 2016 Iris Inami. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class MessagesTableViewController: UITableViewController {
    
    
    
    var database:FIRDatabaseReference!
    var uid = FIRAuth.auth()?.currentUser?.uid
    var keys = [String]()
    var messages = [MessagePreview]()
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        database = FIRDatabase.database().reference()
        
        database.child("usermessages").child(uid!).observe(FIRDataEventType.childAdded, with: { (sshot) in
            self.database.child("messages").child(sshot.key).observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            let key = snapshot.key
            self.keys.append(key)
            print("\(key)")
            
            let message:MessagePreview = MessagePreview.init()
            let timestamp = snapshot.childSnapshot(forPath: "unixstamp").value as? Double
            if(timestamp != nil){
                message.messageid = key
                message.messagetitle = snapshot.childSnapshot(forPath: "messagetitle").value as! String!
                message.opid = snapshot.childSnapshot(forPath: "userid").value as! String!
                for tag in snapshot.childSnapshot(forPath: "threadtags").children{
                    
                    message.messagetags.append((tag as AnyObject).key)
                }
                
                message.unixstamp = timestamp
            }
            self.messages.append(message)
            let indexPath = IndexPath(row: self.keys.count - 1, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .fade)
        })
            
        })
        
        database.child("usermessages").child(self.uid!).observe(FIRDataEventType.childChanged, with: { (sshot) in
            self.database.child("messages").child(sshot.key).observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            let key = snapshot.key
            let idx = self.keys.index(of: key)
            
            let message:MessagePreview = MessagePreview.init()
            let timestamp = snapshot.childSnapshot(forPath: "unixstamp").value as? Double
            if(timestamp != nil){
                message.messageid = key
                message.messagetitle = snapshot.childSnapshot(forPath: "messagetitle").value as! String!
                print("changed: \(message.messagetitle)")
                message.opid = snapshot.childSnapshot(forPath: "userid").value as! String!
                
                for tag in snapshot.childSnapshot(forPath: "threadtags").children{
                    
                    message.messagetags.append((tag as AnyObject).key)
                }
                
                message.unixstamp = timestamp
                self.messages[idx!] = message
                self.tableView.reloadData()
            }
        })
            })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return keys.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "message", for: indexPath)
        // Configure the cell...
        let messagetitle:UILabel! = cell.contentView.viewWithTag(1) as! UILabel!
        messagetitle.text = self.messages[indexPath.row].messagetitle
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let mid = keys[indexPath.row]
            let message = messages[indexPath.row]
            let controller = segue.destination as! ShowMessageTableViewController
            controller.threadid = mid
            controller.threadtitle = message.messagetitle
            controller.navigationItem.title = message.messagetitle
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }
    
}
