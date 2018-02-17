//
//  ThumbnailMatchCell.swift
//  iOSKinkedIn
//
//  Created by alice on 3/8/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

private enum ThumbnailState {
    case EMPTY
    case FILLED
    case FULFILLED
}

class ThumbnailMatchCell: UICollectionViewCell {
    
    private var state = ThumbnailState.EMPTY
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {return}
        let fillColor = UIColor(red: 0.80, green: 0.80, blue: 0.80, alpha: 0.6)
        let strokeColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
        context.addEllipse(in: rect)
        fillColor.setFill()
        context.fillPath()
        strokeColor.setStroke()
        context.strokeEllipse(in: rect)
    }

    
}
