//
//  ViewController.swift
//  iOSKinkedIn
//
//  Created by alice on 2/16/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit
import Toast_Swift

class GendersVC: SetupViewVC, UITableViewDataSource, UITableViewDelegate {
    
    private let CELL_ID = "cellGender"
    @IBOutlet var tableView: UITableView?
    var profile: Profile?
    var updatePreferencesMode: Bool = false
    
    private var genders = [String]()
    private var selectedGenders = Set<String>()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        KinkedInAPI.genders(_loadGenders)
        if(updatePreferencesMode){
            setSelectedGenders(profile?.preferences?.genders ?? [String]())
            self.navigationItem.prompt = "Show me people who are..."
            
            self.navigationItem.hidesBackButton = true
            let buttonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(self.updatePreferences))
            self.navigationItem.setRightBarButton(buttonItem, animated: false)
        } else {
            setSelectedGenders(profile?.genders ?? [String]())
            self.navigationItem.prompt = "I identify as..."
        }
        tableView?.dataSource = self
        tableView?.delegate = self
        self.view.makeToastActivity(.center)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func _loadGenders(_ results: [String]){
        self.genders = results
        tableView?.reloadData()
        self.view.hideToastActivity()
    }
    
    private func setSelectedGenders(_ gens: [String]){
        for g in gens {
            selectedGenders.insert(g)
        }
    }
    
    // MARK: Table View Data Source Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.getOrCreateCell(CELL_ID)
        let label = genders[indexPath.row]
        cell.textLabel?.text = label
        if(selectedGenders.contains(label)){
            CellStyles.select(cell, check: true)
        } else {
            CellStyles.deselect(cell, check: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let label = genders[indexPath.row]
        if(selectedGenders.contains(label)){
            selectedGenders.remove(label)
            tableView.reloadRows(at: [indexPath], with: .none)
            return nil
        }
        else {
            return indexPath
        }
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath){
        let label = genders[indexPath.row]
        selectedGenders.insert(label)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func updatePreferences(_ sender: Any) {
        let newGenders = Array(selectedGenders)
        profile?.preferences?.genders = newGenders
        let params = ["prefers": ["genders": newGenders] ]
        KinkedInAPI.updateProfile(params)
        self.navigationController?.popViewController(animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let newGenders = Array(selectedGenders)
        profile?.genders = newGenders
        let params = ["genders": newGenders]
        KinkedInAPI.updateProfile(params)
    }
    
}
