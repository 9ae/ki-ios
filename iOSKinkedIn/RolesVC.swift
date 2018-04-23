//
//  SetupRolesVC.swift
//  iOSKinkedIn
//
//  Created by alice on 2/19/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit
import Toast_Swift

class RolesVC: SetupViewVC, UITableViewDataSource, UITableViewDelegate {
    
    private let CELL_ID = "cellRole"
    @IBOutlet var tableView: UITableView?

    private var roles = [String]()
    private var selectedRoles = Set<String>()
    
    var profile: Profile?
    var updatePreferencesMode: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        KinkedInAPI.roles { (results: [String]) in
            self.roles = results
            self.tableView?.reloadData()
            self.view.hideToastActivity()
        }
        
        if(updatePreferencesMode){
            self.setSelectedRoles(profile?.preferences?.roles ?? [String]() )
             self.navigationItem.prompt = "Show me people who are..."
            
            self.navigationItem.hidesBackButton = true
            let buttonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(self.updatePreferences))
            self.navigationItem.setRightBarButton(buttonItem, animated: false)
        } else {
            self.setSelectedRoles(profile?.roles ?? [String]() )
            self.navigationItem.prompt = "I identify as..."
        }
        
        tableView?.delegate = self
        tableView?.dataSource = self
        self.view.makeToastActivity(.center)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setSelectedRoles(_ sr: [String]){
        for r in sr {
            selectedRoles.insert(r)
        }
    }
    
    // MARK: Table View Data Source Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.getOrCreateCell(CELL_ID)
        let label = roles[indexPath.row]
        cell.textLabel?.text = label
        if(selectedRoles.contains(label)){
            CellStyles.select(cell, check: true)
        } else {
            CellStyles.deselect(cell, check: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let label = roles[indexPath.row]
        if(selectedRoles.contains(label)){
            selectedRoles.remove(label)
            tableView.reloadRows(at: [indexPath], with: .none)
            return nil
        }
        else {
            return indexPath
        }
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath){
        selectedRoles.insert(roles[indexPath.row])
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func updatePreferences(_ sender: Any) {
        let newRoles =  Array(selectedRoles)
        profile?.preferences?.roles = newRoles
        let params = ["prefers" :["roles" : newRoles ] ]
        KinkedInAPI.updateProfile(params)
        self.navigationController?.popViewController(animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let newRoles =  Array(selectedRoles)
        profile?.roles = newRoles
        let params = ["roles" : newRoles ]
        KinkedInAPI.updateProfile(params)
    

    }


}
