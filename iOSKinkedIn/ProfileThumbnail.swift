//
//  ProfileThumbnail.swift
//  iOSKinkedIn
//
//  Created by alice on 9/8/18.
//  Copyright © 2018 KinkedIn. All rights reserved.
//

import UIKit

class ProfileThumbnail: UICollectionViewCell {
    
    @IBOutlet var nameLabel : UILabel!
    
    var profile: Profile?
    
    func setContent(_ profile: Profile){
        self.profile = profile
        nameLabel.text = profile.name
    }
    
}
