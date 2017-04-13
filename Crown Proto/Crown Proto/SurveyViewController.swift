//
//  SurveyViewController.swift
//  Crown Proto
//
//  Created by Seth Jacobs on 13/4/17.
//  Copyright © 2017 Campbell Brobbel. All rights reserved.
//


import UIKit
import UserNotifications
import CoreLocation

class SurveyViewController: ViewController {
        
        
        override func viewDidLoad() {
            super.viewDidLoad()

            
            
           NotificationCenter.default.post(NSNotification(name: NSNotification.Name(rawValue: "segue"), object: nil) as Notification)
            // Do any additional setup after loading the view, typically from a nib.
        }
        
        
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        
        
        
        
}
    
    
