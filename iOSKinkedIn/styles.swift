//
//  styles.swift
//  iOSKinkedIn
//
//  Created by alice on 2/26/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class ThemeColors {
    static let no = #colorLiteral(red: 0.7474038005, green: 0.1815122068, blue: 0.3448296785, alpha: 1)
    static let yes = #colorLiteral(red: 0.2670845985, green: 0.747251451, blue: 0.5655201674, alpha: 1)
    static let primary = #colorLiteral(red: 0.591878593, green: 0.295220077, blue: 1, alpha: 1)
    static let primaryFade = #colorLiteral(red: 0.6225335002, green: 0.4816721082, blue: 0.8395491838, alpha: 1)
    static let primaryDark = #colorLiteral(red: 0.3744569421, green: 0.2795264721, blue: 0.5165044665, alpha: 1)

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
