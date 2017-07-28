//
//  TruckTimesTableViewController.swift
//  trucksOfFood
//
//  Created by Taylor Simpson on 7/4/17.
//  Copyright © 2017 Taylor Simpson. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class TruckTimesTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    
    var TimesFromListMenu: String!
    
    var openTime: TimeInterval!
    
    var closedTime: TimeInterval!
    
    var Date: NSDate!
    
    var closeData: NSDate!
    
    var openDateString: String!
    
    var closeDateString: String!
    
    var openTimeRefToPass: DatabaseReference!
    
    var closedTimeRefToPass: DatabaseReference!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()

        observeMenues()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableData), name:NSNotification.Name(rawValue: "changeTime"), object: nil)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func reloadTableData(_ notification: Notification) {
        observeMenues()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "timePop" {
        
        let popoverViewController = segue.destination as! TimeUpdateViewController
            
            popoverViewController.popoverPresentationController?.delegate = self
            
            if let indexPath = self.tableView.indexPathForSelectedRow{
                
                let tappedItem = indexPath.row
                
                popoverViewController.cellIndexFromTimeView = tappedItem
                
                if indexPath.row == 0 {
                
                    openTimeRefToPass = Database.database().reference().child("Food Trucks").child(TimesFromListMenu).child("openTime")
                    
                    popoverViewController.refForTimeChange = openTimeRefToPass
                
                }
                
                if indexPath.row == 1 {
                
                
                    closedTimeRefToPass = Database.database().reference().child("Food Trucks").child(TimesFromListMenu).child("closedTime")
                    
                    popoverViewController.refForTimeChange = closedTimeRefToPass
                    
                }
                
            }

        
        }
    }
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
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
        return 2
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hours", for: indexPath) as! TimeCell

        // Configure the cell...
        
        
        
        switch indexPath.row {
        case 0:
            cell.timeLabel.text = openDateString
            cell.openOrClosedLabel.text = "Open Time:"
            
        case 1:
            cell.timeLabel.text = closeDateString
            
            cell.openOrClosedLabel.text = "Closing Time:"

        default:
            cell.timeLabel.text = "No Time"
            
            cell.openOrClosedLabel.text = "No Closing Or Opening Time Yet"
        }
        
            return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "timePop", sender: TruckTimesTableViewController())
        
        
    }
    
    
    func observeMenues () {
        
        guard  let userID = Auth.auth().currentUser?.uid else {
            return
        }
        
        let openTimeRef = Database.database().reference().child("Food Trucks").child(TimesFromListMenu).child("openTime")
        
        let closedTimeRef = Database.database().reference().child("Food Trucks").child(TimesFromListMenu).child("closedTime")
        
        openTimeRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            let aOpenTime = snapshot.value as! TimeInterval
            
            self.openTime = aOpenTime
            
            self.Date = NSDate(timeIntervalSince1970: self.openTime)
            
            let dayTimePeriodFormatter = DateFormatter()
            dayTimePeriodFormatter.dateFormat = "h:mm a"
            
            let dateString = dayTimePeriodFormatter.string(from: self.Date as Date)
            
            
            self.openDateString = dateString
            
            
            print(self.openTime)
            
                
               
                
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            
        })
        
        
        closedTimeRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.closedTime = snapshot.value as! TimeInterval
            
            self.closeData = NSDate(timeIntervalSince1970: self.closedTime)
            
            let dayTimePeriodFormatter = DateFormatter()
            dayTimePeriodFormatter.dateFormat = "h:mm a"
            
            let closedDateString = dayTimePeriodFormatter.string(from: self.closeData as Date)
            
            self.closeDateString = closedDateString
            
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
            })
        })
        
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
