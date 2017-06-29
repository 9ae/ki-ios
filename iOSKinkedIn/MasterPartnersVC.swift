//
//  MasterPartnersVC.swift
//  iOSKinkedIn
//
//  Created by alice on 6/29/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class MasterPartnersVC: UIViewController {
    
    @IBOutlet var segment: UISegmentedControl!
    @IBOutlet var tableView: UITableView!
    
    var newPartnersEmail: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        segment.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addPartner(_ sender: Any) {
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
            let reenter = UIAlertAction(title: "Fix E-mail Address", style: .default){ (action) in
                self.addPartner(sender: action)
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
    
    func isInRequestMode() -> Bool {
        return segment.selectedSegmentIndex == 1
    }
    
    func segmentChanged(){
        if(self.isInRequestMode()){
            print("show requests")
        } else {
            print("show my partners")
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
