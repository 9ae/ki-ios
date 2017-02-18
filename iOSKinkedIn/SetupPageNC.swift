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

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        
        self.userProfile = Profile.create(userNeoId!)
        
        if let firstViewController = orderedViewControllers.first {
            
            firstViewController.setProfile(self.userProfile!)
            
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private(set) lazy var orderedViewControllers: [SetupViewVC] = {
        return [
                self.getPageViewController("Genders"),
                self.getPageViewController("Basic"),
                self.getPageViewController("Kinks")
                ]
    }()
    
    private func getPageViewController(_ name: String ) -> SetupViewVC {
        return (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vcSetup\(name)") as? SetupViewVC)!
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
