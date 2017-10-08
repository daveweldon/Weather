//
//  Forecast.swift
//  Weather
//
//  Created by David Weldon on 08/10/2017.
//  Copyright © 2017 nsdave. All rights reserved.
//

import Foundation
import ObjectMapper

class Forecast: Mappable {
    var cnt: Int?
    var list: [Weather]?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        cnt     <- map["cnt"]
        list    <- map["list"]
    }

}

class Weather: Mappable {
    fileprivate var rawDate: Double?
    var date: Date {
        return Date()
    }
    var temp: Float?
    var tempMin: Float?
    var tempMax: Float?
    var humidity: Int?
    var windSpeed: Float?
    var type: [WeatherType]?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        rawDate     <- map["dt"]
        temp        <- map["main.temp"]
        tempMin     <- map["main.temp_min"]
        tempMax     <- map["main.temp_max"]
        humidity    <- map["main.humidity"]
        windSpeed   <- map["wind.speed"]
        type        <- map["weather"]
    }
}

class WeatherType: Mappable {
    var main: String?
    var desc: String?
    var icon: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        main        <- map["main"]
        desc        <- map["description"]
        icon        <- map["icon"]
    }
}
