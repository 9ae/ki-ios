//
//  TempViewController.swift
//  iOSKinkedIn
//
//  Created by alice on 5/15/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class TempViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.lightGray

        let LABEL_HEIGHT = 20
        let LABEL_PADDING = 8
        let opts: [String] = ["Yes", "No"]
        var uiOpts: [UIView] = []
        
        for o in opts {
            let lbl = UILabel()
            lbl.text = o
            lbl.textColor = UIColor.white
            lbl.backgroundColor = UIColor.blue
            lbl.textAlignment = .center
            lbl.translatesAutoresizingMaskIntoConstraints = false
            uiOpts.append(lbl)
        }
        
        let stack = UIStackView(arrangedSubviews: uiOpts)
        stack.axis = .vertical
        stack.alignment = .trailing
        stack.distribution = .fillEqually
        stack.spacing = 8.0
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(stack)
        
        let stackHeight = (LABEL_HEIGHT*uiOpts.count) + (LABEL_PADDING*(uiOpts.count-1))
        
        let ypos = NSLayoutConstraint(item: stack, attribute: .bottom, relatedBy: .equal,
                                   toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)
        let height = NSLayoutConstraint(item: stack, attribute: .height, relatedBy: .equal,
                                        toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: CGFloat(stackHeight))
        let xa = NSLayoutConstraint(item: stack, attribute: .leading, relatedBy: .equal,
                                    toItem: self.view, attribute: .leading, multiplier: 1, constant: 0)
        let xe = NSLayoutConstraint(item: stack, attribute: .trailing, relatedBy: .equal,
                                   toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0)
        self.view.addConstraints([ypos, height, xa, xe])
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
