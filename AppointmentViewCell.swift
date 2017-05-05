//
//  AppointmentViewCell.swift
//  CleanSwipe0-1
//
//  Created by Kevin Fich on 10/24/16.
//  Copyright © 2016 Kevin Fich. All rights reserved.
//

import UIKit

class AppointmentViewCell: UICollectionViewCell {

    @IBOutlet var bagLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var pickupDateLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
