//
//  CreditCardViewController.swift
//  CleanSwipe0-1
//
//  Created by Kevin Fich on 4/14/16.
//  Copyright © 2016 Kevin Fich. All rights reserved.
//

import UIKit

class CreditCardViewController: UIViewController {
    
    // Properties
    // ================================
    
    var currentAppointment = Appointment()
    var currentUser = User()
    
    struct ResponseStatus {
        
        static let Success = "Sucess"
        static let Failure = "Failure"
    }
    
    // IBOutlets
    // ================================
    
    @IBOutlet weak var cardholderNameTextField: UITextField!
    
    @IBOutlet weak var cardNumberTextField: UITextField!
    
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var securityCodeTextField: UITextField!
    
    @IBOutlet weak var expDateTextField: UITextField!
    
    @IBOutlet weak var zipCodeTextField: UITextField!
    
    
    // View Did Load
    // ================================

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cardholderNameTextField.becomeFirstResponder()
        
        _ = PaymentManager.sharedManager.retrieveDefaultPayment()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // IBActions
    // =================================
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func finishPayment(_ sender: AnyObject) {
        
        if self.validPaymentForm() == true {
            
            if PaymentManager.sharedManager.userHasDefaultPayment {
                dismiss(animated: true, completion: nil)

            }else{
                
                // Create alert
                let alert = UIAlertController(title: "Would you like to save this payment method?", message: "If Yes, CleanSwipe will use this card for future orders", preferredStyle: .alert)
                
                let agree = UIAlertAction(title: "Yes", style: .default, handler: {(action: UIAlertAction) -> Void in
                    
                    //  Call method here for saving default user payment info, then call segue
                    
                    let card = PaymentManager.sharedManager.getPaymentDictionary()
                    let descriptiom = PaymentManager.sharedManager.getDescriptionDictionary()
                    
                    // Store dictionaries
                    
                    PaymentManager.sharedManager.rememberPaymentInfo(card as! NSDictionary)
                    PaymentManager.sharedManager.rememberPaymentDescription(descriptiom as! NSDictionary)
                    
                    
                    
                    // Default payment bool
                    PaymentManager.sharedManager.userHasDefaultPayment = true
                    
                    // Post notification
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "Payment Accept"), object: self)

                    
                    // Call segue
                    
                    self.dismiss(animated: true, completion: nil)

                })
                
                
                // Create notNow action
                let notNow = UIAlertAction(title: "Not this card", style: .default, handler: {(action: UIAlertAction) -> Void in
                    alert.dismiss(animated: true, completion: { _ in })
                    
                    // Call segue
                    // Post notification
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "Payment Updated"), object: self)
                    
                    self.dismiss(animated: true, completion: nil)

                })
                
                alert.addAction(agree)
                alert.addAction(notNow)
                self.present(alert, animated: true, completion: { _ in })
                
            }

        
            
        }else{
            
            // What happens if validation fails
            
            print("Invalid form")
        }
        
        
    }
    
    
    // Custom methods
    // =================================
    
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
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "showConfirmOrder") {
            
            let confirmVC = (segue.destinationViewController as! ConfirmPaymentViewController)
            confirmVC.currentUser = self.currentUser
            confirmVC.appointment = self.currentAppointment
            
            let backItem = UIBarButtonItem()
            backItem.title = " "
            navigationItem.backBarButtonItem = backItem
            navigationItem.setHidesBackButton(true, animated: false)
            
            
            
        }
        
    }
 
    */

}
 

 
 
 
