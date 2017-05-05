//
//  ConfirmedAppointment.swift
//  CleanSwipe0-1
//
//  Created by Kevin Fich on 10/25/16.
//  Copyright © 2016 Kevin Fich. All rights reserved.
//

import Foundation
import Firebase

class ConfirmedAppointment {
    
    var transId : String = ""
    var empId : String = ""
    var customerId : String = ""
    var deliveryDate : String = ""
    var sortDate:Date?
    
    init(){}
    
    init(snapshot: FDataSnapshot) {
        
        let snapshotValue = snapshot.value as? NSDictionary
        transId = snapshotValue?["transactionId"] as! String
        customerId = snapshotValue?["customer_id"] as! String
        empId = snapshotValue?["employee_id"] as! String
        deliveryDate = snapshotValue?["delivery_date"] as! String
        
    }
 
}
