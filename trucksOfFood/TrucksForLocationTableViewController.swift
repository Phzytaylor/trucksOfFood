//
//  TableViewController.swift
//  trucksOfFood
//
//  Created by Taylor Simpson on 7/5/17.
//  Copyright © 2017 Taylor Simpson. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import CoreLocation
//TODO: Don't forget to add a text Field where they can input an adress
class TrucksForLocationTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    var locationManager:CLLocationManager!
    var truckLocation:CLLocation!
    
    var numOfUserTrucks: [String]! = []
    
    var titleString:String!
    var titlesArray:[String]! = []
    
    var foodTruck: [String: Any?] = [:]
    var LocationRef: DatabaseReference!
    
    var truckRefToBePassed: DatabaseReference!
    


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
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationRest", for: indexPath)

       
        
        
        cell.textLabel?.text = titlesArray[indexPath.row]
        
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alertController = UIAlertController(title: "Update Location?", message: "Have your device track your location or enter manually", preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            return
        })
        
        
        let okAction = UIAlertAction(title: "Update Automatically", style: .default, handler: { (UIAlertAction) in
            
            
            self.locationManager = CLLocationManager()
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.startUpdatingLocation()
            
            
            
            if CLLocationManager.locationServicesEnabled() {
                
                self.locationManager.startUpdatingLocation()
                
                switch(CLLocationManager.authorizationStatus()){
                
                
                case .denied, .notDetermined, .restricted:
                    
                    print("boo")
                  
                case .authorizedAlways, .authorizedWhenInUse:
                    
                    self.locationManager.delegate = self
                    self.locationManager.startUpdatingLocation()
                   
                    let locationLatRef = Database.database().reference().child("Food Trucks").child(self.numOfUserTrucks[indexPath.row])
                    
                    self.LocationRef = locationLatRef
                    
                   
                    
                     //var locationLongRef = Database.database().reference().child("Food Trucks").child(self.numOfUserTrucks[indexPath.row]).child("truckLong")
                    
                    //locationLatRef.updateChildValues(["truckLat": self.truckLocation.coordinate.latitude, "truckLong": self.truckLocation.coordinate.longitude])
                    
                    
                    
                default:
                    print("No")
                
                }
                
                
                
            }

            
            return
        })
        
        
        let manAction = UIAlertAction(title: "Update Manually", style: .default, handler: { (UIAlertAction) in
            self.performSegue(withIdentifier: "changeLocation", sender: TrucksForLocationTableViewController())
        })
        
        
        
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        alertController.addAction(manAction)
        self.present(alertController, animated: true, completion: nil)
        
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
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        
        let userLocation:CLLocation = locations[locations.count - 1] as CLLocation
        
        
        truckLocation = userLocation
        
        manager.stopUpdatingLocation()
       
        
        //LocationRef.updateChildValues(["truckLat": self.truckLocation.coordinate.latitude, "truckLong": self.truckLocation.coordinate.longitude])
        
        
        LocationRef.updateChildValues(["truckLat": self.truckLocation.coordinate.latitude, "truckLong": self.truckLocation.coordinate.longitude, "gpsTest": true]) { (error, DatabaseReference) in
            
            if error == nil{
                
                print("yay")
                
                
                self.getPlacemark(forLocation:self.truckLocation , completionHandler: { (orginPlaceMark, error) in
                    
                    if let err = error {
                    
                        print(err)
                    
                    } else if let placemark = orginPlaceMark {
                    
                        var street = placemark.thoroughfare
                        var postalCode = placemark.postalCode
                        var city = placemark.locality
                        var state = placemark.administrativeArea
                        var country = placemark.country
                        
                        
                        
                        
                        self.foodTruck = ["street": street , "zipCode":postalCode, "city": city, "state": state, "country": country]
                        
                        
                        self.LocationRef.updateChildValues(self.foodTruck)
                    
                    }
                    
                })
                
                let alertController = UIAlertController(title: "Change Complete", message: "Your location has been updated", preferredStyle: UIAlertControllerStyle.alert)
                
                
                
                
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                    return
                })
                
                
                
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                
                
                
            }
            
            
            if error != nil {
                
                
                let alertController = UIAlertController(title: "Failure", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                
                
                
                
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                    return
                })
                
                
                
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                
                
                
            }
            

            
        }
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("Error \(error.localizedDescription)")
    }
    
    func getPlacemark(forLocation location: CLLocation, completionHandler: @escaping (CLPlacemark?, String?) -> ()) {
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location, completionHandler: {
            placemarks, error in
            
            if let err = error {
                completionHandler(nil, err.localizedDescription)
            } else if let placemarkArray = placemarks {
                if let placemark = placemarkArray.first {
                    completionHandler(placemark, nil)
                } else {
                    completionHandler(nil, "Placemark was nil")
                }
            } else {
                completionHandler(nil, "Unknown error")
            }
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        let viewController = segue.destination as! ManualLocationViewController
        
        if segue.identifier == "changeLocation" {
            
            if let indexPath = self.tableView.indexPathForSelectedRow{
                
                let tappedItem = indexPath.row

            
           viewController.referencePassed = Database.database().reference().child("Food Trucks").child(self.numOfUserTrucks[tappedItem])
            
            }
        }

        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
