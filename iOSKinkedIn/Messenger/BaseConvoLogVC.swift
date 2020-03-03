//
//  BaseConvoLogVC.swift
//  iOSKinkedIn
//
//  Created by Alice on 2/16/20.
//  Copyright © 2020 KinkedIn. All rights reserved.
//

import UIKit

class BaseConvoLogVC: UITableViewController {
    
    var messages : [Message] = []

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let msg = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "msgCell", for: indexPath)
        if let msgCell = cell as? MsgCell {
            msgCell.setData(msg)
        }
        
        return cell
    }
    
    func refresh(){
        self.tableView.reloadData()
        if (self.messages.count > 0){
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }

   
}
