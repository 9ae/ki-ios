//
//  HelpIntroVC.swift
//  iOSKinkedIn
//
//  Created by alice on 5/16/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class HelpIntroVC: UIViewController {
    
    @IBOutlet var checkinHours: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        super.viewWillDisappear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.checkinHours.addTarget(self, action:#selector(textFieldDidChange(_:)), for: .editingDidEnd)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editEditing)))
        
        var checkinTime = UserDefaults.standard.integer(forKey: UD_CHECKIN_TIME)
        if(checkinTime == 0){
            checkinTime = UD_CHECKIN_TIME_VALUE
        }
        checkinHours.text = String(describing: checkinTime)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc
    func textFieldDidChange(_ textField: UITextField) {
        print("change checkin time to: " + (textField.text ?? "_"))
        let valCheckinHours = Int(textField.text ?? "0") ?? UD_CHECKIN_TIME_VALUE
        UserDefaults.standard.set(valCheckinHours, forKey: UD_CHECKIN_TIME)
    }
    
    @objc func editEditing(){
        checkinHours.endEditing(true)
        checkinHours.resignFirstResponder()
        view.endEditing(true)
    }
    
    @IBAction func reportBug(_ sender: Any) {
        if let url = URL(string: "http://bugs.trykinkedin.com") {
        UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
            print("open bug page in safari \(success)")
        })
        }
    }
    
    @IBAction func chatWithKia(_ sender: Any) {
        
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
    
    @IBAction func previousConvos(_ sender: Any) {
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
    
    @IBAction func checkinInfo(_ sender: UIButton) {
        let alert = UIAlertController(
            title: "About Aftercare Checkin",
            message: "Our Care Team wants to make sure you feel great & supported. How soon after your date should we should check in on you?",
            preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(ok)
        self.present(alert, animated: false)
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
