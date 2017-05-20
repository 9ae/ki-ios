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
    
    @IBOutlet var fieldEmail: UITextField!
    @IBOutlet var fieldPassword: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var focusedField: UIView?
    
    var loginBtnSender: AnyObject?
    var userNeoId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "splash3"))
        
        fieldEmail?.delegate = self
        fieldPassword?.delegate = self
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(keyboardWasShown),
            name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self,
            selector: #selector(keyboardWillBeHidden),
            name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(_ sender: AnyObject){
        loginBtnSender = sender
        if let email = fieldEmail.text,
            let password = fieldPassword.text {
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("text field focused")
        focusedField = textField
    }
    
    func keyboardWasShown(_ notification: NSNotification) {
        print("keyboard is shown")
        guard let info = notification.userInfo else {
            print("no user info")
            return
        }
        guard let keyboardRect = info[UIKeyboardFrameBeginUserInfoKey] as? CGRect else {
            print("failed to cast as CGRect")
            return
        }
        
        let keyboardSize = keyboardRect.size
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
        scrollView.contentInset = contentInsets;
        scrollView.scrollIndicatorInsets = contentInsets;
        
        var aRect = self.view.frame;
        aRect.size.height -= keyboardSize.height;
        let fieldFrame = focusedField?.frame ?? CGRect.init(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
        
        if (!aRect.contains(fieldFrame) ) {
            print("detect textfield inside keyboard frame")
            scrollView.scrollRectToVisible(fieldFrame, animated: true)            
        } else {
            print("text field not in frame")
        }
    }
    
    func keyboardWillBeHidden(_ notification: NSNotification) {
        print("keybaord about to hide")
        guard let scrollView = self.view as? UIScrollView else {
            return
        }
        
        scrollView.contentInset = UIEdgeInsets.zero;
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero;
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    

}
