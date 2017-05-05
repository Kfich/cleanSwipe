//
//  Employee.swift
//  CleanSwipe0-1
//
//  Created by Kevin Fich on 10/24/16.
//  Copyright © 2016 Kevin Fich. All rights reserved.
//

import Foundation
import Firebase

open class Employee{
    
    var password : String = ""
    var empId : String = ""
    var firstName : String = ""
    var lastName : String = ""
    var fullName : String = ""
    var email : String = ""
    var mobileNumber : String = ""
    
    init() {}
    
    init(firstName first:String, lastName last:String, email emailAddress:String, password pass:String){
        
        firstName = first
        lastName  = last
        email = emailAddress
        password = pass
        
    }
    
    
    init(snapshot: FDataSnapshot) {
        empId = snapshot.key
        let snapshotValue = snapshot.value as? NSDictionary
        fullName = snapshotValue?["name"] as! String
        email = snapshotValue?["email"] as! String
        mobileNumber = snapshotValue?["mobile_number"] as! String
        
        //printEmployee()
    }
    
    
    func toAnyObject() -> AnyObject {
        let dict = [
            "name": getName(),
            "email": email,
            "mobile_number": mobileNumber
        ]

        return dict as AnyObject
    }
    
 
    func getName()->String{
        return firstName + " " + lastName
    }
    
    
    func printEmployee(){
        print("\n")
        print("UserId :" + empId)
        print("Name :" + fullName)
        print("Email :" + email)
        print("Mobile Number : " + mobileNumber)
        
    }
    
    
}
