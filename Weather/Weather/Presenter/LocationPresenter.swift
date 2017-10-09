//
//  LocationPresenter.swift
//  Weather
//
//  Created by David Weldon on 09/10/2017.
//  Copyright © 2017 nsdave. All rights reserved.
//

import Foundation
import RealmSwift

protocol LocationView {
    func set(locations: [Location])
}

class LocationPresenter {
    
    fileprivate var locationView: LocationView
    fileprivate var searchText = ""
    fileprivate var realm: Realm
    
    init(locationView: LocationView) {
        self.locationView = locationView
        
        let config = Realm.Configuration(
            fileURL: Bundle.main.url(forResource: "city.list", withExtension: "realm"),
            readOnly: true)
        realm = try! Realm(configuration: config)
    }
    
    func searchTerm(_ text: String?) {
        self.searchText = text ?? ""
        updateLocations()
    }

    // with more time, dispactch searching on a background thread
    // passing realm across boundaries with ThreadSafeReference()
    fileprivate func updateLocations() {
        var locations = realm.objects(Location.self)
        
        if searchText != "" {
            locations = realm.objects(Location.self).filter("name BEGINSWITH[c] '\(searchText)'")
        }

        let locationArray = Array(locations.sorted(byKeyPath: "name", ascending: true))
        locationView.set(locations: locationArray)
    }

}
