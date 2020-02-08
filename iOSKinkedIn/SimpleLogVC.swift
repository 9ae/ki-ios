//
//  SimpleLogVC.swift
//  iOSKinkedIn
//
//  Created by Alice on 2/8/20.
//  Copyright © 2020 KinkedIn. All rights reserved.
//

import UIKit

class SimpleLogVC: UITableViewController {
    
    private var messages : [Message] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messages.count
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let msg = self.messages[indexPath.row]
        let cellRef = msg.isMe ? "msgCellMe" : "msgCellThem"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellRef, for: indexPath)
        
        if let msgCell = cell as? MsgCell {
            msgCell.msgLabel.text = msg.body
        }
        
        return cell
    }

    func iSay(_ message: String){
        self.messages.append(Message(body: message, isMe: true))
        self.tableView.reloadData()
    }
    
    func botSay(_ message: String){
        self.messages.append(Message(body: message, isMe: false))
        self.tableView.reloadData()
    }

}
