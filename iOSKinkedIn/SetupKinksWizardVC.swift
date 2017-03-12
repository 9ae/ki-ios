//
//  SetupKinksWizardVC.swift
//  iOSKinkedIn
//
//  Created by alice on 3/12/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit
import TagListView

class SetupKinksWizardVC: UIViewController, TagListViewDelegate {

   // @IBOutlet weak var kinksGrid: UICollectionView!
   // var kinksGridVC: KinksGridVC
    
    @IBOutlet weak var tlv: TagListView!
    var kinksMap = [String:String]()
    
    required init?(coder aDecoder: NSCoder) {
        // self.kinksGridVC = KinksGridVC()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tlv.delegate = self
        tlv.textFont = UIFont.systemFont(ofSize: 20)
        KinkedInAPI.kinks(form: "omake", callback: kinksDidLoad)
    
    }
    
    func kinksDidLoad(kinks: [Kink]){
        kinksMap.removeAll()
        for k in kinks {
            kinksMap[k.label] = k.code
            tlv.addTag(k.label)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("adding "+kinksMap[title]!)
        tagView.isSelected = true
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
