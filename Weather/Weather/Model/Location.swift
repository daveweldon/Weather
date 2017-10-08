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
