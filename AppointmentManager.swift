//
//  AppointmentManager.swift
//  CleanSwipe0-1
//
//  Created by Kevin Fich on 10/24/16.
//  Copyright © 2016 Kevin Fich. All rights reserved.
//

import Foundation
import Firebase

class AppointmentManager: NSObject {
    
    // Storage Endpoints
    
    static let sharedManager = AppointmentManager()
    let baseRef = Firebase(url: "https://cleanswipe.firebaseio.com/orders")
    let ordersRef = Firebase(url: "https://cleanswipe.firebaseio.com/orders")
    let devicesRef = Firebase(url: "https://cleanswipe.firebaseio.com/devices")
    let confirmedRef = Firebase(url: "https://cleanswipe.firebaseio.com/confirmed-orders")
    let usersRef = Firebase(url:"https://cleanswipe.firebaseio.com/users")
    let employeesRef = Firebase(url:"https://cleanswipe.firebaseio.com/employees")
    let reviewRef = Firebase(url: "https://cleanswipe.firebaseio.com/reviews")
    let referralsRef = Firebase(url: "https://cleanswipe.firebaseio.com/referrals")
    
    // Appointment list
    var activeAppointment = Appointment()
    var appointment = Appointment()
    
    // Bool checks
    var hasActiveAppointment: Bool = false
    var hasBeenReviewed: Bool = false
    var appointmentReviewed: Bool = false
    var userHasRegisteredDevice : Bool = false
    
    var userSelectedDryCleaning : Bool = false
    var userSelectedLaundry : Bool = false
    
    // Properties
    
    var status: String = ""
    var userDeviceToken = ""
    var currentEmp = Employee()
    var selectedAppointment = Appointment()
    var review = Review()
    
    var users = [User]()
    var employees = [Employee]()
    var transactionList = [Appointment]()
    var cart : [selectedItem] = []
    
    // Embedded Objects
    
    class Device{
        
        var token : String = ""
        var userId : String = ""
        
        init() {}
        
        init(snapshot: FDataSnapshot) {
            let snapshotValue = snapshot.value as? NSDictionary
            token = snapshotValue?["device_token"] as! String
            userId = snapshot.key
        }
    }
    
    class Referral{
        var code : String = ""
        init() {}
        
        init(snapshot: FDataSnapshot) {
            let snapshotValue = snapshot.value as? NSDictionary
            code = snapshotValue?["ref_code"] as! String
        }
    }
    
    // Custom Methods
    
    func reset() {
        status = ""
        currentEmp = Employee()
        selectedAppointment.reset()
        appointment.reset()
        currentEmp = Employee()
        cart.removeAll()
        
        userSelectedLaundry = false
        userSelectedDryCleaning = false
    }
    
    // Calculate total price for orders
    
    func calculateTotal() -> Double {
        // Caluclate cart total
        let size = cart.count
        var total : Double = 0.0
        for i in 0 ..< size{
            total += (cart[i].price * Double(cart[i].num))
        }
        
        let includingBags = total + (Double(appointment.numberOfBags!) * 14.0)
        
        return includingBags
    }
    
    
    // Referral Code
    //
    func expiredReferralCode(refCode: String) -> Bool{
        var isExpiredCode = false
        
        referralsRef?.queryOrdered(byChild: "ref_code").observe(.value, with: { snapshot in
            
            for child in (snapshot?.children)! {
                let code = Referral(snapshot: child as! FDataSnapshot)
                if code.code == refCode{
                    isExpiredCode = true
                    // Upload token to endpoint if true
                }
            }
        })
        return isExpiredCode
    }
    
    func uploadUsedReferralCode(code: String){
        
        let referralDict = ["ref_code" : code]
        print("==== The Referral =====")
        print(referralDict)
        
        
        referralsRef?.child(byAppendingPath: code).setValue(referralDict)
        
    }
    
    // To be used later
    func creditUserAccount(userDict: [String: Any], userId: String){
        // Create a child path with a key set to the uid underneath the "users" node
        // This creates a URL path like the following:
        //  - https://<YOUR-FIREBASE-APP>.firebaseio.com/users/<uid>
        
        usersRef?.child(byAppendingPath: userId).setValue(userDict)
    }
    
    
    // =========== Figure out how to validate date information =============
    
    // Convert card to dictionary
    
    func uploadConfirmedAppointment(_ apt : Appointment) {
        
        self.selectedAppointment = apt
        
        // Configure current time for dropoff
        let temp = Date ()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let strDate = String(dateFormatter.string(from: temp))
        let tempTransId:String = self.selectedAppointment.transactionId
        
        let transaction = [
            "transactionId" : self.selectedAppointment.transactionId,
            "delivery_date" : strDate!,
            "employee_id" : self.selectedAppointment.employeeId,
            "customer_id" : self.selectedAppointment.customerId
            
            // Add preferences in the future
        ] as [String : String]
        
        confirmedRef?.child(byAppendingPath: tempTransId).setValue(transaction)
    }
    
