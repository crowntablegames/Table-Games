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
    
    var beaconManager: CLLocationManager = CLLocationManager()
    
    var tableBeacon : CLBeacon?
    
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
        
        let region : CLBeaconRegion = CLBeaconRegion(proximityUUID: UUID(uuidString: proxID)!, identifier: "TEST")
        self.beaconManager.startRangingBeacons(in: region)
    }
    
    func showSurvey() {
        if isLoggedIn() {
            perform(#selector(showSurveyController), with: nil, afterDelay: 0.01)
        }
    }
    
    func showSurveyController() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "surveyController")
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
        
        
        tables.append(table1)
        tables.append(table2)
        
    }
    
    func timerFunc() -> Void {
        seconds += 1
    }


    
}

extension TestViewController : CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        print(beacons)
        //manager.startMonitoring(for: region)
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.unknown}
        
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
                                if(t.getMajor() == tableBeacon!.major.intValue && t.getMinor() == tableBeacon!.minor.intValue) {
                                    idLabel.text = "Table: \(t.getTableNumber())"
                                    dealerLabel.text = "Dealer: \(t.getDealerName())"
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
                    
                    if(beacons.first!.major == tableBeacon!.major && beacons.first!.minor == tableBeacon!.minor) {
                        
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
                        
                        if(beacons.first!.major == tableBeacon!.major && beacons.first!.minor == tableBeacon!.minor) {
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
                tableBeacon = beacons.first! as CLBeacon
                
            }
            
        }
        else {
            if(playerAtTable) {
                print("Table going out of range")
                timerFunc()
                
                if(seconds == 10){
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
    
}
