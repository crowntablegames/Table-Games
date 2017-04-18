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

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, CLLocationManagerDelegate {
    
    
    var window: UIWindow?
    var launchSurveyWindow : Bool = true
    var playerTable : Table?

    
    let proxID : String = "B9407F30-F5F8-466E-AFF9-25556B57FE6E"
    //let proxID : String = "8492E75F-4FD6-469D-B132-043FE94921D8"
    var locationManager : CLLocationManager = CLLocationManager()
    // 2. Add a property to hold the beacon manager and instantiate it
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupLocationManager()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        let mainController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homeScreen") as! TestViewController
        window?.rootViewController = mainController
        
        //Allows access for notificationss
        let center = UNUserNotificationCenter.current()
        UNUserNotificationCenter.current().delegate = self
        let options: UNAuthorizationOptions = [.alert, .sound, .badge];
        center.requestAuthorization(options: options) { (granted, error) in
            if (!granted) {
                print("Something went wrong")
            }
        }
                
        let bool = true
        if bool {
            
        }
        
        return true
    }
    
    
   
   // MARK: - App Delegate Methods
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
    
    // MARK: - Location Manager Delegate
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entering Region")
        pushWelcomeNotification()
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exiting Region")
        pushLeavingNotification()
        
    }
    
    // MARK: - Notification Centre
    
    //Present the notification to the user
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Play sound and show alert to the user
        
        completionHandler([.alert, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if (response.notification.request.identifier == "surveyRequest") {
            let vc = window?.rootViewController as! TestViewController
            vc.showSurvey()
        }
        print("Notification")
    }
    
    public func pushLeavingNotification() {
        
        let content = initLeavingNotif()
        // Deliver the notification in five seconds.
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "surveyRequest", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        
        center.add(request) { (error : Error?) in
            if let theError = error {
                print("theError \(theError)")
            }
        }
    }
    
    func initLeavingNotif() -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        
        content.title = "Crown Entertainment"
        content.body = "We want you to tell us what you think of our service."
        content.sound = UNNotificationSound.default()
        print("enterNotification")
        //content.categoryIdentifier = "exitRegionNotification"
        
        return content
    }
    
    public func pushWelcomeNotification() {
        
        let content = initWelcomeNotif()
        // Deliver the notification in five seconds.
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "welcome", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        
        center.add(request) { (error : Error?) in
            if let theError = error {
                print("theError \(theError)")
            }
        }
    }
    
    func initWelcomeNotif() -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        
        content.title = "Crown Entertainment"
        content.body = "Welcome To Crown Melbourne."
        content.sound = UNNotificationSound.default()
        print("Welcome Notification")
        //content.categoryIdentifier = "exitRegionNotification"
        
        return content
    }
    
    // MARK: - Other Methods
    
    func setupLocationManager() {
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        let newRegion : CLBeaconRegion = CLBeaconRegion(proximityUUID: UUID(uuidString: proxID)!, identifier: "TEST")
        self.locationManager.startMonitoring(for: newRegion)
        
    }
    
    
    
}



