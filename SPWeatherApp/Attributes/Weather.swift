//
//  WeatherAttributes.swift
//  SPWeatherApp
//
//  Created by Aaron Tang on 9/11/19.
//  Copyright © 2019 Aaron Tang. All rights reserved.
//

import Foundation

struct Weather {
    var humidity          : String
    var observation_time  : String
    var temp_C            : String
    var temp_F            : String
    var visibility        : String
    var weatherCode       : String
    var weatherIconUrl    : String
    var weatherDesc       : String
    
    init(){
        self.humidity           = ""
        self.observation_time   = ""
        self.temp_C             = ""
        self.temp_F             = ""
        self.visibility         = ""
        self.weatherCode        = ""
        self.weatherIconUrl     = ""
        self.weatherDesc        = ""
        
    }
    
    init?(dictionary: NSDictionary) {
        self.observation_time = dictionary["observation_time"] as! String
        let wURL = dictionary["weatherIconUrl"] as! NSArray
        let wURLDic = wURL[0] as! NSDictionary
        self.weatherIconUrl = wURLDic["value"] as! String
        
        let wDesc = dictionary["weatherDesc"] as! NSArray
        let wDescDic = wDesc[0] as! NSDictionary
        
        self.weatherDesc = wDescDic["value"] as! String
        self.humidity = dictionary["humidity"] as! String
        self.temp_C = dictionary["temp_C"] as! String
        self.temp_F = dictionary["temp_F"] as! String
        self.weatherCode = dictionary["weatherCode"] as! String
        self.visibility = dictionary["visibility"] as! String
    }
}
