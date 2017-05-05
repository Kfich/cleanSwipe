//
//  ConfirmPaymentViewController.swift
//  CleanSwipe0-1
//
//  Created by Kevin Fich on 4/14/16.
//  Copyright © 2016 Kevin Fich. All rights reserved.
//

import UIKit
import Firebase
import Stripe
import AFNetworking

class ConfirmPaymentViewController: UIViewController {
    
    // Properties
    // =========================================
    
    var currentUser = User()
    var appointment = Appointment()
    let tomorrow = Date()
    var dateFormatter = DateFormatter()
    
    var isValidUserCard = false
    
    var loadingNotification = MBProgressHUD()
    
    
    struct ResponseStatus {
        
        static let Success = "Sucess"
        static let Failure = "Failure"
    }
    
    // IBOutlets
    // =========================================
    @IBOutlet weak var defaultPaymentSwitch: UISwitch!
    
    @IBOutlet weak var reciptTextView: UITextView!
    
    @IBOutlet weak var cleanSwiperLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet var expirationLabel: UILabel!
    
    
    
    
    
    // IBActions // Buttons Pressed
    // =========================================
    
    @IBAction func confirmOrderPressed(_ sender: AnyObject) {
        
        // Check for valid payment
        
        if ((PaymentManager.sharedManager.userHasDefaultPayment && defaultPaymentSwitch.isOn) || userHasValidPayment()){
         
            // Configure loading indicator
            loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.indeterminate
            loadingNotification.label.text = "Processing order ..."
            
            submitPaymentInfo()
            
        }else{
            // Show alert
           print("The payment info not valid")
        }
        
    }
    
    @IBAction func cancelOrder(_ sender: AnyObject) {
        
        // Create alert
        let alert = UIAlertController(title: "", message: "Are you sure you want to cancel the order?", preferredStyle: .alert)
        
        let agree = UIAlertAction(title: "Yes", style: .default, handler: {(action: UIAlertAction) -> Void in
            
            //  Reset appointment and go home
            
            self.appointment.reset()
            AppointmentManager.sharedManager.reset()
            
            self.view.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController")
            self.view.window?.makeKeyAndVisible()
            
        })
        
        
        // Create notNow action
        let notNow = UIAlertAction(title: "Forget it", style: .default, handler: {(action: UIAlertAction) -> Void in
            
            // Dismiss the alert
            alert.dismiss(animated: true, completion: { _ in })
            
        })
        
        alert.addAction(agree)
        alert.addAction(notNow)
        self.present(alert, animated: true, completion: { _ in })
        
        
    }
    
    // Switch changes position 
    
    @IBAction func defaultPaymentToggled(_ sender: AnyObject) {
        
        if defaultPaymentSwitch.isOn {
            print("ON")
            print("Retriving Defaults")
            _ = retrieveDefaultPayment()
            
            // Configure default info label
            let cc = PaymentManager.sharedManager.cardNumber
            let exp = PaymentManager.sharedManager.expDate
            let last4 = cc.substring(from: cc.characters.index(cc.endIndex, offsetBy: -4))
            let defaultInfoString = "EXP: \(exp)\tENDING: \(last4)"
            
            expirationLabel.text = defaultInfoString
            expirationLabel.isHidden = false
        }else{
            print("OFF")
            print("Resetting Payment Manager")
            PaymentManager.sharedManager.reset()
            // Hide label 
            expirationLabel.isHidden = true
        }
    }
    
    
    // View Did Load - Page Setup
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "Swipe. Clean. Done."
        
        currentUser.printUser()
        appointment.printAppointment()
        
        // Format pickupDate string
        
        /*let pickupTime = appointment.pickupDate
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let s2 = dateFormatter.date(from: pickupTime)
        
        dateFormatter.dateFormat = "MMM dd, yyyy @ h:mm a"
        let pickupDateString = dateFormatter.string(from: s2!)*/
        
        
        // Configure recipt
        
        //let range1 = NSRange(location: 0, length: 14) // range starting at location 17 with a lenth of 7: "Strings"
        
        let font = UIFont(name: "Geomanist-Regular", size: 15)
        let blue_green = UIColor(red: 85/255.0, green: 217/255.0, blue: 188.0, alpha: 1.0)
        
