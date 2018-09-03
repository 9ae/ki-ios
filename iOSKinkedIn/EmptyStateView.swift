//
//  EmptyStateView.swift
//  iOSKinkedIn
//
//  Created by alice on 9/2/18.
//  Copyright © 2018 KinkedIn. All rights reserved.
//

import UIKit

class EmptyStateView: UIView {
    
    var button: UIButton
    var label: UILabel
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        button = UIButton()
        label = UILabel()
        
        self.addSubview(label)
        self.addSubview(button)
        
        let label_top = NSLayoutConstraint(
            item: label,
            attribute: .top,
            relatedBy: .equal,
            toItem: self,
            attribute: .top,
            multiplier: 1,
            constant: 0)
        let label_left = NSLayoutConstraint(
            item: label,
            attribute: .left,
            relatedBy: .equal,
            toItem: self,
            attribute: .left,
            multiplier: 1,
            constant: 0)
        let label_right = NSLayoutConstraint(
            item: label,
            attribute: .right,
            relatedBy: .equal,
            toItem: self,
            attribute: .right,
            multiplier: 1,
            constant: 0)
        let button_label = NSLayoutConstraint(
            item: button,
            attribute: .top,
            relatedBy: .equal,
            toItem: label,
            attribute: .bottom,
            multiplier: 1,
            constant: 8)
        let button_left = NSLayoutConstraint(
            item: button,
            attribute: .left,
            relatedBy: .equal,
            toItem: self,
            attribute: .left,
            multiplier: 1,
            constant: 0)
        let button_right = NSLayoutConstraint(
            item: button,
            attribute: .right,
            relatedBy: .equal,
            toItem: self,
            attribute: .right,
            multiplier: 1,
            constant: 0)
        self.addConstraints([label_top, label_left, label_right, button_label, button_left, button_right])
    }
    
    func setData(msg: String, actionText: String) {
        button.setTitle(actionText, for: .normal)
        label.text = msg
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
