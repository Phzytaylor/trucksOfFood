//
//  FoodTruckAnnotation.swift
//  trucksOfFood
//
//  Created by Taylor Simpson on 7/11/17.
//  Copyright © 2017 Taylor Simpson. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class FoodTruckAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    
    var title: String?
    
    var imageForPin: UIImage?
    
    var truckName: String?
    
    var dataBaseID: String?
    
    var averagePrice: String?
    
    var city: String?
    
    var closedTime: TimeInterval?
    
    var country: String?
    
    var customerFavorite: String?
    
    var foodType: String?
    
    var openTime: TimeInterval?
    
    var state: String?
    
    var street: String?
    
    var zipCode: String?
    
    var gpsTest: Bool?
    
    var menuDic: Dictionary<String, AnyObject>?
    


    init(coordinate: CLLocationCoordinate2D, truckName: String, dataBaseID: String, averagePrice:String, city: String, closedTime: TimeInterval, country: String, customerFavorite: String, foodType: String, openTime: TimeInterval, state: String, street: String, zipCode: String, gpsTest: Bool, title: String, imageForPin: UIImage, menuDic: Dictionary<String, AnyObject>){



    self.coordinate = coordinate
    self.truckName = truckName
    self.dataBaseID = dataBaseID
    self.averagePrice = averagePrice
    self.city = city
    self.closedTime = closedTime
    self.country = country
    self.customerFavorite = customerFavorite
    self.foodType = foodType
    self.openTime = openTime
    self.state = state
    self.street = street
    self.zipCode = zipCode
    self.gpsTest = gpsTest
    self.title = title
    self.imageForPin = imageForPin
    self.menuDic = menuDic

super.init()
    
}

    var subtitle: String? {
        return foodType
        
    }

    var image: UIImage? {
        return imageForPin
    
    }
    
}
