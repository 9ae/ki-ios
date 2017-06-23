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
    
    
    var kinksMap = [String:Kink]()
    var omakeFetched = false
    var actsFetched = false
    var servicesFetched = false
    
    required init?(coder aDecoder: NSCoder) {
        // self.kinksGridVC = KinksGridVC()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tlv.delegate = self
        tlv.textFont = UIFont.systemFont(ofSize: 20)
        
        if qstack.arrangedSubviews.count > 0 {
            if let firstQuestion = qstack.arrangedSubviews[0] as? UIButton {
                onOmake(firstQuestion)
            }
        }
        
    }
    
    func kinksDidLoad(kinks: [Kink]){
        tlv.removeAllTags()
        for k in kinks {
            if(!kinksMap.keys.contains(k.label)){
                kinksMap[k.label] = k
            }
            tlv.addTag(k.label)
        }
    }
    
    private func loadActs(){
        if(actsFetched){
            tlv.removeAllTags()
            for (_ , value) in kinksMap {
                if(value.form == .act) {
                    tlv.addTag(value.label)
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
        if(servicesFetched){
            tlv.removeAllTags()
            for (_ , value) in kinksMap {
                if(value.form == .service) {
                    tlv.addTag(value.label)
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
        if(omakeFetched){
            tlv.removeAllTags()
            for (_ , value) in kinksMap {
                if(value.form != .act && value.form != .service) {
                    tlv.addTag(value.label)
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
                tlv.addTag(value.label)
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
            if(kink.form == .wearable){
                kink.likesGet = true
            } else {
                kink.likesBoth = true
            }
        case .give_service:
            kink.likesGet = true
        case .wear:
            kink.likesGive = true
        case .act:
            kink.likesGive = true
        default:
            kink.likesBoth = true
        }
    }
    
    func rmKinkWay(_ kink: Kink){
        switch(q){
        case .get_service:
            if(kink.form == .wearable){
                kink.likesGet = false
            } else {
                kink.likesBoth = false
            }
        case .give_service:
            kink.likesGet = false
        case .wear:
            kink.likesGive = false
        case .act:
            kink.likesGive = false
        default:
            kink.likesBoth = false
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
        
        for (_, kink) in kinksMap {
            if(!kink.likesBoth && !kink.likesGive && !kink.likesGet){
                continue
            }
            var way: String
            if(kink.likesGet && kink.likesGive){
                way = "BOTH"
            } else if (kink.likesGive){
                way = "GIVE"
            } else if (kink.likesGet){
                way = "GET"
            } else {
                way = "BOTH"
            }
            json[kink.code] = ["way": way]
            
        }
        
        return json
    }
    /*
    @IBAction func nextQuestion(_ sender: Any){
        
        if(q==questions.count){
            return
        }
        
        if(q>0){
            let pq = questions[q-1]
            pq.textColor = UIColor.lightGray
            pq.font = UIFont.systemFont(ofSize: 16)
            let tags: [String] = tlv.selectedTags().map({ tag -> String in
                return tag.currentTitle!
            })
            pq.text = pq.text?.replacingOccurrences(of: "___", with: tags.joined(separator: ", "))
        }
        
        questions[q].textColor = ThemeColors.primary
        questions[q].font = UIFont.boldSystemFont(ofSize: 18)
        
        switch(q){
        case 1:
            tlv.removeAllTags()
            KinkedInAPI.kinks(form: "service"){ kinks in
                self.kinksDidLoad(kinks: kinks, updateMap: true)
            }
            self.view.makeToastActivity(.center)
        case 2:
            deselectAll()
        case 3:
            tlv.removeAllTags()
            loadWearables()
        case 4:
            tlv.removeAllTags()
            KinkedInAPI.kinks(form: "act"){ kinks in
                self.kinksDidLoad(kinks: kinks, updateMap: true)
            }
            self.view.makeToastActivity(.center)
            nextQ.isEnabled = false
        default:
            KinkedInAPI.kinks(form: "omake"){ kinks in
                self.kinksDidLoad(kinks: kinks, updateMap: true)
            }
            self.view.makeToastActivity(.center)
        }
        q += 1
    }
    */
    
    func updateQuestionReference(_ sender: Any){
        onQuestion?.setTitleColor(UIColor.gray, for: .normal)
        
        if let button = sender as? UIButton {
            button.setTitleColor(ThemeColors.primary, for: .normal)
            onQuestion = button
        }
    }
    
    @IBAction func onOmake(_ sender: Any) {
        updateQuestionReference(sender)
        loadOmake()
        q = .omake
    }
    
    @IBAction func onGetService(_ sender: Any) {
        updateQuestionReference(sender)
        if(q == .give_service){
            deselectAll()
        } else {
            loadServices()
        }
        
        q = .get_service
    }
    
    @IBAction func onGiveService(_ sender: Any) {
        updateQuestionReference(sender)
        
        if(q == .get_service){
            deselectAll()
        } else {
            loadServices()
        }
        
        q = .give_service
    }
    
    @IBAction func onWear(_ sender: Any) {
        updateQuestionReference(sender)
        loadWearables()
        q = .wear
    }
    
    @IBAction func onActs(_ sender: Any) {
        updateQuestionReference(sender)
        loadActs()
        q = .act
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
        KinkedInAPI.addKinks(compileAnswers())
    }

}
