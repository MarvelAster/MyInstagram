//
//  AppDelegate.swift
//  MyInstagramProjectWithFirebase
//
//  Created by Chuanqi Huang on 5/25/18.
//  Copyright © 2018 Chuanqi Huang. All rights reserved.
//

import UIKit
import Firebase
import TWMessageBarManager
import FirebaseAuth
import GoogleSignIn
import Fabric
import Crashlytics
import FacebookCore
import FBSDKCoreKit
import UserNotifications
import FirebaseMessaging
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    


    var window: UIWindow?
    
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            let googlehandler =
             GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
            
            let facebookhandler = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: options[.sourceApplication] as! String, annotation: [:])
            
            return googlehandler || facebookhandler
    }
    
    
    //MARK: -didFinishLaunchingWithOptions
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        //Fabric.with([Crashlytics.self])
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        setupNotification()
//        GIDSignIn.sharedInstance().delegate = self
        
    
        if let curUser = Auth.auth().currentUser {
            let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = mainStoryboard.instantiateViewController(withIdentifier: "tabBarController")
            self.window?.rootViewController = controller
        }
        return true
    }
    
    func setupNotification() {
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self as? UNUserNotificationCenterDelegate
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (flag, error) in
            DispatchQueue.main.sync {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
        Messaging.messaging().delegate = self
        Messaging.messaging().shouldEstablishDirectChannel = true
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
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        AppEventsLogger.activate(application)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension AppDelegate: MessagingDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let varAvalue = String(format: "%@", deviceToken as CVarArg)
        let token = varAvalue.trimmingCharacters(in: CharacterSet(charactersIn: "<>")).replacingOccurrences(of: "", with: "")
        Messaging.messaging().apnsToken = deviceToken
        print(token)
//        PushWizard.start(withToken: deviceToken, andAppKey: appkeyPush, andValues: nil)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        NotificationCenter.default.post(name : Constants.notificationName, object : userInfo)
//        PushWizard.handleNotification(userInfo, processOnlyStatisticalData: false)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void){
        
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print(fcmToken)
        //cFYmoDOYiXI:APA91bFwJ-wz2-es5XJwTpkwweZPsXxFtgEkC9tsCyErBAWKGDgtHqTFagGpxXKH5mVC1vN94snYzLZabDDPTvyzWfSkFIpLpr-xDw6D7I9g-tz5rMlDjeHZjr5Bn3sunKNRFeGXOt2e
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        
    }
    
}

