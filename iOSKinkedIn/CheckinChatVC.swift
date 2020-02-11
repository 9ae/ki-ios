//
//  MessengerVC.swift
//  iOSKinkedIn
//
//  Created by Alice on 1/25/20.
//  Copyright © 2020 KinkedIn. All rights reserved.
//

import UIKit

class CheckinChatVC: UIViewController, UITextViewDelegate {
    
    private let LABEL_HEIGHT : CGFloat = 40
    private let VPADDING : CGFloat = 8
    private let MSG_BOX_HEIGHT : CGFloat = 120
    
    var _profile : Profile?
    var _convoLog: SimpleLogVC?
    
    var flow : CareQuestion
    
    var optBtns : [UIButton] = []
    
    var isConvoEnd = false
    

    @IBOutlet weak var entryView: UIStackView!
    @IBOutlet weak var noKeyboardConstraint : NSLayoutConstraint!
    
    @IBOutlet weak var textarea: UITextView!
    @IBOutlet weak var sendBtn : UIButton!
    
    @IBOutlet weak var optionsView: UIStackView!
    
    @IBOutlet weak var choicesStackHeigth : NSLayoutConstraint!
    @IBOutlet weak var msgInputStackHeight : NSLayoutConstraint!
    
    /* Setup Coat */

    required init?(coder: NSCoder) {
        self.flow = CareQuestion("There was an error launch after care support. Please contact our staff at help@kinkedin.app", type: .statement, followup: [])
        
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let profile = _profile {
            // TODO change depending on checkin type
            self.navigationItem.title = "Checkin about:" + profile.name
        }
        
         self.hidesBottomBarWhenPushed = true
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWasShown),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillBeHidden),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        
        optionsView.spacing = VPADDING
        optionsView.alignment = .fill
        
        clearQuestion()
        renderQ(flow)
    }

    func setData(profile: Profile, flow: CareQuestion){
        self._profile = profile
        self.flow = flow
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "acConvoEmbed" {
            self._convoLog = segue.destination as? SimpleLogVC
        }
    }
    
    /* Keyboard control */
    
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
        
        noKeyboardConstraint.constant = keyboardRect.size.height + VPADDING
        noKeyboardConstraint.isActive = true
        
    }
    
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
        print("keybaord about to hide")
        
        noKeyboardConstraint.constant =  VPADDING
        noKeyboardConstraint.isActive = true
        
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(textView == textarea){
            sendBtn.isEnabled = true
        }
    }
    
    /* User action handlers */
    
    @IBAction func onSend(_ sender: Any){
        if isConvoEnd {
            /*
            let app = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TabAppView")
            self.navigationController?.pushViewController(app, animated: false)
            */
            // TODO dependent on case type and how we got here
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            let msg = textarea.text
            if (msg?.count ?? 0) > 0 {
                next(msg)
            }
        }
    }
    
    @objc func optionTapped(_ sender: UIButton){
        next(sender.title(for: .normal))
    }
    
    /* Ctrl Flow */
    
    private func movePointer(_ q: CareQuestion) -> CareQuestion? {
        if let nq = q.followup.first {
            return nq
        } else {
            print("~*~ The END ~*~")
            isConvoEnd = true
            return nil
        }
    }
    
    private func renderQ (_ q: CareQuestion){
        _convoLog?.botSay(q.message)
        
        if q.type == .choice {
            prepChoices(q)
        } else if q.type == .question {
            prepQuestion()
        }
    }
    
    private func next(_ _reply: String?){
        print("~*~ next [\(flow.type)] \(flow.message)")
        if self.isConvoEnd {
            onEnd()
            return
        }
        
        var _q : CareQuestion? = nil
        if let reply = _reply {
            _convoLog?.iSay(reply)
            
            if flow.type == .choice {
                clearChoices()
                _q = processChoice(reply)
            } else if flow.type == .question {
                clearQuestion()
            }
        }
        if flow.type != .choice {
            _q = movePointer(self.flow)
        }
        
        if let q = _q {
            renderQ(q)
            
            self.flow = q
            
            if q.type == .statement {
                next(nil)
            }
        } else {
            onEnd()
        }
    }
    
    private func clearQuestion(){
        textarea.endEditing(true)
        textarea.isHidden = true
        sendBtn.isHidden = true
        entryView.isHidden = true
        msgInputStackHeight.constant = 0
        msgInputStackHeight.isActive = true
    }
    
    private func clearChoices(){
        for b in optBtns {
            optionsView.removeArrangedSubview(b)
        }
        
        optBtns.removeAll()
        
        optionsView.isHidden = true
        choicesStackHeigth.constant = 0
        choicesStackHeigth.isActive = true
    }
    
    private func prepChoices(_ q: CareQuestion){
        
        for o in q.followup {
            let lbl = UIButton()
            lbl.setTitleColor(UIColor.white, for: .normal)
            lbl.backgroundColor = ThemeColors.msgBtn
            lbl.titleEdgeInsets = UIEdgeInsets(top: 0.5 , left: 0.0, bottom: 0.5, right: 0.0)
            lbl.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 6.0, bottom: 0.0, right: 6.0)
            lbl.layer.cornerRadius = 10
            lbl.clipsToBounds = true
            lbl.translatesAutoresizingMaskIntoConstraints = false
            lbl.frame.size.height = CGFloat(LABEL_HEIGHT)
            lbl.addTarget(self, action: #selector(self.optionTapped), for: .touchUpInside)
            lbl.setTitle(o.message, for: .normal)
            lbl.sizeToFit()
            optionsView.addArrangedSubview(lbl)
            optBtns.append(lbl)
        }
        
        choicesStackHeigth.constant = CGFloat(q.followup.count) * (LABEL_HEIGHT + VPADDING)
        choicesStackHeigth.isActive = true
        
    }
    
    private func processChoice(_ answer: String) -> CareQuestion? {
        var followup : CareQuestion? = nil
        for o in flow.followup {
            if o.message == answer {
                followup = movePointer(o)
                break
            } else { continue; }
        }
        return followup
    }
    
    private func prepQuestion(){
        textarea.isHidden = false
        sendBtn.isHidden = false
        entryView.isHidden = false
        msgInputStackHeight.constant = MSG_BOX_HEIGHT
        msgInputStackHeight.isActive = true
        
    }
    
    private func onEnd(){
        _convoLog?.botSay("Thank you for sharing with us your thoughts and concerns")
        sendBtn.setTitle("Return to App", for: .normal)
        sendBtn.setTitleColor(ThemeColors.action, for: .normal)
        sendBtn.isEnabled = true
        sendBtn.isHidden = false
        textarea.isHidden = true
        entryView.isHidden = false
        noKeyboardConstraint.constant = 4 * VPADDING
        noKeyboardConstraint.isActive = true
        msgInputStackHeight.constant = 40
        msgInputStackHeight.isActive = true
    }
    

}

