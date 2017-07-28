//
//  MenuListForCustomerTableViewController.swift
//  trucksOfFood
//
//  Created by Taylor Simpson on 7/14/17.
//  Copyright © 2017 Taylor Simpson. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Stripe
import SVProgressHUD
import FirebaseAuth
import PMAlertController
class MenuListForCustomerTableViewController: UITableViewController,STPAddCardViewControllerDelegate {

    var menuItemsArray: [Dictionary<String, AnyObject>] = []
    
    var menuItems: Dictionary<String, AnyObject> = [:]
    
    var keyIndex: [String] = []
    
    var foodItem: [String] = []
    
    var foodPrice: [Double] = []
    
    var truckUserId: String = ""
    
    var truckName: String = ""
    
    
    func addToCart(){
    
    //performSegue(withIdentifier: "checkOut", sender: MenuListForCustomerTableViewController())
        
        let alertController = PMAlertController(title: "Purchase", description: "You are purchashing \(foodItem) with a price of $\(self.foodPrice.reduce(0,+))", image: UIImage(named: "banknotes.png"), style: .alert)
        
        
        alertController.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: {
            return
        }))
       
       
        
        alertController.addAction(PMAlertAction(title: "Checkout", style: .default, action: {
            let addCardViewController = STPAddCardViewController()
            addCardViewController.delegate = self
            // STPAddCardViewController must be shown inside a UINavigationController.
            let navigationController = UINavigationController(rootViewController: addCardViewController)
            self.present(navigationController, animated: true, completion: nil)
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
            SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
            
            return
        }))
    
        self.present(alertController, animated: true, completion: nil)
   
    
    
    }
    
    // MARK: STPAddCardViewControllerDelegate
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        
         SVProgressHUD.showSuccess(withStatus: "Stripe token successfully received: \(token)")
        
        guard let userID = Auth.auth().currentUser?.uid  else {
            print("There was an error")
            
            return
        }
        
        let purchaseRef = Database.database().reference().child("Payments").child(userID).childByAutoId().child("paymentId")
        
       var totalCost = self.foodPrice.reduce(0, +)
        
        let orderDictionary = ["amount": totalCost * 100,"currency": "usd", "description":  "Food Truck Purchase" , "source": "\(token)", "customer": userID] as [String : Any]
        
        purchaseRef.updateChildValues(orderDictionary)
        
        self.dismiss(animated: true, completion: {
            print(token)
            completion(nil)
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = truckName
        
        self.navigationController?.navigationBar.tintColor = .white
        
        self.navigationController?.navigationBar.barTintColor = UIColor(hue: 0.3472, saturation: 0.8, brightness: 0.41, alpha: 1.0)
        
        var settingsButton =  UIBarButtonItem(title:NSString(string: "Add To Cart") as String , style: .plain, target: self, action: #selector(addToCart))
        
        
        let font = UIFont.systemFont(ofSize: 18) // adjust the size as required
        let attributes = [NSAttributedStringKey.font : font]
        
        settingsButton.setTitleTextAttributes(attributes, for: .normal)
        
        
        navigationItem.rightBarButtonItem = settingsButton

        
        self.tableView.allowsMultipleSelection = true
        
        for i in 0...menuItemsArray.count-1 {
            
            menuItems = menuItemsArray[i]
            
            
            }
        
        for myKeys in menuItems.keys{
            
            self.keyIndex.append(myKeys)
            
            
            
            
        }

        
        print(self.keyIndex)

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
        return keyIndex.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuItems", for: indexPath) as! CustomerMenuItemsCell

        // Configure the cell...
        
        cell.accessoryType = cell.isSelected ? .checkmark : .none
        cell.selectionStyle = .none
        
        cell.menuItem.text = keyIndex[indexPath.row]
        
        cell.price.text = "$\(menuItems[keyIndex[indexPath.row]]!)"


        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
       
        
        
        self.foodItem.append(keyIndex[indexPath.row])
        
        self.foodPrice.append((menuItems[keyIndex[indexPath.row]]! as! NSString).doubleValue)
        
        print (foodItem)
        
        print (foodPrice)
        
        
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let selectedCell = tableView.cellForRow(at: indexPath) as? CustomerMenuItemsCell

       
        
        for (index,value) in foodItem.enumerated() {
            if value == selectedCell?.menuItem.text {
                let index = foodItem.index(of: value)
                
                foodItem.remove(at: index!)
                
                foodPrice.remove(at: index!)
            }
        }
        
      /*  for (index,value) in foodPrice.enumerated() {
            if "$\(value)"  == selectedCell?.price.text {
                let index = foodPrice.index(of: value)
                
                
                foodPrice.remove(at:index!)
            }
        }*/
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        
        
        
        print (foodItem)
        
        print (foodPrice)
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
