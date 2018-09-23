//
//  WeatherForecastResponse.swift
//  MyWeatherForecast
//
//  Created by vasadulin on 16.09.2018.
//  Copyright © 2018 Asadulinz Software. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class WeatherForecastResponse: Object, Mappable {
    @objc dynamic var cod: String = ""
    @objc dynamic var message: Double = 0
    @objc dynamic var cnt: Int = 0
    @objc dynamic var city: City! = City()
    
    var forecastList = List<WeatherForecastItem>()
    
    //MARK: Mappable
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        cod <- map["cod"]
        message <- map["message"]
        cnt <- map["cnt"]
        forecastList <- (map["list"], ListTransform<WeatherForecastItem>())
    }
}

class City: Object, Mappable {
    @objc dynamic var id: Int64 = 0
    @objc dynamic var name: String = ""
    @objc dynamic var coord: Coordinate! = Coordinate()
    @objc dynamic var country: String = ""
    @objc dynamic var population: Int = 0
    //MARK: Mappable
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        country <- map["country"]
        population <- map["population"]
    }
}

class Coordinate: Object, Mappable {
    var lat: Double = 0
    var lon: Double = 0
    
    //MARK: Mappable
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        lat <- map["lat"]
        lon <- map["lon"]
    }
}

class WeatherForecastItem: Object, Mappable {
    @objc dynamic var dt: Int64 = 0
    @objc dynamic var dt_txt: String = ""
    @objc dynamic var main: WeatherMainItem! = WeatherMainItem()
    @objc dynamic var clouds: CloudsItem! = CloudsItem()
    @objc dynamic var wind: WindItem! = WindItem()
    var weather: List<WeatherViewItem> = List<WeatherViewItem>()
    //MARK: Mappable
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        dt <- map["dt"]
        dt_txt <- map["dt_txt"]
        main <- map["main"]
        clouds <- map["clouds"]
        wind <- map["wind"]
        weather <- (map["weather"], ListTransform<WeatherViewItem>())
    }
}

class WeatherMainItem: Object, Mappable {
    @objc dynamic var temp: Double = 0
    @objc dynamic var temp_min: Double = 0
    @objc dynamic var temp_max: Double = 0
    @objc dynamic var pressure: Double = 0
    @objc dynamic var sea_level: Double = 0
    @objc dynamic var grnd_level: Double = 0
    @objc dynamic var humidity: Double = 0
    @objc dynamic var temp_kf: Double = 0
    
    //MARK: Mappable
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        temp <- map["temp"]
        temp_min <- map["temp_min"]
        temp_max <- map["temp_max"]
        pressure <- map["pressure"]
        sea_level <- map["sea_level"]
        grnd_level <- map["grnd_level"]
        humidity <- map["humidity"]
        temp_kf <- map["temp_kf"]
    }
}

class WeatherViewItem: Object, Mappable {
    @objc dynamic var id: Int = 0
    @objc dynamic var main: String = ""
    @objc dynamic var descriptionText: String = ""
    @objc dynamic var icon: String = ""
    
    //MARK: Mappable
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        main <- map["main"]
        descriptionText <- map["description"]
        icon <- map["icon"]
    }
}

class CloudsItem: Object, Mappable {
    @objc dynamic var all: Double = 0
    
    //MARK: Mappable
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        all <- map["all"]
    }
}

class WindItem: Object, Mappable {
    @objc dynamic var speed: Double = 0
    @objc dynamic var deg: Double = 0
    
    //MARK: Mappable
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        speed <- map["speed"]
        deg <- map["deg"]
    }
}

