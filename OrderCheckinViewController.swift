//
//  OrderCheckinViewController.swift
//  CleanSwipe0-1
//
//  Created by Kevin Fich on 10/23/16.
//  Copyright © 2016 Kevin Fich. All rights reserved.
//

import UIKit

class OrderCheckinViewController: UIViewController {

    // Properties
    // ===========================
    var appointment = Appointment()
    var currentEmp = Employee()
    var dateFormatter = DateFormatter()
    var isRegistered = false
    
    // IBOutlets
    // ===========================
    
    @IBOutlet weak var numberOfBagsLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var orderDetailsTextView: UITextView!
    
    
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
        
        // Format price
        
        let formattedPrice = NumberFormatter()
        formattedPrice.numberStyle = .currency
        
        // Figure out what goes in this label string
        formattedPrice.string(from: (appointment.numberOfItems as NSNumber))
        
        self.numberOfBagsLabel.text = "Num of items: \(appointment.numberOfItems)"
        self.numberOfBagsLabel.textColor = blue_green
        
        self.statusLabel.text = "Status: \(appointment.status)"
        self.statusLabel.textColor = green
        
        // Query for device token of client 
        queryForDeviceToken()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // IBActions - Buttons Pressed 
    
    @IBAction func declineCheckin(_ sender: AnyObject) {
        
       _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func acceptCheckin(_ sender: AnyObject) {
        
        
        let orderId = appointment.transactionId
        
        // Set appointment
        AppointmentManager.sharedManager.selectedAppointment = appointment
        
        // Update order status
        AppointmentManager.sharedManager.updateOrderStatus(currentEmp.empId, order_id:orderId, newStatus: "in progress")
        
        // Send push to client 
        
        isRegistered = AppointmentManager.sharedManager.userHasRegisteredDevice
        
        if isRegistered {
            
            let userToken = AppointmentManager.sharedManager.userDeviceToken
            let manager = Networking()
            manager.postPushForAppointmentUpdate(appointment.customerId, message: "Awesome news!\nCleanSwiper \(currentEmp.fullName) has accepted your order! Open the app to view appointment status at anytime.", token: userToken)
        }else{
            print("USER NOT REGISTERED FOR PUSH")
        }
        
        // Post notification 
        NotificationCenter.default.post(name: Notification.Name(rawValue: "Status Updated"), object: self)
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    // Custom Methods 
    
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
