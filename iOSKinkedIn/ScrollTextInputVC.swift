//
//  ScrollTextInputVC.swift
//  iOSKinkedIn
//
//  Created by alice on 5/22/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class ScrollTextInputVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    var focusedField: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
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

}
