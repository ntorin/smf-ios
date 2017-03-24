//
//  GroupsTableViewController.swift
//  SMF
//
//  Created by Iris Inami on 2016-09-25.
//  Copyright © 2016 Iris Inami. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class GroupsTableViewController: UITableViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    var database:FIRDatabaseReference!
    var uid = FIRAuth.auth()?.currentUser?.uid
    var keys = [String]()
    var groups = [GroupPreview]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        database = FIRDatabase.database().reference()
        database.child("groups").observe(FIRDataEventType.childAdded, with: { (snapshot) in
            let key = snapshot.key
            self.keys.append(key)
            
            let group:GroupPreview = GroupPreview.init()
            let timestamp = snapshot.childSnapshot(forPath: "unixstamp").value as? Double
            if(timestamp != nil){
                group.groupid = key
                group.creatorid = snapshot.childSnapshot(forPath: "creatorid").value as! String!
                group.groupname = snapshot.childSnapshot(forPath: "groupname").value as! String!
                group.groupscreenid = snapshot.childSnapshot(forPath: "groupscreenid").value as! String!
                group.groupshortdescription = snapshot.childSnapshot(forPath: "groupshortdescription").value as! String!
                
                group.groupmembercount = snapshot.childSnapshot(forPath: "membercount").value as? Int
                group.grouppostcount = snapshot.childSnapshot(forPath: "postcount").value as? Int
                
                for tag in snapshot.childSnapshot(forPath: "grouptags").children{
                    
                    group.grouptags.append((tag as AnyObject).key)
                }
                
                group.unixstamp = timestamp
            }
            self.groups.append(group)
            let indexPath = IndexPath(row: self.keys.count - 1, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .fade)
        })
        
        database.child("groups").observe(FIRDataEventType.childChanged, with: { (snapshot) in
            let key = snapshot.key
            let idx = self.keys.index(of: key)
            
            let group:GroupPreview = GroupPreview.init()
            let timestamp = snapshot.childSnapshot(forPath: "unixstamp").value as? Double
            if(timestamp != nil){
                group.groupid = key
                group.creatorid = snapshot.childSnapshot(forPath: "creatorid").value as! String!
                group.groupname = snapshot.childSnapshot(forPath: "groupname").value as! String!
                group.groupscreenid = snapshot.childSnapshot(forPath: "groupscreenid").value as! String!
                group.groupshortdescription = snapshot.childSnapshot(forPath: "groupshortdescription").value as! String!
                
                group.groupmembercount = snapshot.childSnapshot(forPath: "membercount").value as? Int
                group.grouppostcount = snapshot.childSnapshot(forPath: "postcount").value as? Int
                
                for tag in snapshot.childSnapshot(forPath: "grouptags").children{
                    
                    group.grouptags.append((tag as AnyObject).key)
                }
                
                group.unixstamp = timestamp
                
                self.groups[idx!] = group
                self.tableView.reloadData()
            }
            
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "group", for: indexPath)
        
        // Configure the cell...
        let groupName:UILabel! = cell.contentView.viewWithTag(1) as! UILabel!
        groupName.text = self.groups[indexPath.row].groupname
        return cell
    }
    
}
