//
//  WeatherController.swift
//  MyWeatherForecast
//
//  Created by vasadulin on 16.09.2018.
//  Copyright © 2018 Asadulinz Software. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit
import RealmSwift

class WeatherController {
    
    var forecastDataSource: ForecastDataSource //UICollectionViewDataSource
    
    init() {
        self.forecastDataSource = ForecastDataSource()
    }
    
    func sendRequestForecast(limit: UInt, completion: (()->())? = nil) {
        
        print(#function)
        
        let apiCall: Promise<String> = NetworkService.shared.fetchForecast(cityName: Config.cityName, limit: limit)
        
        apiCall.then { [weak self]
            (responseString: String) -> Void in
            
            self?.forecastDataSource.setForecastData(responseString: responseString)
            
            completion?()
            
        }.catch { error-> Void in
                print("promice error: \(error)")
        }
    }
    
    func textDescriptionWeatherItem(index: Int) -> String {

        let weatherItem = forecastDataSource.forecastItems[index]
        let  result: String = """
        Data: \(weatherItem.dt_txt)
        Temp: \(weatherItem.main.temp),  Humidity: \(weatherItem.main.humidity)
        Pressure: \(weatherItem.main.pressure), Wind speed: \(weatherItem.wind.speed)
        Description: \(weatherItem.weather[0].descriptionText)
        """
        return result
    }
    
}
