//
//  CustomTableViewCell.swift
//  CS Dry Cleaning
//
//  Created by Don Sirivat on 1/13/17.
//  Copyright © 2017 Don Sirivat. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var menuItemDescLabel: UILabel!
    @IBOutlet weak var specialLabel: UILabel!
    @IBOutlet weak var regPriceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var clothingIcon: UIImageView!
    
    let lightGreen = UIColor(red: 0.5, green: 1.0, blue: 0.5, alpha: 1.0)
    let lightRed = UIColor(red: 1.0, green: 0.9, blue: 0.9, alpha: 1.0)
    let discount = 0.1
    
    func string(_ prefix:String, for price: Double) -> String {
        let priceString = String(format: "%2.2f", price)
        return prefix + priceString
    
    }
    
    func show(_ isSpecial:Bool, for price: Double) {
        if !isSpecial {
            //normal
            regPriceLabel.text = ""
            specialLabel.text = ""
            priceLabel.text = string("$", for: price)
            
        } else {
            //special discount
            regPriceLabel.text = string("Regular price $", for: price)
            specialLabel.text = "Special"
            priceLabel.text = string("$", for: price * (1.0 - discount))
            contentView.backgroundColor = lightGreen
        }
    }
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
