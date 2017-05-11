//
//  AppDelegate.swift
//  iOSKinkedIn
//
//  Created by alice on 2/16/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit
import RealmSwift
import Fabric
import Crashlytics
import PusherSwift
import UserNotifications
import HyphenateLite

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    //let pusher = Pusher(key: "24ee5765edd3a7a2bf66")
    let hypKey = "valour#kidev"
    let hypPushCert = "kiapnsdev"
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Fabric.with([Crashlytics.self])
        
        if let hypOptions = EMOptions(appkey: hypKey) {
            hypOptions.apnsCertName = hypPushCert
            EMClient.shared().initializeSDK(with: hypOptions)
        }

        let center = UNUserNotificationCenter.current()
        //center.delegate = self
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if(granted){
                // print("register categories")
                //center.setNotificationCategories([self.partnershipCat()])
            }
        }

        application.registerForRemoteNotifications()
        
        return true
    }
    
    private func partnershipCat() -> UNNotificationCategory {
        let confirm = UNNotificationAction(identifier: "partner_confirm", title: "Confirm")
        let deny = UNNotificationAction(identifier: "partner_deny", title: "Deny")
        let ignore = UNNotificationAction(identifier: "partner_ignore", title: "Ignore",
                                          options: [.destructive] )
        return UNNotificationCategory(identifier: "partner_request", actions: [confirm, deny, ignore], intentIdentifiers: [])
        //TODO: attach to action or now should probably just
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken : Data) {
        print("didRegisterForRemoteNotificationsWithDeviceToken")
        KinkedInAPI.deviceToken = deviceToken
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("didReceiveRemoteNotification")
        //print(userInfo)
        /*
        if let aps = userInfo["aps"] as? [AnyHashable: Any] {
            if let category = aps["category"] as String {
                if(category == "partner_requests"){
                    
                }
            }
        }
        */
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        EMClient.shared().applicationDidEnterBackground(application)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        EMClient.shared().applicationWillEnterForeground(application)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
  
    /*
    func unregisterNotifications(){
        guard let client = EMClient.shared() else {
            return
        }
        client.removeDelegate(self)
        client.contactManager.removeDelegate(self)
            
    }
    
    func registerNotifications(){
        self.unregisterNotifications()
        guard let client = EMClient.shared() else {
            return
        }
       
    }
    */
}

/*
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        guard let data = response.notification.request.content.userInfo["data"] as? [String: Any] else {
            return
        }
        
        guard let request_id = data["request_id"] as? Int else {
            return
        }
        
        switch(response.actionIdentifier){
            case "partner_confirm":
                print("yes we are partners!")
                KinkedInAPI.replyPartnerRequest(request_id, confirm: true)
            case "partner_deny":
                print("no who is this?")
                KinkedInAPI.replyPartnerRequest(request_id, confirm: false)
            default:
                //go to partner requests screen
                break
        }
        
    }
}
*/
