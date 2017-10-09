//
//  WeatherCollectionViewCell.swift
//  Weather
//
//  Created by David Weldon on 09/10/2017.
//  Copyright © 2017 nsdave. All rights reserved.
//

import UIKit
import SDWebImage

class WeatherCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherTypeImageView: UIImageView!
    
    fileprivate var dateFormatter = DateFormatter()
    
    func configure(with weather: Weather) {
        dateFormatter.dateFormat = "EEE, dd MMM yyyy hh:mm"
        dateFormatter.locale = Locale.init(identifier: "en_GB")
        dateLabel.text = dateFormatter.string(from: weather.date)
        
        temperatureLabel.text = String(format: "%.1f℃\n%.1f℃\n%.1f℃\n%d\n%.1fkph",
                                       weather.temp ?? 0,
                                       weather.tempMin ?? 0,
                                       weather.tempMax ?? 0,
                                       weather.humidity ?? 0,
                                       weather.windSpeed ?? 0) // dont assume 0 in a production app
        
        if let iconURL = weather.type?.first?.iconURL {
            weatherTypeImageView.sd_setImage(with: iconURL,
                                             completed: nil)
        }

    }

    override func prepareForReuse() {
        super.prepareForReuse()
        dateLabel.text = ""
    }
    
}
