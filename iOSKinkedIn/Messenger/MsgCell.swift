//
//  MsgCell.swift
//  iOSKinkedIn
//
//  Created by Alice on 1/25/20.
//  Copyright © 2020 KinkedIn. All rights reserved.
//

import UIKit

class MsgCell: UITableViewCell {
    
    @IBOutlet weak var msgLabel : UILabel!
    @IBOutlet weak var leftPad : NSLayoutConstraint!
    @IBOutlet weak var rightPad : NSLayoutConstraint!

    func setData(_ msg: Message){
        msgLabel.text = msg.body
        
        if msg.isMe {
            msgLabel.textAlignment = .right
            msgLabel.textColor = ThemeColors.msgOut
            
            leftPad.constant = 80
            rightPad.constant = 8
            self.contentView.layoutIfNeeded()
            
        } else {
            msgLabel.textAlignment = .left
            msgLabel.textColor = ThemeColors.msgIn
            
            leftPad.constant = 8
            rightPad.constant = 80
            self.contentView.layoutIfNeeded()
        }
    }
}
