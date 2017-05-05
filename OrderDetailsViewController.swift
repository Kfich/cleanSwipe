//
//  OrderDetailsViewController.swift
//  CleanSwipeFE
//
//  Created by Don Sirivat on 10/26/16.
//  Copyright © 2016 Don Sirivat. All rights reserved.
//

import UIKit

class OrderDetailsViewController: UIViewController {
    
    // Properties
    // ==============================
    var appointment = Appointment()
    var employeeList = [Employee]()
    var currentEmp = Employee()
    var dateFormatter = DateFormatter()
    
    // IBOutlets
    // ==============================
    @IBOutlet var orderIdLabel: UILabel!
    
    @IBOutlet var cleanswiperNameLabel: UILabel!
    
    @IBOutlet var numberOfBagsLabel: UILabel!
    
    @IBOutlet var pickupDateLabel: UILabel!
    
    @IBOutlet var locationLabel: UILabel!
    
    @IBOutlet var priceLabel: UILabel!
    
    @IBOutlet var dropoffLabel: UILabel!
    
    // IBActions
    // ==============================
    @IBAction func dismiss(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func contactCleanSwiper(_ sender: AnyObject) {
        
        let phone = "tel://\(currentEmp.mobileNumber)";
        let url:URL = URL(string:phone)!
        UIApplication.shared.openURL(url)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setEmployee()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        // Configure date strings
        let orderTime = appointment.orderDate
        /*dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let s = dateFormatter.date(from: orderTime)
        
        dateFormatter.dateFormat = "MMM dd, yyyy @ h:mm a"
        let orderDateString = dateFormatter.string(from: s!)*/
        
        //let pickupTime = appointment.pickupDate
        /*dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let s2 = dateFormatter.date(from: pickupTime)
        
        dateFormatter.dateFormat = "MMM dd, yyyy @ h:mm a"
        let pickupDateString = dateFormatter.string(from: s2!)*/
        
        // Configure labels 
        
        orderIdLabel.text = "Order: \(appointment.transactionId)"
        cleanswiperNameLabel.text = "CleanSwiper: \(AppointmentManager.sharedManager.currentEmp.fullName)"
        numberOfBagsLabel.text = "Number of Items: \(appointment.numberOfItems)"
        pickupDateLabel.text = "Pickup Date: \(orderTime)"
        locationLabel.text = "Location: \(appointment.building) room \(appointment.dormRoom)"
        
        // Format price
        
        let formattedPrice = NumberFormatter()
        formattedPrice.numberStyle = .currency
        
        formattedPrice.string(from: (appointment.price as NSNumber))
        
        self.priceLabel.text = "Total Price: \(formattedPrice.string(from: (appointment.price as NSNumber))!)"
        
        
        // Figure out how to configure the estimated drop-off
        dropoffLabel.text = ""
        
        // Query DB for current CleanSwiper
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Custom Methods
    // ==============================
    
    func addObservers() {
        // Add observers if neccessary
    }

    func setEmployee()  {
        //Set list to appointment managers emp list 
       self.currentEmp = AppointmentManager.sharedManager.currentEmp
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
