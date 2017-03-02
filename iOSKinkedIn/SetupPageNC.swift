//
//  SetupPageNC.swift
//  iOSKinkedIn
//
//  Created by alice on 2/16/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class SetupPageNC: UINavigationController {
    
    var userNeoId: String?
    var userProfile: Profile?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (userNeoId != nil){
        
            self.userProfile = Profile.create(userNeoId!, isSelf: true)
            RealmDB.save(self.userProfile!)
        
            NotificationCenter.default.addObserver(self,
                selector: #selector(SetupPageNC.handleProfileSetupComplete),
                name: NOTIFY_PROFILE_SETUP_COMPLETE, object: nil)
        
            let firstScreen = self.viewControllers.first as? SetupViewVC
            firstScreen?.setProfile(self.userProfile!)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handleProfileSetupComplete(){
        self.performSegue(withIdentifier: "setup2app", sender: self)
    }

}
/*
extension SetupPageNC: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
        ) -> UIViewController? {
        
        guard let setupViewController = viewController as? SetupViewVC else {
            return nil
        }
        
        guard let viewControllerIndex = orderedViewControllers.index(
            of: setupViewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        let nextView = orderedViewControllers[previousIndex]
        nextView.setProfile(self.userProfile!)
        
        return nextView
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
        ) -> UIViewController? {
        
        guard let setupViewController = viewController as? SetupViewVC else {
            return nil
        }
        
        guard let viewControllerIndex = orderedViewControllers.index(
            of: setupViewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        let nextView = orderedViewControllers[nextIndex]
        nextView.setProfile(self.userProfile!)
        
        return nextView
    }
}
*/
