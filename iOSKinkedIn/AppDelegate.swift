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
// import PusherSwift
import SendBirdSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let layerID = Bundle.main.infoDictionary!["LAYER_APP"] as! String
    
    var notificationLaunchOptions : [String:Any?] = ["category": nil, "identifier": nil, "user_info": nil]

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Fabric.with([Crashlytics.self])

        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if(granted){
                center.setNotificationCategories([self.partnershipCat(), self.aftercareCat()])
            }
        }

        application.registerForRemoteNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(self.kiapiAccessTokenSet), name: NOTIFY_TOKEN_SET, object: nil)
        
        print("LOG: didFinishLaunchingWithOptions")
        
        loadDefaults()
        
        return true
    }
    
    private func loadDefaults(){
        let defaults = UserDefaults.standard
        let checkinHours = defaults.integer(forKey: UD_CHECKIN_TIME)
        if checkinHours == 0 {
            defaults.set(UD_CHECKIN_TIME_VALUE, forKey: UD_CHECKIN_TIME)
        }
    }
    
    private func flySendbird(){
        let initSendbird = SBDMain.initWithApplicationId("15A8D607-1D52-4E30-AA56-11B393263A29")
        print("init sendbird \(initSendbird)")
        
        KinkedInAPI.sendbird { uuid, sendbirdToken in
            
            SBDMain.connect(withUserId: uuid, accessToken: sendbirdToken){(_user, _error) in
                if let user = _user {
                    print("connect to sendbird success!")
                    print(user)
                }
                
                if let error = _error {
                    print("connect to sendbird failrue")
                    print(error)
                }
            }
        }
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
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("didReceiveRemoteNotification")
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
        print("ZZ applicationDidBecomeActive")
        
        
        guard let category = self.notificationLaunchOptions["category"] as? String else {
            print("ZZ category is nil")
            return
        }
 
        self.window = UIWindow(frame: UIScreen.main.bounds)
    
        switch(category){
            case NOTECAT_AFTERCARE:
                print("ZZ aftercare checkin found")
                guard let userInfo = self.notificationLaunchOptions["user_info"] as? [AnyHashable: Any] else {break}
                guard let userId = userInfo["about_user_id"] as? String else {break}
                guard let userName = userInfo["about_user_name"] as? String else {break}
                
                let profile = Profile(uuid: userId, name: userName)
                let caseType : CaseType = .checkin
                KinkedInAPI.aftercareFlow(caseType: caseType) { flow in
                    print("YY got convo flow @ + \(flow.message)")
                    let convo = UIStoryboard(name: "Aftercare", bundle: Bundle.main).instantiateViewController(withIdentifier: "careConvoVC") as! CheckinChatVC
                    convo.setData(profile: profile, flow: flow, caseType: caseType)
                    
                    self.window?.rootViewController = convo
                    self.window?.makeKeyAndVisible()
                }
                
                
                break
            case NOTECAT_PARTNER_REQUEST:
//                let vc = storyboard.instantiateViewController(withIdentifier: "partnersVC") as! MasterPartnersVC
//                navCtrl.pushViewController(vc, animated: false)

                break
            default:
                print("not sure what to do")
            break
                
        }
        
        self.notificationLaunchOptions["category"] = nil
        

    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    @objc func kiapiAccessTokenSet(){
        print("access token set. prefeform listener functions")
        
        flySendbird()
        /*
        if let deviceToken = KinkedInAPI.deviceToken {
            // print("Pusher subscribe to my personal channel")
            // let pusher = Pusher(key: "24ee5765edd3a7a2bf66")
            KinkedInAPI.get("self/pusheen"){ json in
                if let uuid = json["my_channel"] as? String {
                   // pusher.nativePusher.register(deviceToken: deviceToken)
                   // pusher.nativePusher.subscribe(interestName: uuid)
                }
            }
        }
        */
        
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
        let content = response.notification.request.content
        self.notificationLaunchOptions["category"] = content.categoryIdentifier
        self.notificationLaunchOptions["user_info"] = content.userInfo
        
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

