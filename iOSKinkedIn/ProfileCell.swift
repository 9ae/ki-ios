//
//  ProfileCell.swift
//  iOSKinkedIn
//
//  Created by alice on 5/22/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class ProfileCell: UICollectionViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var kinksValue: UILabel!
    @IBOutlet var vouchedLabel: UILabel!
    @IBOutlet var vouchedValue: UILabel!
    
    
    var profile: Profile?
    
    func setContent(_ profile: Profile){
        self.profile = profile
        
        nameLabel.text = profile.name
        
        kinksValue.text = "\(profile.kinksMatched)"
        if profile.vouches > 0 {
            vouchedValue.text = "\(profile.vouches)"
        } else {
            vouchedValue.isHidden = true
            vouchedLabel.isHidden = true
        }
        
    }
}
