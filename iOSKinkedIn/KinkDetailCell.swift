//
//  KinkDetailCell.swift
//  iOSKinkedIn
//
//  Created by alice on 3/5/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class KinkDetailCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if(selected){
            CellStyles.select(self, check: true)
        } else {
            CellStyles.deselect(self, check: true)
        }
    }

}
