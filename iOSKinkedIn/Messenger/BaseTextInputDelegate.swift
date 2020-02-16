//
//  BaseTextInputDelegate.swift
//  iOSKinkedIn
//
//  Created by Alice on 2/16/20.
//  Copyright © 2020 KinkedIn. All rights reserved.
//

import UIKit

class BaseTextInputDelegate: UIViewController, UITextViewDelegate {

    @IBOutlet weak var noKeyboardConstraint : NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillBeHidden),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        print("keyboard is shown")
        guard let info = notification.userInfo else {
            print("no user info")
            return
        }
        
        guard let keyboardRect = info[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect else {
            print("failed to cast as CGRect")
            return
        }
        
        
        UIView.animate(withDuration: 0.5) {
            self.noKeyboardConstraint.constant = keyboardRect.size.height + 8
            self.view.layoutIfNeeded()
        }
        
    }
    
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
        print("keybaord about to hide")
        
        UIView.animate(withDuration: 0.5) {
            self.noKeyboardConstraint.constant = 8
            self.view.layoutIfNeeded()
        }

    }
}
