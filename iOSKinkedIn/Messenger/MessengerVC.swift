//
//  MessengerVC.swift
//  iOSKinkedIn
//
//  Created by Alice on 1/25/20.
//  Copyright © 2020 KinkedIn. All rights reserved.
//

import UIKit

class MessengerVC: UIViewController, UITextViewDelegate {
    
    var _profile : Profile?
    
    @IBOutlet weak var textarea: UITextView!
    @IBOutlet weak var sendBtn : UIButton!
    
    
    @IBOutlet weak var entryView: UIView!
    @IBOutlet weak var noKeyboardConstraint : NSLayoutConstraint!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let profile = _profile {
            self.navigationItem.title = profile.name
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWasShown),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillBeHidden),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWasShown(_ notification: NSNotification) {
        print("keyboard is shown")
        guard let info = notification.userInfo else {
            print("no user info")
            return
        }
        
        guard let keyboardRect = info[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect else {
            print("failed to cast as CGRect")
            return
        }
        
        noKeyboardConstraint.constant = keyboardRect.size.height
        noKeyboardConstraint.isActive = true
        
    }
    
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
        print("keybaord about to hide")
        
        noKeyboardConstraint.constant =  0
        noKeyboardConstraint.isActive = true
        
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(textView == textarea){
            sendBtn.isEnabled = true
        }
    }
    
    @IBAction func onSend(_ sender: Any){
        textarea.endEditing(true)
        print("sending ... \(String(describing: textarea.text))")
        textarea.text = ""
        sendBtn.isEnabled = false
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
