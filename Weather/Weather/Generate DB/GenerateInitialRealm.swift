//
//  GenerateInitialRealm.swift
//  Weather
//
//  Created by David Weldon on 08/10/2017.
//  Copyright © 2017 nsdave. All rights reserved.
//

import Foundation
import RealmSwift

class GenerateInitialRealm {
    
    static func location(with path: String) {
        let realm = try! Realm()
        let fm = FileManager.default
        let docsurl = try! fm.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let realmPath = docsurl.appendingPathComponent("default-compact.realm")
        var recordCount = 0
        
        // remove any existing values (we dont want duplicates)
        try! realm.write {
            realm.deleteAll()
        }
        
        // write the new values to the database
        do {
            let jsonData = try NSData(contentsOfFile: path, options: NSData.ReadingOptions.mappedIfSafe)
            do {
                let jsonResult: NSArray = try JSONSerialization.jsonObject(with: jsonData as Data,
                                                                           options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                recordCount = jsonResult.count
                
                for location in jsonResult {
                    if let location = location as? [String:AnyObject],
                        let locationId = location["id"] as? Int,
                        let name = location["name"] as? String,
                        let country = location["country"] as? String {
                        
                        let newLocation = Location()
                        newLocation.locationId.value = locationId
                        newLocation.name = name
                        newLocation.country = country
                        
                        try! realm.write {
                            realm.add(newLocation)
                        }
                    }
                }
                
            } catch {}
        } catch {}
    
        // copy the file somewhere else, so that a smaller
        // file can be bundled with the app
        try! realm.writeCopy(toFile: realmPath) catch { print("error copying realm database") }
        
        print("• attempted to import \(recordCount) records.\n• copied to path \(realmPath)")
    }
}
