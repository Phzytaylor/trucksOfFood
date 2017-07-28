//
//  TypesOfFoodTableViewController.swift
//  trucksOfFood
//
//  Created by Taylor Simpson on 7/14/17.
//  Copyright © 2017 Taylor Simpson. All rights reserved.
//

import UIKit
import FirebaseDatabase

class TypesOfFoodTableViewController: UITableViewController {

    var foodTypeArray: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        typesOfFood()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func typesOfFood() {
    
        let truckRef = Database.database().reference().child("Food Trucks")
        
        truckRef.queryOrdered(byChild: "foodType").observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            if let userDict = snapshot.value as? [String:AnyObject]{
                
                for each in userDict as [String:AnyObject]{
                    
                    let foodTypes = each.value["foodType"] as! String
                    
                    self.foodTypeArray.append(foodTypes)
                    
                   // print(foodTypes)
                    

                }
            
            
            }
            
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
            })
            
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
        return foodTypeArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foods", for: indexPath)

       cell.textLabel?.text = foodTypeArray[indexPath.row]

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let navController = self.tabBarController?.viewControllers![0] as! UINavigationController
        let targetController = navController.viewControllers.first as! CustomerMainViewController
        
        let tappedItem = self.foodTypeArray[indexPath.row]
        
        
        
        targetController.truckLatsArray.removeAll()
        
        targetController.truckLongsArray.removeAll()
        
        targetController.averagePriceArray.removeAll()
        
        targetController.cityArray.removeAll()
        
        targetController.closedTimeArray.removeAll()
        
        targetController.countryArray.removeAll()
        
        targetController.customerFavoriteArray.removeAll()
        
        targetController.foodTypeArray.removeAll()
        
        targetController.openTimeArray.removeAll()
        
        targetController.stateArray.removeAll()
        
        targetController.streetArray.removeAll()
        
        targetController.truckNameArray.removeAll()
        
        targetController.dataBaseIDArray.removeAll()
        
        targetController.zipCodeArray.removeAll()
        
        targetController.gpsTestArray.removeAll()
        
        
        
        
        
        targetController.foodTypePicked = tappedItem
        
        self.tabBarController?.selectedIndex = 0
        
       // performSegue(withIdentifier: "sortTheFood", sender: TypesOfFoodTableViewController())
        
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
       let destinationNavigationController = segue.destination as! UINavigationController
        let targetController = destinationNavigationController.topViewController as! CustomerMainViewController
        
 
        
        if segue.identifier == "sortTheFood" {
            
            if let indexPath = self.tableView.indexPathForSelectedRow{
                
                let tappedItem = self.foodTypeArray[indexPath.row]
                
                
                
                targetController.truckLatsArray.removeAll()
                
                targetController.truckLongsArray.removeAll()
                
                targetController.averagePriceArray.removeAll()
                
               targetController.cityArray.removeAll()
                
                targetController.closedTimeArray.removeAll()
                
                targetController.countryArray.removeAll()
                
                targetController.customerFavoriteArray.removeAll()
                
                targetController.foodTypeArray.removeAll()
                
                targetController.openTimeArray.removeAll()
                
                targetController.stateArray.removeAll()
                
                targetController.streetArray.removeAll()
                
                targetController.truckNameArray.removeAll()
                
                targetController.dataBaseIDArray.removeAll()
                
                targetController.zipCodeArray.removeAll()
                
                targetController.gpsTestArray.removeAll()
                
               
                

                
                targetController.foodTypePicked = tappedItem
            }
            
            
        }

        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
