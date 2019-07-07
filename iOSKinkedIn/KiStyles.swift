//
//  KiStyles.swift
//  iOSKinkedIn
//
//  Created by Alice on 7/6/19.
//  Copyright © 2019 KinkedIn. All rights reserved.
//

import UIKit

class TextStyles : NSObject {
    static func fontForStyle(_ style: String) -> UIFont {
        switch style {
        case "body":
            return UIFont.systemFont(ofSize: 12)
        case "h1":
            return UIFont.boldSystemFont(ofSize: 36)
        case "h2":
            return UIFont.boldSystemFont(ofSize: 24)
        default:
            return TextStyles.fontForStyle("body")
        }
    }
}

@IBDesignable class KiLabel: UILabel {
    @IBInspectable var style:String="body"{
        didSet{self.font=TextStyles.fontForStyle(style)}
    }
}