    func updateOrderStatus(_ emp_id : String, order_id:String, newStatus : String){
        
        // Set appointment status
        selectedAppointment.status = newStatus
        selectedAppointment.employeeId = emp_id
        
        /*
         let preferences = ["transactionId" : appointment.transactionId,
         "tip" : appointment.preferences.tip,
         "notes" : appointment.preferences.notes]*/
        
        let transaction = [
            "transactionId" : self.selectedAppointment.transactionId,
            "order_date" : self.selectedAppointment.orderDate,
            "customerId": self.selectedAppointment.customerId,
            "location": self.selectedAppointment.location,
            "dorm" : self.selectedAppointment.building,
            "room_number" : self.selectedAppointment.dormRoom,
            "pickup_date" : self.selectedAppointment.pickupDate,
            "mobile_number" : self.selectedAppointment.mobileNumber,
            "number_of_items" : self.selectedAppointment.numberOfItems,
            "total_price" : self.selectedAppointment.price,
            "employeeId" : self.selectedAppointment.employeeId,
            "status" : self.selectedAppointment.status,
            "notes" : self.selectedAppointment.notes,
            "createdAt" : self.selectedAppointment.createdAt

            // Add preferences in the future
            
        ] as [String : Any]
        // Create a child path with a key set to the uid underneath the "users" node
        // This creates a URL path like the following:
        //  - https://<YOUR-FIREBASE-APP>.firebaseio.com/users/<uid>
        
        ordersRef?.child(byAppendingPath: order_id).setValue(transaction)
        
        
    }
    
    // Create new appointment
    
