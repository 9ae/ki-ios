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

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let ways = kinkInFocus?.ways.count else {
            return 0
        }
        return ways
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID)
        if (cell == nil) {
            cell = UITableViewCell(
                style: UITableViewCellStyle.default,
                reuseIdentifier: CELL_ID)
        }
        let wayName = kinkInFocus?.ways[indexPath.row]
        cell?.textLabel?.text = wayName
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        kinkInFocus?.likeWay = (kinkInFocus?.ways[indexPath.row])!
        dataChanged = true
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        guard dataChanged else {
            return
        }
        
        var hasKink: Bool = false
        if waysTable?.indexPathForSelectedRow != nil {
            hasKink = true
        }
        
        if(kinkInFocus?.checked ?? false){
            if(hasKink){ //update
                
            } else { //delete
            
            }
        } else {
            if(hasKink) { //add
            
            }
        }
        
        kinkInFocus?.checked = hasKink
        
    }

}
