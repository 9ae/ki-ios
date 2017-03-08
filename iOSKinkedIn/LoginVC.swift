//
//  LoginVC.swift
//  iOSKinkedIn
//
//  Created by alice on 2/16/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit
import RealmSwift

class LoginVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var fieldEmail: UITextField?
    @IBOutlet var fieldPassword: UITextField?
    
    var loginBtnSender: AnyObject?
    var userNeoId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fieldEmail?.delegate = self
        fieldPassword?.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(_ sender: AnyObject){
        loginBtnSender = sender
        if let email = fieldEmail?.text,
            let password = fieldPassword?.text {
            KinkedInAPI.login(email: email, password: password, callback: checkProfileCreated)
            
        }
        
    }
    
    func checkProfileCreated(_ token: String) {
        KinkedInAPI.checkProfileSetup(){ step in
            if(step == 0){
                self.performSegue(withIdentifier: "login2setup", sender: self.loginBtnSender!)
            } else {
                self.performSegue(withIdentifier: "login2app", sender: self.loginBtnSender!)
            }
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    

}
