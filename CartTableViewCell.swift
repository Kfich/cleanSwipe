//
//  CartTableViewCell.swift
//  CS Dry Cleaning
//
//  Created by Don Sirivat on 1/16/17.
//  Copyright © 2017 Don Sirivat. All rights reserved.
//

import Foundation
import UIKit

class CartTableViewCell : UITableViewCell {
    
    @IBOutlet weak var itemName : UILabel!
    @IBOutlet weak var priceLabel : UILabel!
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var numOfItem : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
