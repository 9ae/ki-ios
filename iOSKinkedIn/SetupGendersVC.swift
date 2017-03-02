//
//  ViewController.swift
//  iOSKinkedIn
//
//  Created by alice on 2/16/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit
import AMPopTip

class SetupGendersVC: SetupViewVC, UITableViewDataSource, UITableViewDelegate {
    
    let CELL_ID = "cellGender"
    @IBOutlet var tableView: UITableView?
    
    var genders =  [
        Gender(id: 1, label: "bishounen"),
        Gender(id: 2, label: "shoujo")
    ]
    
    var selectedGendersIds = Set<Int>()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        KinkedInAPI.genders(_loadGenders)
        tableView?.dataSource = self
        tableView?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func _loadGenders(_ results: [Gender]){
        self.genders = results
        tableView?.reloadData()
    }
    
    // MARK: Table View Data Source Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.getOrCreateCell(CELL_ID)
        cell.textLabel?.text = genders[indexPath.row].label
        return cell
    }
    
    /*
    func tableView(_ tableView: UITableView,
                   accessoryButtonTappedForRowWith indexPath: IndexPath){
        //TODO api:#4 endpoint to look up definiton
        let label = genders[indexPath.row].label
        if let cell = tableView.cellForRow(at: indexPath)
        {
            let popTip = AMPopTip()
            popTip.shouldDismissOnTap = true
            popTip.popoverColor = UIColor.init(white: 0, alpha: 0.6)
            popTip.textColor = UIColor.white
            popTip.showText("Definition of \(label)", direction: .none,
                            maxWidth: 300, in: tableView, fromFrame: cell.frame)
        }
    }
    */
    
    func tableView(_ tableView: UITableView,
                   didDeselectRowAt indexPath: IndexPath){
        let id = genders[indexPath.row].id
        selectedGendersIds.remove(id)
        let cell = tableView.cellForRow(at: indexPath)!
        CellStyles.deselect(cell, check: true)
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath){
        let id = genders[indexPath.row].id
        selectedGendersIds.insert(id)
        let cell = tableView.cellForRow(at: indexPath)!
        CellStyles.select(cell, check: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        me?.saveGenders(Array(selectedGendersIds))
        //TODO #9 post updates to server
        if let nextScene = segue.destination as? SetupViewVC {
            nextScene.setProfile(self.me!)
        }
    }
    
    
}
