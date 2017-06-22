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
    
    let CELL_ID = "cellRole"
    @IBOutlet var tableView: UITableView?
    
    var roles = [Role]()
    var selectedRoles = Set<String>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        KinkedInAPI.roles { (results: [Role]) in
            self.roles = results
            self.tableView?.reloadData()
            self.view.hideToastActivity()
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
    
    // MARK: Table View Data Source Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.getOrCreateCell(CELL_ID)
        let label = roles[indexPath.row].label
        cell.textLabel?.text = label
        if(selectedRoles.contains(label)){
            CellStyles.select(cell, check: true)
        } else {
            CellStyles.deselect(cell, check: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let label = roles[indexPath.row].label
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
        selectedRoles.insert(roles[indexPath.row].label)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let params = ["roles" : Array(selectedRoles) ]
        KinkedInAPI.updateProfile(params)

    }


}
