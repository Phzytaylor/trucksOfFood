//
//  TruckListForTimesTableViewController.swift
//  trucksOfFood
//
//  Created by Taylor Simpson on 7/4/17.
//  Copyright © 2017 Taylor Simpson. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class TruckListForTimesTableViewController: UITableViewController {
    
    var numOfUserTrucks: [String]! = []
    
    var titleString:String!
    var titlesArray:[String]! = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeTrucks()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return titlesArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "truckNamesForTimes", for: indexPath)
        
        cell.textLabel?.text = titlesArray[indexPath.row]
        
        

        // Configure the cell...

        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "truckTimes", sender: TruckListForTimesTableViewController())
    }

    
    func observeTrucks () {
        
        guard  let userID = Auth.auth().currentUser?.uid else {
            return
        }
        
        let menusRef = Database.database().reference().child("truckDriverUserMenus")
        
        menusRef.observe(.childAdded, with: { (snapshot) in
            
            let userId = snapshot.key
            
            if userId == userID {
                
                let userMenuRef = Database.database().reference().child("truckDriverUserMenus").child(userId)
                
                
                userMenuRef.observe(.value, with: { (snapshot) in
                    
                    
                    
                    // print(snapshot.value)
                    
                    if let dictionary = snapshot.value as? [String:AnyObject] {
                        
                        for myKeys in dictionary.keys{
                            
                            self.numOfUserTrucks.append(myKeys)
                            
                            
                            
                            
                            
                        }
                        
                        
                        
                    }
                    
                    /*  DispatchQueue.main.async(execute: {
                     self.tableView.reloadData()
                     }) */
                    
                    for keys in 0...self.numOfUserTrucks.count-1 {
                        
                        var menuRef = Database.database().reference().child("Food Trucks").child(self.numOfUserTrucks[keys])
                        
                        menuRef.observeSingleEvent(of: .value, with: { (snapshot) in
                            
                            
                            //print(snapshot.value)
                            
                            
                            var value = snapshot.value as? NSDictionary
                            //let nameOfTruck = value?["truckName"] as? String ?? ""
                            
                            
                            DispatchQueue.main.async(execute: {
                                self.titleString = value?["truckName"] as! String!
                                
                                self.titlesArray.append(self.titleString)
                                
                                
                                print(self.titlesArray)
                                
                                
                            })
                            
                            DispatchQueue.main.async(execute: {
                                self.tableView.reloadData()
                            })
                            
                            
                            
                        })
                        
                        
                        
                        
                        
                    }
                    
                    
                    
                    
                    
                })
                
            }
            
            
        })
        
        
    }

    
  
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let viewController = segue.destination as! TruckTimesTableViewController
        
    
        
        
        if segue.identifier == "truckTimes" {
            
            if let indexPath = self.tableView.indexPathForSelectedRow{
                
                let tappedItem = self.numOfUserTrucks[indexPath.row]
                
                viewController.TimesFromListMenu = tappedItem
            }
            
            
        }
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
