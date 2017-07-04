//
//  ViewController.swift
//  trucksOfFood
//
//  Created by Taylor Simpson on 6/1/17.
//  Copyright © 2017 Taylor Simpson. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var loginSpinner: UIActivityIndicatorView!
    
    @IBOutlet weak var passwordRestButton: UIButton!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var faceBookLogInButton: UIButton!
    
    @IBAction func registerAction(_ sender: Any) {
        
        
        performSegue(withIdentifier: "toRegisterView", sender: UIButton())
        
        
        
    }
    @IBAction func restPasswordAction(_ sender: Any) {
        
        Auth.auth().sendPasswordReset(withEmail: emailField.text!) { (error) in
            
            
            if self.emailField.text == "" {
            
                let resetAlertNoText = UIAlertController(title: "Error", message: "You must enter an email to reset the password", preferredStyle: UIAlertControllerStyle.alert)
                
                // add an action (button)
                resetAlertNoText.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                // show the alert
                self.present(resetAlertNoText, animated: true, completion: nil)
                
                return
            
            
            }
            
            
            if error != nil {
                
                print (error?.localizedDescription as Any)
                
                
                
                
                
                
                let resetAlert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                
                // add an action (button)
                resetAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                // show the alert
                self.present(resetAlert, animated: true, completion: nil)
                
                return
                
                
                
                
                
                
                
            }
            
            if error == nil {
            
            
                let sucessAlert = UIAlertController(title: "Action Completed", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                
                // add an action (button)
                sucessAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                // show the alert
                self.present(sucessAlert, animated: true, completion: nil)
                
                return
            
            
            }
            
//            let mainStoryboard: UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
//            
//            let homeViewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "loginPage")
//            
//            self.present(homeViewController, animated: true, completion: nil)
            
            
            // ...
        }
        
        
    }
    @IBAction func faceBookLoginAction(_ sender: Any) {
        
        let userDefault = UserDefaults.standard
        
        let alertWasShown = userDefault.integer(forKey: "shownCheck")
        
        
        if  alertWasShown == 0 {
        
        
        
        
        
        let alertController = UIAlertController(title: "Food Truck Check", message: "Are You A Food Truck Driver?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { (UIAlertAction) in
            let defaults = UserDefaults.standard
            
            defaults.set(true, forKey: "isTruckDriver")
            
            defaults.set(1, forKey: "shownCheck")
            
            let fbLoginManager = FBSDKLoginManager()
            fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
                if let error = error {
                    print("Failed to login: \(error.localizedDescription)")
                    return
                }
                
                guard let accessToken = FBSDKAccessToken.current() else {
                    print("Failed to get access token")
                    return
                }
                
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
                
                // Perform login by calling Firebase APIs
                Auth.auth().signIn(with: credential, completion: { (user, error) in
                    if let error = error {
                        print("Login error: \(error.localizedDescription)")
                        let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                        let okayAction = UIKit.UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(okayAction)
                        self.present(alertController, animated: true, completion: nil)
                        
                        return
                    }
                    
                    // Present the main view
                    if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "loginPage") {
                        UIApplication.shared.keyWindow?.rootViewController = viewController
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                    
                    
                    
                    
                })
                
            }
            
            
            
            
            
        })
        
        alertController.addAction(yesAction)
        
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: { (UIAlertAction) in
            print("No")
            
            
            let fbLoginManager = FBSDKLoginManager()
            fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
                if let error = error {
                    print("Failed to login: \(error.localizedDescription)")
                    return
                }
                
                guard let accessToken = FBSDKAccessToken.current() else {
                    print("Failed to get access token")
                    return
                }
                
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
                
                // Perform login by calling Firebase APIs
                Auth.auth().signIn(with: credential, completion: { (user, error) in
                    if let error = error {
                        print("Login error: \(error.localizedDescription)")
                        let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                        let okayAction = UIKit.UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(okayAction)
                        self.present(alertController, animated: true, completion: nil)
                        
                        return
                    }
                    
                    // Present the main view
                    if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "loginPage") {
                        UIApplication.shared.keyWindow?.rootViewController = viewController
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                    
                    
                    
                    
                })
                
            }
        })
        
        alertController.addAction(noAction)
        
        self.present(alertController, animated: true, completion: nil)

        
        } else {
        
        
        
        
            let fbLoginManager = FBSDKLoginManager()
            fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
                if let error = error {
                    print("Failed to login: \(error.localizedDescription)")
                    return
                }
                
                guard let accessToken = FBSDKAccessToken.current() else {
                    print("Failed to get access token")
                    return
                }
                
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
                
                // Perform login by calling Firebase APIs
                Auth.auth().signIn(with: credential, completion: { (user, error) in
                    if let error = error {
                        print("Login error: \(error.localizedDescription)")
                        let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                        let okayAction = UIKit.UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(okayAction)
                        self.present(alertController, animated: true, completion: nil)
                        
                        return
                    }
                    
                    // Present the main view
                    if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "loginPage") {
                        UIApplication.shared.keyWindow?.rootViewController = viewController
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                    
                    
                    
                    
                })
                
            }
            
            
            

        
        
        }
        
       
        
        
        
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let firebaseAuth = Auth.auth()
//        do {
//            try firebaseAuth.signOut()
//            
//            print("SUCCESS")
//            
//            
//        } catch let signOutError as NSError {
//            print ("Error signing out: %@", signOutError)
        
//        }
        
        
        let defaults = UserDefaults.standard
        
        let isTruckDriver = defaults.bool(forKey: "isTruckDriver")
        

        
        
        loginSpinner.isHidden = true
        
        emailField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        passwordField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        registerButton.layer.borderWidth = 2
        
        registerButton.layer.cornerRadius = 0.8
        
        registerButton.layer.borderColor = UIColor.white.cgColor
        
        emailField.delegate = self
        passwordField.delegate = self
        
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            // ...
            
            
            if Auth.auth().currentUser != nil && isTruckDriver == true{
                // User is signed in.
                
                
                let mainStoryboard: UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
                
                let homeViewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "TruckDriver")
                
                self.present(homeViewController, animated: true, completion: nil)

                
                
                // ...
            } else {
                // No user is signed in.
                // ...
            }
            
            
            
            
        }
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func userLoginButton(_ sender: Any) {
        
        guard let email = emailField.text, let password = passwordField.text else {
            print ("Form is not valid")
            
            return
            
        }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            
           self.loginSpinner.isHidden = false
            self.loginSpinner.startAnimating()
            
            if error != nil {
                
                print (error?.localizedDescription as Any)
                
                
                self.loginSpinner.isHidden = true
                
                
                
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
                
                return
                
                
                
                
                
                
                
            }
            
            
            
            let mainStoryboard: UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
            
            let homeViewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "myTest")
            
            self.present(homeViewController, animated: true, completion: nil)
            
            self.loginSpinner.stopAnimating()
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get {
            return .portrait
        }
    }
    
    class YourViewController: UIViewController {
        open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
            get {
                return .portrait
            }
        }}
    
    
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

}

extension UINavigationController {
    
    override open var shouldAutorotate: Bool {
        get {
            if let visibleVC = visibleViewController {
                return visibleVC.shouldAutorotate
            }
            return super.shouldAutorotate
        }
    }
    
    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        get {
            if let visibleVC = visibleViewController {
                return visibleVC.preferredInterfaceOrientationForPresentation
            }
            return super.preferredInterfaceOrientationForPresentation
        }
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get {
            if let visibleVC = visibleViewController {
                return visibleVC.supportedInterfaceOrientations
            }
            return super.supportedInterfaceOrientations
        }
    }}
