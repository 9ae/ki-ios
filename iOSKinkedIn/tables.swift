//
//  tables.swift
//  iOSKinkedIn
//
//  Created by alice on 2/26/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

extension UITableView {
    func getOrCreateCell(_ cellId: String) -> UITableViewCell {
        guard let cell = self.dequeueReusableCell(withIdentifier: cellId)
        else {
            return UITableViewCell(
                style: UITableViewCellStyle.default,
                reuseIdentifier: cellId)
        }
        return cell
    }

}

extension UIViewController {
    func addTopSpace(){
        self.view.layoutMargins = UIEdgeInsetsMake(40, 0, 0, 0)
    }
}

extension UITableViewController {
    override func addTopSpace(){
        self.tableView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0)
    }
}

extension UICollectionViewController {
    override func addTopSpace() {
        self.collectionView?.contentInset = UIEdgeInsetsMake(40, 0, 0, 0)
    }
}
