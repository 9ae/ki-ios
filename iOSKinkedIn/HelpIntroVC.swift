//
//  HelpIntroVC.swift
//  iOSKinkedIn
//
//  Created by alice on 5/16/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class HelpIntroVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func chatWithKia(_ sender: Any) {
        let convo = CareConvoVC(layerClient: LayerHelper.client!)
        do{
            convo.conversation = try LayerHelper.startConvo(withUser: "aftercare", distinct: false)
            try convo.conversation.synchronizeAllMessages(.toFirstUnread)
            convo.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(convo, animated: false)
        } catch {
            print("failed to start aftercare convo")
        }
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        /*
        if(segue.identifier=="help2chat"){
            if let convoView = segue.destination as? CareConvoVC {
                do {
                    convoView.layerClient = LayerHelper.client!
                    convoView.conversation = try LayerHelper.startConvo(withUser: "aftercare")
                    print("set conversation \(convoView.conversation)")
                } catch {
                    print("failed to start aftercare convo")
                }
            }
        }
        */
    }
    
}
