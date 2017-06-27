//
//  PromptVC.swift
//  iOSKinkedIn
//
//  Created by alice on 6/27/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class PromptVC: UITableViewController {
    
    var profile: Profile?
    var prompts = [BioPrompt]()
    
    let CELL_ID = "promptCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        if let _prompts = profile?.prompts {
            prompts = _prompts
            tableView.reloadData()
        } else {
        KinkedInAPI.bioPrompts { results in
            
            for title in results {
                self.prompts.append(BioPrompt(title: title, answer: nil, show: false))
            }
            self.tableView.reloadData()
        }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return prompts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.getOrCreateCell(CELL_ID)

        if let _promptCell = cell as? PromptCell {
            _promptCell.setContent(prompts[indexPath.row])
        }
        
        return cell
    }
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
        
        var i = 0
        while i < prompts.count {
            if let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? PromptCell {
                prompts[i].show = cell.show.isOn
                prompts[i].answer = cell.answer.text
            }
            i = i + 1
        }
        
        profile?.prompts = prompts
        
        let params = [
            "prompts": prompts.map{p in p.objectify()}
        ]
        KinkedInAPI.updateProfile(params)
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
