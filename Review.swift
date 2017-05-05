//
//  Review.swift
//  CleanSwipe0-1
//
//  Created by Kevin Fich on 10/11/16.
//  Copyright © 2016 Kevin Fich. All rights reserved.
//

import Foundation
import Firebase

open class Review{
    
    var transactionId : String = ""
    var comment : String = ""
    var star_rating : Int = 0
    
    init() {}
    
    init(snapshot: FDataSnapshot) {
        transactionId = snapshot.key
        let snapshotValue = snapshot.value as? NSDictionary
        comment = snapshotValue?["comment"] as! String
        star_rating = snapshotValue?["star_rating"] as! Int
        //printEmployee()
    }
    
    


}
