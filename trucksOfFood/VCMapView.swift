//
//  VCMapView.swift
//  biblos
//
//  Created by Taylor FIckle Simpson on 2/17/17.
//  Copyright © 2017 Taylor Simpson. All rights reserved.
//

import Foundation
import MapKit
import FirebaseDatabase
import PMAlertController

extension CustomerMainViewController: MKMapViewDelegate {
    
    
    
    // 1
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        let annotationIdentifier = "Identifier"
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = TrucksMap.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation as! FoodTruckAnnotation
        }
        else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        if let annotationView = annotationView {
            
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "foodtruck.jpg")
        }
        return annotationView
    }


    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        
        if let annotation = view.annotation as? FoodTruckAnnotation {
        
            averagePrice = annotation.averagePrice!
            city = annotation.city!
            closedTime = annotation.closedTime!
            
           
            country = annotation.country!
            customerFavorite = annotation.customerFavorite!
            foodType = annotation.foodType!
            openTime = annotation.openTime!
            state = annotation.state!
            
            street = annotation.street!
            truckName = annotation.truckName!
            
            dataBaseID = annotation.dataBaseID!
            
            zipCode = annotation.zipCode!
            
            gpsTest = annotation.gpsTest!
            
        
        }
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        
       
        
        
        
        
        if segue.identifier == "toMenu" {
            
             let viewController = segue.destination as! MenuListForCustomerTableViewController
            
            viewController.menuItemsArray = [menuItems]
            
            viewController.truckName = truckName
            
            
        }
        
        
            
            
            
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("You Touched ME!")
        
        if let annotation = view.annotation as? FoodTruckAnnotation {
            
            averagePrice = annotation.averagePrice!
            city = annotation.city!
            closedTime = annotation.closedTime!
            
            
            country = annotation.country!
            customerFavorite = annotation.customerFavorite!
            foodType = annotation.foodType!
            openTime = annotation.openTime!
            state = annotation.state!
            
            street = annotation.street!
            truckName = annotation.truckName!
            
            dataBaseID = annotation.dataBaseID!
            
            zipCode = annotation.zipCode!
            
            gpsTest = annotation.gpsTest!
            
            menuItems = annotation.menuDic!

            let alertController = PMAlertController(title: " Choose One", description: "View menu and order or get directions", image: UIImage(named: "menu_filled.png"), style: .alert)
           
 
           
            
            alertController.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: {
                return
            }))
            
            alertController.addAction(PMAlertAction(title: "Take me there!", style: .default, action: {
                let regionDistance: CLLocationDistance = 100
                
                let destinationCoords = CLLocationCoordinate2DMake(annotation.coordinate.latitude, annotation.coordinate.longitude)
                
                let regionSpan = MKCoordinateRegionMakeWithDistance(destinationCoords, regionDistance, regionDistance)
                
                let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan:regionSpan.span)]
                
                let placeMark = MKPlacemark(coordinate: destinationCoords)
                
                let mapItem = MKMapItem(placemark: placeMark)
                
                mapItem.name = annotation.truckName
                
                mapItem.openInMaps(launchOptions: options)
                
                
                
                return
                
            }))
            
            alertController.addAction(PMAlertAction(title: "View menu and order", style: .default, action: {
                self.performSegue(withIdentifier: "toMenu", sender: CustomerMainViewController())
            }))
           
            self.present(alertController, animated: true, completion: nil)
            

            
            
            
            
            
          
            
            
        }

        

        
        
        
        
    }

    
    func postTrucks(){
    
        
        
        if foodTypePicked == "" || foodTypePicked == nil {
        let truckRef = Database.database().reference().child("Food Trucks")
        
        
        
        
        truckRef.observeSingleEvent(of: .value, with: {snapshot in
            
                        if let userDict = snapshot.value as? [String:AnyObject]{
                
                for each in userDict as [String:AnyObject]{
                    
                    let truckLats =  each.value["truckLat"] as! NSNumber
                    
                    let truckLongs = each.value["truckLong"] as! NSNumber
                    
                    let averagePrice = each.value["averagePrice"] as! Double
                    let city = each.value["city"] as! String
                    let closedTime = each.value["closedTime"] as! TimeInterval
                    let country = each.value["country"] as! String
                    let customerFavorite = each.value["customerFavorite"] as! String
                    let foodType = each.value["foodType"] as! String
                    let openTime = each.value["openTime"] as! TimeInterval
                    let state = each.value["state"] as! String
                    let street = each.value["street"] as! String
                    let truckName = each.value["truckName"] as! String
                    let userID = each.value["userID"] as! String
                    let zipCode = each.value["zipCode"] as! String
                    let gpsTest = each.value["gpsTest"] as! Bool
                    let menu = each.value["Menu"] as! Dictionary<String, AnyObject>
                    
                    
                    
                    self.truckLatsArray.append(Double(truckLats))
                    
                    self.truckLongsArray.append(Double(truckLongs))
                    
                    self.averagePriceArray.append(String(averagePrice))
                    
                    self.cityArray.append(city)
                    
                    self.closedTimeArray.append(closedTime)
                    
                    self.countryArray.append(country)
                    
                    self.customerFavoriteArray.append(customerFavorite)
                    
                    self.foodTypeArray.append(foodType)
                    
                    self.openTimeArray.append(openTime)
                    
                    self.stateArray.append(state)
                    
                    self.streetArray.append(street)
                    
                    self.truckNameArray.append(truckName)
                    
                    self.dataBaseIDArray.append(userID)
                    
                    self.zipCodeArray.append(zipCode)
                    
                    self.gpsTestArray.append(gpsTest)
                    
                    self.menusArray.append(menu)
                    
                    print(truckLats)
                    print(menu)
                    
                    
                }
                
                
            }
            
                    for i in 0...(self.truckLatsArray.count-1){
                
                
                               
                let locationCoordinates = CLLocationCoordinate2D(latitude: self.truckLatsArray[i], longitude: self.truckLongsArray[i])
                
                
                // let point = BookAnnotation(title:self.bookTitlesArray[i], Comment: self.commentsArry[i],coordinate: locationCoordinates)
                
                let point = FoodTruckAnnotation(coordinate: locationCoordinates, truckName: self.truckNameArray[i], dataBaseID: self.dataBaseIDArray[i], averagePrice: self.averagePriceArray[i], city: self.cityArray[i], closedTime: self.closedTimeArray[i], country: self.countryArray[i], customerFavorite: self.customerFavoriteArray[i], foodType: self.foodTypeArray[i], openTime: self.openTimeArray[i], state: self.stateArray[i], street: self.streetArray[i], zipCode: self.zipCodeArray[i], gpsTest: self.gpsTestArray[i], title: self.truckNameArray[i], imageForPin: UIImage(named: "foodtruck.jpg")!, menuDic: self.menusArray[i])
 
                    self.TrucksMap.addAnnotation(point)
    
            }
    
        })
    
    
    }
        else if self.foodType != nil{
        
            let truckRef = Database.database().reference().child("Food Trucks")
            
            truckRef.queryOrdered(byChild: "foodType").queryEqual(toValue: foodTypePicked).observeSingleEvent(of: .value, with: {snapshot in
                
                if let userDict = snapshot.value as? [String:AnyObject]{
                    
                    for each in userDict as [String:AnyObject]{
                        
                        let truckLats =  each.value["truckLat"] as! NSNumber
                        
                        let truckLongs = each.value["truckLong"] as! NSNumber
                        
                        let averagePrice = each.value["averagePrice"] as! Double
                        let city = each.value["city"] as! String
                        let closedTime = each.value["closedTime"] as! TimeInterval
                        let country = each.value["country"] as! String
                        let customerFavorite = each.value["customerFavorite"] as! String
                        let foodType = each.value["foodType"] as! String
                        let openTime = each.value["openTime"] as! TimeInterval
                        let state = each.value["state"] as! String
                        let street = each.value["street"] as! String
                        let truckName = each.value["truckName"] as! String
                        let userID = each.value["userID"] as! String
                        let zipCode = each.value["zipCode"] as! String
                        let gpsTest = each.value["gpsTest"] as! Bool
                        let menu = each.value["Menu"] as! Dictionary<String, AnyObject>
                        
                        
                        self.truckLatsArray.append(Double(truckLats))
                        
                        self.truckLongsArray.append(Double(truckLongs))
                        
                        self.averagePriceArray.append(String(averagePrice))
                        
                        self.cityArray.append(city)
                        
                        self.closedTimeArray.append(closedTime)
                        
                        self.countryArray.append(country)
                        
                        self.customerFavoriteArray.append(customerFavorite)
                        
                        self.foodTypeArray.append(foodType)
                        
                        self.openTimeArray.append(openTime)
                        
                        self.stateArray.append(state)
                        
                        self.streetArray.append(street)
                        
                        self.truckNameArray.append(truckName)
                        
                        self.dataBaseIDArray.append(userID)
                        
                        self.zipCodeArray.append(zipCode)
                        
                        self.gpsTestArray.append(gpsTest)
                        
                        self.menusArray.append(menu)
                        
                        print(truckLats)
                        
                        print(menu)
                        
                        
                    }
                    
                    
                }
                
                for i in 0...(self.truckLatsArray.count-1){
                    
                    
                    
                    let locationCoordinates = CLLocationCoordinate2D(latitude: self.truckLatsArray[i], longitude: self.truckLongsArray[i])
                    
                    
                    // let point = BookAnnotation(title:self.bookTitlesArray[i], Comment: self.commentsArry[i],coordinate: locationCoordinates)
                    
                    let point = FoodTruckAnnotation(coordinate: locationCoordinates, truckName: self.truckNameArray[i], dataBaseID: self.dataBaseIDArray[i], averagePrice: self.averagePriceArray[i], city: self.cityArray[i], closedTime: self.closedTimeArray[i], country: self.countryArray[i], customerFavorite: self.customerFavoriteArray[i], foodType: self.foodTypeArray[i], openTime: self.openTimeArray[i], state: self.stateArray[i], street: self.streetArray[i], zipCode: self.zipCodeArray[i], gpsTest: self.gpsTestArray[i], title: self.truckNameArray[i], imageForPin: UIImage(named: "foodtruck.jpg")!, menuDic: self.menusArray[i])
                    
                    self.TrucksMap.addAnnotation(point)
                    
                }
                
            })
            
            
        }

        
        
        }
    
    
    func postDistanceFiltiredTrucks (){
    
    
    
    if foodTypePicked == "" || foodTypePicked == nil {
    let truckRef = Database.database().reference().child("Food Trucks")
    
    
    
    
    truckRef.observeSingleEvent(of: .value, with: {snapshot in
    
    if let userDict = snapshot.value as? [String:AnyObject]{
    
    for each in userDict as [String:AnyObject]{
    
    let truckLats =  each.value["truckLat"] as! NSNumber
    
    let truckLongs = each.value["truckLong"] as! NSNumber
    
    let averagePrice = each.value["averagePrice"] as! Double
    let city = each.value["city"] as! String
    let closedTime = each.value["closedTime"] as! TimeInterval
    let country = each.value["country"] as! String
    let customerFavorite = each.value["customerFavorite"] as! String
    let foodType = each.value["foodType"] as! String
    let openTime = each.value["openTime"] as! TimeInterval
    let state = each.value["state"] as! String
    let street = each.value["street"] as! String
    let truckName = each.value["truckName"] as! String
    let userID = each.value["userID"] as! String
    let zipCode = each.value["zipCode"] as! String
    let gpsTest = each.value["gpsTest"] as! Bool
    let menu = each.value["Menu"] as! Dictionary<String, AnyObject>
    
    
    
    self.truckLatsArray.append(Double(truckLats))
    
    self.truckLongsArray.append(Double(truckLongs))
    
    self.averagePriceArray.append(String(averagePrice))
    
    self.cityArray.append(city)
    
    self.closedTimeArray.append(closedTime)
    
    self.countryArray.append(country)
    
    self.customerFavoriteArray.append(customerFavorite)
    
    self.foodTypeArray.append(foodType)
    
    self.openTimeArray.append(openTime)
    
    self.stateArray.append(state)
    
    self.streetArray.append(street)
    
    self.truckNameArray.append(truckName)
    
    self.dataBaseIDArray.append(userID)
    
    self.zipCodeArray.append(zipCode)
    
    self.gpsTestArray.append(gpsTest)
    
    self.menusArray.append(menu)
    
    print(truckLats)
    print(menu)
    
    
    }
    
    
    }
    
    for i in 0...(self.truckLatsArray.count-1){
    
    
    
        var userLocation  = self.userLocationForFilter
        
        var userLocationCoords:CLLocation = CLLocation(latitude: self.userLocationForFilter.latitude, longitude: self.userLocationForFilter.longitude)
        
        /*var myAnt:MKAnnotationView!
         
         var annotationLocation = myAnt.annotation as! FoodTruckAnnotation!
         
         var anotationisInRange: CLLocationCoordinate2D = (annotationLocation?.coordinate)!
         
         var annotationCoords: CLLocation = CLLocation(latitude: anotationisInRange.latitude, longitude: anotationisInRange.longitude)
         
         
         */
        
        let locationCoordinates = CLLocation(latitude: self.truckLatsArray[i], longitude: self.truckLongsArray[i])
        
        
        
        
        
        
        
        var distance = locationCoordinates.distance(from: userLocationCoords)/1609.344
        
        print("This is the \(distance)")
        
        if distance <= 500.00 {
            
            
            let locationCoordinatesForAnt = CLLocationCoordinate2D(latitude: self.truckLatsArray[i], longitude: self.truckLongsArray[i])
            
            let point = FoodTruckAnnotation(coordinate: locationCoordinatesForAnt, truckName: self.truckNameArray[i], dataBaseID: self.dataBaseIDArray[i], averagePrice: self.averagePriceArray[i], city: self.cityArray[i], closedTime: self.closedTimeArray[i], country: self.countryArray[i], customerFavorite: self.customerFavoriteArray[i], foodType: self.foodTypeArray[i], openTime: self.openTimeArray[i], state: self.stateArray[i], street: self.streetArray[i], zipCode: self.zipCodeArray[i], gpsTest: self.gpsTestArray[i], title: self.truckNameArray[i], imageForPin: UIImage(named: "foodtruck.jpg")!, menuDic: self.menusArray[i])
            
            self.TrucksMap.addAnnotation(point)
            
            
            
        }
    }
    
    })
    
    
    }
    else if self.foodType != nil{
    
    let truckRef = Database.database().reference().child("Food Trucks")
    
    truckRef.queryOrdered(byChild: "foodType").queryEqual(toValue: foodTypePicked).observeSingleEvent(of: .value, with: {snapshot in
    
    if let userDict = snapshot.value as? [String:AnyObject]{
    
    for each in userDict as [String:AnyObject]{
    
    let truckLats =  each.value["truckLat"] as! NSNumber
    
    let truckLongs = each.value["truckLong"] as! NSNumber
    
    let averagePrice = each.value["averagePrice"] as! Double
    let city = each.value["city"] as! String
    let closedTime = each.value["closedTime"] as! TimeInterval
    let country = each.value["country"] as! String
    let customerFavorite = each.value["customerFavorite"] as! String
    let foodType = each.value["foodType"] as! String
    let openTime = each.value["openTime"] as! TimeInterval
    let state = each.value["state"] as! String
    let street = each.value["street"] as! String
    let truckName = each.value["truckName"] as! String
    let userID = each.value["userID"] as! String
    let zipCode = each.value["zipCode"] as! String
    let gpsTest = each.value["gpsTest"] as! Bool
    let menu = each.value["Menu"] as! Dictionary<String, AnyObject>
    
    
    self.truckLatsArray.append(Double(truckLats))
    
    self.truckLongsArray.append(Double(truckLongs))
    
    self.averagePriceArray.append(String(averagePrice))
    
    self.cityArray.append(city)
    
    self.closedTimeArray.append(closedTime)
    
    self.countryArray.append(country)
    
    self.customerFavoriteArray.append(customerFavorite)
    
    self.foodTypeArray.append(foodType)
    
    self.openTimeArray.append(openTime)
    
    self.stateArray.append(state)
    
    self.streetArray.append(street)
    
    self.truckNameArray.append(truckName)
    
    self.dataBaseIDArray.append(userID)
    
    self.zipCodeArray.append(zipCode)
    
    self.gpsTestArray.append(gpsTest)
    
    self.menusArray.append(menu)
    
    print(truckLats)
    
    print(menu)
    
    
    }
    
    
    }
    
    for i in 0...(self.truckLatsArray.count-1){
    
        var userLocation  = self.userLocationForFilter
        
        var userLocationCoords:CLLocation = CLLocation(latitude: self.userLocationForFilter.latitude, longitude: self.userLocationForFilter.longitude)
        
    /*var myAnt:MKAnnotationView!
        
        var annotationLocation = myAnt.annotation as! FoodTruckAnnotation!
        
        var anotationisInRange: CLLocationCoordinate2D = (annotationLocation?.coordinate)!
        
        var annotationCoords: CLLocation = CLLocation(latitude: anotationisInRange.latitude, longitude: anotationisInRange.longitude)
        
        
        */
        
        let locationCoordinates = CLLocation(latitude: self.truckLatsArray[i], longitude: self.truckLongsArray[i])
        
        
        
       

        
        
        var distance = locationCoordinates.distance(from: userLocationCoords)/1609.344
        
        print("This is the \(distance)")
        
        if distance < 20 {
            
            
            let locationCoordinatesForAnt = CLLocationCoordinate2D(latitude: self.truckLatsArray[i], longitude: self.truckLongsArray[i])
            
            let point = FoodTruckAnnotation(coordinate: locationCoordinatesForAnt, truckName: self.truckNameArray[i], dataBaseID: self.dataBaseIDArray[i], averagePrice: self.averagePriceArray[i], city: self.cityArray[i], closedTime: self.closedTimeArray[i], country: self.countryArray[i], customerFavorite: self.customerFavoriteArray[i], foodType: self.foodTypeArray[i], openTime: self.openTimeArray[i], state: self.stateArray[i], street: self.streetArray[i], zipCode: self.zipCodeArray[i], gpsTest: self.gpsTestArray[i], title: self.truckNameArray[i], imageForPin: UIImage(named: "foodtruck.jpg")!, menuDic: self.menusArray[i])
            
            self.TrucksMap.addAnnotation(point)
            
            
            
        }

    
       
    
    // let point = BookAnnotation(title:self.bookTitlesArray[i], Comment: self.commentsArry[i],coordinate: locationCoordinates)
    
    
    
    }
    
    })
    
    
    }
    
    
    
    }
    
    
    }



