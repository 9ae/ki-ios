//
//  PartnerRequestsVC.swift
//  iOSKinkedIn
//
//  Created by alice on 4/30/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class PartnerRequestsVC: UITableViewController {
    
    var prequests: [PartnerRequest] = [PartnerRequest]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        KinkedInAPI.partnerRequests { (partnerRequests) in
            self.prequests = partnerRequests
            self.tableView.reloadData()
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return prequests.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.getOrCreateCell("partnerRequestCell")
        let req = prequests[indexPath.row]
        cell.textLabel?.text = req.from_name

        /* uncomment later. for now let's resoruces
        let url = "https://res.cloudinary.com/i99/image/upload/c_thumb,g_face,h_100,w_100/\(req.from_image)"
        let imgURL = URL(string: url)
        do {
            let imgData = try Data(contentsOf: imgURL!)
            let img = UIImage(data: imgData)
            cell.imageView?.image = img
        } catch {
            // TODO: use put in place holder image
            print("error loading profile picture")
        }
        */

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let confirm = UITableViewRowAction(style: .normal, title: "Confirm") { action, index in
            let req = self.prequests[index.row]
            KinkedInAPI.replyPartnerRequest(req.id, confirm: true)
            self.vouchFor(req.from_uuid, name: req.from_name, index: index.row)
            
        }
        confirm.backgroundColor = UIColor.green
        
        let deny = UITableViewRowAction(style: .normal, title: "Deny") { action, index in
            KinkedInAPI.replyPartnerRequest(self.prequests[index.row].id, confirm: false)
            self.deleteRequest(index.row)
        }
        deny.backgroundColor = UIColor.red
        
        return [deny, confirm]
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        
    }
    
    private func vouchFor(_ userid: String, name: String, index: Int){
        let alert = UIAlertController(title: "Vouch for partner", message: "Would you like to vouch for \(name)?", preferredStyle: .alert)
        let noVouch = UIAlertAction(title: "Not now", style: .default){ action in
            print("not vouching now")
        }
        let yesVouch = UIAlertAction(title: "Yes", style: .default){ action in
            let params = [
                "uuid": userid,
                "name": name
            ]
            self.performSegue(withIdentifier: "pr2vouchIntro", sender: params)
        }
        alert.addAction(noVouch)
        alert.addAction(yesVouch)
        
        present(alert, animated: false) { 
            self.deleteRequest(index)
        }
    }
    
    private func deleteRequest(_ atRow: Int){
        prequests.remove(at: atRow)
        self.tableView.reloadData()
    }
    
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier=="pr2vouchIntro"){
            //pass params
        }
    }
    

}
