//
//  styles.swift
//  iOSKinkedIn
//
//  Created by alice on 2/26/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class LabelStyles {

    static func selectedCell(_ label: UILabel) {
        label.textColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
    }
    
    static func deselectCell(_ label: UILabel) {
        label.textColor  = UIColor.black
    }
    
}
