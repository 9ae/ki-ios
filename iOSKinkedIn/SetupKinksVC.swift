//
//  SetupKinksVC.swift
//  iOSKinkedIn
//
//  Created by alice on 2/17/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class SetupKinksVC: SetupViewVC, UITableViewDataSource, UITableViewDelegate {
    
    let CELL_ID = "cellKinks"
    @IBOutlet var kinksTableView: UITableView?
    @IBOutlet var segmentControl: UISegmentedControl?
    
    var kinks = [Kink]()
    var selectedKink: Kink?
    
    var isComingBack = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        KinkedInAPI.kinks(_loadKinks)
        kinksTableView?.dataSource = self
        kinksTableView?.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(isComingBack){
            kinksTableView?.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func sortByABC(a:Kink, b:Kink) -> Bool {
        return a.label < b.label
    }
    
    private func sortByPopularity(a:Kink, b:Kink) -> Bool {
        return a.popularity > b.popularity
    }

    private func _loadKinks(_ results: [Kink]){
        self.kinks = results.sorted(by: sortByABC)
        kinksTableView?.reloadData()
    }
    
    private func _detailView(_ kink: Kink){
        selectedKink = kink
        self.performSegue(withIdentifier: "kinkprefs", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.getOrCreateCell(CELL_ID)
        let kink = kinks[indexPath.row]
        cell.textLabel?.text = kink.label
        if(KinkInterest.has(_label: kink.label)){
            CellStyles.select(cell)
        } else {
            CellStyles.deselect(cell)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   accessoryButtonTappedForRowWith indexPath: IndexPath){
        _detailView(kinks[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath){
        _detailView(kinks[indexPath.row])
    }
 
    @IBAction func indexChanged(_ sender: AnyObject) {
        guard let idx = segmentControl?.selectedSegmentIndex else {
            return
        }
        
        switch idx
        {
        case 0:
            self.kinks = self.kinks.sorted(by: sortByABC)
        case 1:
            self.kinks = self.kinks.sorted(by: sortByPopularity)
            
        default:
            break
        }
        kinksTableView?.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if (segue.identifier == "kinkprefs"){
            let kinkPrefsView = segue.destination as? SetKinkPrefsVC
            kinkPrefsView?.kinkInFocus = selectedKink
            isComingBack = true
        }
    }

}
