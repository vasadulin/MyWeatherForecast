//
//  ForecastDataSource.swift
//  MyWeatherForecast
//
//  Created by vasadulin on 16.09.2018.
//  Copyright © 2018 Asadulinz Software. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class ForecastDataSource: NSObject, UICollectionViewDataSource, ChartWrapperDataSource {
    
    
    var realm: Realm
    
    override init() {
        realm = try! Realm()
        super.init()
    }
    
    
    func setForecastData(responseString: String) {
        //Parse
        let forecastResponse: WeatherForecastResponse = WeatherForecastResponse(JSONString: responseString)!
        //print("forecastResponse: \(forecastResponse)")
        
        let forecastArray: [WeatherForecastItem] = Array(forecastResponse.forecastList)
        //print("forecastArray.count: \(forecastArray.count)")
        
        //Сохранить
        self.forecastItems = forecastArray
    }
    
    var forecastItems: [WeatherForecastItem] {
        set (forecastArray) {
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
        }
        get {
            return Array(realm.objects(WeatherForecastItem.self).sorted(byKeyPath: "dt"))
        }
    }

    //Mark: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return realm.objects(WeatherForecastItem.self).count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weatherCellId", for: indexPath) as! ForecastViewCell
        
        //TODO: оптимизировать, чтобы не сортировало каждый раз
        let items = realm.objects(WeatherForecastItem.self).sorted(byKeyPath: "dt")
        let item = items[indexPath.row]
        
        cell.updateWith(forecastItem: item)
        
        return cell
    }
    
    // Mark - ChartWrapperDataSource
    // returns temperature values
    func getPointsArray() -> [Double] {
        let array: [WeatherForecastItem] = Array(realm.objects(WeatherForecastItem.self).sorted(byKeyPath: "dt"))
        var result = [Double]()
        for item in array {
            result.append(item.main.temp)
        }
        
        return result
    }
    
}
