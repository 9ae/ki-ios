//
//  ReadConvoVC.swift
//  iOSKinkedIn
//
//  Created by Alice on 10/26/19.
//  Copyright © 2019 KinkedIn. All rights reserved.
//

import UIKit
import LayerXDK.LayerXDKUI

class ReadConvoVC: UIViewController {
    
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
        cv.backgroundColor = UIColor.white
        self.view = cv
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
