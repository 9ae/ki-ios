//
//  RegisterVC.swift
//  iOSKinkedIn
//
//  Created by alice on 3/2/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit
import Toast_Swift

class RegisterVC: ScrollTextInputVC {
    
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var inviteCode: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signup: UIButton!
    
    @IBOutlet weak var goToLogin: UIButton!
    @IBOutlet weak var requestInvite: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "splash2"))
        
        email?.delegate = self
        password?.delegate = self
        inviteCode?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func register(_ sender: AnyObject) {
        signup.isEnabled = false
        UIView.animate(withDuration: 0.5) { 
            self.signup.alpha = 0.1
        }
        
        KinkedInAPI.register(
            email: email.text!,
            password: password.text!,
            inviteCode: inviteCode.text!) { success in
                self.view.hideToastActivity()
                if(success){
                    self.performSegue(withIdentifier: "register2app", sender: self)
                } else {
                    self.wrongAlert()
                }
        }
        self.view.makeToastActivity(.center)
    }
    
    private func wrongAlert(){
        let alert = UIAlertController(
            title: "Incorrect Information",
            message: "Error in creating your account. Please check your email and invite code combo, or contact Alice",
            preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default){ action in
            self.signup?.isEnabled = true
            self.signup?.alpha = 1.0
        }
        alert.addAction(ok)
        self.present(alert, animated: false)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    

}