    func uploadAppointment(apt: Appointment){
        
        self.appointment = apt
        
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
            "createdAt" : self.selectedAppointment.createdAt
            
            // Add preferences in the future
            
            ] as [String : Any]

        
         ordersRef?.child(byAppendingPath: self.appointment.transactionId).setValue(transaction)
        
    }
    
    
    func queryForActiveAppointment(_ user_id: String) -> Appointment {
        
        print("QUERY GOT CALLED")
        self.transactionList.removeAll()
        var appointment = Appointment()
        
        // Query backend to retrieve array of Transactions for currentUser
        
        let ref2 = Firebase(url:"https://cleanswipe.firebaseio.com/orders")
        
        ref2?.queryOrdered(byChild: "order_date").observe(.value, with: { snapshot in
            
            
            for child in (snapshot?.children)! {
                
                // Initialize appointment
                let order = Appointment(snapshot: child as! FDataSnapshot)
                
                if (order.customerId == user_id){
                    
                    // Format date for sorting
                    let strTime = order.createdAt
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd-MM-yyyy HH:mm"
                    let s = formatter.date(from: strTime)
                    order.sortDate = s
                    
                    // Add appointment to transaction list
                    self.transactionList.append(order)
                    
                }
            }
            
            if self.transactionList.count != 0{
                
                self.transactionList.sort(by: { $0.sortDate!.compare($1.sortDate! as Date) == ComparisonResult.orderedDescending })
                
                // Set appropriate order vars
                self.activeAppointment = self.transactionList[0]
                appointment = self.transactionList[0]
                print("\n\nAppointment Manager Shared Manager \n\n")
                print("\(self.transactionList.count) \n\n")
                self.activeAppointment.printAppointment()
                print("\n\nShared Manager \n\n")
                self.transactionList.removeAll()
                print("\(self.transactionList.count) \n\n")
                NotificationCenter.default.post(name: Notification.Name(rawValue: "Active Appointment"), object: self)

            }else{
                NotificationCenter.default.post(name: Notification.Name(rawValue: "No Appointments"), object: self)
            }
            
        
        })
        return appointment
    }
    
    
    func queryForAppointmentReview(_ trans_id: String) {
        hasBeenReviewed = false
        
        print("THE SELECTED APPOINTMENT: \(trans_id) \n\n\n")

        // Query backend to retrieve review list
        
        reviewRef?.queryOrdered(byChild: "transactionId").observe(.value, with: { snapshot in
            
            for child in (snapshot?.children)! {
                
                // Initialize appointment
                let review = Review(snapshot: child as! FDataSnapshot)
                print("GAJHG:KJGDLKJGA \(review.transactionId)")
                
                if (review.transactionId == trans_id){
                    
                    // set bool to true and return
                    self.hasBeenReviewed = true
                    print("\n\nTHE APPOINTMENT WAS REVIEWED")
                    print("Was reviewed: \(self.hasBeenReviewed)")
                    self.postReviewNotification()
                }
            }
        
        })
    }

    
    // Query for user list for name assignments
    
    func queryForUserList(){
        usersRef?.queryOrdered(byChild: "uid").observe(.value, with: { snapshot in
            for child in (snapshot?.children)! {
                
                // Append all users to the list
                let user = User(snapshot: child as! FDataSnapshot)
                self.users.append(user)
                //print(user)
                
            }
        })
    
    }
    
    // Query for user list for name assignments
    
    func queryForEmployeeList(){
        // Clear emp list
        self.employees.removeAll()
        employeesRef?.queryOrdered(byChild: "uid").observe(.value, with: { snapshot in
            
            for child in (snapshot?.children)! {
                
                // Append all users to the list
                let emp = Employee(snapshot: child as! FDataSnapshot)
                self.employees.append(emp)
                // Check if thats the current employee
                _ = self.setCurrentEmployee(emp, empId: self.activeAppointment.employeeId)
                //print(emp)
                
            }
        })
        
        // Post Active appointment notification
        //NSNotificationCenter.defaultCenter().postNotificationName("Employee List", object: self)
        
    }
    
    // Query for device tokens
    
    func queryForDeviceToken(_ userId: String){
        // Set bool to false
        
        devicesRef?.queryOrdered(byChild: "uid").observe(.value, with: { snapshot in
            
            for child in (snapshot?.children)! {
                let device = Device(snapshot: child as! FDataSnapshot)
                if device.userId == userId{
                    self.userHasRegisteredDevice = true
                    self.userDeviceToken = device.token
                }
            }
        })
    }
    

    
    // Filter through emp list to find current emp
    
    func setCurrentEmployee(_ employee: Employee, empId : String) -> Bool {
        var isEmployee = false
        // Check if id strings match
        if employee.empId == empId{
            currentEmp = employee
            isEmployee = true
            return isEmployee
            
        }
        return isEmployee
    }

    // Post review notification 
    
    func postReviewNotification() {
        
        // Add logics here for uploading the reviews 
        
        // Post notification
        NotificationCenter.default.post(name: Notification.Name(rawValue: "Review Submitted"), object: self)

    }
    
    // Create method for accepting reviews 
    func uploadAppointmentReview(_ appointment: Appointment, rating: Int) {
        // Logics here
        
        let reviewDict = ["transactionId" : appointment.transactionId,
                          "star_rating" : rating,
                          "comment" : review.comment] as [String : Any]
        
        print("==== The Review =====")
        print(reviewDict)
        
        
        reviewRef?.child(byAppendingPath: self.activeAppointment.transactionId).setValue(reviewDict)
        
        // Dispact push notification
        dispatchPush()
    }
    
    
    func dispatchPush(){
        let m = Networking()
        m.genericPostCall("userId", deviceToken: AuthManager.sharedManager.deviceToken)
    }
    
    // Device token storage
    
    func updateUserDeviceToken(_ userId: String) {
        
        if UIApplication.shared.isRegisteredForRemoteNotifications
            && AuthManager.sharedManager.deviceToken != "" {
            
            let tokenParams = ["device_token" : AuthManager.sharedManager.deviceToken]
            devicesRef?.child(byAppendingPath: userId).setValue(tokenParams)
        }
    }

    // Device storage
    
    func rememberReview(_ transId: String){
        
        let reviewId = transId
        UDWrapper.setString("transaction_id", value: reviewId as NSString?)
    }
    
    func retrieveLastReview(_ activeTransId: String) -> String{
        
        var reviewString = String()
        
        let userInfo = UserDefaults.standard
        
        if userInfo.value(forKey: "transaction_id") != nil{
            
            reviewString = userInfo.value(forKey: "transaction_id") as! String
            print("Review details: \(review)")
            
            if reviewString == activeTransId{
                appointmentReviewed = true
            }else{
                appointmentReviewed = false
            }
            
        }else{
            print("There was review")
            appointmentReviewed = false
        }
        return reviewString
    }

    func rememberPaymentInfo(_ payment: NSDictionary){
        
        let paymentDict = payment
        UDWrapper.setDictionary("default_payment", value: paymentDict)
    }

    func retrieveDefaultPayment() -> NSDictionary {
        
        let paymentDict = UDWrapper.getDictionary("default_payment")
        return paymentDict!
    }
    
    
    func rememberPaymentDescription(_ description: NSDictionary){
        let descriptionDict = description
        UDWrapper.setDictionary("paymet_description", value: descriptionDict)
    }
    
    func retrievePaymentDescription() -> NSDictionary {
        
        let descriptionDict = UDWrapper.getDictionary("paymet_description")
        return descriptionDict!
    }
    
    
}
