//
//  AftercareConvoView.swift
//  iOSKinkedIn
//
//  Created by alice on 9/2/18.
//  Copyright © 2018 KinkedIn. All rights reserved.
//

import UIKit
import LayerXDK.LayerXDKUI

class AftercareConvoView: LYRUIConversationView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func enableKeyboard(_ isKeyboard: Bool) {
        if isKeyboard {
            self.composeBar.backgroundColor = UIColor.cyan
        } else {
            self.composeBar.backgroundColor = UIColor.red
        }
    }

}
