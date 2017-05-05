//
//  OrderPickupViewController.swift
//  CleanSwipe0-1
//
//  Created by Kevin Fich on 10/23/16.
//  Copyright © 2016 Kevin Fich. All rights reserved.
//

import UIKit

class OrderPickupViewController: UIViewController {
    
    // Properties
    // ===========================
    var appointment = Appointment()
    var currentUser = User()
    var currentEmp = Employee()
    var dateFormatter = DateFormatter()
    var isRegistered = false

    
    
    // IBOutlets
    // ===========================
    
    @IBOutlet weak var customerNameLabel: UILabel!
    
    @IBOutlet weak var numOfBagsLabel: UILabel!

    @IBOutlet weak var orderDetailsTextView: UITextView!
    
    
    // Page Setup - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Format appointment string
        
        let orderTime = appointment.orderDate
        /*dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let s = dateFormatter.date(from: orderTime)
        
        dateFormatter.dateFormat = "MMM dd, yyyy @ h:mm a"
        let orderDateString = dateFormatter.string(from: s!)*/
        
        let pickupTime = appointment.pickupDate
        /*dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let s2 = dateFormatter.date(from: pickupTime)
        
        dateFormatter.dateFormat = "MMM dd, yyyy @ h:mm a"
        let pickupDateString = dateFormatter.string(from: s2!)*/
        
        // Sort for name associated with Appointment
        let username = sortUserListForName(appointment.customerId)
        
        
        // Configure recipt
        
        let range1 = NSRange(location: 0, length: 14) // range starting at location 17 with a lenth of 7: "Strings"
        
        let font = UIFont(name: "Geomanist-Regular", size: 18)
        let blue_green = UIColor(red: 85/255.0, green: 217/255.0, blue: 188.0, alpha: 1.0)
        let green = UIColor(red: 85/255.0, green: 217/255.0, blue: 188.0/255.0, alpha: 1.0)
        
        
        let recipt = NSMutableAttributedString(string:"Order Details:\n\nOrderID:\t\(appointment.transactionId)\n\nPurchase Date:\t\(orderTime)\n\nPickup Date:\t\(pickupTime)\n\nSpecial Notes: \(appointment.notes)\n\nPickup Location:\t\(appointment.building) \(appointment.dormRoom)")
        
        recipt.addAttribute(NSForegroundColorAttributeName, value: green, range: range1)
        
        // Range starting at location 0 with a lenth recipt
        let range2 = NSRange(location: 0, length: recipt.length)
        
        recipt.addAttribute(NSFontAttributeName, value: font!, range: range2)
        
        
        self.orderDetailsTextView.attributedText = recipt
        
        // Format labels
        
        self.numOfBagsLabel.text = "Num of items: \(appointment.numberOfItems)"
        self.numOfBagsLabel.textColor = blue_green
        
        // Query to find users name before configuring
        
        self.customerNameLabel.text = "\(username)'s Order"

        // Query for device token of client
        queryForDeviceToken()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // IBActions - Buttons Pressed
    
    @IBAction func confirmPickup(_ sender: AnyObject) {
        
        let orderId = appointment.transactionId
        AppointmentManager.sharedManager.selectedAppointment = appointment
        AppointmentManager.sharedManager.updateOrderStatus(currentEmp.empId, order_id:orderId, newStatus: "picked up")

        // Close viewcontroller
        dismiss(animated: true, completion: nil)
        
        // Send push to client
        
        isRegistered = AppointmentManager.sharedManager.userHasRegisteredDevice
        
        if isRegistered {
            
            let userToken = AppointmentManager.sharedManager.userDeviceToken
            let manager = Networking()
            manager.postPushForAppointmentUpdate(appointment.customerId, message: "CleanSwiper \(currentEmp.fullName) confirmed your order has been picked up. Order updates are available within the app at anytime.", token: userToken)
        }else{
            print("USER NOT REGISTERED FOR PUSH")
        }

        
        // Post notification
        NotificationCenter.default.post(name: Notification.Name(rawValue: "Status Updated"), object: self)

    }
    
    
    @IBAction func backPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)

    }
    
    @IBAction func contactClient(_ sender: AnyObject) {
        
        let phone = "tel://\(currentUser.mobileNumber)";
        let url:URL = URL(string:phone)!
        UIApplication.shared.openURL(url)
    }
    
    
    // Custom methods
    // =========================
    
    func sortUserListForName(_ client_id : String) -> String {
        
        var name = ""
        let userList = AppointmentManager.sharedManager.users
        
        for user in userList {
            print(user.userId)
            if user.userId == client_id{
                currentUser = user
                name = user.fullName
                print("FOUND THE NAME: \(name)")
            }
        }
        return name
    }
    
    func queryForDeviceToken(){
        AppointmentManager.sharedManager.queryForDeviceToken(appointment.customerId)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
