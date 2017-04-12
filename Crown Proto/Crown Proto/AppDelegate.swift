//
//  AppDelegate.swift
//  EstimoteBeacons
//
//  Created by Seth Jacobs on 11/4/17.
//  Copyright © 2017 SquarePlayground. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
//ESTBeaconManagerDelegate added for Estimote SDK whilst UNUserNotificationCenterDelegate used for new iOS Notifications
class AppDelegate: UIResponder, UIApplicationDelegate, ESTBeaconManagerDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    // 2. Add a property to hold the beacon manager and instantiate it
    let beaconManager = ESTBeaconManager()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        /* Currently not working
         func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject: AnyObject], didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
         //Implementation of notification -> Survey functionality
         let storyboard = UIStoryboard(name: "main.storyboard", bundle: nil)
         let rootVC = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! UITabBarController
         
         rootVC.selectedIndex = 2 // Index of the tab bar item you want to present, as shown in question it seems is item 2
         self.window!.rootViewController = rootVC
         */
        
        
        
        
        
        // 3. Set the beacon manager's delegate
        self.beaconManager.delegate = self
        
        // Requests authorization for iBeacon functionality:
        self.beaconManager.requestAlwaysAuthorization()
        
        // Start monitoring a specific beacon (Add more later):
        self.beaconManager.startMonitoring(for: CLBeaconRegion(
            proximityUUID: UUID(uuidString: "8492E75F-4FD6-469D-B132-043FE94921D8")!,
            major:0, minor:19987, identifier: "monitored region"))
        // Override point for customization after application launch.
        
        //Allows access for notifications updated for iOS10
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        let options: UNAuthorizationOptions = [.alert, .sound];
        center.requestAuthorization(options: options) {
            (granted, error) in
            if !granted {
                print("Something went wrong")
            }
        }
        
        return true
    }
    //Present the notification to the user
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Play sound and show alert to the user
        completionHandler([.alert,.sound])
    }
    //
    
    //function for when you enter the range of a beacon (Starting the session if you will)
    func beaconManager(_ manager: Any, didEnter region: CLBeaconRegion) {
        let content = UNMutableNotificationContent()
        
        content.title = "Crown Entertainment"
        content.body = "Welcome to Crown!"
        content.sound = UNNotificationSound.default()
        
        //make sure to assign the correct category identifier
        content.categoryIdentifier = "enterRegionNotification"
        
        // Deliver the notification in five seconds.
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "startRedeemingPoints", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        
        center.add(request) { (error : Error?) in
            if let theError = error {
                print("theError \(theError)")
            }
        }
    }
    /*
     //function for when you leave the range of a beacon (Starting the session if you will)
     func beaconManager(_manager: Any, didExitRegion region: CLBeaconRegion) {
     let content = UNMutableNotificationContent()
     
     content.title = "Crown Entertainment"
     content.body = "Have a second to complete a customer satisfaction survey?"
     content.sound = UNNotificationSound.default()
     
     //make sure to assign the correct category identifier
     content.categoryIdentifier = "exitRegionNotification"
     
     // Deliver the notification in five seconds.
     let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
     let request = UNNotificationRequest(identifier: "promptSurvey", content: content, trigger: trigger)
     let center = UNUserNotificationCenter.current()
     
     center.add(request) { (error : Error?) in
     if let theError = error {
     print("theError \(theError)")
     }
     }
     }
     */
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
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}



