//
//  PartnersVC.swift
//  iOSKinkedIn
//
//  Created by alice on 3/2/19.
//  Copyright © 2019 KinkedIn. All rights reserved.
//

import UIKit

class PartnersVC: UITableViewController {
    
    @IBOutlet var segment: UISegmentedControl!
    var newPartnersEmail: String?
    
    var partners = [Profile]()
    var requests = [PartnerRequest]()
    
    private var isPartnersLoaded : Bool = true
    private var isRequestsLoaded : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        segment.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        self.loadPartners()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (segment.selectedSegmentIndex == 0 ? partners.count : requests.count )
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        if let userCell = cell as? UserCell {
            print("cast cell")
            if segment.selectedSegmentIndex == 0 {
                let profile = partners[indexPath.row]
                userCell.set(profile.picture_public_id!, profile.name)
            } else {
                let req = requests[indexPath.row]
                userCell.set(req.from_image, req.from_name)
            }
        } else {
            print("fail to cast cell")
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let uuid = segment.selectedSegmentIndex == 1 ? self.requests[indexPath.row].from_uuid : self.partners[indexPath.row].uuid
        
        self.view.makeToastActivity(.center)
        KinkedInAPI.readProfile(uuid) { profile in
            let profileView = ViewProfileVC(profile)
            self.view.hideToastActivity()
            self.navigationController?.pushViewController(profileView, animated: false)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if segment.selectedSegmentIndex == 1{
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
            // self.vouchFor(req.from_uuid, name: req.from_name, index: index.row)
            
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
            self.tableView.reloadData()
            
        }
        remove.backgroundColor = UIColor.red
        return remove
    }
    
    /* Aux actions */
    /*
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
    */
    private func deleteRequest(_ atRow: Int){
        requests.remove(at: atRow)
        self.tableView.reloadData()
    }
    
    func loadPartners(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addPartner))

        if self.partners.isEmpty {
            let alert = emptyList(
                title: "No partners yet",
                msg: "If you have existing partners, why not send them a partner request and invite them to KinkedIn?",
                actionLabel: "Invite Partner",
                action: { a in self.addPartner()})
            self.present(alert, animated: false)
        }
    }
    
    func loadRequests(){
        self.navigationItem.rightBarButtonItem = nil
        
        if self.isRequestsLoaded {
            return
        }
        print("getting partner requests")
        KinkedInAPI.partnerRequests{ reqs in
            print(reqs)
            self.requests = reqs
            self.isRequestsLoaded = true
            self.tableView.reloadData()
            if reqs.isEmpty {
                let alert = emptyList(
                    title: "No pending partner requests",
                    msg: "",
                    actionLabel: "OK",
                    action: nil)
                self.present(alert, animated: false)
            }
        }
    }
    
    @objc func addPartner() {
        
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
            
            let invitePartnerAlert = UIAlertController(
                title: "E-mail not found",
                message: "Please make sure \(email) is the e-mail they used for KinkedIn. If your partner is not currently a KinkedIn member, would you like us to invite them to join on your behalf.",
                preferredStyle: .alert)
            let reenter = UIAlertAction(title: "Fix E-mail Address", style: .default){ (action) in
                self.addPartner()
            }
            
            let invite = UIAlertAction(title: "Invite Partner", style: .default){ action in
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
    
    @objc func segmentChanged(){
        switch segment.selectedSegmentIndex {
        case 1:
            loadRequests()
            break
        default:
            loadPartners()
            break
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
