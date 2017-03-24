//
//  BBSTableViewController.swift
//  SMF
//
//  Created by Iris Inami on 2017-03-16.
//  Copyright © 2017 Iris Inami. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class BBSTableViewController: UITableViewController {
    
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var database:FIRDatabaseReference!
    var uid = FIRAuth.auth()?.currentUser?.uid
    var keys = [String]()
    var threads = [ThreadPreview]()
    
    var threadtitle:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        database = FIRDatabase.database().reference()
        database.child("threads").observe(FIRDataEventType.childAdded, with: { (snapshot) in
            let key = snapshot.key
            self.keys.append(key)
            
            let thread:ThreadPreview = ThreadPreview.init()
            if(snapshot.childSnapshot(forPath: "unixstamp").value as? Double != nil){
            print("\(snapshot.childSnapshot(forPath: "unixstamp").value)")
            thread.threadid = key
            thread.threadtitle = snapshot.childSnapshot(forPath: "threadtitle").value as! String!
            thread.unixstamp = snapshot.childSnapshot(forPath: "unixstamp").value as! Double!
            thread.opid = snapshot.childSnapshot(forPath: "userid").value as! String!
            
            for tag in snapshot.childSnapshot(forPath: "threadtags").children{
                
                thread.threadtags.append((tag as AnyObject).key)
            }
            }
            
            self.threads.append(thread)
            let indexPath = IndexPath(row: self.keys.count - 1, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .fade)
        })
        
        database.child("threads").observe(FIRDataEventType.childChanged, with: { (snapshot) in
            let key = snapshot.key
            let idx = self.keys.index(of: key)
            
            let thread:ThreadPreview = ThreadPreview.init()
            let timestamp = snapshot.childSnapshot(forPath: "unixstamp").value as? Double
            if(timestamp != nil){
                thread.threadid = key
                thread.threadtitle = snapshot.childSnapshot(forPath: "threadtitle").value as! String!
                thread.unixstamp = timestamp
                thread.opid = snapshot.childSnapshot(forPath: "userid").value as! String!
                
                for tag in snapshot.childSnapshot(forPath: "threadtags").children{
                    
                    thread.threadtags.append((tag as AnyObject).key)
                }
                
                self.threads[idx!] = thread
                self.tableView.reloadData()
            }
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return keys.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "thread", for: indexPath)

        // Configure the cell...
        let threadTitle:UILabel! = cell.contentView.viewWithTag(1) as! UILabel!
        threadTitle.text = self.threads[indexPath.row].threadtitle
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if segue.identifier == "showThread" {
            print("showthread")
            if let indexPath = self.tableView.indexPathForSelectedRow {
                print("pathforselected")
                let tid = keys[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! ThreadTableViewController
                controller.threadid = tid
                controller.threadtitle = threadtitle
                controller.navigationItem.title = threadtitle
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        //}
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
