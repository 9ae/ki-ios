//
//  ReverseButton.swift
//  iOSKinkedIn
//
//  Created by alice on 5/3/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class ReverseButton: UIButton {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
    
    func reverseColors(){
        let textColor = self.titleLabel?.textColor
        let bgColor = self.backgroundColor
        
        self.titleLabel?.textColor = bgColor
        self.backgroundColor = textColor
    }
    

}
