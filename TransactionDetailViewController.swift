//
//  TransactionDetailViewController.swift
//  CleanSwipe0-1
//
//  Created by Kevin Fich on 4/17/16.
//  Copyright © 2016 Kevin Fich. All rights reserved.
//

import UIKit

class TransactionDetailViewController: UIViewController {
    
    // Properties
    // ========================================
    
    var appointment = Appointment()
    var dateFormatter = DateFormatter()
    
    @IBOutlet weak var reciptTextView: UITextView!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!

    // IBOutlets
    // ========================================
    
    

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
        
        
        
        /*
        var recipt = String()
        recipt = "Order Details:\n\nOrderID:\t\(appointment.transactionId)\n\nPurchase Date:\t\(orderDateString)\n\nPickup Date:\t\(pickupDateString)\n\nNumber of Bags:\t\(appointment.numberOfBags)\n\nPickup Location:\t\(appointment.building) \(appointment.dormRoom)"
        
        self.reciptTextView.text = recipt
        self.priceLabel.text = "Amount Paid: \(String(appointment.price))"
        self.priceLabel.textColor = UIColor(red: 85/255.0, green: 217/255.0, blue: 188.0, alpha: 1.0)
        */
        
        
        // Configure recipt
        
        let range1 = NSRange(location: 0, length: 14) // range starting at location 17 with a lenth of 7: "Strings"
        
        let font = UIFont(name: "Geomanist-Regular", size: 18)
        let blue_green = UIColor(red: 85/255.0, green: 217/255.0, blue: 188.0, alpha: 1.0)
        let green = UIColor(red: 85/255.0, green: 217/255.0, blue: 188.0/255.0, alpha: 1.0)

        
        let recipt = NSMutableAttributedString(string:"Order Details:\n\nOrderID:\t\(appointment.transactionId)\n\nPurchase Date:\t\(orderTime)\n\nPickup Date:\t\(pickupTime)\n\nNumber of Items:\t\(appointment.numberOfItems)\n\nPickup Location:\t\(appointment.building) \(appointment.dormRoom)")
        
        recipt.addAttribute(NSForegroundColorAttributeName, value: blue_green, range: range1)
        
        // Range starting at location 0 with a lenth recipt
        let range2 = NSRange(location: 0, length: recipt.length)
        
        recipt.addAttribute(NSFontAttributeName, value: font!, range: range2)
        
        
        self.reciptTextView.attributedText = recipt
        
        // Format price
        
        let formattedPrice = NumberFormatter()
        formattedPrice.numberStyle = .currency
        
        formattedPrice.string(from: (appointment.price as NSNumber))
        
        
        self.priceLabel.text = "Total Price: \(formattedPrice.string(from: (appointment.price as NSNumber))!)"
        self.priceLabel.textColor = blue_green
        
        self.statusLabel.text = "Status: \(appointment.status)"
        self.statusLabel.textColor = green

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // IBActions
    // ============================================
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "showReview" {
            let reviewVC = (segue.destination as! ReviewViewController)
            reviewVC.appointment = self.appointment
            
        }
    }

    
    
    
   
    

}








