//
//  ReadCaseVC.swift
//  iOSKinkedIn
//
//  Created by alice on 6/28/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit
import Atlas

class ReadCaseVC: KiConvoVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.messageInputToolbar.isHidden = true
        self.messageInputToolbar.resignFirstResponder()
        
        if let dateTitle = self.conversation.createdAt?.description {
            self.setTitleToAll(dateTitle)
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.addTopSpace()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
