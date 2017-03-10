//
//  RegisterVC.swift
//  iOSKinkedIn
//
//  Created by alice on 3/2/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit


class RegisterVC: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var inviteCode: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signup: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var goToLogin: UIButton!
    @IBOutlet weak var requestInvite: UIButton!
    
    
    private var userToken: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "splash2"))

        progressBar?.isHidden = true
        
        email?.delegate = self
        password?.delegate = self
        inviteCode?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func register(_ sender: AnyObject) {
        progressBar?.isHidden = false
        _updateProgressBar(0.25)
        
        KinkedInAPI.register(
            email: email.text!,
            password: password.text!,
            inviteCode: inviteCode.text!) { success in
                self._updateProgressBar(0.5)
                self._login()
        }
    }
    
    private func _updateProgressBar(_ percent: Float){
        UIView.animate(withDuration: 1) {
            self.progressBar?.progress = percent
        }
    }
    
    private func _login(){
        _updateProgressBar(0.75)
        KinkedInAPI.login(
            email: email.text!,
            password: password.text!) { token in
                self.userToken = token
                self._updateProgressBar(1.0)
                self.performSegue(withIdentifier: "register2setup", sender: self)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    

}
