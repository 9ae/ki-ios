//
//  ConnectionsVC.swift
//  iOSKinkedIn
//
//  Created by alice on 3/11/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

enum SegmentType {
    case reciprocals, partners , disconnects
}

struct ProfileList {
    var isFetched = false
    var data = [Profile]()
}
 
class ConnectionsVC: UITableViewController {
    
    var segmentMode : SegmentType = .reciprocals
    
    var profiles: [SegmentType: ProfileList] = [
        .reciprocals : ProfileList(),
        .partners : ProfileList(),
        .disconnects : ProfileList()
    ]
    
    var selectedProfile: Profile?
    
    @IBOutlet var segment: UISegmentedControl!
    
    let underline = UIView()
    var segmentItemWidth : CGFloat = 0.0
    var segmentX : CGFloat = 0.0
    
//    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
//        super.viewWillAppear(animated)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(false, animated: false)
//        super.viewWillDisappear(animated)
//    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadReciprocals()
        
        segment.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        segment.backgroundColor = .clear
        segment.tintColor = .clear
        
        segment.setTitleTextAttributes([ NSAttributedString.Key.foregroundColor: ThemeColors.primary!], for: .normal)
        segment.setTitleTextAttributes([ NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        
        underline.translatesAutoresizingMaskIntoConstraints = false
        underline.backgroundColor = ThemeColors.primaryFade
        underline.heightAnchor.constraint(equalToConstant: 3).isActive = true
        
        if let navView = navigationItem.titleView {
            navView.addSubview(underline)
            underline.leftAnchor.constraint(equalTo: navView.leftAnchor).isActive = true
            underline.bottomAnchor.constraint(equalTo: navView.bottomAnchor, constant: 8.0).isActive = true
            
            segmentItemWidth = navView.frame.width / CGFloat(segment.numberOfSegments)
            underline.widthAnchor.constraint(equalToConstant: segmentItemWidth ).isActive = true
            segmentX = 0.0
            underline.frame.origin.x = segmentX
        }
    }
    
    func loadReciprocals(){
        segmentMode = .reciprocals
        
//        editPartners.isEnabled = false
//        editPartners.isHidden = true
        
        let isFetched = (self.profiles[.reciprocals]?.isFetched) ?? false
        
        if isFetched {
            self.tableView.reloadData()
        } else {
            DataTango.connections { profiles in
                self.profiles[.reciprocals] = ProfileList(isFetched: true, data: profiles)
                if profiles.isEmpty {
                    let alert = emptyList(
                        title: "No connections yet",
                        msg: "Discover kinky people near you.",
                        actionLabel: "Discover!",
                        action: { a in
                            self.tabBarController?.selectedIndex = 1
                    })
                    self.present(alert, animated: false)
                } else {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func loadPartners(){
        segmentMode = .partners
        
//        editPartners.isEnabled = true
//        editPartners.isHidden = false

        let isFetched = (self.profiles[.partners]?.isFetched) ?? false
        
        if isFetched {
            self.tableView.reloadData()
        }
        else {
            DataTango.partners { profiles in
                self.profiles[.partners] = ProfileList(isFetched: true, data: profiles)
                if profiles.isEmpty {
                    let alert = emptyList(
                        title: "No partners yet",
                        msg: "If you have existing partners, why not send them a partner request and invite them to KinkedIn?",
                        actionLabel: "Invite Partner",
                        action: nil)
                    // TODO: interface invite partner modules
                    self.present(alert, animated: false)
                } else {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func loadDC(){
        segmentMode = .disconnects
        
//        editPartners.isEnabled = false
//        editPartners.isHidden = true
        
        let isFetched = (self.profiles[.disconnects]?.isFetched) ?? false
        
        if isFetched {
            self.tableView.reloadData()
        } else {
            DataTango.blockedProfiles { profiles in
                self.profiles[.disconnects] = ProfileList(isFetched: true, data: profiles)
                if profiles.isEmpty {
                    let alert = UIAlertController(title: "No disconnected users", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                    self.present(alert, animated: false)
                }
                else {
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    
    func unblock(_ user: Profile){
        DataTango.unblockUser(user.uuid)
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
        if let p = self.profiles[segmentMode] {
            return p.data.count
        } else {
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "connectionCell", for: indexPath)
        
        if let cc = cell as? ConnectionCell, let p = self.profiles[segmentMode] {
            let profile = p.data[indexPath.row]
            cc.setData(profile)
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let p = self.profiles[segmentMode] else {
            return
        }
        
        if (segmentMode == .partners || segmentMode == .reciprocals) {
            let convo = UIStoryboard(name: "Msg", bundle: Bundle.main).instantiateViewController(withIdentifier: "msgVC") as! MessengerVC
            convo.setData(p.data[indexPath.row])
            self.navigationController?.pushViewController(convo, animated: false)
        }
        underline.frame.origin.x = segmentX
    }
    
    @objc func segmentChanged(){
        segmentX = (segmentItemWidth * CGFloat(self.segment.selectedSegmentIndex))
        
        UIView.animate(withDuration: 0.2, animations: {
            self.underline.frame.origin.x = self.segmentX
        }, completion: {ok in
            self.underline.frame.origin.x = self.segmentX
        })
        
        switch segment.selectedSegmentIndex {
        case 1:
            self.segmentMode = .partners
            loadPartners()
            break
        case 2:
            self.segmentMode = .disconnects
            loadDC()
            break
        default:
            self.segmentMode = .reciprocals
            loadReciprocals()
            break
        }
        
        self.tableView.reloadData()
    }
    
    private func profileAt(_ index: Int) -> Profile? {
        if let p = self.profiles[segmentMode] {
            if p.isFetched {
                return p.data[index]
            }
        }
        return nil
    }
    
    private func removeAt(_ index: Int) {
        if let p = self.profiles[segmentMode] {

            if p.isFetched {
               var data = p.data
                data.remove(at: index)
               self.profiles[segmentMode]?.data = data
            }
        }
        tableView.reloadData()
    }
    
    private func viewProfile(_ profile: Profile){
        self.view.makeToastActivity(.center)
        
        DataTango.readProfile(profile.uuid) { profile in
            let profileView = ViewProfileVC(profile)
            self.view.hideToastActivity()
            self.navigationController?.pushViewController(profileView, animated: false)
        }
    }
    
    private func disconnect(_ profile: Profile){
        DataTango.blockUser(profile.uuid)
    }
    
    private func reconnect(_ profile: Profile){
        DataTango.unblockUser(profile.uuid)
    }
    
    private func unpartner(_ profile: Profile){
        DataTango.unPartner(profile.uuid)
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        print("willDisplayHeaderView")
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        print("canEditRowAt")
        underline.frame.origin.x = segmentX
        return true
    }
    
    override func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        print("willBeginEditingRowAt")
        super.tableView(tableView, willBeginEditingRowAt: indexPath)
        underline.frame.origin.x = segmentX
    }
    
    override func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        print("didEndEditingRowAt")
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        print("editActionsForRowAt")
        var actions : [UITableViewRowAction] = []
        let viewProfile = UITableViewRowAction(style: .normal, title: "View Profile"){ (action, indexPath) in
            if let profile = self.profileAt(indexPath.row) { self.viewProfile(profile) }
        }
        actions.append(viewProfile)
        
        switch segmentMode {
        case .partners:
            actions.append(UITableViewRowAction(style: .destructive, title: "Unpartner"){ (action, indexPath) in
                if let profile = self.profileAt(indexPath.row) {
                    self.unpartner(profile)
                    self.removeAt(indexPath.row)
                }
            })
            break;
        case .disconnects:
            let recon = UITableViewRowAction(style: .normal, title: "Reconnect"){ (action, indexPath) in
                if let profile = self.profileAt(indexPath.row) {
                    self.reconnect(profile)
                    self.removeAt(indexPath.row)
                }
            }
            recon.backgroundColor = UIColor.green
            actions.append(recon)
            break;
        default:
            actions.append(UITableViewRowAction(style: .destructive, title: "Disconnect"){ (action, indexPath) in
                 if let profile = self.profileAt(indexPath.row) {
                    self.disconnect(profile)
                    self.removeAt(indexPath.row)
                }
            })
            break;
        }
        return actions
    }

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "connects2partners",
            let vc = segue.destination as? PartnersVC {
            vc.partners = (self.profiles[.partners]?.data)!
        }
    }
    

}
