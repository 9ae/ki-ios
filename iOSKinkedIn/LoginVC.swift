//
//  LoginVC.swift
//  iOSKinkedIn
//
//  Created by alice on 2/16/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit
import RealmSwift

class LoginVC: ScrollTextInputVC {
    
    @IBOutlet var fieldEmail: UITextField!
    @IBOutlet var fieldPassword: UITextField!
    
    var loginBtnSender: UIButton?
    var userNeoId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "splash3"))
        
        fieldEmail.delegate = self
        fieldPassword.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(_ sender: AnyObject){
        loginBtnSender = sender as? UIButton
        loginBtnSender?.isEnabled = false
        UIView.animate(withDuration: 0.5){
            self.loginBtnSender?.alpha = 0.1
        }
        if let email = fieldEmail.text,
            let password = fieldPassword.text {
            KinkedInAPI.login(email: email, password: password, callback: checkProfileCreated)
            
        }
        
    }
    
    func checkProfileCreated(_ token: String) {
        self.performSegue(withIdentifier: "login2app", sender: self.loginBtnSender!)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    

}
