//
//  RoundButton.swift
//  iOSKinkedIn
//
//  Created by alice on 6/30/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class RoundButton: UIButton {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
    }
    

}
