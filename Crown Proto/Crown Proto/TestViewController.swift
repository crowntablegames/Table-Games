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

class TestViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    var beaconManager : CLLocationManager = CLLocationManager()
    let proxID : String = "B9407F30-F5F8-466E-AFF9-25556B57FE6E"
    var tableBeacon : CLBeacon?
    
    var tableInRange = false
    var playerAtTable : Bool = false
    var tables : [Table] = []
    
    var timer : Timer?
    var seconds : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTables()
        self.beaconManager.delegate = self
        self.beaconManager.requestAlwaysAuthorization()
        

        let region : CLBeaconRegion = CLBeaconRegion(proximityUUID: UUID(uuidString: proxID)!, identifier: "TEST")
        beaconManager.startRangingBeacons(in: region)

    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.unknown}
        
        if(knownBeacons.count > 0) {
            
            if (tableBeacon != nil) {
    
                if (!playerAtTable) {
                    timerFunc()
                    if (seconds == 10) {
                        //Compare the stored Beacon with the first beacon in the array
                        //If beacon is the same as beacons[0] then player is now at the table.
                        
                        if (tableBeacon!.major == knownBeacons.first!.major && tableBeacon!.minor == knownBeacons.first!.minor) {
                            print("Player is at table")
                            print(tableBeacon)
                            print("---------")
                            playerAtTable = true
                            seconds = 0
                            timerLabel.text = "\(seconds)"
                        }
                        else {
                            print("Table Not Connected")
                            tableBeacon = nil
                            seconds = 0
                            timerLabel.text = "\(seconds)"

                        }
                    
                    }
                    else {
                        // Hasn't reached 10 seconds yet.
                    }
                }
                else {
                    // Player is at the table
                    
                    if(beacons.first!.major == tableBeacon!.major && beacons.first!.minor == tableBeacon!.minor) {
                            tableInRange = true
                            seconds = 0
                            timerLabel.text = "\(seconds)"
                            print("Player Still at table")
                         // Player is still at table
                            
                    }
                    else {
                        tableInRange = false;
                    }
                    
                    if(!tableInRange) {
                        print("Table going out of range")
                        timerFunc()
                        
                            if(beacons.first!.major == tableBeacon!.major && beacons.first!.minor == tableBeacon!.minor) {
                                tableInRange = true
                                seconds = 0
                                timerLabel.text = "\(seconds)"
                                print("Player Back at table")
                                
                                // Player is still at table
                                
                            }
                            else if(seconds == 10){
                                print("Player Left Table")
                                tableBeacon = nil
                                seconds = 0
                                timerLabel.text = "\(seconds)"
                                playerAtTable = false
                                tableBeacon = nil
                                playerDidLeaveTable()
                            }
                            else {
                                //Do Nothing
                            }
                        
                    }
                    else {
                        // Table is still the first on the list
                    }
                }
                
                // Otherwise continue Ranging
            }
            else {
                tableBeacon = beacons.first! as CLBeacon

            }
            
        }
        else {
            print("No Beacons")
            print("_______")
        }
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
        let table1 = Table(tableNumber: "2412", dealerName: "Campbell", major: 48476, minor: 56089)
        //Lemon
        let table2 = Table(tableNumber: "2413", dealerName: "Seth", major: 48476, minor: 28165)
        
        
        tables.append(table1)
        tables.append(table2)
        
    }
    
    func timerFunc() -> Void {
        seconds += 1
        timerLabel.text = seconds.description
    }

   public func playerDidLeaveTable() {
        let content = UNMutableNotificationContent()
        
        content.title = "Crown Entertainment"
        content.body = "We want you to tell us what you think of our service."
        content.sound = UNNotificationSound.default()
        print("enterNotification")
        content.categoryIdentifier = "exitRegionNotification"
        
        // Deliver the notification in five seconds.
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "finishRedeemingPoints", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        
        center.add(request) { (error : Error?) in
            if let theError = error {
                print("theError \(theError)")
            }
        }
    }
    
}
