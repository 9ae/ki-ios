//
//  ViewController.swift
//  iOSKinkedIn
//
//  Created by alice on 2/16/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class SetupGendersVC: SetupViewVC, UITableViewDataSource, UITableViewDelegate {
    
    let CELL_ID = "cellGender"
    @IBOutlet var tableView: UITableView?
    
    var genders = [Gender]()
    var selectedGenders = Set<String>()

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
        let label = genders[indexPath.row].label
        cell.textLabel?.text = label
        if(selectedGenders.contains(label)){
            CellStyles.select(cell, check: true)
        } else {
            CellStyles.deselect(cell, check: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didDeselectRowAt indexPath: IndexPath){
        selectedGenders.remove(genders[indexPath.row].label)
        tableView.reloadRows(at: [indexPath], with: .none)

    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath){
        selectedGenders.insert(genders[indexPath.row].label)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        let params = ["genders": Array(selectedGenders)]
        KinkedInAPI.updateProfile(params)
    }
    
    
    
    
}
