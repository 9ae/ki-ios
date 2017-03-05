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
    var myWays = Set<String>()
    var interest: KinkInterest?
    
    var dataChanged = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard kinkInFocus != nil else {
            return
        }
        
        waysTable?.dataSource = self
        waysTable?.delegate = self
        
        let lbl = kinkInFocus?.label ?? ""
        defineLabel?.text = "Definition of \(lbl)"
        
        interest = KinkInterest.getOrCreate(_label: (kinkInFocus?.label)!)
        let _ways = splitStrings((interest?.compactWays)!)
        for w in _ways {
            myWays.insert(w)
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
        if(myWays.contains(wayName!)){
            CellStyles.select(cell!, check: true)
        } else {
            CellStyles.deselect(cell!, check: true)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath){
        let cell = tableView.cellForRow(at: indexPath)
        let w = kinkInFocus?.ways[indexPath.row]
        if(cell?.accessoryType == .checkmark) {
            CellStyles.deselect(cell!, check: true)
            myWays.remove(w!)
        } else {
            CellStyles.select(cell!, check: true)
            myWays.removeAll()
            myWays.insert(w!)
        }
        dataChanged = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        let hasKink: Bool = myWays.count > 0
        
        if (!dataChanged){
            return
        }
        
        if(kinkInFocus?.checked ?? false){
            if(hasKink){ //update
                
            } else { //delete
            
            }
        } else {
            if(hasKink) { //add
            
            }
        }
        
        let realm = RealmDB.instance()
        
        if(hasKink){
            try! realm.write{
                interest?.compactWays = myWays.first!
            }
            kinkInFocus?.checked = true
            
        } else {
            try! realm.write {
                realm.delete(interest!)
            }
            kinkInFocus?.checked = false
        }
    }

}
