//
//  MessengerVC.swift
//  iOSKinkedIn
//
//  Created by Alice on 1/25/20.
//  Copyright © 2020 KinkedIn. All rights reserved.
//

import UIKit

class CheckinChatVC: BaseTextInputDelegate {
    
    private let LABEL_HEIGHT : CGFloat = 40
    private let VPADDING : CGFloat = 8
    private let MSG_BOX_HEIGHT : CGFloat = 60

    
    var _profile : Profile?
    var _convoLog: SimpleLogVC?
    
    var _caseType: CaseType?
    
    var flow : CareQuestion
    
    var optBtns : [UIButton] = []
    
    var isConvoEnd = false
    var caseId = -1
    
    var keyboardHeight : CGFloat = 0
    
    @IBOutlet weak var entryView: UIStackView!
    
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

        self.navigationItem.title = self.title
        
         self.hidesBottomBarWhenPushed = true

        clearQuestion()
        renderQ(flow)
        
        // should really be MsgTextarea but something weird is going on
        textarea.layer.cornerRadius = MSG_BOX_HEIGHT * 0.5
        textarea.clipsToBounds = true
        textarea.backgroundColor = UIColor.white
        let padding = MSG_BOX_HEIGHT * 0.25
        textarea.textContainerInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        
    }

    func setData(profile: Profile, flow: CareQuestion, caseType: CaseType){
        self._profile = profile
        self.flow = flow
        
        self._caseType = caseType
        
        DataTango.createCase(aboutUser: profile.uuid, caseType: caseType) { caseId in
            self._convoLog?.setCaseId(caseId)
            self.caseId = caseId
        }
        
        self.title = "\(caseType == .checkin ? "Checkin" : "Concerns") about: \(profile.name)"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "acConvoEmbed" {
            self._convoLog = segue.destination as? SimpleLogVC
        }
    }
    
    @objc override func keyboardWillShow(_ notification: NSNotification) {

        guard let info = notification.userInfo else { return }
        
        // set height for the first time because other heights are funky
        if let keyboardRect = info[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect {
            if keyboardHeight == 0 {
                keyboardHeight = keyboardRect.size.height
            }
        }
        
        if keyboardHeight == 0 {
            let offset : CGFloat = 308
            print("offsetting by \(offset)")
            UIView.animate(withDuration: 0.5) {
                self.noKeyboardConstraint.constant = offset
                self.view.layoutIfNeeded()
            }
        } else {
            let offset = keyboardHeight + 8
            print("offsetting by \(offset)")
            UIView.animate(withDuration: 0.5) {
                self.noKeyboardConstraint.constant = offset
                self.view.layoutIfNeeded()
            }
        }
        
    }
    
    /* User action handlers */
    
    @IBAction func onSend(_ sender: Any){
        if isConvoEnd {
            if _caseType == .some(.checkin){
                // TODO probaby better for app stickiness to go back to main screen. and app store submission will reject
                
                UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                    exit(EXIT_SUCCESS)
                }
            } else {
                self.navigationController?.popToRootViewController(animated: true)
            }
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
        self.view.layoutIfNeeded()
    }
    
    private func clearChoices(){
        self.optionsView.isHidden = true
        
        for b in optBtns {
            optionsView.removeArrangedSubview(b)
        }
        
        optBtns.removeAll()
        
        self.choicesStackHeigth.constant = 0
        self.view.layoutIfNeeded()
    }
    
    private func prepChoices(_ q: CareQuestion){
        optionsView.isHidden = false

        self.choicesStackHeigth.constant = CGFloat(q.followup.count) * (self.LABEL_HEIGHT + self.VPADDING)
        self.view.layoutIfNeeded()
        
        for o in q.followup {
            let lbl = UIButton()
            lbl.setTitleColor(UIColor.white, for: .normal)
            lbl.backgroundColor = ThemeColors.msgOut
            lbl.titleEdgeInsets = UIEdgeInsets(top: 0.5 , left: 0.0, bottom: 0.5, right: 0.0)
            lbl.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 6.0, bottom: 0.0, right: 6.0)
            lbl.layer.cornerRadius = LABEL_HEIGHT / 2.0
            lbl.clipsToBounds = true
            lbl.translatesAutoresizingMaskIntoConstraints = false
            lbl.addTarget(self, action: #selector(self.optionTapped), for: .touchUpInside)
            lbl.setTitle(o.message, for: .normal)
            self.optionsView.addArrangedSubview(lbl)
            self.optBtns.append(lbl)
        }
        self.view.layoutSubviews()

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
        textarea.text = ""
        textarea.isHidden = false
        sendBtn.isHidden = false
        entryView.isHidden = false
        sendBtn.isEnabled = true
        msgInputStackHeight.constant = MSG_BOX_HEIGHT
     //   entryView.frame.size.height = MSG_BOX_HEIGHT
        self.view.layoutIfNeeded()
        
    }
    
    private func onEnd(){
        if flow.isTrigger && caseId != -1 {
            DataTango.alertCATeam(case_id: caseId)
        } else {
            _convoLog?.botSay("Thank you for sharing with us your thoughts and concerns")
        }
        
        if _caseType == .some(.checkin) {
            sendBtn.setTitle("Close checkin", for: .normal)
        } else {
            sendBtn.setTitle("Return to App", for: .normal)
        }
        sendBtn.setTitleColor(ThemeColors.action, for: .normal)
        sendBtn.isEnabled = true
        sendBtn.isHidden = false
        textarea.isHidden = true
        entryView.isHidden = false
        
     //   entryView.frame.size.height = 40
        noKeyboardConstraint.constant = 4 * VPADDING
       msgInputStackHeight.constant = 40
        
        self.view.layoutIfNeeded()
    }
    

}

