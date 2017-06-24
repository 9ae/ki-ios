//
//  AppDelegate.swift
//  iOSKinkedIn
//
//  Created by alice on 2/16/17.
//  Copyright © 2017 KinkedIn. All rights reserved.
//

import UIKit
import UserNotifications

import Fabric
import Crashlytics
import PusherSwift
import LayerKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, LYRClientDelegate {
    
    var window: UIWindow?
    let layerID = "layer:///apps/staging/39241b6e-8c36-11e6-8a28-c7b78f1e6a1c"
    var notificationLaunchOptions : [String:Any?] = ["category": nil, "identifier": nil]

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Fabric.with([Crashlytics.self])
        
        let layerURL = URL(string: layerID)
        LayerHelper.client = LYRClient(appID: layerURL!, delegate: self, options: nil)
        LayerHelper.client?.connect { (success, error) in
            if(success){
                print("layer connected")
            } else {
                print("layer failed")
                print(error.debugDescription)
            }
        }
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if(granted){
                // print("register categories")
                center.setNotificationCategories([self.partnershipCat(), self.aftercareCat()])
            }
        }

        application.registerForRemoteNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(self.kiapiAccessTokenSet), name: NOTIFY_TOKEN_SET, object: nil)
        
        print("didFinishLaunchingWithOptions")
        
        return true
    }
    
    private func partnershipCat() -> UNNotificationCategory {
        //let confirm = UNNotificationAction(identifier: "partner_confirm", title: "Confirm")
        //let deny = UNNotificationAction(identifier: "partner_deny", title: "Deny")
        let view = UNNotificationAction(identifier: "partner_view", title: "View", options: [.foreground])
        let ignore = UNNotificationAction(identifier: "partner_ignore", title: "Ignore",
                                          options: [.destructive] )
        return UNNotificationCategory(identifier: NOTECAT_PARTNER_REQUEST, actions: [view, ignore], intentIdentifiers: [])
        //TODO: attach to action or now should probably just
    }
    
    private func aftercareCat() -> UNNotificationCategory {
        let talk = UNNotificationAction(identifier: NOTIACT_TALK, title: "Answer", options: [.foreground])
        let ignore = UNNotificationAction(identifier: NOTIACT_IGNORE, title: "Ignore")
        return UNNotificationCategory(identifier: NOTECAT_AFTERCARE, actions: [talk, ignore], intentIdentifiers: [])
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken : Data) {
        print("didRegisterForRemoteNotificationsWithDeviceToken")
        KinkedInAPI.deviceToken = deviceToken
        try! LayerHelper.client?.updateRemoteNotificationDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("didReceiveRemoteNotification")
        LayerHelper.client?.synchronize(withRemoteNotification: userInfo, completion: { (conversation, message, error) in
            if((error) != nil){
                print(error?.localizedDescription ?? "Layer notification error")
            } else {
                print("layer notification recieved")
                //TODO launch convo
            }
        })
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
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        print("applicationWillEnterForeground")
        
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("applicationDidBecomeActive")
        
        guard let category = self.notificationLaunchOptions["category"] as? String else {
            print("category is not nil")
            return
        }
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let navCtrl = storyboard.instantiateViewController(withIdentifier: "appNaviCtrl") as! UINavigationController
        self.window?.rootViewController = navCtrl
        self.window?.makeKeyAndVisible()
            
        switch(category){
            case NOTECAT_AFTERCARE:
                navCtrl.pushViewController(LayerHelper.makeAftercareVC(), animated: false)
            case NOTECAT_PARTNER_REQUEST:
                let vc = storyboard.instantiateViewController(withIdentifier: "partnerRequests") as! PartnerRequestsVC
                navCtrl.pushViewController(vc, animated: false)
                print("lauch partner request screen")
            default:
                print("not sure what to do")
                
        }
            
        self.notificationLaunchOptions["category"] = nil
        

    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func layerClient(_ client: LYRClient, didReceiveAuthenticationChallengeWithNonce nonce: String){
        print("layer didReceiveAuthenticationChallengeWithNonce")
        LayerHelper.authCallback(client, nonce)
    }
    
    @objc func kiapiAccessTokenSet(){
        print("access token set. prefeform listener functions")
        
        if let deviceToken = KinkedInAPI.deviceToken {
            print("Pusher subscribe to my personal channel")
            let pusher = Pusher(key: "24ee5765edd3a7a2bf66")
            KinkedInAPI.get("self/pusheen"){ json in
                if let neoId = json["my_channel"] as? String {
                    pusher.nativePusher.register(deviceToken: deviceToken)
                    pusher.nativePusher.subscribe(interestName: neoId)
                }
            }
        }
        
        if let layerClient = LayerHelper.client {
            if (layerClient.isConnected){
                print("Layer auth user")
                LayerHelper.auth()
            }
        }
        
        
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


extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        /*
        guard let data = response.notification.request.content.userInfo["data"] as? [String: Any] else {
            return
        }
        */
        // print("notification recieved: \(response)");
        //print(data);
        
        self.notificationLaunchOptions["category"] = response.notification.request.content.categoryIdentifier
        
        /*
        switch(category){
            case "aftercare_checkin":
                print("launch aftercare")
                self.notificationLaunchOptions["category"] = category
            
            case "partner_request":
                print("show partner request")
            default:
                print("unhandled category \(category)")
        }
        */
        
        completionHandler();
        /*
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
        */
    }
}

