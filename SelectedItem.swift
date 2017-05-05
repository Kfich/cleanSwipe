//
//  SelectedItems.swift
//  CS Dry Cleaning
//
//  Created by Don Sirivat on 1/16/17.
//  Copyright © 2017 Don Sirivat. All rights reserved.
//

import Foundation

class selectedItem {
    var name : String
    var price: Double
    var num: Int = 1
    var picture: String
    
    init(nameInput: String, priceInput: Double, pictureString: String) {
        name = nameInput
        price = priceInput
        picture = pictureString
    }
}
