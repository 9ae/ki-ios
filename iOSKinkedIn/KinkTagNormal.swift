//
//  KinkTagNormal.swift
//  iOSKinkedIn
//
//  Created by alice on 3/12/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class KinkTagNormal: UIView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else {return}
        ctx.addEllipse(in: rect)
        #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).setStroke()
        ctx.strokePath()
    }
    

}
