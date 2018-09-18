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
    
    static let shared = NetworkService()
    private init() { }
    
    func fetchForecast(cityName: String, limit cnt: UInt)-> Promise<String> {
        
        let requestUrl = "\(Config.baseUrl)\(Config.apiForecast)"
        
        let parameters: Parameters = ["units": "metric",
                                      "q": cityName,
                                      "cnt": cnt,
                                      "appid": Config.appId]
        
        
        return Promise<String> { (successHandler, errorHandler) -> Void in
            
            return Alamofire.request(requestUrl, parameters: parameters).responseString(completionHandler: { (responseObject) in
            
                switch(responseObject.result) {
                case .success(let responseString):
                    //print("responseString: \(responseString)<<<")
                    
                    successHandler(responseString)
                    
                case .failure(let error):
                    print("alamofire error: \(error)")
                    errorHandler(error)
                }
            })
            
        }
    }
}
