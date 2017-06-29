//
//  LoginVC.swift
//  iOSKinkedIn
//
//  Created by alice on 2/16/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

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
            KinkedInAPI.login(email: email, password: password){ success in
                if success {
                    self.performSegue(withIdentifier: "login2app", sender: self.loginBtnSender!)
                } else {
                    self.wrongAlert()
                }
            }
            
        }
        
    }
    
    private func wrongAlert(){
        let alert = UIAlertController(title: "Incorrect Information", message: "Incorrect e-mail and password combo. Please double check both fields", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default){ action in
            self.loginBtnSender?.isEnabled = true
            self.loginBtnSender?.alpha = 1.0
        }
        alert.addAction(ok)
        self.present(alert, animated: false)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    

}
