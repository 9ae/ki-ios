//
//  RegisterVC.swift
//  iOSKinkedIn
//
//  Created by alice on 3/2/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit
import Toast_Swift

class RegisterVC: UIViewController, UITextFieldDelegate {
    
    
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
        KinkedInAPI.register(
            email: email.text!,
            password: password.text!,
            inviteCode: inviteCode.text!) { success in
                self.view.hideToastActivity()
                if(success){
                    self.performSegue(withIdentifier: "register2setup", sender: self)
                } else {
                    self.view.makeToast("Error in creating your account. Please check your email and invite code combo, or contact Alice")
                }
        }
        self.view.makeToastActivity(.center)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    

}
