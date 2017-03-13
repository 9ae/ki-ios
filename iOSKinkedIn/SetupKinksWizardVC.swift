//
//  SetupKinksWizardVC.swift
//  iOSKinkedIn
//
//  Created by alice on 3/12/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit
import TagListView

class SetupKinksWizardVC: SetupViewVC, TagListViewDelegate {

   // @IBOutlet weak var kinksGrid: UICollectionView!
   // var kinksGridVC: KinksGridVC
    
    @IBOutlet weak var omakeQuestion: UILabel!
    @IBOutlet weak var RServiceQuestion: UILabel!
    @IBOutlet weak var PServiceQuestion: UILabel!
    @IBOutlet weak var wearQuestion: UILabel!
    @IBOutlet weak var actQuestion: UILabel!
    
    @IBOutlet weak var tlv: TagListView!
    var questions: [UILabel]!
    var kinksMap = [String:Kink]()
    var q = 0
    
    required init?(coder aDecoder: NSCoder) {
        // self.kinksGridVC = KinksGridVC()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tlv.delegate = self
        tlv.textFont = UIFont.systemFont(ofSize: 20)
        
        self.questions = [omakeQuestion, RServiceQuestion, PServiceQuestion, wearQuestion, actQuestion]
        nextQuestion(self)
    }
    
    func kinksDidLoad(kinks: [Kink], updateMap: Bool){
        for k in kinks {
            if( updateMap && !kinksMap.keys.contains(k.label)){
                kinksMap[k.label] = k
            }
            tlv.addTag(k.label)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addKinkWay(_ kink: Kink){
        switch(q){
        case 1:
            if(kink.form == .wearable){
                kink.likesGet = true
            } else {
                kink.likesBoth = true
            }
        case 2:
            kink.likesGet = true
        case 3:
            kink.likesGive = true
        case 4:
            kink.likesGive = true
        default:
            kink.likesBoth = true
        }
    }
    
    func rmKinkWay(_ kink: Kink){
        switch(q){
        case 1:
            if(kink.form == .wearable){
                kink.likesGet = false
            } else {
                kink.likesBoth = false
            }
        case 2:
            kink.likesGet = false
        case 3:
            kink.likesGive = false
        case 4:
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
    
    private func loadWearables(){
        for (_ , value) in kinksMap {
            if(value.form == .wearable) {
                tlv.addTag(value.label)
            }
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
        
        print(json)
        return json
    }
    
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
        
        questions[q].textColor = ThemeColors.secondary
        questions[q].font = UIFont.boldSystemFont(ofSize: 18)
        
        switch(q){
        case 1:
            tlv.removeAllTags()
            KinkedInAPI.kinks(form: "service"){ kinks in
                self.kinksDidLoad(kinks: kinks, updateMap: true)
            }
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
        default:
            KinkedInAPI.kinks(form: "omake"){ kinks in
                self.kinksDidLoad(kinks: kinks, updateMap: true)
            }
        }
        q += 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        KinkedInAPI.addKinks(compileAnswers())
    }

}
