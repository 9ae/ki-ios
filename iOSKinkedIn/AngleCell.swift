//
//  AngleCell.swift
//  iOSKinkedIn
//
//  Created by alice on 12/29/18.
//  Copyright © 2018 KinkedIn. All rights reserved.
//

import UIKit

class AngleCell: UIView {
    
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return super.draw(rect)
        }
        
        ctx.setFillColor(UIColor.white.cgColor)
        ctx.beginPath()
        ctx.move(to: CGPoint(x: rect.maxX - 20, y: rect.minY))
        ctx.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        ctx.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        ctx.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        ctx.closePath()
        ctx.fillPath()
    }

}
