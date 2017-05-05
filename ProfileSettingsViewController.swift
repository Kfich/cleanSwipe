//
//  ProfileSettingsViewController.swift
//  CleanSwipe0-1
//
//  Created by Hedgeable on 7/11/16.
//  Copyright © 2016 Kevin Fich. All rights reserved.
//

import UIKit
import Firebase

class ProfileSettingsViewController: UIViewController {
    
    // Properties
    // ==============================
    
    var currentUser = User()
    let updatedUser = User()

    
    // IBOutlets
    // ==============================
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print("Profile Settings \n")
        
        let fullNameArr = currentUser.fullName.characters.split{$0 == " "}.map(String.init)

        firstNameTextField.text = fullNameArr[0]
        lastNameTextField.text = fullNameArr[1]
        emailTextField.text = currentUser.email
        usernameTextField.text = currentUser.username
        
        print("User Email: \(AuthManager.sharedManager.email) \t User Password: \(AuthManager.sharedManager.password)")

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // IBActions
    // ================================
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func finishUpdatingProfile(_ sender: AnyObject) {
        
        print("\n\nFinish Pressed")
        updateUserSettings()

    }
    
    // Custom Methods
    // =================================
    
    func updateEmail(){
        let endpointReference = Firebase(url:"https://cleanswipe.firebaseio.com")
        
        endpointReference?.changeEmail(forUser: AuthManager.sharedManager.email, password: AuthManager.sharedManager.password,
                                       toNewEmail: self.updatedUser.email, withCompletionBlock: { error in
                                        
                                        if error != nil {
                                            // There was an error processing the request
                                            
                                            print("\nThere was an error updating the email")
                                        } else {
                                            // Email changed successfully
                                            
                                            print("\nThe email was update SUCCESSFULLY")
                                            
                                            // Retrieve the credentials, update the email, the sync the new dict
                                            let userDict = AuthManager.sharedManager.retrieveUserCredentials()
                                            
                                            print("Current Credentials: \t\(userDict)")
                                            
                                            //userDict.setValue(self.updatedUser.email, forKey: "email")
                                            
                                            // Sync new dictionary
                                           // AuthManager.sharedManager.rememberUserCredentials(userDict)
                                            
                                        }
                })

    }
    
    func updatePassword(){
        
        let ref = Firebase(url:"https://cleanswipe.firebaseio.com")
    

        ref?.changePassword(forUser: AuthManager.sharedManager.email, fromOld: AuthManager.sharedManager.password,
                                  toNew: self.updatedUser.password, withCompletionBlock: { error in
                                    if error != nil {
                                        // There was an error processing the request
                                        
                                        print("\nThere was an error updating the password")
                                    } else {
                                        // Password changed successfully
                                        
                                        print("\nThe password was updates SUCCESFULLY BITCH")
                                        
                                        // Retrieve the credentials, update the email, the sync the new dict
                                        let userDict = AuthManager.sharedManager.retrieveUserCredentials()
                                       // userDict.setValue(self.updatedUser.password, forKey: "password")
                                        
                                        print("Password: ")
                                        print("Current Credentials: \t\(userDict)")
                                       
                                        AuthManager.sharedManager.password = self.updatedUser.password
                                        
                                        // Sync new dictionary
                                       // AuthManager.sharedManager.rememberUserCredentials(userDict)
                                    }
        })
    
    
    }
    
