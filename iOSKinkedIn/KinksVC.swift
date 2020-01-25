//
//  SetupKinksWizardVC.swift
//  iOSKinkedIn
//
//  Created by alice on 3/12/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit
import TagListView

enum QuestionForm: Int {
    case omake = 0
    case get_service
    case give_service
    case wear
    case act
}

class KinksVC: SetupViewVC, TagListViewDelegate {

    let questions : [String] = [
        "I am turned on by",
        "I want to receive",
        "I can provide you with",
        "I like to wear",
        "I fantasize about"]
    
    var onQuestion: UIButton?
    var q : QuestionForm = .omake
    
    @IBOutlet var qstack: UIStackView!
    @IBOutlet weak var tlv: TagListView!
    
    @IBOutlet var btnOmake : UIButton!
    @IBOutlet var btnGet : UIButton!
    @IBOutlet var btnGive : UIButton!
    @IBOutlet var btnWear : UIButton!
    @IBOutlet var btnAct : UIButton!
    
    var profile: Profile?
    private var kinksMap = [String:Kink]()
    var omakeFetched = false
    var actsFetched = false
    var servicesFetched = false
    var isDone = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tlv.delegate = self
        tlv.textFont = UIFont.systemFont(ofSize: 20)
        
        setExistingKinks()
        if qstack.arrangedSubviews.count > 0 {
            if let firstQuestion = qstack.arrangedSubviews[0] as? UIButton {
                onOmake(firstQuestion)
            }
        }
        
    }
    
    private func setExistingKinks(){
        if let kinks = profile?.kinks {
        for k in kinks {
            kinksMap[k.label] = k
            //TODO append to question buttons
        }
        }
    }
    
    private func hangTag(_ kink: Kink){
        let tagView = tlv.addTag(kink.label)
        
        switch(q){
        case .get_service:
            tagView.isSelected = kink.likesGet || kink.likesBoth
        case .give_service:
            tagView.isSelected = kink.likesGive || kink.likesBoth
        case .wear:
            tagView.isSelected = kink.likesGive || kink.likesBoth
        case .act:
            tagView.isSelected = kink.likesBoth
        default:
            if(kink.form == .wearable){
                tagView.isSelected = kink.likesGet || kink.likesBoth
            } else {
                tagView.isSelected = kink.likesBoth
            }
        }
    }
    
    func kinksDidLoad(kinks: [Kink]){
        for k in kinks {
            if(!kinksMap.keys.contains(k.label)){
                kinksMap[k.label] = k
            }
            hangTag(kinksMap[k.label]!)
        }
    }
    
    private func loadActs(){
        tlv.removeAllTags()
        if(actsFetched){
            for (_ , value) in kinksMap {
                if(value.form == .act) {
                    hangTag(value)
                }
            }
        } else {
            KinkedInAPI.kinks(form: "act"){ kinks in
                self.kinksDidLoad(kinks: kinks)
                self.actsFetched = true
            }
        }
    }
    
    private func loadServices(){
        tlv.removeAllTags()
        if(servicesFetched){
            for (_ , value) in kinksMap {
                if(value.form == .service) {
                    hangTag(value)
                }
            }
        } else {
            KinkedInAPI.kinks(form: "service", callback: { kinks in
                self.kinksDidLoad(kinks: kinks)
                self.servicesFetched = true
            })
        }
    }
    
    private func loadOmake(){
        tlv.removeAllTags()
        if(omakeFetched){
            for (_ , value) in kinksMap {
                if(value.form != .act && value.form != .service) {
                    hangTag(value)
                }
            }
        } else {
            KinkedInAPI.kinks(form: "omake", callback: { kinks in
                self.kinksDidLoad(kinks: kinks)
                self.omakeFetched = true
            })
        }
    }
    
    private func loadWearables(){
        tlv.removeAllTags()
        for (_ , value) in kinksMap {
            if(value.form == .wearable) {
                hangTag(value)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addKinkWay(_ kink: Kink){
        switch(q){
        case .get_service:
            kink.likesGet = true
        case .give_service:
            kink.likesGive = true
        case .wear:
            kink.likesGive = true
        case .act:
            kink.likesBoth = true
        default:
            if(kink.form == .wearable){
                kink.likesGet = true
            } else {
                kink.likesBoth = true
            }
        }
    }
    
    func rmKinkWay(_ kink: Kink){
        switch(q){
        case .get_service:
            kink.likesGet = false
        case .give_service:
            kink.likesGive = false
        case .wear:
            kink.likesGive = false
        case .act:
            kink.likesBoth = false
        default:
            if(kink.form == .wearable){
                kink.likesGet = false
            } else {
                kink.likesBoth = false
            }
        }
    }

    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        if(tagView.isSelected){
            tagView.isSelected = false
            rmKinkWay(kinksMap[title]!)
        } else {
            tagView.isSelected = true
            addKinkWay(kinksMap[title]!)
            
        }
    }
    
    private func deselectAll(){
        for tv in tlv.tagViews {
            tv.isSelected = false
        }
    }
    
    func compileAnswers() -> [String: Any]{
        var json = [String: Any]()
        
        var kinksArray = [Kink]()
        for (_, kink) in kinksMap {
            
            if let way = kink.way() {
                json[kink.code] = ["way": way]
                kinksArray.append(kink)
            }
            
        }
        profile?.kinks = kinksArray
        
        return json
    }
    
    func updateQuestionReference(_ sender: Any){
        onQuestion?.setTitleColor(UIColor.gray, for: .normal)
        let tags: [String] = tlv.selectedTags().map({ tag -> String in
            return tag.currentTitle!
        })
        let newText = "\(questions[q.rawValue]) \(shortJoin(tags))"
        onQuestion?.setTitle(newText, for: .normal)
        
        
        if let button = sender as? UIButton {
            button.setTitleColor(ThemeColors.primary, for: .normal)
            onQuestion = button
        }
    }
    
    @IBAction func onOmake(_ sender: Any) {
        updateQuestionReference(sender)
        
        q = .omake
        loadOmake()
    }
    
    @IBAction func onGetService(_ sender: Any) {
        updateQuestionReference(sender)
        
        if(q == .give_service){
            deselectAll()
            q = .get_service
        } else {
            q = .get_service
            loadServices()
        }
        
        
    }
    
    @IBAction func onGiveService(_ sender: Any) {
        updateQuestionReference(sender)
        
        if(q == .get_service){
            deselectAll()
            q = .give_service
        } else {
            q = .give_service
            loadServices()
        }
        
        
    }
    
    @IBAction func onWear(_ sender: Any) {
        updateQuestionReference(sender)
        
        q = .wear
        loadWearables()
        
    }
    
    @IBAction func onActs(_ sender: Any) {
        updateQuestionReference(sender)
        
        q = .act
        loadActs()
    }
    
    @IBAction func onNext (_ sender : Any) {
        if isDone {
            navigationController?.popViewController(animated: false)
        }
        
        switch(q){
        case .omake:
            onGetService(btnGet)
            break;
        case .get_service:
            onGiveService(btnGive)
            break;
        case .give_service:
            onWear(btnWear)
            break;
        case .wear:
            onActs(btnAct)
            break;
        case .act:
            if let nextBtn = sender as? UIButton {
              nextBtn.setTitle("Done", for: .normal)
            }
            isDone = true
            break;
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
        KinkedInAPI.addKinks(compileAnswers())
    }

}
