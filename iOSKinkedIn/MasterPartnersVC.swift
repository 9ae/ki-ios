//
//  MasterPartnersVC.swift
//  iOSKinkedIn
//
//  Created by alice on 6/29/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class MasterPartnersVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let SEGUE2VOUCH = "partners2vouch"
    
    @IBOutlet var segment: UISegmentedControl!
    @IBOutlet var tableView: UITableView!
    
    var newPartnersEmail: String?
    var requests: [PartnerRequest] = [PartnerRequest]()
    var partners: [Profile] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        loadPartners()
        segment.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadPartners(){
        KinkedInAPI.partners { (result) in
            self.partners = result
            self.refreshTable()
        }
    }
    
    func loadRequests(){
        KinkedInAPI.partnerRequests { (partnerRequests) in
            self.requests = partnerRequests
            self.refreshTable()
        }
    }
    
    func refreshTable(){
        if isInRequestMode() {
            if requests.isEmpty {
                self.view.makeToast("No partner requests at the moment")
            } else {
                self.view.makeToast("Swipe to confirm/deny a partner request")
            }
        } else {
            if partners.isEmpty {
                self.view.makeToast("No partners yet")
            } else {
                self.view.makeToast("Swipe to remove a partner")
            }
        }
        
        self.tableView.reloadData()
    }
    
    /* table basics */
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isInRequestMode() ? self.requests.count : self.partners.count
    }
    
    /* Editing and cell interactivity */
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.getOrCreateCell("partnerBasicCell")
        
        if(isInRequestMode()){
            cell.textLabel?.text = self.requests[indexPath.row].from_name
        } else {
            cell.textLabel?.text = self.partners[indexPath.row].name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let uuid = isInRequestMode() ? self.requests[indexPath.row].from_uuid : self.partners[indexPath.row].uuid
        
        self.view.makeToastActivity(.center)
        KinkedInAPI.readProfile(uuid) { profile in
            let profileView = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "discoverProfileVC") as! DiscoverProfile
            profileView.setProfile(profile, isDiscoverMode: false)
            self.view.hideToastActivity()
            self.navigationController?.pushViewController(profileView, animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if isInRequestMode(){
            return [ makeRequestActionConfirm(), makeRequestActionDeny() ]
        } else {
            return [ makePartnerActionRemove() ]
        }
    }
    
    /* Actions on swipe */
    
    private func makeRequestActionConfirm() -> UITableViewRowAction {
        let confirm = UITableViewRowAction(style: .normal, title: "Confirm") { action, index in
            let req = self.requests[index.row]
            KinkedInAPI.replyPartnerRequest(req.id, confirm: true)
            self.vouchFor(req.from_uuid, name: req.from_name, index: index.row)
            
        }
        confirm.backgroundColor = UIColor.green
        return confirm
    }
    
    private func makeRequestActionDeny() -> UITableViewRowAction {
        let deny = UITableViewRowAction(style: .normal, title: "Deny") { action, index in
            KinkedInAPI.replyPartnerRequest(self.requests[index.row].id, confirm: false)
            self.deleteRequest(index.row)
        }
        deny.backgroundColor = UIColor.red
        return deny
    }
    
    private func makePartnerActionRemove() -> UITableViewRowAction {
        let remove = UITableViewRowAction(style: .destructive, title: "Remove") { action, index in
            let ind = index.row
            let uuid = self.partners[ind].uuid
            KinkedInAPI.removePartner(uuid)
            self.partners.remove(at: ind)
            self.refreshTable()
            
        }
        remove.backgroundColor = UIColor.red
        return remove
    }
    
    /* Aux actions */
    
    private func vouchFor(_ userid: String, name: String, index: Int){
        let alert = UIAlertController(title: "Vouch for partner", message: "Would you like to vouch for \(name)?", preferredStyle: .alert)
        let noVouch = UIAlertAction(title: "Not now", style: .default){ action in
            print("not vouching now")
        }
        let yesVouch = UIAlertAction(title: "Yes", style: .default){ action in
            let params = [
                "uuid": userid,
                "name": name
            ]
            self.performSegue(withIdentifier: self.SEGUE2VOUCH, sender: params)
        }
        alert.addAction(noVouch)
        alert.addAction(yesVouch)
        
        present(alert, animated: false) {
            self.deleteRequest(index)
        }
    }
    
    private func deleteRequest(_ atRow: Int){
        requests.remove(at: atRow)
        self.refreshTable()
    }

    
    /* adding partner */
    
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
            
            let invite = UIAlertAction(title: "Invite Partner", style: .default){ action in
                print("send partner an invite")
                KinkedInAPI.invitePartner(email)
            }
            
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
            loadRequests()
        } else {
            loadPartners()
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if(segue.identifier==SEGUE2VOUCH){
            if let vouch = segue.destination as? VouchIntroVC,
                let params = sender as? [String: String] {
                vouch.subjectName = params["name"]
                vouch.subjectUUID = params["uuid"]
            }
        }
    }
    

}
