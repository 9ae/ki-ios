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
                style: UITableViewCell.CellStyle.default,
                reuseIdentifier: cellId)
        }
        return cell
    }

}

extension UIViewController {
    func addTopSpace(){
        self.view.layoutMargins = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
    }
}

extension UITableViewController {
    override func addTopSpace(){
        self.tableView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
    }
}

extension UICollectionViewController {
    override func addTopSpace() {
        self.collectionView?.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
    }
}

func emptyList(
    title: String,
    msg: String,
    actionLabel: String,
    action: ((UIAlertAction) -> Swift.Void)? ) -> UIAlertController {
    let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
    let ok = UIAlertAction(
        title: actionLabel, style: UIAlertAction.Style.default, handler: action)
    let cancel = UIAlertAction(title: "Not Now", style: .cancel)
    alert.addAction(cancel)
    alert.addAction(ok)
    return alert
}
