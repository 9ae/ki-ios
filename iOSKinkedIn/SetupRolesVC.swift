//
//  SetupRolesVC.swift
//  iOSKinkedIn
//
//  Created by alice on 2/19/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit
import AMPopTip

class SetupRolesVC: SetupViewVC, UITableViewDataSource, UITableViewDelegate {
    
    let CELL_ID = "cellRole"
    @IBOutlet var tableView: UITableView?
    
    var roles = [Role]()
    var selectedRoleIds = Set<Int>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        KinkedInAPI.roles { (results: [Role]) in
            self.roles = results
            self.tableView?.reloadData()
        }
        tableView?.delegate = self
        tableView?.dataSource = self

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
        var cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID)
        if (cell == nil) {
            cell = UITableViewCell(
                style: UITableViewCellStyle.default,
                reuseIdentifier: CELL_ID)
        }
        cell?.textLabel?.text = roles[indexPath.row].label
        return cell!
    }
    
    func tableView(_ tableView: UITableView,
                   accessoryButtonTappedForRowWith indexPath: IndexPath){
        //TODO api:#4 endpoint to look up definiton
        let label = roles[indexPath.row].label
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
    
    func tableView(_ tableView: UITableView,
                   didDeselectRowAt indexPath: IndexPath){
        let id = roles[indexPath.row].id
        selectedRoleIds.remove(id)
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath){
        let id = roles[indexPath.row].id
        selectedRoleIds.insert(id)
        //TODO #7 apply cool styles
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        me?.saveGenders(Array(selectedRoleIds))
        //TODO #9 post updates to server
        if let nextScene = segue.destination as? SetupViewVC {
            nextScene.setProfile(self.me!)
        }
    }


}
