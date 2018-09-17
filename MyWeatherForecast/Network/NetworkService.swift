//
//  NetworkService.swift
//  MyWeatherForecast
//
//  Created by vasadulin on 16.09.2018.
//  Copyright © 2018 Asadulinz Software. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit
import RealmSwift

//  h ttp://api.openweathermap.org/data/2.5/forecast?q=Dnipro&cnt=20&units=metric&lang=ru&appid=d7d6d9c6a5f8122c238b6e94aab7c1ce

class NetworkService {
    
    class func fetchForecast(cityName: String, limit cnt: UInt)-> Promise<[WeatherForecastItem]> {
        //TODO: переделать на нормальное формироввание URL
        let requestUrl = "\(Config.baseUrl)\(Config.apiForecast)?units=metric&q=\(cityName)&cnt=\(cnt)&appid=\(Config.appId)"
        
        return Promise<[WeatherForecastItem]> {
            (fullfil, reject) -> Void in
            
            //TODO: переделать responseString->responseJSON
            return Alamofire.request(requestUrl).responseString(completionHandler: { (responseJSON) in
   
                switch(responseJSON.result) {
                case .success(let responseString):
                    //print("responseString: \(responseString)<<<")
                    let forecastResponse: WeatherForecastResponse = WeatherForecastResponse(JSONString: "\(responseString)")! //TODO: переделать responseString->responseJSON
                    //print("forecastResponse: \(forecastResponse)")
                    //let forecastResponse: WeatherForecastResponse = WeatherForecastResponse(value: responseString)
                    let forecastArray: [WeatherForecastItem] = Array(forecastResponse.forecastList)
                    print("forecastArray.count: \(forecastArray.count)")
                    fullfil(forecastArray)
                    
                    //----- записываем данне в Realm  ----
                    do {
                        let realm = try Realm()
                        try realm.write {
                            
                            realm.deleteAll() //удаляем все перед добавлением
                            //добавляем новые записи в Realm
                            for weatherItem in forecastArray {
                                realm.add(weatherItem, update: false)//можно update: true, если у weatherItem есть primaryKey
                            }
                        }
                    } catch let error as NSError {
                        print("realm error: \(error)")
                    }
                    //----- конец записи в Realm  ----
                case .failure(let error):
                    print("alamofire error: \(error)")
                    reject(error)
                }
            })
            
        }
    }
}