        // Remove end from pickupdate string
        if let dotRange = appointment.pickupDate.range(of: "\n") {
            appointment.pickupDate.removeSubrange(dotRange.lowerBound..<appointment.pickupDate.endIndex)
        }
        
        let recipt = NSMutableAttributedString(string:"Number of Items: \(appointment.numberOfItems)\n\nSpecial Notes: \(appointment.notes)\n\nDelivery Fee:\t$2.00\n\nPickup Date:\t\(appointment.pickupDate)\n\nPickup Location:\t\(appointment.building) \(appointment.dormRoom)")
        
        //recipt.addAttribute(NSForegroundColorAttributeName, value: blue_green, range: range1)
        
        // Range starting at location 0 with a lenth recipt
        let range2 = NSRange(location: 0, length: recipt.length)
        
        recipt.addAttribute(NSFontAttributeName, value: font!, range: range2)
        
        
        self.reciptTextView.attributedText = recipt
        
        // Calulate account credit
        
        if currentUser.credit != 0 {
            appointment.price = appointment.price - Double(currentUser.credit)
        }
        
        
        // Format price
        let formattedPrice = NumberFormatter()
        formattedPrice.numberStyle = .currency
        
        formattedPrice.string(from: (appointment.price as NSNumber))
        if currentUser.credit != 0 {
            self.priceLabel.text = "Total: \(formattedPrice.string(from: (appointment.price as NSNumber))!) ($\(currentUser.credit) credit applied)"
        }else{
            self.priceLabel.text = "Total Price: \(formattedPrice.string(from: (appointment.price as NSNumber))!)"
        }
        self.priceLabel.textColor = blue_green
        
        // Configure Defualt Payment switch
        
        configureDefaults()
        
        // Add observers 
        addObservers()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Custom methods
    // ==========================================
    
