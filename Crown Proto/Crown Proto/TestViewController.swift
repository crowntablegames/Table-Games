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
    var tableInRange : Bool?
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
        //beaconManager.stopRangingBeacons(in: region)
        

    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.unknown}
        
        if(knownBeacons.count > 0) {
            for b in knownBeacons {
                print(b)
            }
            print("-------")
            
            if (tableBeacon != nil) {
                tableInRange = false
                for b in knownBeacons {
                    if(b.isEqual(tableBeacon)) {
                        tableInRange = true
                    }
                }
                
                if(!tableInRange!) {
                    // Set off timer. When timer is complete trigger notification and set beacon to nil
                    let region = CLBeaconRegion(proximityUUID: UUID(uuidString: proxID)!, identifier: "TEST")
                    //beaconManager.stopRangingBeacons(in: region)
                    //timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerFunc), userInfo: nil, repeats: true)
                    print("Table Beacon Gone Out Of Range. Start Timer")
                    
                }
                else {
                    tableInRange = true
                    print("Table Is Still in Range")
                }
                
                // Otherwise continue Ranging
            }
            else {
                //tableBeacon = beacons.first! as CLBeacon
                //changeLabels(beacon: tableBeacon!)
                //print("Table Beacon : \(tableBeacon)")
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
        
        let table1 = Table(tableNumber: "2412", dealerName: "Campbell", major: 48476, minor: 56089)
        let table2 = Table(tableNumber: "2413", dealerName: "Seth", major: 48476, minor: 28165)
        
        tables.append(table1)
        tables.append(table2)
        
    }
    
    func timerFunc() -> Void {
        timerLabel.text = seconds.description
        seconds += 1
    }

   public func playerDidLeaveTable() {
        let content = UNMutableNotificationContent()
        
        content.title = "Crown Entertainment"
        content.body = "We want you to tell us what you think of our service."
        content.sound = UNNotificationSound.default()
        print("enterNotification")
        content.categoryIdentifier = "exitRegionNotification"
        
        // Deliver the notification in five seconds.
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0, repeats: false)
        let request = UNNotificationRequest(identifier: "finishRedeemingPoints", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        
        center.add(request) { (error : Error?) in
            if let theError = error {
                print("theError \(theError)")
            }
        }
    }
    
}
