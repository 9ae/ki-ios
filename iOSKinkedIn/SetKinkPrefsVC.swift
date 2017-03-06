//
//  SetKinkPrefsVC.swift
//  iOSKinkedIn
//
//  Created by alice on 2/20/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class SetKinkPrefsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet var headerImage: UIImageView?
    @IBOutlet var defineLabel: UILabel?
    @IBOutlet var waysTable: UITableView?
    
    let CELL_ID = "kinkyWay"
    var kinkInFocus: Kink?
    
    var dataChanged = false
    
    let experiences = ["curious about", "dabbled with", "learning", "practicing", "skilled in", "master of"]

    override func viewDidLoad() {
        super.viewDidLoad()
        defineLabel?.isHidden = true
        
        guard let kink = kinkInFocus else {
            return
        }
        
        waysTable?.dataSource = self
        waysTable?.delegate = self
        
        let lbl = kink.label
        defineLabel?.text = "Definition of \(lbl)"
        
        if(!kink.likeWay.isEmpty) {
        for i in 0...2 {
            if(kink.ways[i] == kink.likeWay){
                let wayIndex = IndexPath(row: i, section: 0)
                waysTable?.selectRow(at: wayIndex, animated: false, scrollPosition: .none)
            }
        }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section){
        case 0:
            return "My interest in"
        case 1:
            return "My experience level"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0:
            return wayNumberOfRowsInSection()
        case 1:
            return expNumberOfRowsInSection()
        default:
            return 0
        }
    }
    
    private func wayNumberOfRowsInSection() -> Int {
        guard let ways = kinkInFocus?.ways.count else {
            return 0
        }
        return ways
    }
    
    private func expNumberOfRowsInSection() -> Int {
        return experiences.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID)
        if (cell == nil) {
            cell = KinkDetailCell(
                style: UITableViewCellStyle.default,
                reuseIdentifier: CELL_ID)
        }
        var label: String
        let row = indexPath.row
        switch(indexPath.section){
        case 0:
            label = (kinkInFocus?.ways[row])!
        case 1:
            label = experiences[row]
        default:
            label = ""
        }
        cell?.textLabel?.text = label
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let selected = tableView.indexPathsForSelectedRows else {
            return indexPath
        }
         for p in selected {
            if(p.section==indexPath.section){
                tableView.deselectRow(at: p, animated: false)
            }
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch(indexPath.section){
        case 0:
            wayDidSelectRowAt(indexPath)
        case 1:
            expDidSelectRowAt(indexPath)
        default:
            break
        }
        dataChanged = true
    }
    
    private func wayDidSelectRowAt(_ indexPath: IndexPath){
        guard let wayLabel = kinkInFocus?.ways[indexPath.row] else {
            return
        }
        if(kinkInFocus?.likeWay == wayLabel){
            waysTable?.deselectRow(at: indexPath, animated: false)
            kinkInFocus?.likeWay = ""
        } else {
            kinkInFocus?.likeWay = wayLabel
        }
    }
    
    private func expDidSelectRowAt(_ indexPath: IndexPath){
        kinkInFocus?.exp = indexPath.row
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        guard dataChanged else {
            return
        }
        
        guard let kink = kinkInFocus else {
            return
        }
        let hasKink: Bool = !kink.likeWay.isEmpty
        
        if(kink.checked){
            if(hasKink){ //update
                print("update kink")
                KinkedInAPI.updateKink(kink.id, way: kink.likeWay)
            } else { //delete
                print("delete kink")
                KinkedInAPI.deleteKink(kink.id)
            }
        } else {
            if(hasKink) { //add
                print("add kink")
                KinkedInAPI.addKink(kink.id, way: kink.likeWay)
            }
        }
        
        kinkInFocus?.checked = hasKink
        
    }

}