    // Submit order converts the appointment data into a dict and stores
    // to firebase. Once done a segue is called to show success view.
    
    
    // Notification center
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(ConfirmPaymentViewController.refreshUI), name: NSNotification.Name(rawValue: "Payment Updated"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ConfirmPaymentViewController.refreshUIOnAccept), name: NSNotification.Name(rawValue: "Payment Accept"), object: nil)
        
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func refreshUI() {
        print("REFRESH")
        
        // Configure loading indicator
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.customView
        loadingNotification.customView = UIImageView(image: UIImage(named: "CheckmarkGradiant.png"))
        loadingNotification.backgroundColor = UIColor.clear
        loadingNotification.label.text = "Payment updated successfully"
        loadingNotification.hide(animated: true, afterDelay: 1.50)
    }
    
    func refreshUIOnAccept() {
        print("REFRESH")
        
        // Configure loading indicator
        refreshUI()
        // Retreieve default info then configure UI accordingly
        _ = retrieveDefaultPayment()
        expirationLabel.isHidden = false
        defaultPaymentSwitch.isOn = true
    }
    

    // Submit payment
    
    func submitOrder(){
        
        let ref = Firebase(url: "https://cleanswipe.firebaseio.com/orders")
        
        // Set appointment status
        appointment.status = "processing"
        
        /*
         let preferences = ["transactionId" : appointment.transactionId,
         "tip" : appointment.preferences.tip,
         "notes" : appointment.preferences.notes]*/
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let strDate = dateFormatter.string(from: date)
        self.appointment.createdAt = strDate
        
        let transaction = [
            "transactionId" : self.appointment.transactionId,
            "order_date" : self.appointment.orderDate,
            "customerId": self.appointment.customerId,
            "location": self.appointment.location,
            "dorm" : self.appointment.building,
            "room_number" : self.appointment.dormRoom,
            "pickup_date" : self.appointment.pickupDate,
            "mobile_number" : self.appointment.mobileNumber,
            "number_of_items" : self.appointment.numberOfItems,
            "total_price" : self.appointment.price,
            "employeeId" : self.appointment.employeeId,
            "status" : self.appointment.status,
            "notes" : self.appointment.notes,
            "createdAt" : self.appointment.createdAt
            
            // Add preferences in the future
            
        ] as [String : Any]
        // Create a child path with a key set to the uid underneath the "users" node
        // This creates a URL path like the following:
        //  - https://<YOUR-FIREBASE-APP>.firebaseio.com/users/<uid>
        
        ref?.child(byAppendingPath: self.appointment.transactionId).setValue(transaction)
        
        // Hide loading animator
        
        loadingNotification.hide(animated: true)
        
        // Push notification dispatch before the shipment goes out
        dispatchPush()
        
        self.performSegue(withIdentifier: "showPaymentSuccess", sender: self)
        
    }
    
    // Push Notification dispatch
    
    func dispatchPush(){
        
        let m = Networking()
        m.genericPostCall(currentUser.userId, deviceToken: AuthManager.sharedManager.deviceToken)
        print(AuthManager.sharedManager.deviceToken)
        print("Button hit")
    }
    
    // Payment Methods
    // ===============================
    
    // Configure Default if available
    
    func configureDefaults() {
        // Check if user has default payment
        _ = retrieveDefaultPayment()
        _ = retrieveLastLogin()
        
        // Configure switch accordingly based on setting
        
        if PaymentManager.sharedManager.userHasDefaultPayment && isValidUserCard {
            defaultPaymentSwitch.isOn = true
            
            
        }else{
            defaultPaymentSwitch.isOn = false
            defaultPaymentSwitch.isEnabled = false
            
            // Tear down expLabel
            expirationLabel.isHidden = true
            expirationLabel.text = ""
        }
    }
    
    func retrieveLastLogin() -> NSDictionary{
        
        var emailDict = NSDictionary()
        let userInfo = UserDefaults.standard
        // Check last email login
        if userInfo.value(forKey: "login_email") != nil{
            
            emailDict = userInfo.value(forKey: "login_email") as! NSDictionary
            print("\nLast email: \(emailDict)")
            
            let email = emailDict.object(forKey: "email") as! String
            
            if email == currentUser.email {
                isValidUserCard = true
            }
        }else{
            print("No one has logged in")
            isValidUserCard = false
        }
        return emailDict
    }

    
    
    // Payment Validation
    
    func userHasValidPayment() -> Bool{
        
        let paymentValidation = PaymentManager.sharedManager.paymentValidation()
        guard paymentValidation.success else {
            if let errorMessage = paymentValidation.errorMessage {
                showOKAlertView(nil, message: errorMessage)
            }
            return false
        }
        return true
    }

    
    func submitPaymentInfo() {
        
        // Initiate the card
        let stripeCard = STPCard()
        
        // Split the expiration date to extract Month & Year
        
        let expirationDate = PaymentManager.sharedManager.expDate.components(separatedBy: "/")
        let expMonth = UInt(expirationDate[0])
        let expYear = UInt(expirationDate[1])
        
        // Send the card info to Strip to get the token
        stripeCard.number = PaymentManager.sharedManager.cardNumber
        stripeCard.cvc = PaymentManager.sharedManager.securityCode
        stripeCard.expMonth = expMonth!
        stripeCard.expYear = expYear!
        
        printStipeCard(stripeCard)
        
        
        
        let underlyingError: NSError? = nil
        
        do {
            try stripeCard.validateReturningError()
        } catch {
            print("Card Vaidation Error")
            loadingNotification.hide(animated: true)
        }
        
        if underlyingError != nil {
            
            // Stop Loading indicator here somewhere
            
            self.loadingNotification.hide(animated: true)
            self.handleError(underlyingError!)
            return
        }
        
        STPAPIClient.shared().createToken(with: stripeCard, completion: { (token, error) -> Void in
            
            if error != nil {
                self.handleError(error! as NSError)
                return
            }
            
            self.postStripeToken(token!)
        })
        
    }
    
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
            PaymentManager.sharedManager.userHasDefaultPayment = false
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
            
            // Configure default info label
            let cc = PaymentManager.sharedManager.cardNumber
            let exp = PaymentManager.sharedManager.expDate
            let last4 = cc.substring(from: cc.characters.index(cc.endIndex, offsetBy: -4))
            let defaultInfoString = "EXP: \(exp)\tENDING: \(last4)"
            
            expirationLabel.text = defaultInfoString
            
            //print(name)
            //print(billing)
            //print(zip)
            
        }else{
            print("There was no default description")
        }
        return payment
    }
    
    
    func showOKAlertView(_ title: String?, message: String?) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertView, animated: true, completion: nil)
    }
    
    
    func generateDescription() -> String{
        
        let description = "Name: \(PaymentManager.sharedManager.fullName),\nBilling: \(PaymentManager.sharedManager.address),\nZip: \(PaymentManager.sharedManager.zip)"
        print(description)
        return description
    }
    
    func printStipeCard(_ card: STPCard){
        
        print("Card Info: \n\t\(card.number)\n\t\(card.cvc)\n\t\(card.expMonth)\n\t\(card.expYear)")
    }
    
    
    func handleError(_ error: NSError) {
        
        let alertView = UIAlertController(title: "Please Try Again", message: error.localizedDescription, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertView, animated: true, completion: nil)
        
        // Hide loading indicator
        
        loadingNotification.hide(animated: true)
        
        // Configure to the following once ready for deployment
        /*
         showOKAlertView("Please try again", message: "There was an error processing your request.")
         */
        
    }
    
    // Note: Verify that the price is the proper data type
    
    // postStripeToken() is called once the payment info has been
    // validated. Once it returns success, postStripeToken() also
    // calls submitOrder() to post appointment data to firebase.
    
    func postStripeToken(_ token: STPToken) {
        
        
        // Here, insert the url for the amazon server
        
        // Test URL
        let URL = "http://52.55.249.87/cleanSwipe/test_payment.php"
        
        // Official URL
       // let URL = "http://52.55.249.87/cleanSwipe/payment.php"
        
        // Local Host
        //let URL = "http://localhost/cs_payments/payment.php"
        var totalAmount : Double
        
        totalAmount = appointment.price
        
        
        let parameters : [String: AnyObject] = [
            "stripeToken" : token.tokenId as AnyObject,
            "amount" : totalAmount as AnyObject,
            "currency" : "usd" as AnyObject,
            "description" : generateDescription() as AnyObject
        ]
        
        let manager = AFHTTPRequestOperationManager()
        manager.post(URL, parameters: parameters, success: { (operation, responseObject) -> Void in
            
            if let response = responseObject as? [String: String] {
                
                // if response == good then go to home page
                // else
                // Stay on ccVC and reprocess
                
                if response["status"] == "Success"{
                    
                    print("The response was SUCCESSFUL KEV WOO")
                    
                    // Save order values to firebase once payment result
                    // returns successful
                    //
                    
                    self.submitOrder()
                    
                    // self.performSegueWithIdentifier("showConfirmOrder", sender: self)
                    
                }else if response["status"] == "Failure"{
                    
                    print("The response was A FAILURE")
                    
                    // Configure messages to custom before deploying
                    
                    let alertView = UIAlertController(title: response["status"], message: response["message"], preferredStyle: .alert)
                    alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertView, animated: true, completion: nil)
                    
                    // Hide all huds present
                    self.loadingNotification.hide(animated: true)
                    
                    
                }
            }
            
        }) { (operation, error) -> Void in
            self.handleError(error! as NSError)
            // Hide all huds present
            self.loadingNotification.hide(animated: true)
        }
    }
    
    // Navigation 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "showCCView") {
            
            let ccVC = (segue.destination as! CreditCardViewController)
            ccVC.currentUser = self.currentUser
            ccVC.currentAppointment = self.appointment
            
            /*
             let backItem = UIBarButtonItem()
             backItem.title = " "
             navigationItem.backBarButtonItem = backItem
             navigationItem.setHidesBackButton(true, animated: false)
             */
            
        }else if (segue.identifier == "showPaymentSuccess") {
            
            let ccVC = (segue.destination as! PaymentSuccessViewController)
            ccVC.currentUser = self.currentUser
                       
            /*
             let backItem = UIBarButtonItem()
             backItem.title = " "
             navigationItem.backBarButtonItem = backItem
             navigationItem.setHidesBackButton(true, animated: false)
             */
            
            
        }

        
    }
    
}
