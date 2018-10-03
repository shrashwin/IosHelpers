//
//  ExampleCollectionViewCell.swift
//  IosHelpers
//
//  Created by Insight Workshop on 10/3/18.
//  Copyright © 2018 Insight Workshop. All rights reserved.
//

import UIKit

class ExampleCollectionViewCell: UICollectionViewCell {

    static let cellIdentifier = "ExampleCollectionViewCell"
    
    @IBOutlet weak var contentWrapper: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentWrapper.layer.borderColor = UIColor.white.cgColor
        contentWrapper.layer.borderWidth = 2.0
        contentWrapper.layer.cornerRadius = 5.0
        contentWrapper.layer.masksToBounds = true
    }

}
