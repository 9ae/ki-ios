//
//  AftercareMain.swift
//  iOSKinkedIn
//
//  Created by Alice on 7/27/19.
//  Copyright © 2019 KinkedIn. All rights reserved.
//

import UIKit

class HelpVC: UITableViewController {
    
    @IBOutlet var fieldHours: UITextField!
    @IBOutlet var fieldPhone: UITextField!
    @IBOutlet var countDatesScheduled: UILabel!
    @IBOutlet var countRepliedCheckins: UILabel!
    @IBOutlet var countRaisedIssues: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fieldHours.addTarget(self, action:#selector(textFieldDidChange(_:)), for: .editingDidEnd)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editEditing)))
        
        var checkinTime = UserDefaults.standard.integer(forKey: UD_CHECKIN_TIME)
        if(checkinTime == 0){
            checkinTime = UD_CHECKIN_TIME_VALUE
        }
        fieldHours.text = String(describing: checkinTime)
        
        //TODO update phone number
        //TODO update stats
    }

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 2
        } else {
            return 5
        }
    }
    
    @objc
    func textFieldDidChange(_ textField: UITextField) {
        print("change checkin time to: " + (textField.text ?? "_"))
        let valCheckinHours = Int(textField.text ?? "0") ?? UD_CHECKIN_TIME_VALUE
        UserDefaults.standard.set(valCheckinHours, forKey: UD_CHECKIN_TIME)
    }
    
    @objc func editEditing(){
        fieldHours.endEditing(true)
        fieldHours.resignFirstResponder()
        view.endEditing(true)
    }
    
    func chatWithKia() {
        
        self.view.makeToastActivity(.center)
        KinkedInAPI.connections { profiles in
            self.view.hideToastActivity()
            let selectUserVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AbstractUserListVC") as! AbstractUserListVC
            selectUserVC.profiles.append(contentsOf: profiles)
            selectUserVC.setMultiSelect(false)
            selectUserVC.doneCallbackSingle = self.userSelected
            selectUserVC.navigationItem.title = "Issue with which user?"
            
            self.navigationController?.pushViewController(selectUserVC, animated: false)
        }
        
    }
    
    func previousConvos() {
        print("load previous chat convos")
        /*
         let listVC = CaseList(layerClient: LayerHelper.client!)
         self.navigationController?.pushViewController(listVC, animated: false)
         */
    }
    
    func userSelected(_ selected: Profile) {
        
        print("selected \(selected.name)")
        let convo = LayerHelper.makeAftercareConvoVC(selected.uuid)
        self.navigationController?.pushViewController(convo, animated: false)
        
    }
    
    func actionAt(_ indexPath: IndexPath){
        if (indexPath.section == 0 && indexPath.row == 1) {
            chatWithKia()
        }
        
        if (indexPath.section == 1 && indexPath.row == 4) {
            previousConvos()
        }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        actionAt(indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        actionAt(indexPath)
    }


}
