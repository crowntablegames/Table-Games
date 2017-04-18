//
//  TestViewController.swift
//  Crown Proto
//
//  Created by Campbell Brobbel on 12/4/17.
//  Copyright © 2017 Campbell Brobbel. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation


class TestViewController: UIViewController {

    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var dealerLabel: UILabel!
    
    @IBAction func buttonPress(_ sender: Any) {
    
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "surveyController") as! SurveyViewController
        
        self.present(vc, animated: true, completion: nil)
    }

    var lastNotificationDate : Date?
    
    // Interval is represented in seconds.
    var intervalBetweenNotifications : TimeInterval = TimeInterval(exactly: 7200.00)!
    
    var beaconManager: CLLocationManager = CLLocationManager()
    
    var tableBeacon : CLBeacon?
    
    var playerTable : Table?
    
    var tableInRange = false
    var playerAtTable : Bool = false
    var tables : [Table] = []
    let proxID : String = (UIApplication.shared.delegate as! AppDelegate).proxID

    var timer : Timer?
    var seconds : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTables()
        beaconManager.delegate = self
        setupBeaconManager()
    }
    
    // MARK: - Beacon Manager Delegate
    
    func setupBeaconManager() {
        self.beaconManager.desiredAccuracy = kCLLocationAccuracyBest
        //self.beaconManager.requestAlwaysAuthorization()
        self.beaconManager.startUpdatingLocation()
        self.beaconManager.allowsBackgroundLocationUpdates = true
        let region : CLBeaconRegion = CLBeaconRegion(proximityUUID: UUID(uuidString: proxID)!, identifier: "TEST")
        self.beaconManager.startRangingBeacons(in: region)
    }
    
    func showSurvey() {
        if isLoggedIn() {
            perform(#selector(showSurveyController), with: nil, afterDelay: 0.01)
        }
    }
    
    func showSurveyController() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "surveyController") as! SurveyViewController
        vc.playerTable = self.playerTable
        present(vc, animated: true, completion: nil)
    }
    
    func isLoggedIn() -> Bool {
        let del = UIApplication.shared.delegate as! AppDelegate
        return del.launchSurveyWindow
    }
    
    
    
    func changeLabels(beacon : CLBeacon) {
        for table in tables {
            if(table.getMajor() == beacon.major.intValue
                && table.getMinor() == beacon.minor.intValue) {
                self.idLabel.text = table.getTableNumber()
            }
            
        }
        
    }
    func setupTables() -> Void {
        
        //Candy
        let table1 = Table(tableNumber: "2412", dealerName: "Candy", major: 48476, minor: 56089)
        //Lemon
        let table2 = Table(tableNumber: "2413", dealerName: "Lemon", major: 48476, minor: 28165)
        //Beetroot
        let table3 = Table(tableNumber: "2414", dealerName: "Ice", major: 2651, minor: 58570)
        //Blueberry
        let table4 = Table(tableNumber: "2415", dealerName: "Blueberry", major: 23011, minor: 17764)
        
        tables.append(table1)
        tables.append(table2)
        tables.append(table3)
        tables.append(table4)
        
    }
    
    func timerFunc() -> Void {
        seconds += 1
    }


    
}

extension TestViewController : CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.unknown}
        print(knownBeacons)
        if(knownBeacons.count > 0) {
            
            if (tableBeacon != nil) {
                
                if (!playerAtTable) {
                    timerFunc()
                    if (seconds == 4) {
                        //Compare the stored Beacon with the first beacon in the array
                        //If beacon is the same as beacons[0] then player is now at the table.
                        
                        if (tableBeacon!.major == knownBeacons.first!.major && tableBeacon!.minor == knownBeacons.first!.minor) {
                            print("Player is at table")
                            print(tableBeacon ?? "nil")
                            print("---------")
                           
                            
                            for t in tables {
                                if(t.matchTableBy(major: tableBeacon!.major.intValue, minor: tableBeacon!.minor.intValue)) {
                                    idLabel.text = "Table: \(t.getTableNumber())"
                                    //pushNotification(identifier: "tableArrival", bodyString: "Arriving at table \(t.getTableNumber())")

                                    dealerLabel.text = "Dealer: \(t.getDealerName())"
                                    playerTable = t
                                }
                            }
                            playerAtTable = true
                            seconds = 0
                        }
                        else {
                            print("Table Not Connected")
                            tableBeacon = nil
                            seconds = 0
                            
                        }
                        
                        
                    }
                    else {
                        // Hasn't reached 10 seconds yet.
                    }
                }
                else {
                    // Player is at the table
                    
                    if(knownBeacons.first!.major == tableBeacon!.major && knownBeacons.first!.minor == tableBeacon!.minor) {
                        
                        tableInRange = true
                        seconds = 0
                        print("Player Still at table")
                        // Player is still at table
                        
                    }
                    else {
                        tableInRange = false;
                    }
                    
                    if(!tableInRange) {
                        print("Table going out of range")
                        timerFunc()
                        
                        if(knownBeacons.first!.major == tableBeacon!.major && knownBeacons.first!.minor == tableBeacon!.minor) {
                            tableInRange = true
                            seconds = 0
                            print("Player Back at table")
                            
                            // Player is still at table
                            
                        }
                        else if(seconds == 10){
                            print("Player Left Table")
                            tableBeacon = nil
                            seconds = 0
                            playerAtTable = false
                            tableBeacon = nil
                            idLabel.text = "No Table"
                            dealerLabel.text = "No dealer"
                            
                            let currentTime = Date()
                            
                            if (lastNotificationDate == nil) {
                                pushNotification(identifier: "surveyRequest", bodyString: "We want you to tell us what you think of our service.")
                                lastNotificationDate = Date()
                            }
                            else {
                                
                                let timeSinceLastNotification = currentTime.timeIntervalSince(lastNotificationDate!)
                                print(timeSinceLastNotification)
                                if (intervalBetweenNotifications < timeSinceLastNotification)  {
                                    pushNotification(identifier: "surveyRequest", bodyString: "We want you to tell us what you think of our service.")
                                    lastNotificationDate = Date()
                                }
                                else {
                                    print("Not enough time between last notification")
                                }
                            }
                            
                            
//
                            

                        }
                        else {
                            //Do Nothing
                        }
                        
                    }
                    else {
                        // Table is still the first on the list
                    }
                }
                
            }
            else {
                tableBeacon = knownBeacons.first! as CLBeacon
                
            }
            
        }
        else {
            if(playerAtTable) {
                print("Table going out of range")
                timerFunc()
                
                if(seconds == 5){
                    print("Player Left Table")
                    tableBeacon = nil
                    seconds = 0
                    playerAtTable = false
                    tableBeacon = nil
                    idLabel.text = "No Table"
                    dealerLabel.text = "No dealer"
                }
                else {
                    //Do Nothing
                }
                
            }
            else {
                // Table is still the first on the list
                tableInRange = true
            }

        }
    }
    public func pushNotification(identifier : String, bodyString : String) {
        
        let content = initPushNotification(tableString: bodyString)
        // Deliver the notification in five seconds.
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        
        center.add(request) { (error : Error?) in
            if let theError = error {
                print("theError \(theError)")
            }
        }
    }
    
    
    func initPushNotification(tableString : String) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        
        content.title = "Crown Entertainment"
        content.body = tableString
        content.sound = UNNotificationSound.default()
        print("Welcome Notification")
        //content.categoryIdentifier = "exitRegionNotification"
        
        return content
    }
    
}
