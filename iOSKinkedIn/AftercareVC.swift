//
//  AftercareVC.swift
//  iOSKinkedIn
//
//  Created by alice on 9/2/18.
//  Copyright © 2018 KinkedIn. All rights reserved.
//

import UIKit
import LayerXDK.LayerXDKUI

enum ReplyType {
    case none, text, choice
}

class AftercareVC: UIViewController {
    
    var config: LYRUIConfiguration?
    var convo: LYRConversation?
    
    private var stack = UIStackView()
    private var stackHeightConstraint: NSLayoutConstraint?
    private var scrollOffsetConstraint: NSLayoutConstraint?
    
    private let LABEL_HEIGHT = 40
    private let LABEL_PADDING = 8
    
    private var replyState: ReplyType = .text
    private var currentQuestion: [String: Any]? = nil
    private var tempQ: String? = nil
    private var isKeyboardHidden = false
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func loadView() {
        super.loadView()
        
        guard let _config = self.config else {
            print("ERR: config nil")
            return
        }
        
        guard let _convo = self.convo else {
            print("ERR: convo nil")
            return
        }
        
        let cv = LYRUIConversationView(configuration: _config)
        cv.conversation = _convo
        cv.backgroundColor = UIColor.white
        self.view = cv
        _makeOptionsView()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendText("Case created on \(Date().description)")
        self._enableKeyboard(false)
        
        if let _client = self.config?.client {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceiveLayerObjectsDidChangeNotification),
                                               name: NSNotification.Name.LYRClientObjectsDidChange,
                                               object: _client)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendText(_ text: String){
        let part = LYRMessagePart(text: text)
            do {
            if let msg = try LayerHelper.client?.newMessage(with: [part], options: nil) {
                try self.convo?.send(msg)
            }
            } catch {
                print("ERR: sending message")
        }
        _enableKeyboard(false)
    }
    
    func _enableKeyboard(_ isKeyboard: Bool) {
        guard let composeBar = (self.view as! LYRUIConversationView).composeBar else {
            print("ERR cant find compose bar")
            return
        }
        if isKeyboard {
            composeBar.isHidden = false
            composeBar.becomeFirstResponder()
            print("LOG show keyboard")
        } else {
            composeBar.isHidden = true
            composeBar.resignFirstResponder()
            print("LOG hide keyboard")
        }
        self.isKeyboardHidden = !isKeyboard
    }
    
    private func _makeOptionsView() {
        stack.axis = .vertical
        stack.alignment = .trailing
        stack.distribution = .fillEqually
        stack.spacing = 8.0
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(stack)
        
        let ypos = NSLayoutConstraint(item: stack, attribute: .bottom, relatedBy: .equal,
                                      toItem: self.view, attribute: .bottom, multiplier: 1, constant: -8)
        let height = NSLayoutConstraint(item: stack, attribute: .height, relatedBy: .equal,
                                        toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        let xa = NSLayoutConstraint(item: stack, attribute: .leading, relatedBy: .equal,
                                    toItem: self.view, attribute: .leading, multiplier: 1, constant: 0)
        let xe = NSLayoutConstraint(item: stack, attribute: .trailing, relatedBy: .equal,
                                    toItem: self.view, attribute: .trailing, multiplier: 1, constant: -8)
        view.addConstraints([ypos, height, xa, xe])
        stackHeightConstraint = height
    }
    
    private func _closeOptionsView(){
        // Remove exsiting elements not tested yet
        for sv in stack.arrangedSubviews {
            sv.removeFromSuperview()
        }
        stack.isHidden = true
        
        if let _oldOffset = self.scrollOffsetConstraint {
            view.removeConstraint(_oldOffset)
        }
        self.scrollOffsetConstraint = nil
        print("LOG close options view")
    }
    
    private func _setOptions(_ opts: [String]){
        
        for o in opts {
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
            lbl.setTitle(o, for: .normal)
            lbl.sizeToFit()
            stack.addArrangedSubview(lbl)
        }
        let stackHeight = CGFloat( (LABEL_HEIGHT*opts.count) + (3*LABEL_PADDING*(opts.count-1)) )
        let height = NSLayoutConstraint(item: stack, attribute: .height, relatedBy: .equal,
                                        toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: stackHeight)

        if let _oldHeight = self.stackHeightConstraint {
            view.removeConstraint(_oldHeight)
        }
        view.addConstraint(height)
        stackHeightConstraint = height
        
        if let messagesView = (self.view as? LYRUIConversationView)?.messageListView {
            let offset = NSLayoutConstraint(
                item: messagesView,
                attribute: .bottom,
                relatedBy: .equal,
                toItem: self.bottomLayoutGuide,
                attribute: .top,
                multiplier: 1,
                constant: -stackHeight)
            view.addConstraint(offset)
            scrollOffsetConstraint = offset
        }
        
        stack.isHidden = false
    }
    
    @objc func didReceiveLayerObjectsDidChangeNotification(_ notification: NSNotification){
        guard let info = notification.userInfo else {
            return
        }
        
        guard let changes = info[LYRClientObjectChangesUserInfoKey] as? NSArray else {
            return
        }
        for ch in changes{
            if let change = ch as? LYRObjectChange {
                if let message = isMessageRecieved(change) {
                    interceptMessage(message)
                }
            }
        }
    }
    
    public func _updateReplyState(state: ReplyType){
        self.replyState = state
        
        if (state == .text) {
            _enableKeyboard(true)
        } else {
            _enableKeyboard(false)
        }
    }
    
    @objc func optionTapped(_ sender: UIButton){
        
        guard let text = sender.title(for: .normal) else {
            print("ERR cant find text")
            return
        }
        sendText(text)
        _closeOptionsView()
    }
    
    private func isMessageRecieved(_ change: LYRObjectChange) -> LYRMessage? {
        if(change.type == .create){
            if let message = change.object as? LYRMessage {
                if(message.sender.userID=="aftercare"){
                    return message
                }
            }
        }
        return nil
    }
    
    private func interceptMessage(_ message: LYRMessage){
        guard let msgpart = message.parts.first else {
            print("ERR message does not have root part")
            return
        }
        
        if (msgpart.mimeType == "application/json") {
            if let headerData = msgpart.data {
                do {
                    currentQuestion = try JSONSerialization.jsonObject(with: headerData, options: .mutableContainers) as? [String: Any]
                    if let responseType = currentQuestion?["response_type"] as? String {
                        if (responseType == "choice"){
                            if let options = currentQuestion?["options"] as? [String] {
                                print("LOG reply options")
                                _setOptions(options)
                                _updateReplyState(state: .choice)
                            }
                        }
                        else if (responseType == "none"){
                            print("LOG reply none")
                            _updateReplyState(state: .none)
                        }
                        else {
                            print("LOG reply text")
                            _updateReplyState(state: .text)
                        }
                    }
                    let isEnd = (currentQuestion?["is_end"] as? Bool) ?? false
                    if isEnd {
                        convoEndedAlert()
                    }
                } catch {
                    print(error)
                }
            }
            
        }
        
    }
    
    private func convoEndedAlert(){
        let alert = UIAlertController(title: "Aftercare Complete", message: "Thank you for sharing with us your thoughts and concerns", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Return to App", style: .default){ action in
            let app = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TabAppView")
            self.navigationController?.pushViewController(app, animated: false)
        }
        alert.addAction(ok)
        self.present(alert, animated: false)
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
