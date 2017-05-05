//
//  RegistrationP2ViewController.swift
//  CleanSwipe0-1
//
//  Created by Kevin Fich on 4/12/16.
//  Copyright © 2016 Kevin Fich. All rights reserved.
//

import UIKit
import Firebase

class RegistrationP2ViewController: UIViewController, DormListViewControllerDelegate {
    
    // Properties
    
    var selectedDorm = String()
    var currentUser = User()
    
    // ========================================
    
    @IBOutlet weak var bgScrollView: UIScrollView!
    
    @IBOutlet weak var selectedDormLabel: UILabel!
    
    @IBOutlet weak var roomNumberTextField: UITextField!
    
    @IBOutlet weak var mobileNumberTextField: UITextField!
    
    
    
    @IBOutlet var referralCheckmarkImage: UIImageView!
    
    @IBOutlet var referralTextField: UITextField!
    // ========================================

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        bgScrollView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        // Hide image
        
        referralCheckmarkImage.isHidden = true
        
      //  currentUser.printUser()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    // IBActions
    // ================================================
    
    @IBAction func showDormList(_ sender: AnyObject) {
        
       // self.navigationController?.navigationBarHidden = true
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DormList") as! DormListViewController
        vc.delegate = self;
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func doneRegisteringUser(_ sender: AnyObject) {
        
        if self.referralTextField.text != "" {
            let refCode = self.referralTextField.text
            if refCode == "MIAMI2017"{
                self.currentUser.credit = 5
                // Show alert saying that it was good
                referralCheckmarkImage.isHidden = false
            }else{
                self.currentUser.credit = 0
                
            }
        }
        
        currentUser.mobileNumber = self.mobileNumberTextField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        currentUser.building = self.selectedDorm
        currentUser.dormRoom = self.roomNumberTextField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
       
        currentUser.printUser()

        
        print("Mobile Num: \(currentUser.mobileNumber)  Password: \(currentUser.building)")
        
        if currentUser.building.characters.count == 0 || currentUser.dormRoom.characters.count == 0 || !self.validatePhone(currentUser.mobileNumber) {
            
            let alert = UIAlertController(title: "Sorry, there was a problem", message: "Please make sure you enter a valid information.", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            
        }else{
            
            
            // Configure loading indicator
            let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.indeterminate
            loadingNotification.label.text = "Loading"
            
            // Check for valid code here
            
            if referralTextField.text != "" {
                let refCode = referralTextField.text
                if AppointmentManager.sharedManager.expiredReferralCode(refCode: refCode!){
                    // The code was expired
                    
                    // Show alert saying that it was no good
                }else{
                    // If it was good, award credit to user 
                    
                    // Then upload the now-used ref_code
                    
                }
            }
            
            
            let ref = Firebase(url: "https://cleanswipe.firebaseio.com")
            ref?.createUser(currentUser.email, password: currentUser.password,
                           withValueCompletionBlock: { error, result in
                            if error != nil {
                                // There was an error creating the account
                                print("There was an error creating user.")
                                
                                // Hide HUD
                                loadingNotification.hide(animated: true)
                                
                                // Show error alert
                                
                                let alert = UIAlertController(title: "There was a problem", message: "Please make sure you enter valid information.", preferredStyle: UIAlertControllerStyle.alert)
                                
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)

                                
                                
                            } else {
                                let uid = result?["uid"] as? String
                                print("Successfully created user account with uid: \(uid)")
                                
                                // Validate referral code
                                
                                let newUser = [
                                    "name" : self.currentUser.getName(),
                                    "username" : self.currentUser.username,
                                    "email": self.currentUser.email,
                                    "dorm" : self.currentUser.building,
                                    "room_number" : self.currentUser.dormRoom,
                                    "mobile_number" : self.currentUser.mobileNumber,
                                    "referral_code" : self.randomStringWithLength(10),
                                    "credit" : self.currentUser.credit
                                ] as [String : Any]
                                // Create a child path with a key set to the uid underneath the "users" node
                                // This creates a URL path like the following:
                                //  - https://<YOUR-FIREBASE-APP>.firebaseio.com/users/<uid>
                                ref?.child(byAppendingPath: "users")
                                    .child(byAppendingPath: uid).setValue(newUser)
                                
                                // Hide HUD 
                                
                                loadingNotification.hide(animated: true)
                                
                                self.loginRegisteredUser()
                            }
            })
            
        }

        
        
    }
    
    
    // Custom Methods
    // ==========================================
    
    // Theres a casting issue with the home view controller from the storyboard. Use window.root or whatever 
    
    
    
    
    func validatePhone(_ candidate: String) -> Bool {
        let phoneRegex = "[0-9]{10}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: candidate)
    }
    
    func validateRoom(_ candidate: String) -> Bool {
        let phoneRegex = "[0-9]"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: candidate)
    }
    
