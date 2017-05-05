//
//  TransactionViewCell.swift
//  CleanSwipe0-1
//
//  Created by Kevin Fich on 9/7/16.
//  Copyright © 2016 Kevin Fich. All rights reserved.
//

import UIKit

class TransactionViewCell: UITableViewCell {
    
    // Properties
    // ==========================

    
    
    // IBOutlets
    // ==========================
    
    @IBOutlet weak var bgContainerView: UIView!
    
    @IBOutlet weak var purchaseDateLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
          bgContainerView.layer.borderColor = UIColor.lightGray.cgColor
          bgContainerView.layer.borderWidth = 1.0
          bgContainerView.layer.cornerRadius = 10.0
          bgContainerView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    
    }
    
}
