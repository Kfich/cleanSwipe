//
//  SettingOptionsViewController.swift
//  CleanSwipe0-1
//
//  Created by Hedgeable on 7/11/16.
//  Copyright © 2016 Kevin Fich. All rights reserved.
//

import UIKit
import Firebase

class SettingOptionsViewController: UIViewController {
    
    // Properties
    // ================================
    
    var currentUser = User()
    var email = String()
    var password = String()
    
    var authorized = false
    var paymentSelected = false
    var profileSelected = false
    
    // IBOutlets
    // ================================

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.\
        
        print("Setting Options \n")
        currentUser.printUser()
        
        print("\n\n\nRetireving Credentials")
        _ = retrieveDefaultUser()
        
         print("User Email: \(AuthManager.sharedManager.email) \t User Password: \(AuthManager.sharedManager.password)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // IBActions
    // ==================================
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func updatePaymentSelected(_ sender: AnyObject) {
        paymentSelected = true
        authorized = AuthManager.sharedManager.isVerifiedForUpdateSettings
        
        if authorized == true {
            performSegue(withIdentifier: "showUpdatePayment", sender: self)
        }else{
            showAuthAlert()
        }
    }
    
    
    @IBAction func updateOptionSelected(_ sender: AnyObject) {
        profileSelected = true
        authorized = AuthManager.sharedManager.isVerifiedForUpdateSettings
        
        if authorized == true {
            performSegue(withIdentifier: "showUpdateProfile", sender: self)
        }else{
            showAuthAlert()
        }
    }
    
    // Custom methods
    // ==================================
    
    func showAuthAlert(){
        
        // Create alertController
        let alertController = UIAlertController(title: "Please verify your identity", message: "", preferredStyle: .alert)
        
        // Create login action
        let loginAction = UIAlertAction(title: "Verify", style: .default) { (_) in
            let emailTextField = alertController.textFields![0] as UITextField
            let passwordTextField = alertController.textFields![1] as UITextField
        
            
            // Retrieve the strings from each text box
            
            self.email = emailTextField.text!
            self.password = passwordTextField.text!
            
            // Call authUser action here with credentials
            
            if(self.authUser(self.email, password: self.password) == true){
                
                // Authorize user for update settings
                AuthManager.sharedManager.isVerifiedForUpdateSettings = true
                
                // Check user decision
                if self.profileSelected == true{
                    self.performSegue(withIdentifier: "showUpdateProfile", sender: self)
                }else if self.paymentSelected == true{
                    self.performSegue(withIdentifier: "showUpdatePayment", sender: self)
                }
            }else{
                
                // Should go home according to hack
                print("There was an issue unauthorizing so we should go to home screen")
            }
        }
        loginAction.isEnabled = true
        
        // Create cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        // Add textFields to alertController
        alertController.addTextField { (textField) in
            textField.placeholder = "Login"
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
                loginAction.isEnabled = textField.text != ""
            }
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        }
        // Add actions to alertController
        alertController.addAction(loginAction)
        alertController.addAction(cancelAction)
        
        // Present alertController
        present(alertController, animated: true, completion: nil)
    }
    
    
    // Authenticate user credentials
    
    // UPDATE: authUser() will instead check the entered username and password against 
    // the username and password most recently entered into the phone using UDWrapper
    // class. This will ensure that the last set of credentials entered are the ones 
    // used to update the user's info.
    
    
    func retrieveDefaultUser() -> NSDictionary{
        
        var user = NSDictionary()
        
        let userInfo = UserDefaults.standard
        
        if userInfo.value(forKey: "auth_credentials") != nil{
            
            user = userInfo.value(forKey: "auth_credentials") as! NSDictionary
            print("Credentials: \(user)")
            
            self.email = user.value(forKey: "email") as! String
            self.password = user.value(forKey: "password") as! String
            
            print("\nUsername: \(self.email) Password: \(self.password)")
            AuthManager.sharedManager.email = self.email
            AuthManager.sharedManager.password = self.password
            
            
        }else{
            print("There was no username or password")
        }
        return user
    }
    
    
    func authUser(_ email: String, password: String) -> Bool{
        
        var success = false

        // Check input against stored credentials 
        
        let userDict = AuthManager.sharedManager.retrieveUserCredentials()
        let savedEmail = userDict.value(forKey: "email") as! NSString
        let savedPassword = userDict.value(forKey: "password") as! NSString
        
        if (email == savedEmail as String && password == savedPassword as String) {
            success = true
            AuthManager.sharedManager.email = email
            AuthManager.sharedManager.password = password
        
        }else{
            print("The email and password provided are not correct")
        }
        
        print("\n\nDo they match?: \(success)")
        return success
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showUpdateProfile" {
            
            let updateProfileVC = (segue.destination as! ProfileSettingsViewController)
            updateProfileVC.currentUser = self.currentUser
        
        }else if segue.identifier == "showUpdatePayment" {
            
            let updatePaymentVC = (segue.destination as! PaymentSettingsViewController)
            updatePaymentVC.currentUser = self.currentUser
        }
    }
    

}
