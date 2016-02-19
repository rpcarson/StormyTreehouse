//
//  DailyWeather.swift
//  StormyTreehouse
//
//  Created by Reed Carson on 2/13/16.
//  Copyright © 2016 Reed Carson. All rights reserved.
//

import Foundation
import UIKit


struct DailyWeather {
    
    let maxTemp: Int?
    let minTemp: Int?
    let humidity: Int?
    let precipChance: Int?
    var summary: String?
    var icon: UIImage? = UIImage(named: "default.png")
    var largeIcon: UIImage? = UIImage(named: "default_large.png")
    var sunriseTime: String?
    var sunsetTime: String?
    var day: String?
    
    let dateFormatter = NSDateFormatter()
    
    init(dailyWeatherDictionary: [String:AnyObject]) {
        
        minTemp = dailyWeatherDictionary["temperatureMin"] as? Int
        maxTemp = dailyWeatherDictionary["temperatureMax"] as? Int
        if let humidityFloat = dailyWeatherDictionary["humidity"] as? Double {
            
            humidity = Int(humidityFloat * 100) } else { humidity = nil
            
        }
        if let precipFloat = dailyWeatherDictionary["precipProbability"] as? Double  {
            
            precipChance = Int(precipFloat * 100) } else { precipChance = nil }
        
        summary = dailyWeatherDictionary["summary"] as? String
        
        if let
            iconString = dailyWeatherDictionary["icon"] as? String,
            iconEnum = Icon(rawValue: iconString) {
                (icon, largeIcon) = iconEnum.toImage() }
        
        if let sunriseDate = dailyWeatherDictionary["sunriseTime"] as? Double {
            
            sunriseTime = timeStringFromUnixTime(sunriseDate) } else { sunriseTime = nil }
        
        if let sunsetDate = dailyWeatherDictionary["sunsetTime"] as? Double {
            sunsetTime = timeStringFromUnixTime(sunsetDate) } else { sunsetTime = nil }
        
        if let time = dailyWeatherDictionary["time"] as? Double {
            
            day = dayStringFromUnixTime(time) } else { day = nil }
        
    }
    
    
    func timeStringFromUnixTime(unixTime: Double) -> String {
        
        let date = NSDate(timeIntervalSince1970: unixTime)
        
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.stringFromDate(date)
        
    }
    
    func dayStringFromUnixTime(unixTime: Double) -> String {
        
        let date = NSDate(timeIntervalSince1970: unixTime)
        dateFormatter.locale = NSLocale(localeIdentifier: NSLocale.currentLocale().localeIdentifier)
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.stringFromDate(date)
        
    }
    


}