//
//  WeatherError.swift
//  Weather
//
//  Created by David Weldon on 08/10/2017.
//  Copyright © 2017 nsdave. All rights reserved.
//

import Foundation

fileprivate let errorDomain = "WeatherError"

enum WeatherError: Int {
    case unknownError = 0,
    notFound

    init(_ serverCode: Int) {
        switch serverCode {
        case 404:
            self = .notFound
        default:
            self = .unknownError
        }
    }

    var error: Error {
        switch self {
        case .notFound:
            let userInfo = [ NSLocalizedDescriptionKey: NSLocalizedString("Not found", value: "An error occurred retrieving data", comment: ""),
                             NSLocalizedFailureReasonErrorKey: NSLocalizedString("Resource not found", value: "Check that the resource is still available at this location", comment: "")]
            return NSError(domain: errorDomain, code: -51, userInfo: userInfo)
        default:
            let userInfo = [ NSLocalizedDescriptionKey: NSLocalizedString("Unknown", value: "An unknown error occurred", comment: "")]
            return NSError(domain: errorDomain, code: -50, userInfo: userInfo)

        }
    }
}
