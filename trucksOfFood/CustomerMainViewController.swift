//
//  CustomerMainViewController.swift
//  trucksOfFood
//
//  Created by Taylor Simpson on 7/7/17.
//  Copyright © 2017 Taylor Simpson. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import PMAlertController

class CustomerMainViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var myLocationButton: UIButton!
    var pointAnnotation: FoodTruckAnnotation!
    
    @IBAction func locationFilter(_ sender: Any) {
        
        let allAnnotations = self.TrucksMap.annotations
        self.TrucksMap.removeAnnotations(allAnnotations)
       
        self.truckLatsArray.removeAll()
        
        self.truckLongsArray.removeAll()
        
        self.averagePriceArray.removeAll()
        
        self.cityArray.removeAll()
        
        self.closedTimeArray.removeAll()
        
        self.countryArray.removeAll()
        
        self.customerFavoriteArray.removeAll()
        
        self.foodTypeArray.removeAll()
        
        self.openTimeArray.removeAll()
        
        self.stateArray.removeAll()
        
        self.streetArray.removeAll()
        
        self.truckNameArray.removeAll()
        
        self.dataBaseIDArray.removeAll()
        
        self.zipCodeArray.removeAll()
        
        self.gpsTestArray.removeAll()
        
        
        
        postDistanceFiltiredTrucks()
        
                
    }
    
    var userLocationForFilter: CLLocationCoordinate2D!
    
    var foodTypePicked: String?
    
    var pinAnnotationView: MKPinAnnotationView!
    var truckCoordinate = CLLocationCoordinate2D()
    
    var truckName = String()
    
    var dataBaseID = String()
    
    var averagePrice = String()
    
    var city = String()
    
    var closedTime = TimeInterval()
    
    var country = String()
    
    var customerFavorite = String()
    
    var foodType = String()
    
    var openTime = TimeInterval()
    
    var state = String()
    
    var street = String()
    
    var zipCode = String()
    
    var gpsTest = Bool()
    
    var menuItems = Dictionary<String, AnyObject>()
    
    var truckAnts: [FoodTruckAnnotation] = []
    
    var menusArray = [Dictionary<String, AnyObject>]()
    
    var truckNameArray = [String]()
    
    var dataBaseIDArray = [String]()
    
    var averagePriceArray = [String]()
    
    var cityArray = [String]()
    
    var closedTimeArray = [TimeInterval]()
    
    var countryArray = [String]()
    
    var customerFavoriteArray = [String]()
    
    var foodTypeArray = [String]()
    
    var openTimeArray = [TimeInterval]()
    
    var stateArray = [String]()
    
    var streetArray = [String]()
    
    var zipCodeArray = [String]()
    
    var truckLatsArray = [Double]()
    
    var truckLongsArray = [Double]()
    
    var truckCordArray = [[Double]]()
    
    var gpsTestArray = [Bool]()

    
    
    @IBAction func currentLocationButton(_ sender: Any) {
        
        
        manager.startUpdatingLocation()
        
    }

    @IBOutlet weak var TrucksMap: MKMapView!
    
    var lastUserLocation: MKUserLocation?
    
    let manager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Access the last object from locations to get perfect current location
        if let location = locations.last {
            let span = MKCoordinateSpanMake(0.00775, 0.00775)
            let myLocation = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude)
            
            self.userLocationForFilter = myLocation
            
            
            let region = MKCoordinateRegionMake(myLocation, span)
            TrucksMap.setRegion(region, animated: true)
        }
        self.TrucksMap.showsUserLocation = true
        manager.stopUpdatingLocation()
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false
        
        if foodTypePicked != nil || foodTypePicked != "" {
        
        let allAnnotations = self.TrucksMap.annotations
        self.TrucksMap.removeAnnotations(allAnnotations)
        

        
            postTrucks()
        
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Food Near You"
        myLocationButton.setBackgroundImage(UIImage(named:"myLocation.png"), for: .normal)
        
        self.navigationController?.navigationBar.tintColor = .white
        
        self.navigationController?.navigationBar.barTintColor = UIColor(hue: 0.3472, saturation: 0.8, brightness: 0.41, alpha: 1.0)
        
         var settingsButton =  UIBarButtonItem(title:NSString(string: "\u{2699}\u{0000FE0E}") as String , style: .plain, target: self, action: #selector(accountOptions))
        
        
        let font = UIFont.systemFont(ofSize: 28) // adjust the size as required
        let attributes = [NSAttributedStringKey.font : font]
        
        settingsButton.setTitleTextAttributes(attributes, for: .normal)
        
        
        navigationItem.rightBarButtonItem = settingsButton
        
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()

        self.TrucksMap.delegate = self
        
        postTrucks()
        
        

        // Do any additional setup after loading the view.
    }
    

    
    func accountOptions () {
        performSegue(withIdentifier: "userSettings", sender: CustomerMainViewController())
        
        
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
