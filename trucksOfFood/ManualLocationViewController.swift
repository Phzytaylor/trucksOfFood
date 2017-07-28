//
//  ManualLocationViewController.swift
//  trucksOfFood
//
//  Created by Taylor Simpson on 7/5/17.
//  Copyright © 2017 Taylor Simpson. All rights reserved.
//

import UIKit
import Eureka
import PostalAddressRow
import FirebaseDatabase
import FirebaseAuth
import CoreLocation

class ManualLocationViewController: FormViewController {

  
    var referencePassed: DatabaseReference!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButton))
        
        form +++ Section("Adress Information")
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

        // Do any additional setup after loading the view.
        
        
    }
    
    
    
    func doneButton (){
    
        var currentDate = Date().timeIntervalSince1970
        
        let truckPostalRow: PostalAddressRow? = form.rowBy(tag: "postalRow")
        
        let truckPostalAdd = truckPostalRow?.value
        
        var TruckLat: CLLocationDegrees?
        var TruckLong: CLLocationDegrees?
        
       // let address = "1 Infinite Loop, Cupertino, CA 95014"
        
        let address = truckPostalAdd?.street as String! + "," + " " + (truckPostalAdd?.city)! as String! + "," + " " + (truckPostalAdd?.state)! as String! + " " + (truckPostalAdd?.postalCode!)! as String!
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address!) { (placemarks, error) in
            
            
            if error == nil{
            
            var myCoords = (placemarks?.first?.location?.coordinate)!
            //Whather more you want to do in this completion handler.
            
            
            TruckLat = myCoords.latitude
            
            TruckLong = myCoords.longitude
            
            
            let dictToUpload = ["street": truckPostalAdd?.street! as Any, "zipCode": truckPostalAdd?.postalCode! as Any, "city": truckPostalAdd?.city! as Any, "state": truckPostalAdd?.state! as Any, "country": truckPostalAdd?.country! as Any,"locationUpdated": currentDate, "truckLat": TruckLat!, "truckLong": TruckLong!, "gpsTest": "true"] as [String : Any]
            
            
            
                self.referencePassed.updateChildValues(dictToUpload)
            }
            
            else if error != nil{
            
            let dictToUpload = ["street": truckPostalAdd?.street! as Any, "zipCode": truckPostalAdd?.postalCode! as Any, "city": truckPostalAdd?.city! as Any, "state": truckPostalAdd?.state! as Any, "country": truckPostalAdd?.country! as Any,"locationUpdated": currentDate, "gpsTest": "false"] as [String : Any]
            
            
            }
            
        }
        
       
        
        
        
    
    
    
    
    
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
