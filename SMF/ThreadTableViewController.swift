//
//  ThreadTableViewController.swift
//  SMF
//
//  Created by Iris Inami on 2017-03-16.
//  Copyright © 2017 Iris Inami. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ThreadTableViewController: UITableViewController {

    var database:FIRDatabaseReference!
    var uid = FIRAuth.auth()?.currentUser?.uid
    var keys = [String]()
    var posts = [Post]()
    
    var threadid:String!
    var threadtitle:String!
    
    var postid:String!
    var postcontent:String!
    var userid:String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.navigationItem.title = threadtitle
        
        database = FIRDatabase.database().reference()
        database.child("posts").child(threadid).observe(FIRDataEventType.childAdded, with: { (snapshot) in
            let key = snapshot.key
            self.keys.append(key)
            
            let post:Post = Post.init()
            post.content = snapshot.childSnapshot(forPath: "content").value as! String!
            post.userid = snapshot.childSnapshot(forPath: "userid").value as! String!
            post.unixstamp = snapshot.childSnapshot(forPath: "unixstamp").value as! Double!
            post.postid = key
            self.posts.append(post)
            let indexPath = IndexPath(row: self.keys.count - 1, section:0)
            self.tableView.insertRows(at: [indexPath], with: .fade)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "post", for: indexPath)
        
        // Configure the cell...
        let postContent:UITextView! = cell.contentView.viewWithTag(2) as! UITextView!
        postContent.text = posts[indexPath.row].content
        let username:UILabel! = cell.contentView.viewWithTag(1) as! UILabel!
        
        //	username.text = database.child("users").child(userid).value(forKey: "screenname") as! String?
        database.child("users").child(posts[indexPath.row].userid).child("screenname").observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            print(snapshot.value)
            username.text = snapshot.value as! String!
        })
        
        return cell
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
