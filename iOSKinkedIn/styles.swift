//
//  styles.swift
//  iOSKinkedIn
//
//  Created by alice on 2/26/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class ThemeColors {
    static let secondary = #colorLiteral(red: 0.2400001287, green: 0.9493332505, blue: 0.9999999404, alpha: 1)
    static let action = #colorLiteral(red: 0.7797902226, green: 0.113660492, blue: 0.2339498401, alpha: 1)
    static let primary = #colorLiteral(red: 0.5868333578, green: 0.3299999237, blue: 0.9999999404, alpha: 1)
    static let primaryFade = #colorLiteral(red: 0.6201483011, green: 0.4896999002, blue: 0.8299999237, alpha: 1)
    static let primaryDark = #colorLiteral(red: 0.3716200292, green: 0.285599947, blue: 0.5099999309, alpha: 1)

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
