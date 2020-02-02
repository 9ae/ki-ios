//
//  ConvoLogVC.swift
//  iOSKinkedIn
//
//  Created by Alice on 1/26/20.
//  Copyright © 2020 KinkedIn. All rights reserved.
//

import UIKit

struct Message {
    let body : String
    let isMe : Bool
}

class ConvoLogVC: UITableViewController {

       var messages : [Message] = [Message(body: "Hey cutie. A LIMIT parameter indicates how many messages to be included in a returned list. A SBDPreviousMessageListQuery instance itself does pagination of a result set according to the value of the LIMIT parameter, and internally manages a token to retrieve the next page in the result set.", isMe: false), Message(body: "Howdy!", isMe: true)]

       override func viewDidLoad() {
           super.viewDidLoad()

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
           let msg = messages[indexPath.row]
           let cellRef = msg.isMe ? "msgCellMe" : "msgCellThem"
           let cell = tableView.dequeueReusableCell(withIdentifier: cellRef, for: indexPath)
           
           if let msgCell = cell as? MsgCell {
               msgCell.msgLabel.text = msg.body
           }
           
           return cell
       }

}
