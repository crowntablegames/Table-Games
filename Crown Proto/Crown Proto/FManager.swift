//
//  FManager.swift
//  
//
//  Created by Campbell Brobbel on 13/4/17.
//
//

import Foundation


class FManager {
    
    var manager : FileManager = FileManager()
    
    init() {
        let contents = manager.contents(atPath: "tableInfo.txt")
        print(contents ?? "nil")
    }
    
    
    
}
