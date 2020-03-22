//
//  styles.swift
//  iOSKinkedIn
//
//  Created by alice on 2/26/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit
import SwiftUI

class ThemeColors {
    // UIColors
    
    static let primary = UIColor(named: "primaryColor")
    static let primaryFade = UIColor(named: "fadePrimaryColor")
    static let title = UIColor(named: "titleColor")
    
    static let msgIn = UIColor(named: "textColor")
    static let msgOut = UIColor(named: "titleColor")
    static let bg = UIColor(named: "bgColor")
    
    static let text = UIColor(named: "textColor")
    static let action = UIColor(named: "actionColor")
}

extension Color {
    // Swift UI Colors
    static let myBG = Color("bgColor")
    static let myPrimary = Color("primaryColor")
    static let myFadePrimary = Color("fadePrimaryColor")
    static let myAction = Color("actionColor")
    static let myText = Color("textColor")
    static let myTitle = Color("titleColor")
    static let myDisable = Color("disableColor")
}

class CellStyles {

    static func select(_ cell: UITableViewCell, check: Bool = false) {
        let label = cell.textLabel
        label?.textColor = ThemeColors.primary
        if(check) {
            cell.accessoryType = .checkmark
            cell.tintColor = ThemeColors.primary
        }
    }
    
    static func deselect(_ cell: UITableViewCell, check: Bool = false) {
        let label = cell.textLabel
        label?.textColor = UIColor.black
        if(check) {
            cell.accessoryType = .none
        }
    }
}

extension UIViewController {
    
    func setTitleToAll(_ title: String){
        self.title = title
        self.navigationItem.title = title
    }

}

struct ThemeDimensions {
    static let smSpace : CGFloat = 8
    static let mdSpace : CGFloat = 16
    static let lgSpace : CGFloat = 24
}
