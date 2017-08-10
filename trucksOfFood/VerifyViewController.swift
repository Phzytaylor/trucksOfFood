//
//  VerifyViewController.swift
//  trucksOfFood
//
//  Created by Taylor Simpson on 8/3/17.
//  Copyright © 2017 Taylor Simpson. All rights reserved.
//

import UIKit
import Eureka
import ImageRow
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import SVProgressHUD
import PMAlertController

class VerifyViewController: FormViewController {

     var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(uploadTruckVerInfo))
        
        
        form +++ Section("Food Truck Verification")
            <<< TextRow(){
                $0.title = "Name of Business"
                $0.placeholder = "Business Name(required)"
                $0.tag = "businessName"
        }
            <<< TextRow(){
                
                $0.title = "Contact Person & Title"
                $0.placeholder = "Contact's Name"
                $0.tag = "contact"
        }
        
            <<< EmailRow(){
                $0.title = "Email"
                $0.placeholder = "Email Address"
                $0.tag = "address"
        }
        
            <<< PhoneRow(){
                $0.title = "Phone Number"
                $0.placeholder = "Enter Phone Number"
                $0.tag = "phone"
        }
        
            <<< TextRow(){
                $0.title = "Food Type Sold"
                $0.placeholder = "American"
                $0.tag = "foodType"
                
        }
        
            <<< TextRow(){
                $0.title = "BOE Sellers Permit Number"
                $0.placeholder = "Enter BOE Number"
                $0.tag = "BOE"
                
        }
        
        form +++ Section("Pictures And Social")
        
            <<< ImageRow() { row in
                row.title = "Image One"
                row.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum]
                row.clearAction = .yes(style: UIAlertActionStyle.destructive)
                row.tag = "imageOne"
        }
        
            <<< ImageRow() { row in
                row.title = "Image Two"
                row.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum]
                row.clearAction = .yes(style: UIAlertActionStyle.destructive)
                row.tag = "imageTwo"
        }
        
            <<< ImageRow() { row in
                row.title = "Image Three"
                row.sourceTypes = [.PhotoLibrary, .SavedPhotosAlbum]
                row.clearAction = .yes(style: UIAlertActionStyle.destructive)
                row.tag = "imageThree"
        }
        
            <<< URLRow(){ row in
                row.title = "Your website"
                row.placeholder = "Enter your website"
                row.tag = "website"
                
        }
            <<< URLRow(){ row in
                row.title = "Facebook"
                row.placeholder = "Enter Your Facebook Address"
                row.tag = "faceBook"
                
        }
            <<< URLRow(){ row in
                row.title = "Twitter"
                row.placeholder = "Enter Your Twitter Address"
                row.tag = "twitter"
                
        }

        // Do any additional setup after loading the view.
    }
    
    func uploadTruckVerInfo () {
        
        ref = Database.database().reference()
        let imageOne: ImageRow = form.rowBy(tag: "imageOne")!
        let imageOneValue = imageOne.value
        let imageTwo: ImageRow = form.rowBy(tag: "imageTwo")!
        let imageTwoValue = imageTwo.value
        let imageThree:ImageRow = form.rowBy(tag: "imageThree")!
        let imageThreeValue = imageThree.value
        
        
       var imagesArray = [imageOneValue, imageTwoValue, imageThreeValue]
        
        let website: URLRow = form.rowBy(tag: "website")!
        let websiteValue = website.value?.absoluteString
        let faceBook: URLRow = form.rowBy(tag: "faceBook")!
        let faceBookValue = faceBook.value?.absoluteString
        let twitter: URLRow = form.rowBy(tag: "twitter")!
        let twitterValue = twitter.value?.absoluteString
        
        
        
        let valuesDictionary = form.values()
        
        print(valuesDictionary)
        
        var businessName: TextRow = form.rowBy(tag: "businessName")!
        var businessNameValue = businessName.value
        var contact: TextRow = form.rowBy(tag: "contact")!
        var contactValue = contact.value
        var address: EmailRow = form.rowBy(tag:"address")!
        var adressValue = address.value
        var phone: PhoneRow = form.rowBy(tag:"phone")!
        var phoneValue = phone.value
        var foodType: TextRow = form.rowBy(tag:"foodType")!
        var foodTypeValue = foodType.value
        var BOE: TextRow = form.rowBy(tag:"BOE")!
        var BOEValue = BOE.value
       
        

        
        if (businessNameValue == nil || businessNameValue == nil || contactValue == nil || adressValue == nil || phoneValue == nil || foodTypeValue == nil || BOEValue == nil || imageOneValue == nil || imageTwoValue == nil || imageThreeValue == nil || websiteValue == nil || faceBookValue == nil || twitterValue == nil) {
            
            
            let blankAlert = PMAlertController(title: "Error", description: "You Left A field Blank or you are missing a picture", image: UIImage(named:"redX.png"), style: .alert)
            
            blankAlert.addAction(PMAlertAction(title: "OK", style: .default, action: {
                return
            }))
            
            self.present(blankAlert, animated: true) {
                print("done")
            }
            return
        }
        else {
            
            
            let verifcationDict = ["businessName":valuesDictionary["businessName"], "contact":valuesDictionary["contact"], "address":valuesDictionary["address"], "phone":valuesDictionary["phone"], "foodType":valuesDictionary["foodType"], "BOE":valuesDictionary["BOE"], "website":websiteValue, "faceBook":faceBookValue, "twitter":twitterValue, "isVerified": false]
            
            let truckRef = self.ref.child("Food Trucks")
            let truckInfoRef = truckRef.childByAutoId()
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
            SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
            SVProgressHUD.show()
            
            
            
            truckInfoRef.updateChildValues(verifcationDict as Any as! [AnyHashable : Any]){(error, ref) in
                
                
                if error != nil {
                    
                    print(error?.localizedDescription)
                    return
                    
                }
                
                
                let menuRef = Database.database().reference().child("truckVerifications").child((Auth.auth().currentUser?.uid)!)
                
                let menuId = truckInfoRef.key
                
                for i in 0...imagesArray.count-1  {
                    
                    
                    PostService.create(for: imagesArray[i]!, imagename: "image\(i)", at: truckRef.child(menuId))
                    
                    
                }
                
                menuRef.updateChildValues([menuId : 1])
                
                SVProgressHUD.showSuccess(withStatus: "Success")
                
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
