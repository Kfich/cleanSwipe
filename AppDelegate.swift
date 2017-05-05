//
//  AppDelegate.swift
//  CleanSwipe0-1
//
//  Created by Kevin Fich on 3/29/16.
//  Copyright © 2016 Kevin Fich. All rights reserved.
//

import UIKit
import Firebase
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var backgroundedDate: Date?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Registering for push notifications
        registerForPushNotifications(application)
        
        
        if let font = UIFont(name: "Geomanist-Regular", size: 20) {
            UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: font]
            
            // Test Key
            Stripe.setDefaultPublishableKey("pk_test_Qu4nfphcJZ2Inz5QDv4iLUYa")

            // Live key
            //Stripe.setDefaultPublishableKey("pk_live_B942AayQNOrQl4QBGCdSKdsf")
            
        }
        
        // Here we handle opening the app from a push notification
        
        if let notification = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [String: AnyObject] {
            // 2
            let aps = notification["aps"] as! [String: AnyObject]
            print(aps)
        }
        
        // IQKeyboardManager.sharedManager().enable = true
        
        
        return true
    }
    
    
    // Push notifications
    // =======================
    
    func registerForPushNotifications(_ application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(
            types: [.badge, .sound, .alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != UIUserNotificationType() {
            application.registerForRemoteNotifications()
            
        }
    }
    
    // After registration
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenChars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
        var tokenString = ""
        
        for i in 0..<deviceToken.count {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        print("Device Token:", tokenString)
        // Set device token string 
        AuthManager.sharedManager.deviceToken = tokenString
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register:", error)
    }
    
    // Once Reveived 
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        let aps = userInfo["aps"] as! [String: AnyObject]
        print(aps)
    }
    
    // App Life Cycle 
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        backgroundedDate = Date()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        if let backgroundedDate = backgroundedDate {
            print(backgroundedDate.timeIntervalSinceNow)
            
            if  backgroundedDate.timeIntervalSinceNow <= -(15 * 60) {

                //  Unauth
                let ref = Firebase(url: "https://cleanswipe.firebaseio.com")
                    
                ref?.unauth()
                window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LandingPageVC")
                window?.makeKeyAndVisible()
            }
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

