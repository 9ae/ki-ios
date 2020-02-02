//
//  ConvoLogVC.swift
//  iOSKinkedIn
//
//  Created by Alice on 1/26/20.
//  Copyright © 2020 KinkedIn. All rights reserved.
//

import UIKit
import SendBirdSDK

struct Message {
    let body : String
    let isMe : Bool
}

class ConvoLogVC: UITableViewController, SBDChannelDelegate {
    
    private let PAGE_SIZE = 3
    private let SBID = "raven_brings_the_night"

       private var messages : [Message] = []
    
        var theirId = ""
        var _chan : SBDGroupChannel?
    
    var query : SBDPreviousMessageListQuery?
    
    let loadMore = UIButton()


       override func viewDidLoad() {
           super.viewDidLoad()
        
        loadMore.setTitleColor(ThemeColors.action, for: .normal)
        loadMore.tintColor = ThemeColors.action
        loadMore.setTitle("show more...", for: .normal)
        loadMore.addTarget(self, action: #selector(loadMoreMessages), for: .touchUpInside)
        loadMore.isHidden = true
        
        SBDMain.add(self, identifier: SBID)
       }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        SBDMain.removeChannelDelegate(forIdentifier: SBID)
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
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            return loadMore

    }
    
    func toMessage(_ msg: SBDUserMessage) -> Message? {
        guard let body = msg.message else { return nil }
        var isMe = false
        if let sender = msg.sender {
            print("senderId = \(sender.userId)")
            isMe = sender.userId != self.theirId
        }
        return Message(body: body, isMe: isMe)
    }
    
    func channel(_ sender: SBDBaseChannel, didReceive message: SBDBaseMessage) {
        print("received message")
        
        if let msg = message as? SBDUserMessage {
            if let m = toMessage(msg) {
                self.messages.append(m)
                self.tableView.reloadData()
            }
        }
    }
    
    func setData(theirId: String, chan: SBDGroupChannel){
        self.theirId = theirId
        self._chan = chan
        
        query = chan.createPreviousMessageListQuery()
        
        print("query created")
        
        query?.loadPreviousMessages(withLimit: PAGE_SIZE, reverse: false) { (_messages, _error) in
            if let messages = _messages as? [SBDUserMessage] {
                for msg in messages {
                    if let m = self.toMessage(msg) {
                        self.messages.append(m)
                    } else {
                        continue
                    }
                }
                self.tableView.reloadData()
                
                if messages.count < self.PAGE_SIZE {
                    self.loadMore.isHidden = true
                } else {
                    self.loadMore.isHidden = false
                }
                

            } else {
                print(_error)
            }
        }
        
    }
    
    func addMyMessage(_ msg: String){
        self.messages.append(Message(body: msg, isMe: true))
        self.tableView.reloadData()
    }
    
    @objc func loadMoreMessages(_ sender: Any){
        
        query?.loadPreviousMessages(withLimit: PAGE_SIZE, reverse: false, completionHandler: { _msgs, _error in
             if let msgs = _msgs as? [SBDUserMessage] {
                let prevMsgs = msgs.map { msg -> Message in
                    return self.toMessage(msg)!
                }
                self.messages = prevMsgs + self.messages
                 self.tableView.reloadData()
                 
                if msgs.count < self.PAGE_SIZE {
                    self.loadMore.isHidden = true
                 }  else {
                                    self.loadMore.isHidden = false
                                }

             } else {
                 print(_error)
             }
        })
    }

}
