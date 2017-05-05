//
//  Appointment.swift
//  CleanSwipe0-1
//
//  Created by Kevin Fich on 4/13/16.
//  Copyright © 2016 Kevin Fich. All rights reserved.
//

import Foundation
import UIKit
import Firebase

open class Appointment{
    
    var transactionId : String = ""
    var orderDate : String = ""
    var customerId : String = ""
    var employeeId : String = ""
    var location : String = ""
    var pickupDate : String = ""
    var building : String = ""
    var dormRoom : String = ""
    var mobileNumber : String = ""
    var numberOfBags : Int?
    var numberOfItems : Int
    var price : Double = 0.0
    var status : String = ""
    var notes : String = ""
    var sortDate:Date?
    var createdAt : String = ""
    
    // Figure this out 
    var items : NSArray?
    
    
    var preferences = Preferences.init()
    
    struct Preferences {
        
        var transId : String = ""
        var tip : Double = 0.0
        var notes : String = ""
    
        init() {
        }
    }
    
    init(){
        //let temp = Date ()
        
        let dateFormatter = Date().toString()
        // Original Date Code
        /*
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let strDate = String(dateFormatter.string(from: temp as Date))
        */
        let strDate = String(dateFormatter)
        
        transactionId = ""
        orderDate  = strDate!
        customerId = ""
        employeeId = ""
        location = ""
        pickupDate = ""
        building = ""
        dormRoom = ""
        mobileNumber = ""
        numberOfBags = 0
        status = ""
        notes = ""
        numberOfItems = 0
        createdAt = ""

    }
    
    
    
    init(snapshot: FDataSnapshot) {
        
        let snapshotValue = snapshot.value as? NSDictionary
        
        transactionId = snapshotValue?["transactionId"] as! String
        customerId = snapshotValue?["customerId"] as! String
        orderDate = snapshotValue?["order_date"] as! String
        employeeId = snapshotValue?["employeeId"] as! String
        pickupDate = snapshotValue?["pickup_date"] as! String
        numberOfItems = snapshotValue?["number_of_items"] as! Int
        location = snapshotValue?["location"] as! String
        building = snapshotValue?["dorm"] as! String
        dormRoom = snapshotValue?["room_number"] as! String
        mobileNumber = snapshotValue?["mobile_number"] as! String
        price = snapshotValue?["total_price"] as! Double
        status = snapshotValue?["status"] as! String
        notes = snapshotValue?["notes"] as! String
        createdAt = snapshotValue?["createdAt"] as! String
        
    
        //printUser()
        
    }
    
    // Reset Appointment
    
    
    func reset() {
        transactionId = ""
        orderDate  = ""
        customerId = ""
        employeeId = ""
        location = ""
        pickupDate = ""
        building = ""
        dormRoom = ""
        mobileNumber = ""
        numberOfBags = 0
        numberOfItems = 0
        status = ""
        notes = ""
        createdAt = ""
        
        
    }
    
    
    init (transactionId transaction:String, orderDate transDate:String, customerId custId:String, employeeId empId:String, location local:String, pickupDate pickDate: String, building build: String, dormRoom room:String, mobileNumber mobileNum:String, numberOfBags num_bags: Int, numberOfItems num_items: Int, notes noteString: String,  createdAt createdString: String){
        
        transactionId = transaction
        orderDate  = transDate
        customerId = custId
        employeeId = empId
        location = local
        pickupDate = pickDate
        building = build
        dormRoom = room
        mobileNumber = mobileNum
        numberOfBags = num_bags
        notes = noteString
        numberOfItems = num_items
        createdAt = createdString
        
    }
    
    
    func calculatePrice(numOfBags:Int){
        
        // The display viewcontroller handles the calculations for price on the 
        // Dry Cleaning front
        
        // So this function just adds whats already there for price
        
        let total = (Double(numOfBags) * 14.0) + 2.0
        price += total
    }
    
    func getTransactionId()->String{
        return transactionId
    }
    
    func setTransactionId(){
        
        transactionId = randomStringWithLength(10) as String
    }
    
    
    func randomStringWithLength (_ len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for _ in 0 ..< 10 {
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        
      //  print(randomString)
        return randomString
    }
    
    func printAppointment(){
        
        print("\n\n// ============  Order Created  =============== \\\n")

        
        print("TransID :" + transactionId)
        print("Order Placed : ")
        print(orderDate)
        print("CreatedAt: " + createdAt)
        print("CustomerId : " + customerId)
        print("EmployeeId : " + employeeId)
        print("Location : " + location)
        print("Building : " + building)
        print("Room Number : \(dormRoom)")
        print("Mobile Number : " + mobileNumber)
        print("// -------------- \\\n")
        print("Number of Bags : \(numberOfBags)")
        print("Number of Items : \(numberOfItems)")
        print("Pickup date: ")
        print(pickupDate)
        print("Status : \(status)")
        print("Notes : \(notes)")
        print("// -------------- \\\n")
        
    }
    
}

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        return dateFormatter.string(from: self)
    }
}




