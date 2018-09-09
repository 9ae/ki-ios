//
//  AngleView.swift
//  iOSKinkedIn
//
//  Created by alice on 9/8/18.
//  Copyright © 2018 KinkedIn. All rights reserved.
//

import UIKit

class AngleView: UIView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return super.draw(rect)
        }

        ctx.setFillColor(UIColor.gray.cgColor)
        ctx.beginPath()
        ctx.move(to: rect.origin)
        let p1 = CGPoint(x: rect.maxX , y: rect.minY + 120.0)
        ctx.addLine(to: p1)
        ctx.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        ctx.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        ctx.closePath()
        ctx.fillPath()
    }


}
