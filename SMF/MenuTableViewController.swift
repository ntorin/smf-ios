//
//  MenuTableViewController.swift
//  SMF
//
//  Created by Iris Inami on 2017-03-15.
//  Copyright © 2017 Iris Inami. All rights reserved.
//

import UIKit
import FirebaseAuth

class MenuTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let revealController = self.revealViewController()
        print("selected row; \(indexPath.section), \(indexPath.row)")
        if(indexPath.section == 0 && indexPath.row == 0){ //BBS
            let frontController = self.storyboard?.instantiateViewController(withIdentifier: "bbsVC")
            revealController?.setFront(frontController, animated: true)
        }
        
        if(indexPath.section == 0 && indexPath.row == 1){ //Personal/Home
            let frontController = self.storyboard?.instantiateViewController(withIdentifier: "homeVC")
            revealController?.setFront(frontController, animated: true)
        }
        
        if(indexPath.section == 2 && indexPath.row == 1){ //Sign Out
            try! FIRAuth.auth()!.signOut()
            self.performSegue(withIdentifier: "logout", sender: self)
        }
        
        revealController?.revealToggle(animated: true)
    }

}
