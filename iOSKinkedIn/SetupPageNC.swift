//
//  SetupPageNC.swift
//  iOSKinkedIn
//
//  Created by alice on 2/16/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit

class SetupPageNC: UIPageViewController {
    
    var userNeoId: String?
    var userProfile: Profile?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        
        self.userProfile = Profile.create(userNeoId!, isSelf: true)
        RealmDB.save(self.userProfile!)
        
        if let firstViewController = orderedViewControllers.first {
            
            firstViewController.setProfile(self.userProfile!)
            
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(SetupPageNC.handleProfileSetupComplete), name: SetupBioVC.PROFILE_SETUP_COMPLETE, object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private(set) lazy var orderedViewControllers: [SetupViewVC] = {
        return [
                self.getPageViewController("Kinks"),
                self.getPageViewController("Basic"),
                self.getPageViewController("Genders"),
                self.getPageViewController("Picture"),
                //TODO #12 self.getPageViewController("Roles"),
                 self.getPageViewController("Bio")
                ]
    }()
    
    private func getPageViewController(_ name: String ) -> SetupViewVC {
        return (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vcSetup\(name)") as? SetupViewVC)!
    }

    @objc func handleProfileSetupComplete(){
        print("profile setup comlete")
        self.performSegue(withIdentifier: "setup2app", sender: self)
    }

}

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
