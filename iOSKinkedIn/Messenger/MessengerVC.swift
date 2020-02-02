//
//  MessengerVC.swift
//  iOSKinkedIn
//
//  Created by Alice on 1/25/20.
//  Copyright © 2020 KinkedIn. All rights reserved.
//

import UIKit

class MessengerVC: UIViewController {
    
    var _profile : Profile?
    
    @IBOutlet weak var textarea: UITextView!
    @IBOutlet weak var sendBtn : UIButton!
    
    
    @IBOutlet weak var entryView: UIView!
    @IBOutlet weak var noKeyboardConstraint : NSLayoutConstraint!
    
    var _withKeyboardConstraint: NSLayoutConstraint?

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
        
        noKeyboardConstraint.isActive = false
        
        if let withKeyboardConstraint = _withKeyboardConstraint {
            withKeyboardConstraint.isActive = true
        } else {
        let withKeyboardConstraint = NSLayoutConstraint(item: self.view, attribute: .bottom, relatedBy: .equal, toItem: entryView, attribute: .bottom, multiplier: 1, constant: keyboardRect.size.height)
            withKeyboardConstraint.isActive = true
            view.addConstraint(withKeyboardConstraint)
        
            _withKeyboardConstraint = withKeyboardConstraint
        }
    
        
        
    }
    
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
        print("keybaord about to hide")
        
        if let withKeyboardConstraint = _withKeyboardConstraint {
            withKeyboardConstraint.isActive = false
            noKeyboardConstraint.isActive = true
        }
        
    }
    
    @IBAction func onSend(_ sender: Any){
        textarea.endEditing(true)
        print("sending ... \(String(describing: textarea.text))")
        textarea.text = ""
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
