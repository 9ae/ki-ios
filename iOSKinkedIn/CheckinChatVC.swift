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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("=== AFTER CARE CONVO NOW ===")
        loadQuestion()
        
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
        let msg = textarea.text
        if (msg?.count ?? 0) > 0 {
            next(msg)
        }
    }
    
    func movePointer(_ q: CareQuestion){
        if let nextMsg = q.followup.first {
            self.flow = nextMsg
        } else {
            print("~*~ The END ~*~")
        }
    }
    
    func next(_ _reply: String?){
        if let reply = _reply {
            _convoLog?.iSay(reply)
            
            if flow.type == .choice {
                clearChoices()
                processChoice(reply)
            }
        }
        
        switch flow.type {
            case .choice:
                // do nothing handled already
            break;
            
            case .question:
                clearQuestion()
                movePointer(self.flow)
            break;
            
            default:
                movePointer(self.flow)
            break;
        }
        
        loadQuestion()
    }
    
    func loadQuestion(){
        if let log = _convoLog {
            log.botSay(flow.message)
        }
        
        switch flow.type {
            case .choice:
                prepChoices()
            break;
            
            case .question:
                prepQuestion()
            break;
            
            case .statement:
                prepStatement()
                break;
            
            default:
                prepWait()
            break;
        }
    }
    
    func clearQuestion(){
        textarea.endEditing(true)
        textarea.isHidden = true
        sendBtn.isHidden = true
        entryView.isHidden = true
        msgInputStackHeight.constant = 0
        msgInputStackHeight.isActive = true
    }
    
    func clearChoices(){
        for b in optBtns {
            optionsView.removeArrangedSubview(b)
        }
        
        optBtns.removeAll()
        
        optionsView.isHidden = true
        choicesStackHeigth.constant = 0
        choicesStackHeigth.isActive = true
    }
    
    func prepChoices(){
        
        for o in flow.followup {
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
        
        choicesStackHeigth.constant = CGFloat(flow.followup.count) * (LABEL_HEIGHT + VPADDING)
        choicesStackHeigth.isActive = true
        
    }
    
    func processChoice(_ answer: String){
        for o in flow.followup {
            if o.message == answer {
                movePointer(o)
                break;
            } else { continue; }
        }
    }
    
    @objc func optionTapped(_ sender: UIButton){
        next(sender.title(for: .normal))
    }
    
    func prepQuestion(){
        textarea.isHidden = false
        sendBtn.isHidden = false
        entryView.isHidden = false
        msgInputStackHeight.constant = MSG_BOX_HEIGHT
        msgInputStackHeight.isActive = true
        
    }
    
    func prepStatement(){
        if flow.followup.count > 0 {
            next(nil)
        }
    }
    
    func prepWait() {
        
    }
    

}

