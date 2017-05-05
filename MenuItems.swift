//
//  MenuItems.swift
//  CS Dry Cleaning
//
//  Created by Don Sirivat on 1/13/17.
//  Copyright © 2017 Don Sirivat. All rights reserved.
//

import Foundation
import UIKit

class MenuItems:NSObject {
    let names:[String] = [
    "Dress Shirt", "Dress", "Blouse", "Skirt",
    "Slacks/Pants", "Sweater", "Suit (2pc)", "Polo Shirt", "Jacket", "Tie/Bow-Tie"]
    let prices:[Double] = [
    8.50, 15.00, 8.50, 8.75,
    8.75, 9.00, 18.75, 5.75, 12.80, 5.75]
    let specials:[Bool] = [
    false, false, false, false,
    false, false, false, false, false, false]
    let pictures:[String] = ["shirt", "dress", "blouse", "skirt",
                             "pants", "sweater","suit","polo", "jacket", "tie"]
}
