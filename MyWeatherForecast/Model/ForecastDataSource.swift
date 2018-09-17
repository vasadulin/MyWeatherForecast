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

class ForecastDataSource: NSObject, UICollectionViewDataSource {
    
    var realm: Realm
    
    override init() {
        realm = try! Realm()
        super.init()
    }
    
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
}
