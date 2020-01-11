//
//  LineTextField.swift
//  iOSKinkedIn
//
//  Created by Alice on 11/17/19.
//  Copyright © 2019 KinkedIn. All rights reserved.
//

import UIKit

class LineTextField: UITextField {

    override func draw(_ rect: CGRect) {
        let ln = CALayer()
        ln.frame = CGRect(origin: CGPoint(x:0, y: rect.height - 1), size: CGSize(width: rect.width, height: 1.0))
        ln.backgroundColor = ThemeColors.primaryLight.cgColor
        self.borderStyle = .none
        self.layer.addSublayer(ln)
    }


}
