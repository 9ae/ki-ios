//
//  SetupBasicVC.swift
//  iOSKinkedIn
//
//  Created by alice on 2/16/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class SetupBasicVC: SetupViewVC {
    
    @IBOutlet var fieldName: UITextField?
    @IBOutlet var fieldBirthday: UIDatePicker?
    
    //TODO limit date field to be YYYY-MM-DD and assert they are 18 years of age

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //fieldName?.addTarget(self, action: #selector(nameFieldChanged(_:)), for: .editingChanged)
        
    }
    
    func nameFieldChanged(_ textField: UITextField){
        let newValue = textField.text!
        print(newValue)
        me?.name = newValue
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let name = fieldName?.text!
        
        let realm = RealmDB.instance()
        try! realm.write {
            me?.name = name!
            me?.birthday = fieldBirthday?.date
        }
        //TODO: post updates to server
        
    }
    
}
