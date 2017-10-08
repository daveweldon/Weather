//
//  Location.swift
//  Weather
//
//  Created by David Weldon on 08/10/2017.
//  Copyright © 2017 nsdave. All rights reserved.
//

import Foundation
import RealmSwift

class Location: Object {
    let locationId = RealmOptional<Int>()
    @objc dynamic var name: String = ""
    @objc dynamic var country: String = ""
}

//    {
//    "id": 707860,
//    "name": "Hurzuf",
//    "country": "UA",
//    "coord": {
//    "lon": 34.283333,
//    "lat": 44.549999
//    }
//    }
