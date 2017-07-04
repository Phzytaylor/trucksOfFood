//
//  userViewController.swift
//  trucksOfFood
//
//  Created by Taylor Simpson on 6/5/17.
//  Copyright © 2017 Taylor Simpson. All rights reserved.
//

import UIKit
import FirebaseAuth
import Eureka
import ImageRow
import CoreLocation
import PostalAddressRow

class userViewController: UIViewController {
    
    var locationManager = CLLocationManager()
    
    var locationlong: Double?
    
    var locationlat: Double?
    
    var test = (0,0)
    
  
  
    
    @IBAction func logOut(_ sender: Any) {
        
        
//        let firebaseAuth = Auth.auth()
//                do {
//                    try firebaseAuth.signOut()
//        
//                    print("SUCCESS")
//                    
//                    
//                    
//        
//        
//                } catch let signOutError as NSError {
//                    print ("Error signing out: %@", signOutError)
//        
//                }
//        
//        
//         Auth.auth().addStateDidChangeListener { (auth, user) in
//            
//            
//            if auth.currentUser == nil {
//            
//            
//                let mainStoryboard: UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
//                
//                let homeViewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "loginPage")
//                
//                self.present(homeViewController, animated: true, completion: nil)
//            
//            
//            }
//        }
//
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MY SCREEN"
        
       // determineMyCurrentLocation()
        
                 
    
        self.navigationController?.navigationBar.barTintColor = UIColor(hue: 0.3472, saturation: 0.8, brightness: 0.41, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
      
        
        //determineMyCurrentLocation()
    }
    
    
   /* func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self as! CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) -> (Double, Double) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        // manager.stopUpdatingLocation()
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        
        self.locationlat = userLocation.coordinate.latitude
        
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        self.locationlong = userLocation.coordinate.longitude
        
        
        
        return (self.locationlat!, self.locationlong!)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    } */

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
