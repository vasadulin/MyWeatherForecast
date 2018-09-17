//
//  ForecastViewCell.swift
//  MyWeatherForecast
//
//  Created by vasadulin on 16.09.2018.
//  Copyright © 2018 Asadulinz Software. All rights reserved.
//

import UIKit
import AlamofireImage

class ForecastViewCell: UICollectionViewCell {
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var iconImage: UIImageView!
    
    func updateWith(forecastItem item: WeatherForecastItem) {
        dateTimeLabel.text = item.dt_txt
        temperatureLabel.text = "Temp: \(item.main.temp)\nHumidity: \(item.main.humidity)%"
        descriptionLabel.text = "Description: \(item.weather[0].descriptionText)"

        let iconUrl = URL(string: Config.baseImageUrl + item.weather[0].icon + ".png")!
        iconImage.af_setImage(withURL: iconUrl,
                              placeholderImage: UIImage(named: Config.defaultWeatherIcon),
                              completion: nil)
    }
    
}
