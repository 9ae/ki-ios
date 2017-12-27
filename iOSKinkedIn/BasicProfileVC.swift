//
//  BasicVC.swift
//  iOSKinkedIn
//
//  Created by alice on 6/18/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class BasicProfileVC: ScrollTextInputVC, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var birthdayField: UIDatePicker!
    @IBOutlet var expField: UIPickerView!
    @IBOutlet var cityField: UIPickerView!
    
    var expTitles = [String]()
    var cities = [City]()
    
    var profile: Profile?

    override func viewDidLoad() {
        super.viewDidLoad()

        let today = Date()
        var dc = DateComponents()
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        dc.year = -18
        birthdayField?.maximumDate = calendar.date(byAdding: dc, to: today)
        
        expField.delegate = self
        expField.dataSource = self
        nameField.delegate = self
        cityField.delegate = self
        
        KinkedInAPI.experienceLevels { results in
            self.expTitles = results
            self.expField.reloadComponent(0)
            self.expField.selectRow((self.profile?.expLv!)!, inComponent: 0, animated: false)
        }
        
        KinkedInAPI.cities { results in
            self.cities = results
            self.cityField.reloadComponent(0)
            if let city = self.profile?.city {
                var r = 0
                for (i, c) in self.cities.enumerated() {
                    if c.label == city {
                        r = i
                        break
                    }
                }
                self.cityField.selectRow(r, inComponent: 0, animated: false)
            }
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.nameField.text = profile?.name
        if (profile?.birthday != nil){
            self.birthdayField.setDate((profile?.birthday!)!, animated: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.isEqual(expField)) {
            return expTitles.count
        } else if (pickerView.isEqual(cityField)) {
            return cities.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.isEqual(expField)) {
            return expTitles[row]
        } else if (pickerView.isEqual(cityField)) {
            return cities[row].label
        } else {
            return "..."
        }
        
    }
    
    
    func post() {
        var params = [String:Any]()
        
        if let name = nameField?.text {
            if profile?.name != name {
                params["name"] = name
                profile?.name = name
            }
        }
        
        if let birthday = birthdayField?.date, let calendar = birthdayField?.calendar {
            if profile?.birthday != birthday {
                params["birthday"] = [
                    "year": calendar.component(.year, from: birthday),
                    "month": calendar.component(.month, from: birthday),
                    "date": calendar.component(.day, from: birthday)
                ]
                profile?.birthday = birthday
                
                let today = Date()
                profile?.age = calendar.dateComponents([.year], from: birthday, to: today).year ?? 0 
            }
        }
        
        let exp = expField.selectedRow(inComponent: 0)
        if profile?.expLv != exp {
            params["exp"] = exp
            profile?.expLv = exp
            profile?.exp = expTitles[exp]
        }
        
        let cityIndex = cityField.selectedRow(inComponent: 0)
        let city = self.cities[cityIndex]
        if profile?.city != city.label {
            params["city"] = city.code
        }
        
        KinkedInAPI.updateProfile(params)
    }
    
    func isNameSet() -> Bool {
        return nameField.text != nil
    }
    
    override func viewWillDisappear(_ animated: Bool){
        post()
        super.viewWillDisappear(animated)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
