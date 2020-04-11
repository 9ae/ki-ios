//
//  KiNavCtrl.swift
//  iOSKinkedIn
//
//  Created by Alice on 4/11/20.
//  Copyright © 2020 KinkedIn. All rights reserved.
//

import UIKit

class KiNavCtrl: UINavigationController {
    
    override func viewWillAppear(_ animated: Bool) {
        let bgColor = ThemeColors.title
        let titleColor = ThemeColors.bg
        let btnColor = ThemeColors.bg
        
        if #available(iOS 13.0, *){
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = bgColor
            appearance.titleTextAttributes = [ .foregroundColor : titleColor]
            appearance.largeTitleTextAttributes = [ .foregroundColor : titleColor]
            
            self.navigationBar.standardAppearance = appearance
            self.navigationBar.scrollEdgeAppearance = appearance
            self.navigationBar.compactAppearance = appearance
            
            self.navigationBar.tintColor = btnColor
            
        } else {
            self.navigationBar.barTintColor = bgColor
            self.navigationBar.tintColor = btnColor
            self.navigationBar.titleTextAttributes = [ .foregroundColor : titleColor]
            self.navigationBar.largeTitleTextAttributes = [ .foregroundColor : titleColor]
        }
        
        super.viewWillAppear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
