//
//  PaymentSettingsViewController.swift
//  CleanSwipe0-1
//
//  Created by Hedgeable on 7/11/16.
//  Copyright © 2016 Kevin Fich. All rights reserved.
//

import UIKit

class PaymentSettingsViewController: UIViewController {
    
    // Properties
    // ============================
    
    var currentUser = User()
    var appointment = Appointment()
    
    // IBOutets
    // ============================
    
    @IBOutlet weak var cardholderNameTextField: UITextField!
    
    @IBOutlet weak var cardNumberTextField: UITextField!
    
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var securityCodeTextField: UITextField!
    
    @IBOutlet weak var expDateTextField: UITextField!
    
    @IBOutlet weak var zipCodeTextField: UITextField!
    
    // Page setup / ViewDidLoad
    // =============================

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        cardholderNameTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // IBActions
    // ==============================
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func finishUpdatingPayment(_ sender: AnyObject) {
        
        // Validate payment form brfore submitting 
        
        if self.validPaymentForm() == true {
            
            // Validate using stripe to get a token/validate card forreal before you 
            // perform seg and store the data
            
            
            // Store payments to defaults
            self.storePayment()
            self.storePaymentDescription()
            
            // Segue to success
            self.performSegue(withIdentifier: "showSavedPaymentSuccess", sender: self)
            
        }else{
            
            // What happens if validation fails
            
            print("Invalid payment information form")
            showOKAlertView("An error occured", message: "Please enter valid default payment info.")
        }
        
    }
    
    // Custom methods
    // ===============================
    
    // Device storage
    
    func storePayment() {
        // Use PaymentManager to store payment info
        let payment = PaymentManager.sharedManager.getPaymentDictionary()
        
        PaymentManager.sharedManager.rememberPaymentInfo(payment as! NSDictionary)
    }
    
    func storePaymentDescription(){
        
        let description = PaymentManager.sharedManager.getDescriptionDictionary()
        PaymentManager.sharedManager.rememberPaymentDescription(description as! NSDictionary)
    }
    
    
    // Form validation
    
    func validPaymentForm() -> Bool{
        
        PaymentManager.sharedManager.fullName = cardholderNameTextField.text!
        PaymentManager.sharedManager.cardNumber = cardNumberTextField.text!
        PaymentManager.sharedManager.expDate = expDateTextField.text!
        PaymentManager.sharedManager.address = addressTextField.text!
        PaymentManager.sharedManager.securityCode = securityCodeTextField.text!
        PaymentManager.sharedManager.zip = zipCodeTextField.text!
        
        let paymentValidation = PaymentManager.sharedManager.paymentValidation()
        guard paymentValidation.success else {
            if let errorMessage = paymentValidation.errorMessage {
                showOKAlertView(nil, message: errorMessage)
            }
            return false
        }
        return true
    }
    
    // Custom alert view method
    
    func showOKAlertView(_ title: String?, message: String?) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertView, animated: true, completion: nil)
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
