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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fieldHours.addTarget(self, action:#selector(onHoursChanged(_:)), for: .editingDidEnd)
        self.fieldPhone.addTarget(self, action: #selector(onPhoneChanged(_:)), for: .editingDidEnd)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editEditing)))
        
        loadCheckinHours()
        loadPhoneNumber()
        loadScheduledDates()
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
    
    func loadCheckinHours(){
        var checkinTime = UserDefaults.standard.integer(forKey: UD_CHECKIN_TIME)
        if(checkinTime == 0){
            checkinTime = UD_CHECKIN_TIME_VALUE
        }
        fieldHours.text = String(describing: checkinTime)
    }
    
    func loadPhoneNumber(){
        DataTango.myPhoneNumber { phone in
            self.fieldPhone.text = phone
        }
    }
    
    func loadScheduledDates(){
        let dates = UserDefaults.standard.integer(forKey: UD_SCH_DATES)
        // TODO put as badge in scheduled dates row?
    }

    @objc
    func onHoursChanged(_ textField: UITextField) {
        let valCheckinHours = Int(textField.text ?? "0") ?? UD_CHECKIN_TIME_VALUE
        UserDefaults.standard.set(valCheckinHours, forKey: UD_CHECKIN_TIME)
    }
    
    @objc func onPhoneChanged (_ textField: UITextField){
        if let phone = textField.text {
            DataTango.updateMyPhoneNumber(phone)
        }
    }
    
    @objc func editEditing(){
        if fieldHours.isEditing {
        fieldHours.endEditing(true)
        fieldHours.resignFirstResponder()
        }
        
        if fieldPhone.isEditing {
            fieldPhone.endEditing(true)
            fieldPhone.resignFirstResponder()
        }
        view.endEditing(true)
    }
    
    func chatWithKia(){
        
        self.view.makeToastActivity(.center)
        DataTango.connections { profiles in
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
        
        self.performSegue(withIdentifier: "help2Cases", sender: self)
    }
    
    func userSelected(_ selected: Profile) {
        
        print("selected \(selected.name)")
        
        //TODO launch new after care chat
        
    }
    
    func reportBug() {
        if let url = URL(string: "https://bugs.trykinkedin.com") {
            print("open in safari")
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    func actionAt(_ indexPath: IndexPath){
        print("row tapped")
        if (indexPath.section == 0 && indexPath.row == 0) {
            print("report bug")
            reportBug()
        }
        if (indexPath.section == 0 && indexPath.row == 1) {
            print("issue with user")
            chatWithKia()
        }
        
        if (indexPath.section == 1 && indexPath.row == 3) {
            print("scheduled dates")
            self.performSegue(withIdentifier: "help2dates", sender: self)
        }
        
        if (indexPath.section == 1 && indexPath.row == 4) {
            print("load prev convos")
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