    func updateEmailAndPassword(){
        let endpointReference = Firebase(url:"https://cleanswipe.firebaseio.com")
        
        endpointReference?.changeEmail(forUser: AuthManager.sharedManager.email, password: AuthManager.sharedManager.password,
                                             toNewEmail: self.updatedUser.email, withCompletionBlock: { error in
                                                
                                                if error != nil {
                                                    // There was an error processing the request
                                                    
                                                    print("\nThere was an error updating the email")
                                                } else {
                                                    // Email changed successfully
                                                    
                                                    print("\nThe email was update SUCCESSFULLY")
                                                
                                                    /*
                                                    // Retrieve the credentials, update the email, the sync the new dict
                                                    let userDict = AuthManager.sharedManager.retrieveUserCredentials()
                                                    
                                                    print("Current Credentials: \t\(userDict)")
                                                    
                                                    */
                                                    
                                                    AuthManager.sharedManager.email = self.updatedUser.email
                                                    
                                                    self.updatePassword()
                                                    
                                                }
        })
        
    }
    
    
    func updateUserSettings() {
       
        
        updatedUser.firstName = self.firstNameTextField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        updatedUser.lastName = self.lastNameTextField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        updatedUser.email = self.emailTextField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        updatedUser.username = self.usernameTextField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        updatedUser.password = self.passwordTextField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        let confirmPasswordString = self.confirmPasswordTextField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    
        
        // Validate the updated user info entered in the text fields
        
        print("CurrentUser Email: \(currentUser.email)")
        print("Update Email: \(updatedUser.email)")


        
        print("Auth Email: \(AuthManager.sharedManager.email)")
        print("Auth Password: \(AuthManager.sharedManager.email)")


    
        if updatedUser.password.characters.count < 6 || confirmPasswordString.characters.count < 6 || confirmPasswordString != updatedUser.password || updatedUser.email.characters.count == 0 || !self.validateEmail(updatedUser.email) || updatedUser.firstName.characters.count == 0 || updatedUser.lastName.characters.count == 0 || updatedUser.username.characters.count == 0 {
            
            let alert = UIAlertController(title: "Sorry, there was a problem", message: "Please make sure you enter a valid information.", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            
        }else {

            
            let userEndpointRef = Firebase(url:"https://cleanswipe.firebaseio.com/users")
                    
            // Update logics here to include the updating of mobile number, building, etc..
            // Update these logics once the UI is updated to accomodate recieving these values
            // from the user.
    
            let updatedUserValues = [
                    "name" : updatedUser.getName(),
                    "username" : updatedUser.username,
                    "email": updatedUser.email,
                    "dorm" : self.currentUser.building,
                    "room_number" : self.currentUser.dormRoom,
                    "mobile_number" : self.currentUser.mobileNumber,
                    "referral_code" : self.currentUser.referralCode,
                    "credit" : self.currentUser.credit
            ] as [String : Any]
        
            print("\n\nUPDATED USER")
            
            print(updatedUserValues)
            
            
            // Updating emails & passwords are done seperately so before updating
            // Check if the user is updating the email, then password, if not, then
            // don't call the methods to hit the endpoints
            
            // Add an auth view controller between settings options and this VC to obtain 
            // user credentials and set the AuthManager vars accordingly before trying to 
            // update here. That way firebase can't get in the way 
            
            
            print("AuthManager Email: \(AuthManager.sharedManager.email)")
            print("UpdatedUser Email: \(updatedUser.email)")
            
            print("AuthManager Password: \(AuthManager.sharedManager.password)")
            print("UpdatedUser Password: \(updatedUser.password)")

            // Check to see if email and password are to be changed together or seperately
            
            if updatedUser.email != AuthManager.sharedManager.email && updatedUser.password != AuthManager.sharedManager.password{
                print("They WERE BOTH DIFFERENT")
                updateEmailAndPassword()
            }else if updatedUser.password != AuthManager.sharedManager.password && updatedUser.email == AuthManager.sharedManager.email{
                print("THE PASSWORDS DIFFERED")
                updatePassword()
            }else if updatedUser.email != AuthManager.sharedManager.email && updatedUser.password == AuthManager.sharedManager.password{
                
                print("THE EMAILS DIFFERED")
                updateEmail()
            }
            
            
            // Now udpate the rest of the user settings
            
            
            let userRef = userEndpointRef?.child(byAppendingPath: self.currentUser.userId)
            
            userRef?.updateChildValues(updatedUserValues , withCompletionBlock: {
                (error:Error?, ref:Firebase?) in
                    if (error != nil) {
                        print("User Data could not be saved.")
                        
                    } else {
                        print("All User Data saved successfully!")
                        self.performSegue(withIdentifier: "showProfileUpdateConfirmation", sender: self)

                    }
            })
            
               // self.performSegueWithIdentifier("showProfileUpdateConfirmation", sender: self)
                
        
        }
    }
    
    // Email validation
    
    func validateEmail(_ candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@miami.edu"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        return emailTest.evaluate(with: candidate)
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showProfileUpdateConfirmation"{
        
            print("\n\nSEGUE: Executed.")
        
    }
 

}

}

