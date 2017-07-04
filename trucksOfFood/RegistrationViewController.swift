//
//  RegistrationViewController.swift
//  trucksOfFood
//
//  Created by Taylor Simpson on 6/2/17.
//  Copyright © 2017 Taylor Simpson. All rights reserved.
//

import UIKit
import FirebaseAuth
import BEMCheckBox
class RegistrationViewController: UIViewController, UITextFieldDelegate {

    @IBAction func isFoodTruckAction(_ sender: Any) {
        
        if isTruckDriverBox.on == true {
        
            print("I am on")
            
            let defaults = UserDefaults.standard
            
            defaults.set(true, forKey: "isTruckDriver")
        
        
        } else if isTruckDriverBox.on == false {
        
        
            let defaults = UserDefaults.standard
            
            defaults.removeObject(forKey: "isTruckDriver")
            
            print(" I am off")
        
        }
        
        
        
        
    }
    @IBOutlet weak var isTruckDriverBox: BEMCheckBox!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var regIndicator: UIActivityIndicatorView!
     let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(hue: 0.3472, saturation: 0.8, brightness: 0.41, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.title = "Registration"
        
       
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
        
        
        self.emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        regIndicator.isHidden = true
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        
    
    
    }
    @IBAction func registerButtonAction(_ sender: Any) {
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            
            
            if self.emailTextField.text == "" || self.passwordTextField.text == ""{
            
                let registerAlert = UIAlertController(title: "Registration Error", message: "You must have an email and a password", preferredStyle: .alert)
                
                registerAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(registerAlert, animated: true, completion: nil)
                
                return
            
            
            
            }
            self.regIndicator.isHidden = false
            self.regIndicator.startAnimating()
            
            if error != nil {
                
                print (error?.localizedDescription as Any)
                
                
                
                
                
                
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
                
                
                self.regIndicator.stopAnimating()
                
                return
                
                
                
                
                
                
            }
            
            
            
            let mainStoryboard: UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
            
            let homeViewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "loginPage")
            
            self.present(homeViewController, animated: true, completion: nil)
            
            self.regIndicator.stopAnimating()
            
        }
        
        
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

}
