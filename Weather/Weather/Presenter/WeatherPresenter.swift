//
//  WeatherPresenter.swift
//  Weather
//
//  Created by David Weldon on 09/10/2017.
//  Copyright © 2017 nsdave. All rights reserved.
//

import Foundation

protocol PresenterView {
    func present(_ error: Error)
}

protocol WeatherView: PresenterView {
    func startLoading()
    func finishLoading()
    func set(forecast: Forecast?)
}

class WeatherPresenter {

    fileprivate var weatherView: WeatherView?
    
    init(weatherView: WeatherView) {
        self.weatherView = weatherView
    }
    
    func search(locationId: Int) {
        weatherView?.startLoading()
        DataRequest.forecast(with: locationId) { [weak self] forecast, error in
            guard let strongSelf = self else { return }
            strongSelf.weatherView?.finishLoading()
            
            if let error = error {
                strongSelf.weatherView?.present(error)
            }
            
            strongSelf.weatherView?.set(forecast: forecast)
        }
    }

}
