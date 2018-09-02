//
//  AftercareVC.swift
//  iOSKinkedIn
//
//  Created by alice on 9/2/18.
//  Copyright © 2018 KinkedIn. All rights reserved.
//

import UIKit
import LayerXDK.LayerXDKUI

class AftercareVC: UIViewController {
    
    var config: LYRUIConfiguration?
    var convo: LYRConversation?
    
    override func loadView() {
        super.loadView()
        
        guard let _config = self.config else {
            print("ERR: config nil")
            return
        }
        
        guard let _convo = self.convo else {
            print("ERR: convo nil")
            return
        }
        
        let cv = LYRUIConversationView(configuration: _config)
        cv.conversation = _convo
        
        self.view = cv
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendText("Case created on \(Date().description)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendText(_ text: String){
        let part = LYRMessagePart(text: text)
            do {
            if let msg = try LayerHelper.client?.newMessage(with: [part], options: nil) {
                try self.convo?.send(msg)
            }
            } catch {
                print("ERR: sending message")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
