//
//  ChangeProfileVC.swift
//  iOSKinkedIn
//
//  Created by alice on 4/26/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class ChangeProfileVC: UIViewController {
    
    var newPartnersEmail: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func enterPartner(sender: AnyObject) {
        
        var partnerEmail: UITextField?
        let addPartnerAlert = UIAlertController(title: "Add a partner",
            message: "What is your partner's email?", preferredStyle: .alert)
        
        addPartnerAlert.addTextField { (textField) in
            partnerEmail = textField
            partnerEmail?.text = self.newPartnersEmail
            partnerEmail?.keyboardType = UIKeyboardType.emailAddress
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let send = UIAlertAction(title: "Done", style: .default){ (action) in
            self.newPartnersEmail = partnerEmail?.text
            KinkedInAPI.addPartner(self.newPartnersEmail!, callback: self.findPartnerResult)
        }
        addPartnerAlert.addAction(cancel)
        addPartnerAlert.addAction(send)
        
        
        present(addPartnerAlert, animated: false, completion: nil)
        
    }
    
    func findPartnerResult(found: Bool) {
        if(!found){
            let email : String = newPartnersEmail ?? ""

            let invitePartnerAlert = UIAlertController(title: "E-mail not found",
                message: "Please make sure \(email) is the e-mail they used for KinkedIn. If your partner is not currently a KinkedIn member, would you like us to invite them to join on your behalf.", preferredStyle: .alert)
                let reenter = UIAlertAction(title: "Correct E-mail", style: .default){ (action) in
                    self.enterPartner(sender: action)
                }
            
            let invite = UIAlertAction(title: "Invite Partner", style: .default, handler: nil)
            
            invitePartnerAlert.addAction(reenter)
            invitePartnerAlert.addAction(invite)
            
            
            present(invitePartnerAlert, animated: false, completion: nil)
        }
        else {
        newPartnersEmail = nil
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
