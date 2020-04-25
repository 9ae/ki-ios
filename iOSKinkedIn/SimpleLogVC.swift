//
//  SimpleLogVC.swift
//  iOSKinkedIn
//
//  Created by Alice on 2/8/20.
//  Copyright © 2020 KinkedIn. All rights reserved.
//

import UIKit

class SimpleLogVC: BaseConvoLogVC {
    
    private var _caseId : Int?
    
    private var msgQ : [(Message, Date)] = []

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func setCaseId(_ caseId : Int){
        self._caseId = caseId
        
        for q in msgQ {
            let (msg, date) = q
            DataTango.writeToCaselog(case_id: caseId, msg: msg, date: date)
        }
    }
    
    private func addMessage(_ msg : Message){
        self.messages.append(msg)
        self.refresh()
        
        if let caseId = self._caseId {
            DataTango.writeToCaselog(case_id: caseId, msg: msg, date: nil)
        } else {
            msgQ.append((msg, Date()))
        }
    }

    func iSay(_ message: String){
        addMessage(Message(body: message, isMe: true))
    }
    
    func botSay(_ message: String){
       addMessage( Message(body: message, isMe: false))
    }

}
