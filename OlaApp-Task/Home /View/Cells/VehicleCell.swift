//
//  VehicleCell.swift
//  OlaApp-Task
//
//  Created by Anand Nimje on 13/11/19.
//  Copyright © 2019 Anand. All rights reserved.
//

import UIKit

class VehicleCell: UICollectionViewCell {

    @IBOutlet weak var vehicleImage: UIImageView!
    @IBOutlet weak var vehicleTitle: UILabel!
    
    override var isSelected: Bool {
      didSet {
         manageSelection()
      }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func manageSelection(){
        guard isSelected else {
            contentView.backgroundColor = .white
            return
        }
        contentView.backgroundColor = UIColor.yellow.withAlphaComponent(0.5)
    }
}
