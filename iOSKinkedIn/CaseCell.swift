//
//  CaseCell.swift
//  iOSKinkedIn
//
//  Created by Alice on 10/26/19.
//  Copyright © 2019 KinkedIn. All rights reserved.
//

import UIKit

class CaseCell: UITableViewCell {
    
    @IBOutlet var name: UILabel!
    @IBOutlet var caseType: UILabel!
    @IBOutlet var status: UILabel!
    @IBOutlet var lastUpdate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
