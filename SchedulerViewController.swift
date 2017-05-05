//
//  SchedulerViewController.swift
//  CleanSwipe0-1
//
//  Created by Kevin Fich on 4/13/16.
//  Copyright © 2016 Kevin Fich. All rights reserved.
//

// Find if simulator

#if (TARGET_IPHONE_SIMULATOR)
var isSimulator = true
#endif

import UIKit
import Firebase


class SchedulerViewController: UIViewController {
    
    // Properties
    // ==============================================
    
    var currentUser = User()
    var activeAppointment = Appointment()
    var swipeRec = UISwipeGestureRecognizer()

    var userHasCurrentAppointment = false
    var users = [User]()
    var isSimulator = false
    
    struct Status {
        
        static let Processing = "processing"
        static let InProgress = "in progress"
        static let PickedUp = "picked up"
        static let Washing = "washing"
        static let Delivered = "delivered"
    }
    
    // Menu Configuration
    // ==================
    
    lazy var menuLauncher: MenuLauncher = {
        let launcher = MenuLauncher()
        launcher.homeController = self
        return launcher
  }()
    
    
    func handleMore() {
        
        menuLauncher.showMenu()
    }
    
    // Menu VC

    func transitionViewController(_ settingString: String) {
        menuLauncher.homeController = self
        print(settingString)
        if settingString == "My Account" {
            self.performSegue(withIdentifier: "showSettingsOptions", sender: self)
        }
        if settingString == "Transaction History" {
            self.performSegue(withIdentifier: "showTransactionHistory", sender: self)
        }
        if settingString == "Contact Us" {
            self.performSegue(withIdentifier: "showAboutUs", sender: self)
        }
        if settingString == "Logout" {
            self.logout(self)
        }
    }


    
    // IBOutlets
    // ==============================================

    @IBOutlet weak var textView: UITextView!
    
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var swipeView: UIView!
    
    @IBOutlet var greetingLabel: UILabel!
    
    @IBOutlet var locationLabel: UILabel!
    
    @IBOutlet var statusLabel: UILabel!
    
    @IBOutlet var progressView: KDCircularProgress!
    
    @IBOutlet var statusImage: UIImageView!
    
    @IBOutlet var orderDetailsButton: UIButton!
    
    @IBOutlet var titleLabel: UILabel!
    
    
    // ==============================================
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add observers
        addObservers()
        
        // Set up navigation bar and menu
        self.navigationItem.setHidesBackButton(true, animated:true)
        self.navigationItem.title = "Swipe. Clean. Done."

        print("USER PASSWORD: \(self.currentUser.password)")
        
        // Set up swipe gesture
        
        swipeRec = UISwipeGestureRecognizer(target: self, action: #selector(SchedulerViewController.swipedView(_:)))
        swipeRec.direction = .left
        swipeView.addGestureRecognizer(swipeRec)
        self.view.addGestureRecognizer(swipeRec)
    
        configureSwipeView()

        //
        UIView.animate(withDuration: 1.0, delay: 1.0, options: UIViewAnimationOptions(), animations: {
                
              //  self.swipeView.alpha = 0.5
                
                }, completion: nil)
        
        
        let today = Date()
    
        
        print(today)
        
        // Configure loading indicator
    
        let loadingNotification = MBProgressHUD()
        // loadingNotification.mode = MBProgressHUDMode.Indeterminate
       // loadingNotification.label.text = "Loading"
       
        titleLabel.text = "Loading ..."
       
        let ref = Firebase(url: "https://cleanswipe.firebaseio.com")
        
        ref?.observeAuthEvent({ authData in
            if authData != nil {
                // user authenticated
               // print("A user \(authData) is logged in")
                print(authData)
    
                print(authData?.auth)
                print("\n\nTHIS IS THE QUERY BEING CALLED\n\n")
                print("User Email: \(AuthManager.sharedManager.email) \t User Password: \(AuthManager.sharedManager.password)")

                // Query db and return user data based on uid
               
                
                let ref2 = Firebase(url:"https://cleanswipe.firebaseio.com/users")
                ref2?.queryOrdered(byChild: "uid").observe(.value, with: { snapshot in
                   
                    print("\n\nGOT INSIDE THE QUERY\n\n")

                    for child in (snapshot?.children)! {
                        let user = User(snapshot: child as! FDataSnapshot)
                        // Major issue here appending and not clearing everytime
                        self.users.append(user)
                        //user.printUser()
                        print("\n\nPRINtiNG USERS\n\n")

                        
                        if user.userId == authData?.uid{
                            
                            self.titleLabel.text = "CleanSwipe"
                            
                            
                            print("\n\nFOUND THE CURRENT USER\n\n")
                            // Set current user
                            self.currentUser = user
                            
                            // Update device token
                            if self.isSimulator == false{
                                self.updateUserDeviceToken()
                            }else{
                                print("ITS THE SIMULATOR")
                            }

                            
                            // Hide loading notification
                            loadingNotification.hide(animated: true)

                            // Find currentUser's most recent appointment
                            self.queryForActiveAppointment()
                            
                            // Store device token to DB
                            self.currentUser.printUser()
                            //self.postDeviceNofitication()
                        
                        }
                        // store/update token info
                    }
                })
                                
            } else {
                // No user is signed in
                _ = self.navigationController?.popToRootViewController(animated: true)
            }
        })
        

    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // IBActions // Buttons pressed
    // =================================
    
    @IBAction func showOrderDetails(_ sender: AnyObject) {
        
        if userHasCurrentAppointment {
            self.performSegue(withIdentifier: "showOrderDetails", sender: self)
        }else{
            self.performSegue(withIdentifier: "showBagSelection", sender: self)

        }
    }
    
    
    // Testing push notifs 
    
    @IBAction func push(_ sender: AnyObject) {
        
    }
    
    @IBAction func sendPush(_ sender: AnyObject) {
        //let m = Networking()
        
        //m.postPushForAppointmentUpdate(currentUser.userId, message: "This is a test!")
        print(AuthManager.sharedManager.deviceToken)
        print("Button hit")
        
    }
    
    @IBAction func pushNav(_ sender: AnyObject) {
        
        self.view.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "dry")
        self.view.window?.makeKeyAndVisible()
 
        /*
        var current = Date()
         let min = Date().addingTimeInterval(-60 * 60 * 24 * 4)
         let max = Date().addingTimeInterval(60 * 60 * 24 * 4)
         let picker = DateTimePicker.show(selected: current, minimumDate: min, maximumDate: max)
         picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
         picker.doneButtonTitle = "Schedule Appointment"
         picker.todayButtonTitle = "Today"
         picker.completionHandler = { date in
         current = date
         let formatter = DateFormatter()
         formatter.dateFormat = "HH:mm dd/MM/YYYY"
            
         }*/
        
    }
    
    
    
