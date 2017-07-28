//
//  ProductClass.swift
//  trucksOfFood
//
//  Created by Taylor Simpson on 7/17/17.
//  Copyright © 2017 Taylor Simpson. All rights reserved.
//

import Foundation


class Product {
    var id: Int
    var price: Int // Stripe takes everything as cents
    var description: String
    
    init(id: Int, price: Int, name: String, description: String) {
        self.id = id
        self.price = price
        self.description = description
    }
}
