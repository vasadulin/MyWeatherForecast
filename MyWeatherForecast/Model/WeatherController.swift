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
    
    var forecastDataSource: UICollectionViewDataSource
    
    init() {
        self.forecastDataSource = ForecastDataSource()
    }
    
    func sendRequestForecast(limit: UInt, completion: (()->())? = nil) {
        
        print(#function)
        
        let apiCall: Promise<[WeatherForecastItem]> = NetworkService.fetchForecast(cityName: Config.cityName, limit: limit)
        
        apiCall.then { //[weak self]
            (forecastList: [WeatherForecastItem]) -> Void in
            //TODO: использовтать forecastList
//            self?.dataSourceArray = forecastList
//            self?.tableView.reloadData()
            completion?()
            
        }.catch { error-> Void in
                print("promice error: \(error)")
        }
    }
}
