//
//  AuthVC.swift
//  iOSKinkedIn
//
//  Created by Alice on 7/6/19.
//  Copyright © 2019 KinkedIn. All rights reserved.
//

import UIKit

class AuthVC: UIViewController {
    
    @IBOutlet var segment: UISegmentedControl!
    @IBOutlet var container: UIView!
    let underline = UIView()
    
    var segmentItemWidth : CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "splash2"))
        
        segment.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        segment.backgroundColor = .clear
        segment.tintColor = .clear
        
        segment.setTitleTextAttributes([ NSAttributedString.Key.foregroundColor: UIColor.darkGray], for: .normal)
        segment.setTitleTextAttributes([ NSAttributedString.Key.foregroundColor: ThemeColors.primaryDark], for: .selected)
        
        underline.translatesAutoresizingMaskIntoConstraints = false
        underline.backgroundColor = ThemeColors.primary
        view.addSubview(underline)
        underline.topAnchor.constraint(equalTo: segment.bottomAnchor).isActive = true
        underline.heightAnchor.constraint(equalToConstant: 5).isActive = true
        underline.leftAnchor.constraint(equalTo: segment.leftAnchor).isActive = true
        
        segmentItemWidth = segment.frame.width / CGFloat(segment.numberOfSegments)
        underline.widthAnchor.constraint(equalToConstant: segmentItemWidth ).isActive = true
        underline.frame.origin.x = segment.frame.origin.x
        
        self.loadInContainer(asChildViewController: self.registerVC)

    }
    
    private func loadInContainer(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        self.addChild(viewController)
        
        // Add Child View as Subview
        container.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = container.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }
    
    private func removeFromContainer(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParent()
    }
    
    private lazy var registerVC : RegisterVC = {
        let storyboard = UIStoryboard(name: "Auth", bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
    }()
    
    private lazy var loginVC : LoginVC = {
        let storyboard = UIStoryboard(name: "Auth", bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
    }()
    

    
    @objc func segmentChanged(){
        let x = segment.frame.origin.x + (segmentItemWidth * CGFloat(self.segment.selectedSegmentIndex))
        
        UIView.animate(withDuration: 0.2, animations: {
            self.underline.frame.origin.x = x
        }, completion: {ok in
            self.underline.frame.origin.x = x
        })
        
        switch segment.selectedSegmentIndex {
        case 1:
            self.removeFromContainer(asChildViewController: self.registerVC)
            self.loadInContainer(asChildViewController: self.loginVC)
            break
        default:
            self.removeFromContainer(asChildViewController: self.loginVC)
            self.loadInContainer(asChildViewController: self.registerVC)
            break
        }
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
