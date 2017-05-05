//
//  CollectionViewCell.swift
//  CS Dry Cleaning
//
//  Created by Don Sirivat on 1/18/17.
//  Copyright © 2017 Don Sirivat. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var clothingLabel: UILabel!
    @IBOutlet weak var num: UILabel!
    @IBOutlet weak var xButton: UIButton!
   
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
