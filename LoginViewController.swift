//
//  LoginViewController.swift
//  CleanSwipe0-1
//
//  Created by Kevin Fich on 4/13/16.
//  Copyright © 2016 Kevin Fich. All rights reserved.
//

import UIKit
import Firebase
import AnimatedTextInput


class LoginViewController: UIViewController {
    
    // Properties
    
    var currentUser = User()
    
    var email = ""
    var password = ""
    
    
    struct CustomTextInputStyle: AnimatedTextInputStyle {
        let activeColor = UIColor.white
        let inactiveColor = UIColor.white.withAlphaComponent(0.3)
        let lineInactiveColor = UIColor.white.withAlphaComponent(0.9)
        let errorColor = UIColor.red
        let textInputFont = UIFont.systemFont(ofSize: 16)
        let textInputFontColor = UIColor.white
        let placeholderMinFontSize: CGFloat = 12
        let counterLabelFont: UIFont? = UIFont(name: "Geomanist-Regular", size: 12)
        let leftMargin: CGFloat = 25
        let topMargin: CGFloat = 20
        let rightMargin: CGFloat = 0
        let bottomMargin: CGFloat = 10
        let yHintPositionOffset: CGFloat = 7
        let yPlaceholderPositionOffset: CGFloat = 0
    }
    
    // IBOutlets
    // ========================================
    
    @IBOutlet var usernameTextField: AnimatedTextInput!
    @IBOutlet var passwordTextField: AnimatedTextInput!
    
    
    
    
    // ========================================


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        usernameTextField.style = CustomTextInputStyle()
        passwordTextField.style = CustomTextInputStyle()
        
        usernameTextField.accessibilityLabel = "standard_text_input"
        usernameTextField.placeHolderText = "Username/Email"
        
        passwordTextField.placeHolderText = "Password"
        passwordTextField.type = .password
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)

        
        _ = retrieveDefaultUser()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // IBActions
    // ========================================
    @IBAction func userLogin(_ sender: AnyObject) {
        
        currentUser.email = usernameTextField.text!
        currentUser.password = passwordTextField.text!
        
        if AuthManager.sharedManager.isValidEmail(currentUser.email) {
            
            // Configure loading indicator
            let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.indeterminate
            loadingNotification.label.text = "Loading"
            
            let ref = Firebase(url: "https://cleanswipe.firebaseio.com")
            
            ref?.authUser(currentUser.email, password: currentUser.password,
                         withCompletionBlock: { error, authData in
                            if error != nil {
                                // There was an error logging in to this account
                                print("There was an error logging in")
                                // Show error message here
                                
                                // Hide loading indicator
                                loadingNotification.hide(animated: true)
                                
                                let alert = UIAlertController(title: "There was a problem", message: "Please make sure you enter a valid email/password.", preferredStyle: UIAlertControllerStyle.alert)
                                
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                                
                                
                                
                            } else {
                                // We are now logged in
                                
                                print("Yahoo, we loggin in successfully!")
                                
                                AuthManager.sharedManager.email = self.currentUser.email
                                AuthManager.sharedManager.password = self.currentUser.password
                                
                                // Store last email
                                let email = ["email": self.currentUser.email]
                                AuthManager.sharedManager.rememberLastEmail(email as NSDictionary)
                                
                                
                                // Store current credentials
                                let credentials = ["email": self.currentUser.email, "password":self.currentUser.password]
                                AuthManager.sharedManager.rememberUserCredentials(credentials as NSDictionary)
                                
                                loadingNotification.hide(animated: true)
                                
                                print("User Email: \(AuthManager.sharedManager.email) \t User Password: \(AuthManager.sharedManager.password)")
                                
                                
                                self.view.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController")
                                self.view.window?.makeKeyAndVisible()
                                
                            }
            })
            
        }else{
            // Show ok alert
            let alert = UIAlertController(title: "There was a problem", message: "Please make sure you enter a valid miami email address.", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

    }
    
    
    // Custom methods
    // ========================================
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }


    func retrieveDefaultUser() -> NSDictionary{
        
        var user = NSDictionary()
            
        let userInfo = UserDefaults.standard
            
        if userInfo.value(forKey: "auth_credentials") != nil{
                
            user = userInfo.value(forKey: "auth_credentials") as! NSDictionary
            print("Credentials: \(user)")
            
            self.email = user.value(forKey: "email") as! String
            self.password = user.value(forKey: "password") as! String
            
            print("\nUsername: \(self.email) Password: \(self.password)")
            self.usernameTextField.text = self.email
            self.passwordTextField.text = self.password
            
            
        }else{
            print("There was no username or password")
        }
        return user
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
