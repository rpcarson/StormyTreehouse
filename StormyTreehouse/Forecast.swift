//
//  Forecast.swift
//  StormyTreehouse
//
//  Created by Reed Carson on 2/14/16.
//  Copyright © 2016 Reed Carson. All rights reserved.
//

import Foundation



struct Forecast {
    
    var currentWeather: CurrentWeather?
    
    var weekly: [DailyWeather] = []
    
    init(weatherDictionary: [String:AnyObject]?) {

            if let currentWeatherDictionary = weatherDictionary?["currently"] as? [String:AnyObject] {
                
                currentWeather = CurrentWeather(weatherDictionary: currentWeatherDictionary)
        }
    
        if let weeklyWeatherArray = weatherDictionary?["daily"]?["data"] as? [[String:AnyObject]] {
            
            for dailyWeather in weeklyWeatherArray {
                
                let daily = DailyWeather(dailyWeatherDictionary: dailyWeather)
                
                weekly.append(daily)
                
            }
            
        }
    
    }
    
}