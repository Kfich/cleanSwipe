//
//  PaymentViewController.swift
//  CleanSwipe0-1
//
//  Created by Kevin Fich on 4/14/16.
//  Copyright © 2016 Kevin Fich. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController {
    
    // Properties
    // ================================
    
    var currentUser = User()
    var appointment = Appointment()

    var defaultPayment = Payment()
    
    // IBOutlets
    // ================================
    
    @IBOutlet weak var defaultPaymentSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Properties
        // =========================================
        var swipeRec = UISwipeGestureRecognizer()
        var swipeRecBack = UISwipeGestureRecognizer()
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "Swipe. Clean. Done."
        
        // Configure swiping
        
        swipeRec = UISwipeGestureRecognizer(target: self, action: #selector(PaymentViewController.swipedView(_:)))
        swipeRec.direction = .left
        
        swipeRecBack = UISwipeGestureRecognizer(target: self, action: #selector(PaymentViewController.swipedBack(_:)))
        swipeRecBack.direction = .right
        
        self.view.addGestureRecognizer(swipeRec)
        self.view.addGestureRecognizer(swipeRecBack)
        
        
        // Check if user has default payment
        
        _ = retrieveDefaultPayment()
        
        // Configure switch accordingly based on setting
        
        if PaymentManager.sharedManager.userHasDefaultPayment {
            defaultPaymentSwitch.isOn = true
            
            //
            
        }else{
            defaultPaymentSwitch.isOn = false
            defaultPaymentSwitch.isEnabled = false
        }
        
        //currentUser.printUser()
       appointment.printAppointment()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // IBActions
    // ==========================================
    
    // Custom methods
    // ==========================================
    
    
    func swipedView(_ gesture: UIGestureRecognizer){
        
        // Check to see if user has default payment, if not, show 
        // message to configure default settings
        
        if (PaymentManager.sharedManager.userHasDefaultPayment && defaultPaymentSwitch.isOn){
            self.performSegue(withIdentifier: "showOrderRecipt", sender: self)
        }else{
            // Show alert 
            showOKAlertView("We could not find a card", message: "Please select 'Pay now with card' or go to Settings->Update Payment to configure your default payment method.")
        }
        
    }
    func swipedBack(_ gesture: UIGestureRecognizer){
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    // Memory
    
    func retrieveDefaultPayment() -> NSDictionary{
        
        var payment = NSDictionary()
        
        let userInfo = UserDefaults.standard
        
        if userInfo.value(forKey: "default_payment") != nil{
            
            payment = userInfo.value(forKey: "default_payment") as! NSDictionary
            print("Payment: \(payment)")
            
            PaymentManager.sharedManager.cardNumber = payment.value(forKey: "card_number") as! String
            PaymentManager.sharedManager.expDate = payment.value(forKey: "expiration") as! String
            
            PaymentManager.sharedManager.securityCode = payment.value(forKey: "security") as! String
            
            // Set hasPayment to true 
            
            PaymentManager.sharedManager.userHasDefaultPayment = true
            
            _ = retrievePaymentDescription()
            
            
        }else{
            print("There was no default payment")
        }
        return payment
    }
    
    func retrievePaymentDescription() -> NSDictionary{
        
        var payment = NSDictionary()
        
        let userInfo = UserDefaults.standard
        
        if userInfo.value(forKey: "paymet_description") != nil{
            
            payment = userInfo.value(forKey: "paymet_description") as! NSDictionary
            print("Payment Desc: \(payment)")
            
            let name = payment.value(forKey: "cardholder_name") as! String
            let billing = payment.value(forKey: "billing") as! String
            let zip = payment.value(forKey: "zip") as! String
            
            PaymentManager.sharedManager.fullName = name
            PaymentManager.sharedManager.address = billing
            PaymentManager.sharedManager.zip = zip
            
            print(name)
            print(billing)
            print(zip)
            
        }else{
            print("There was no default description")
        }
        return payment
    }
    
    // Custom alert view method
    
    func showOKAlertView(_ title: String?, message: String?) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertView, animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        
        if (segue.identifier == "showOrderRecipt") {
            
            let confirmVC = (segue.destination as! ConfirmPaymentViewController)
            confirmVC.currentUser = self.currentUser
            confirmVC.appointment = self.appointment
            
            
            /*
            let backItem = UIBarButtonItem()
            backItem.title = " "
            navigationItem.backBarButtonItem = backItem
            navigationItem.setHidesBackButton(true, animated: false)
            */
            
            
        }else if (segue.identifier == "showCCView") {
            
            let ccVC = (segue.destination as! CreditCardViewController)
            ccVC.currentUser = self.currentUser
            ccVC.currentAppointment = self.appointment
           
            /*
            let backItem = UIBarButtonItem()
            backItem.title = " "
            navigationItem.backBarButtonItem = backItem
            navigationItem.setHidesBackButton(true, animated: false)
            */
            
            
        }
    
    }
    

}
