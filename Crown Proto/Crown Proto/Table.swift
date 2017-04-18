//
//  Table.swift
//  Crown Proto
//
//  Created by Campbell Brobbel on 12/4/17.
//  Copyright © 2017 Campbell Brobbel. All rights reserved.
//

import Foundation

class Table {
    
    private var tableNumber : String!
    private var dealer : Dealer!
    private var beaconMajor : Int!
    private var beaconMinor : Int!
    
    init(tableNumber : String, dealerName : String, major : Int, minor : Int) {
        self.tableNumber = tableNumber
        self.dealer = Dealer(name: dealerName)
        self.beaconMajor = major
        self.beaconMinor = minor
    }
    
    public func getMajor() -> Int {
        return self.beaconMajor
    }
    public func getMinor() -> Int {
        return self.beaconMinor
    }
    public func getTableNumber() -> String {
        return self.tableNumber
    }
    public func getDealerName() -> String {
        return self.dealer.getName()
    }
    public func matchTableBy(major : Int, minor : Int) -> Bool {
        if (major == self.getMajor() && minor == self.getMinor()) {
            return true
        }
        return false
    }
    
}
