//
//  TruckMainMenuTableViewController.swift
//  trucksOfFood
//
//  Created by Taylor Simpson on 6/27/17.
//  Copyright © 2017 Taylor Simpson. All rights reserved.
//

import UIKit
import FirebaseAuth

class TruckMainMenuTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Main Menu"
        
        
       
        
        self.navigationController?.navigationBar.tintColor = .white

        self.navigationController?.navigationBar.barTintColor = UIColor(hue: 0.3472, saturation: 0.8, brightness: 0.41, alpha: 1.0)
        
      var settingsButton =  UIBarButtonItem(title:NSString(string: "\u{2699}\u{0000FE0E}") as String , style: .plain, target: self, action: #selector(accountOptions))
        
        
        let font = UIFont.systemFont(ofSize: 28) // adjust the size as required
        let attributes = [NSAttributedStringKey.font : font]
        
        settingsButton.setTitleTextAttributes(attributes, for: .normal)
        
        
        navigationItem.rightBarButtonItem = settingsButton

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        
        
    }
    
    func accountOptions () {
        performSegue(withIdentifier: "settings", sender: TruckMainMenuTableViewController())
    
    
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
        return 5
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        switch indexPath.row{
        
        case 0:
        
        performSegue(withIdentifier: "truckInfo", sender: TruckMainMenuTableViewController())
        
        case 1:
        
        
        performSegue(withIdentifier: "menuItems", sender: TruckMainMenuTableViewController())
            
        case 2:
            
            performSegue(withIdentifier: "truckListForTime", sender: TruckMainMenuTableViewController())
        
        case 3:
            
            performSegue(withIdentifier: "truckListForLocation", sender: TruckMainMenuTableViewController())
        
        default:
        
            print("Nothing here")
        
        
        
        
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainMenuItem", for: indexPath) as! truckMainMenuTableViewCell
        
        
        let view = UIView(frame: tableView.frame)
        
        let gradient = CAGradientLayer()
        
        gradient.frame = view.frame
        
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        
        gradient.locations = [0.0, 0.5]
        
        view.layer.insertSublayer(gradient, at: 0)
        
        cell.mainMenuImage.addSubview(view)
        
        cell.mainMenuImage.bringSubview(toFront: view)
        
        
        switch indexPath.row {
        
        case 0 :
            
            cell.mainMenuLabel.text = "Upload All Info"
            
            cell.mainMenuLabel.textColor = .white
            
            
            cell.mainMenuImage.image = UIImage(named: "iphone.jpeg")
            
        
        
        case 1:
            
            cell.mainMenuImage.image = UIImage(named: "menuPhoto.jpeg")
            
           
            
            cell.mainMenuLabel.text = "Menu"
            
            cell.mainMenuLabel.textColor = UIColor.white
        case 2:
            
            cell.mainMenuImage.image = UIImage(named: "timePhoto.jpeg")
            
            cell.mainMenuLabel.text = "Times"
            
            cell.mainMenuLabel.textColor = .white
        case 3:
            
            cell.mainMenuImage.image = UIImage(named: "location.gif")
            
            
            
            cell.mainMenuLabel.text = "Truck Location"
            
            cell.mainMenuLabel.textColor = UIColor.white
            
        case 4:
            
            cell.mainMenuImage.image = UIImage(named: "credit-card.jpeg")
            
            cell.mainMenuLabel.text = "Mobile Orders"
            
            cell.mainMenuLabel.textColor = .white
            
        default:
            print("Not There")
        }
        
//        if indexPath.row == 0 {
//        
//        cell.mainMenuImage.image = UIImage(named: "menuPhoto.jpeg")
//        
//        
//        }
        // Configure the cell...

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