    func loginRegisteredUser(){
        
        let ref = Firebase(url: "https://cleanswipe.firebaseio.com/")

        
        ref?.authUser(currentUser.email, password: currentUser.password,
            withCompletionBlock: { error, authData in
                if error != nil {
                    // There was an error logging in to this account
                    print("There was an error logging in")
                } else {
                    // We are now logged in
                    
                    print("Yahoo, we loggin in successfully!")
                    
                    // Set email and password to global shared manager vars
                    
                    AuthManager.sharedManager.email = self.currentUser.email
                    AuthManager.sharedManager.password = self.currentUser.password
                    
                    // Store last email
                    let email = ["email": self.currentUser.email]
                    AuthManager.sharedManager.rememberLastEmail(email as NSDictionary)

                    // Store user credentials here
                    let credentials = ["email": self.currentUser.email, "password":self.currentUser.password]
                    AuthManager.sharedManager.rememberUserCredentials(credentials as NSDictionary)
                    
                    // Show homeVC
                    self.view.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController")
                    self.view.window?.makeKeyAndVisible()
                }
        })

    }
    
    
    func randomStringWithLength (_ len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for _ in 0 ..< 10 {
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        
        //  print(randomString)
        return randomString
    }
    
    // Referral Code Validation
    
    func checkForValidReferralCode(code: String) -> Bool{
        let isValidCode = false
        // Add validation code here
        
        return isValidCode
    }

    func showOKAlertView(_ title: String?, message: String?) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertView, animated: true, completion: nil)
    }
    
    
    // Delegates
    // ================================================
    
    func dormListDidFinishSelecting(_ selected: String) {
        let swiftColor = UIColor(red: 85/255.0, green: 217/255.0, blue: 188/255.0, alpha: 1)
        
        //print(items.indexOfObject(x))
                
                if (selected == "Mahoney Residential College"){
                    print("Mahoney Residential College")
                    self.selectedDormLabel.text = "Building selected: \tMahoney Residential College"
                    self.selectedDorm = "Mahoney"
                    self.selectedDormLabel.textColor = swiftColor
        
                    
                }else if (selected == "Stanford Residential College"){
                    print("Stanford Residential College")
                    self.selectedDormLabel.text = "Building selected: \tStanford Residential College"
                    self.selectedDorm = "Stanford"
                    self.selectedDormLabel.textColor = swiftColor
                    

                }else if (selected == "Hecht Residential College"){
                    print("Hect Residential College")
                    self.selectedDormLabel.text = "Building selected: \tHecht Residential College"
                    self.selectedDorm = "Hecht"
                    self.selectedDormLabel.textColor = swiftColor

                }else if (selected == "Pearson Residential College"){
                    print("Pearson Residential College")
                    self.selectedDormLabel.text = "Building selected: \tPearson Residential College"
                    self.selectedDorm = "Pearson"
                    self.selectedDormLabel.textColor = swiftColor

                }else if (selected == "Eaton Residential College"){
                    print("Eaton Residential College")
                    self.selectedDormLabel.text = "Building selected: \tEaton Residential College"
                    self.selectedDorm = "Eaton"
                    self.selectedDormLabel.textColor = swiftColor

                }else if (selected == "Red Road Commons"){
                    print("Red Road Commons")
                    self.selectedDormLabel.text = "Building selected: \tRed Road Commons"
                    self.selectedDorm = "Red Road Commons"
                    self.selectedDormLabel.textColor = swiftColor
                    
                }else if (selected == "UV 1"){
                    print("UV 1")
                    self.selectedDormLabel.text = "Building selected: \tUV 1"
                    self.selectedDorm = "UV 1"
                    self.selectedDormLabel.textColor = swiftColor
                    
                }else if (selected == "UV 2"){
                    print("UV 2")
                    self.selectedDormLabel.text = "Building selected: \tUV 2"
                    self.selectedDorm = "UV 2"
                    self.selectedDormLabel.textColor = swiftColor
                    
                }else if (selected == "UV 3"){
                    print("Eaton Residential College")
                    self.selectedDormLabel.text = "Building selected: \tUV 3"
                    self.selectedDorm = "UV 3"
                    self.selectedDormLabel.textColor = swiftColor
                    
                }else if (selected == "UV 4"){
                    print("UV 4")
                    self.selectedDormLabel.text = "Building selected: \tUV 4"
                    self.selectedDorm = "UV 4"
                    self.selectedDormLabel.textColor = swiftColor
                    
                }else if (selected == "UV 5"){
                    print("UV 5")
                    self.selectedDormLabel.text = "Building selected: \tUV 5"
                    self.selectedDorm = "UV 5"
                    self.selectedDormLabel.textColor = swiftColor
                    
                }else if (selected == "UV 6"){
                    print("UV 6")
                    self.selectedDormLabel.text = "Building selected: \tUV 6"
                    self.selectedDorm = "UV 6"
                    self.selectedDormLabel.textColor = swiftColor
                    
                }else if (selected == "UV 7"){
                    print("UV 7")
                    self.selectedDormLabel.text = "Building selected: \tUV 7"
                    self.selectedDorm = "UV 7"
                    self.selectedDormLabel.textColor = swiftColor
                    
        }
               // print(selectedDorm)
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

