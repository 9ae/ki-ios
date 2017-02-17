//
//  SetupBasicVC.swift
//  iOSKinkedIn
//
//  Created by alice on 2/16/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class SetupBasicVC: UIViewController {
    
    var me: Profile?
    @IBOutlet var fieldName: UITextField?
    @IBOutlet var fieldBirthday: UIDatePicker?

    override func viewDidLoad() {
        super.viewDidLoad()

        if(me==nil){
            me = Profile()
        }
        
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
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        print("sege to next")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let name = fieldName?.text!
        me?.name = name!
        me?.birthday = fieldBirthday?.date
        RealmDB.save(me!)
    }
    
}
