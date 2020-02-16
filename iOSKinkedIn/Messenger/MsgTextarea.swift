//
//  MsgTextarea.swift
//  iOSKinkedIn
//
//  Created by Alice on 2/16/20.
//  Copyright © 2020 KinkedIn. All rights reserved.
//

import UIKit

class MsgTextarea: UITextView {

    override func draw(_ rect: CGRect) {
        
        let cornerSize = rect.height * 0.5

        self.layer.cornerRadius = cornerSize
        self.clipsToBounds = true
        
        self.backgroundColor = UIColor.white
        
        let padding = cornerSize * 0.5
        self.textContainerInset = UIEdgeInsets(top: 4, left: padding, bottom: 4, right: padding)
    }
    
}
