//
//  ConvoLogVC.swift
//  iOSKinkedIn
//
//  Created by Alice on 1/26/20.
//  Copyright © 2020 KinkedIn. All rights reserved.
//

import UIKit
import SendBirdSDK

class ConvoLogVC: BaseConvoLogVC, SBDChannelDelegate {
    
    private let PAGE_SIZE = 20
    private let SBID = "raven_brings_the_night"

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
            
            loadMore.backgroundColor = ThemeColors.msgBg
            
            SBDMain.add(self, identifier: SBID)
       }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        SBDMain.removeChannelDelegate(forIdentifier: SBID)
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
                self.refresh()
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
                
                self.refresh()
                
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
        self.refresh()
    }
    
    @objc func loadMoreMessages(_ sender: Any){
        
        query?.loadPreviousMessages(withLimit: PAGE_SIZE, reverse: false, completionHandler: { _msgs, _error in
             if let msgs = _msgs as? [SBDUserMessage] {
                let prevMsgs = msgs.map { msg -> Message in
                    return self.toMessage(msg)!
                }
                self.messages = prevMsgs + self.messages
                self.tableView.reloadData()
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                 
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