    // Menu
    
    @IBAction func menuSelected(_ sender: AnyObject) {
         self.handleMore()
    }
    
    @IBAction func logout(_ sender: AnyObject) {
        
        // Create alert
        let alert = UIAlertController(title: "", message: "Are you sure you want to logout?", preferredStyle: .alert)
        
        let agree = UIAlertAction(title: "Yes", style: .default, handler: {(action: UIAlertAction) -> Void in
            
            //  Reset appointment and go home
            
            let ref = Firebase(url: "https://cleanswipe.firebaseio.com")
            
            ref?.unauth()
            
            // Reset Manager classes
            AuthManager.sharedManager.reset()
            PaymentManager.sharedManager.reset()
            
            self.view.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LandingPageVC")
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
        
       // self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
    
    // Custom methods
    // ==========================================
    
    // Notification center
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(SchedulerViewController.updateUserDeviceToken), name: NSNotification.Name(rawValue: "Update DeviceToken"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SchedulerViewController.setActiveAppointment), name: NSNotification.Name(rawValue: "Active Appointment"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SchedulerViewController.configureLabelsForAppointment), name: NSNotification.Name(rawValue: "No Appointments"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SchedulerViewController.resetUI), name: NSNotification.Name(rawValue: "Review Submitted"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SchedulerViewController.queryForActiveAppointment), name: NSNotification.Name(rawValue: "Status Updated"), object: nil)
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func postDeviceNofitication(){
        // Post notification
        NotificationCenter.default.post(name: Notification.Name(rawValue: "Update DeviceToken"), object: self)
        print("Notification posted to viewcontroller. ((LL))")
    }
    
    func queryForActiveAppointment(){
        // Query Backend for appointments that are active
        _ = AppointmentManager.sharedManager.queryForActiveAppointment(currentUser.userId)

    }
    
    func setActiveAppointment(){
        
        //queryForActiveAppointment()
        // Query Backend for appointments that are active
        
        
        activeAppointment = AppointmentManager.sharedManager.activeAppointment
        print("\n\n\nTHIS IS THE STATUS")
        print("\(AppointmentManager.sharedManager.activeAppointment.status)")
        print("YEYEYEYEYEYEYEYE")
        configureLabelsForAppointment()

        // Query for appointment review
        AppointmentManager.sharedManager.queryForAppointmentReview(self.activeAppointment.transactionId)

        // Query for employee details in background
        AppointmentManager.sharedManager.queryForEmployeeList()
    
    }

    func resetUI() {
        
        statusLabel.text = "You have no active orders. Get started now"
        orderDetailsButton.setTitle("SWIPE TO START", for: UIControlState())
        progressView.animateToAngle(360*(0/5), duration: 1.3, completion: nil)
        statusImage.image = UIImage(named:"home-1.png")
        
        // Cancel alert if showing
        closeAlert(self)
        
        // Enable swiping
        userHasCurrentAppointment = false
    }
    
    // Configure labels with appointment data
    
    func configureLabelsForAppointment() {
        
        greetingLabel.text = "Welcome, \(currentUser.fullName)"
        locationLabel.text = "\(currentUser.building) room \(currentUser.dormRoom)"
        
        if activeAppointment.transactionId != "" {
            
            // Disable swipe capabilities
            userHasCurrentAppointment = true
            
            // Configure details button
            orderDetailsButton.setTitle("VIEW ORDER DETAILS", for: UIControlState())
            
            // Show appropriate image based on status
            if activeAppointment.status == Status.Processing {
                // Show processing image //
                statusImage.image = UIImage(named: "processing-1.png")
                progressView.animateToAngle(360*(1/5), duration: 1.3, completion: nil)
                // Set status
                statusLabel.text = "-  Your order is currently \(activeAppointment.status)  -"
                
            }else if activeAppointment.status == Status.InProgress {
                // Show in progress image
                statusImage.image = UIImage(named:"inprogress-1.png")
                progressView.animateToAngle(360*(2/5), duration: 1.3, completion: nil)
                // Set status
                statusLabel.text = "-  Your order is currently \(activeAppointment.status)  -"
                
            }else if activeAppointment.status == Status.PickedUp {
                // Show picked up image
                statusImage.image = UIImage(named:"pickedup-1.png")
                progressView.animateToAngle(360*(3/5), duration: 1.3, completion: nil)
                // Set status
                statusLabel.text = "-  Your order has been \(activeAppointment.status)  -"
                
            }else if activeAppointment.status == Status.Washing {
                // Show washing image
                statusImage.image = UIImage(named:"washing-1.png")
                progressView.animateToAngle(360*(4/5), duration: 1.3, completion: nil)
                // Set status
                statusLabel.text = "-  Your order is currently \(activeAppointment.status)  -"
                
                
            }else if activeAppointment.status == Status.Delivered {
                // Show washing image
                statusImage.image = UIImage(named:"CheckmarkGradiant.png")
                progressView.animateToAngle(360*(5/5), duration: 1.3, completion: nil)
                statusLabel.text = "-  Your order has been \(activeAppointment.status)  -"
                // Check for order reviews
                _ = AppointmentManager.sharedManager.retrieveLastReview(activeAppointment.transactionId)
                // Show review screen
                showRate()
                // Enable swiping
                //userHasCurrentAppointment = false

            }

        }else{
            print("HEY NO ORDERS")
            statusLabel.text = "You have no active orders. Get started now"
            orderDetailsButton.setTitle("SWIPE TO START", for: UIControlState())
            statusImage.image = UIImage(named:"home-1.png")

            // Enable swiping
            userHasCurrentAppointment = false
            
        }
        
        //
        
        
    }
    
    // Rating configuration
    func showRate(){
        
        if !userHasCurrentAppointment {
            resetUI()
        }else if AppointmentManager.sharedManager.appointmentReviewed != true{
            print("\n\n\n\n\n\n\(AppointmentManager.sharedManager.appointmentReviewed)")
            showRateAlertInmediatly(self)
            userHasCurrentAppointment = false
        }
    }
    // Update device tokens when user signs in
    func updateUserDeviceToken() {
        AppointmentManager.sharedManager.updateUserDeviceToken(currentUser.userId)
    }
    
    // Swipe configuration
    
    func configureSwipeView(){
        
        swipeView.layer.shadowColor = UIColor.gray.cgColor
        swipeView.layer.shadowOpacity = 0.5
        swipeView.layer.shadowOffset = CGSize.zero
        swipeView.layer.shadowRadius = 5
    }
    
    func swipedView(_ gesture: UIGestureRecognizer){
        
        if !userHasCurrentAppointment {
            self.performSegue(withIdentifier: "showBagSelection", sender: self)
        }else{
            showOKAlertView("Laundry order in progress", message: "Please allow your current order to be satisfied before placing another one. Thank you.")
        }
    }
    
    // Custom alert view 
    
    func showOKAlertView(_ title: String?, message: String?) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertView, animated: true, completion: nil)
    }
    
    // Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "showBagSelection") {

            let bagVC = (segue.destination as! BagSelectionViewController)
            bagVC.currentUser = self.currentUser
            
            let backItem = UIBarButtonItem()
            backItem.title = " "
            navigationItem.backBarButtonItem = backItem
            navigationItem.setHidesBackButton(true, animated: false)
            
            
        }else if segue.identifier == "showSettingsOptions" {
            
            let optionsVC = (segue.destination as! SettingOptionsViewController)
            optionsVC.currentUser = self.currentUser
            
        }else if segue.identifier == "showTransactionHistory"{
            
            let transactionVC = (segue.destination as! TransactionHistoryViewController)
            transactionVC.currentUser = self.currentUser
            
        }else if segue.identifier == "showOrderDetails"{
            
            let transactionVC = (segue.destination as! OrderDetailsViewController)
            transactionVC.appointment = self.activeAppointment
        
        }

    }

}
