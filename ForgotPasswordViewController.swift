//
//  ForgotPasswordViewController.swift
//  CleanSwipe0-1
//
//  Created by Kevin Fich on 9/13/16.
//  Copyright © 2016 Kevin Fich. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordViewController: UIViewController {
    
    // Properties
    // ==========================
    
    var email: String = String()
    
    // IBOutlets
    // ==========================
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // IBActions // Buttons Pressed
    // =============================
    
    @IBAction func submitEmailForPasswordReset(_ sender: AnyObject) {
        
        email = self.emailTextField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        // Validate email string, if invalid, show error message
        
        if validateEmail(email) {
            
            // Configure loading indicator
            let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.indeterminate
            loadingNotification.label.text = "Processing request.."
            
            // Create firebase endpoint reference
            
            let ref = Firebase(url: "https://cleanswipe.firebaseio.com")
            ref?.resetPassword(forUser: email, withCompletionBlock: { error in
                if error != nil {
                    // There was an error processing the request
                    
                    print("There was an error processing the email reset")
                    self.showOKAlertView("Error", message: "There was an error processing your request. Please try again.")
                    
                } else {
                    // Password reset sent successfully
                    
                    print("The password email was send SUCCESSFULLY")
                    self.performSegue(withIdentifier: "showEmailSuccess", sender: self)
                }
            })
        }else{
            
            showOKAlertView("", message: "Please enter a valid email address.")
            
        }
        
    }
    
    // Custom methods
    // =============================
    
    // Email validation
    
    func validateEmail(_ candidate: String) -> Bool {
        //  Original Regex
        //  let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        // @miami.edu Regex
        //let emailRegex = "[A-Z0-9a-z._%+-]+@miami.edu"
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        return emailTest.evaluate(with: candidate)
    }
    
    // Custom alert view method
    
    func showOKAlertView(_ title: String?, message: String?) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertView, animated: true, completion: nil)
    }
    

}
