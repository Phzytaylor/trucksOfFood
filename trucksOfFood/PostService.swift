//
//  PostService.swift
//  trucksOfFood
//
//  Created by Taylor Simpson on 8/7/17.
//  Copyright © 2017 Taylor Simpson. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

struct PostService {
    static func create(for image: UIImage,imagename: String, at reference: DatabaseReference) {
        let imageRef = Storage.storage().reference().child("verificationImages").child((Auth.auth().currentUser?.uid)!)
        
        StorageService.uploadImage(image, at: imageRef) { (downloadURL) in
            guard let downloadURL = downloadURL else {
                return
            }
            
            let urlString = downloadURL.absoluteString
            
          
           reference.updateChildValues([imagename: urlString])
            
            print("image url: \(urlString)")
        }
        
        
        
    }
}
