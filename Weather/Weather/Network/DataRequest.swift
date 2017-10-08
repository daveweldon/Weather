//
//  DataRequest.swift
//  Weather
//
//  Created by David Weldon on 08/10/2017.
//  Copyright © 2017 nsdave. All rights reserved.
//

import Foundation

fileprivate let apiKey = "816287136a0140daed993a38804be8a2"

enum RequestType: String {
    case forecast = "forecast"
    
    func url(with queryItems: [URLQueryItem]) -> URL?  {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/\(self.rawValue)"
        components.queryItems = queryItems
        components.queryItems?.append(URLQueryItem(name: "APPID", value: apiKey))
        return components.url
    }
}

class DataRequest {
    
    static func forecast(with locationId: Int, completion: @escaping (Forecast)->Void) {
        let query = URLQueryItem(name: "id", value: "\(locationId)")
        
        request(with: .forecast, queryItems: [query], completion: { json in
            if let nowPlaying = Forecast(JSONString: json) {
                completion(nowPlaying)
            }
        })
    }
    
    static private func request(with type: RequestType, queryItems: [URLQueryItem], completion: @escaping (String)->Void) {
        guard let url = type.url(with: queryItems) else { return }
        print(url.absoluteString)
        _ = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                /* handle technical aspects of error here and,
                 afterwards, pass a user friendly error back
                 to the UI to be displayed to the user */
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                // send a human friendly error back to the UI
                return
            }
            
            switch response.statusCode {
            case 200:
                if let data = data, let jsonString = String(data: data, encoding: String.Encoding.utf8) {
                    DispatchQueue.main.async(execute: {
                        completion(jsonString) // Might want to move the parsing to another thread
                    })
                }
                return
            case 401, 404:
                // send a human friendly error back to the UI
                return
            default:
                return
            }
            
        }.resume()
    }

}
