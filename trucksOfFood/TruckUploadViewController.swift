//
//  TruckUploadViewController.swift
//  trucksOfFood
//
//  Created by Taylor Simpson on 6/8/17.
//  Copyright © 2017 Taylor Simpson. All rights reserved.
//

import UIKit
import Eureka
import PostalAddressRow
import ImageRow
import CoreLocation
import Firebase
class TruckUploadViewController: FormViewController, CLLocationManagerDelegate {
    
    var locationManager:CLLocationManager!
    var ref: DatabaseReference!
    
    var truckLocation:CLLocation!
    
    var numOfMenuItems: Int!
    
    var menuItem: [String]! = []
    var menuItemPrices: [String]! = []
    
    var menuItemsAndPrices: [String:String]! = [:]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        
        
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager.startUpdatingLocation()
            
            
            
            
            
        }
        
        title = "Trucks"
        self.navigationController?.navigationBar.barTintColor = UIColor(hue: 0.3472, saturation: 0.8, brightness: 0.41, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButton))
        
        
        
        form +++ Section("Food Truck Info")
            <<< TextRow(){
                $0.title = "Name of Food Truck"
                $0.placeholder = "Enter name here (required)"
                $0.tag = "truckName"
                 $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                
                
            }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
            }
            <<< TextRow(){
                $0.title = "Type of Food Served"
                $0.placeholder = "American, French, etc.. (required)"
                $0.tag = "foodType"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
            }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
            }
            
            <<< DecimalRow(){
                
                $0.title = "Average Price of Food (required)"
                $0.placeholder = "$0.00"
                $0.tag = "averagePrice"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange

                
            }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
            }

            
            <<< TextRow(){
                $0.title = "Customer Favorite"
                $0.placeholder = "Big Boss Taco, King Tuna"
                $0.tag = "customerFavorite"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange

                
                
            }
            
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
            }

            
            <<< TimeRow(){
            
                $0.title = "Time Open (required)"
                $0.tag = "openTime"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange

            }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.backgroundColor = .red
                    }
            }

            
            <<< TimeRow(){
                
                $0.title = "Time Closed (required)"
                $0.tag = "closedTime"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange

            }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.backgroundColor = .red
                    }
            }

            
            <<< PostalAddressRow() {
                $0.streetPlaceholder = "Street"
                $0.statePlaceholder = "State"
                $0.cityPlaceholder = "City"
                $0.countryPlaceholder = "Country"
                $0.postalCodePlaceholder = "Zip code"
                $0.tag = ("postalRow")
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
            }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                    }
            }
        
           
        +++
        
        MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                           header: "Menu Items and Price",
                           footer: ".Insert adds a 'Add Item' (Add New Tag) button row as last cell.") {
                            $0.addButtonProvider = { section in
                                return ButtonRow(){
                                    $0.title = "Add New Menu Item"
                                }
                            }
                            $0.multivaluedRowToInsertAt = { index in
                                return MenuItemRow("tag_\(index+1)") {
                                    $0.menuItemPlaceholder = "Pizza"
                                    $0.pricePlaceholder = "5.50"
                                    
                                    
                                }
                            }
                            $0 <<< MenuItemRow("tag_1") {
                            
                                $0.menuItemPlaceholder = "Enter A Food Item"
                                $0.pricePlaceholder = "Enter it's price"
                                
                            
                            }
                            
                            
                            
        }
        
    
        let myTest = form.values()
        
        print(myTest.count)

        // Do any additional setup after loading the view.
    }
    
    func doneButton (){
    
        //Determain Trucks Location
        
        
        
        
    
        
      // values used for both uploading and checking if required fields are empty.
        
        let truckPostalRow: PostalAddressRow? = form.rowBy(tag: "postalRow")
        
        let truckPostalAdd = truckPostalRow?.value
        
        let valuesDictionary = form.values()
        
        let foodTruckNameRow: TextRow? = form.rowBy(tag: "truckName")
        
        let foodTruckName = foodTruckNameRow?.value
        
        let openTime: TimeRow? = form.rowBy(tag: "openTime")
        
        let openTimeCheck = openTime?.value
        
       
        
        let closeTime: TimeRow? = form.rowBy(tag: "closedTime")
        
        let closeTimeCheck = closeTime?.value
        
        

        
        
        if truckPostalAdd?.city == "" || truckPostalAdd?.country == "" || truckPostalAdd?.postalCode == "" || truckPostalAdd?.state == "" || truckPostalAdd?.street == "" || foodTruckName == "" || openTimeCheck == nil || closeTimeCheck == nil {
        
            let alertController = UIAlertController(title: "Empty Field", message: "One of the required fields is empty. Empty Fields may highlighted in red or simply blank", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
                return
            })
            
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                return
            })
            
            
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        
        
        
        } else {
        
        
        var foodTruck: [String: Any?] = [:]
        
       
         let myOpenTime = openTime?.value?.timeIntervalSince1970
        
       let myCloseTime = closeTime?.value?.timeIntervalSince1970
        
        
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        
        
        
        print(valuesDictionary.count)
        
        if valuesDictionary.count == 7 {
        
            numOfMenuItems = 0
            
        
        
        } else if valuesDictionary.count > 7  {
        
        numOfMenuItems = valuesDictionary.count - 7
        
        
        }
        
        
        
        
        if numOfMenuItems > 0 {
        
        
            for items in 1...numOfMenuItems {
                
                
                
                let firebaseMenuItem: MenuItemRow? = form.rowBy(tag: "tag_\(items)")
                
                let firebaseMenuItems = firebaseMenuItem?.value
                
                
                
                //print(myTree?.menuItem)
                
                menuItem.append((firebaseMenuItems?.menuItem)!)
                
                menuItemPrices.append((firebaseMenuItems?.price)!)
                
                
                
                
                
            
                
                
               
            
            }
            
            for i in 0...menuItem.count - 1 {
            
            
                menuItemsAndPrices[menuItem[i]] = menuItemPrices[i]
                
                
            
            }
            
        
        }
        
        
        
        
        
        
       
        
      
        
        
        
            var currentDate = Date().timeIntervalSince1970
        
        
        
        let truckRef = self.ref.child("Food Trucks")
    
        
        let truckInfoRef = truckRef.childByAutoId()
        
        let truckMenuRef = truckInfoRef.child("Menu")
        
        
        
        if CLLocationManager.locationServicesEnabled(){
            
            switch(CLLocationManager.authorizationStatus()) {
            
            case . notDetermined, .restricted, .denied:
                
                print("No access")
                
                foodTruck = ["truckName": valuesDictionary["truckName"]!, "foodType": valuesDictionary["foodType"]!, "averagePrice": valuesDictionary["averagePrice"]!, "customerFavorite": valuesDictionary["customerFavorite"]!, "openTime": myOpenTime!, "closedTime": myCloseTime!, "street": truckPostalAdd?.street!, "zipCode": truckPostalAdd?.postalCode!, "city": truckPostalAdd?.city!, "state": truckPostalAdd?.state!, "country": truckPostalAdd?.country, "userID": userID, "locationUpdated": currentDate, "gpsTest": false]
                
            case .authorizedAlways, .authorizedWhenInUse:
                
                print ("Acess")
                
                 foodTruck = ["truckName": valuesDictionary["truckName"]!, "foodType": valuesDictionary["foodType"]!, "averagePrice": valuesDictionary["averagePrice"]!, "customerFavorite": valuesDictionary["customerFavorite"]!, "openTime": myOpenTime!, "closedTime": myCloseTime!, "street": truckPostalAdd?.street!, "zipCode": truckPostalAdd?.postalCode!, "city": truckPostalAdd?.city!, "state": truckPostalAdd?.state!, "country": truckPostalAdd?.country!,"truckLat":truckLocation.coordinate.latitude, "truckLong": truckLocation.coordinate.longitude, "userID": userID, "locationUpdated": currentDate, "gpsTest": true]
                
            
            
            
            }
        } else {
        
            print("Location Services Not Enabled")
            
            foodTruck = ["truckName": valuesDictionary["truckName"]!, "foodType": valuesDictionary["foodType"]!, "averagePrice": valuesDictionary["averagePrice"]!, "customerFavorite": valuesDictionary["customerFavorite"]!, "openTime": myOpenTime!, "closedTime": myCloseTime!, "street": truckPostalAdd?.street!, "zipCode": truckPostalAdd?.postalCode!, "city": truckPostalAdd?.city!, "state": truckPostalAdd?.state!, "country": truckPostalAdd?.country, "userID": userID, "locationUpdated": currentDate, "gpsTest": false]
        
        
        }
        
        
        
        
        
            
        
        
        
        truckInfoRef.updateChildValues(foodTruck as Any as! [AnyHashable : Any]){(error, ref) in
            
            
            if error != nil {
                
                print(error?.localizedDescription)
                return
                
            }
            
            
            let menuRef = Database.database().reference().child("truckDriverUserMenus").child(userID)
            
            let menuId = truckInfoRef.key
            
            menuRef.updateChildValues([menuId : 1])
            
        }
        
        truckMenuRef.updateChildValues(menuItemsAndPrices as Any as! [AnyHashable : Any]) { (error, ref) in
            
            if error != nil {
            
                print(error?.localizedDescription)
            
            
            }
            
            
        
            
            
            }
            
    
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0] as CLLocation
        
        
        truckLocation = userLocation
        
        manager.stopUpdatingLocation()
        
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("Error \(error.localizedDescription)")
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
