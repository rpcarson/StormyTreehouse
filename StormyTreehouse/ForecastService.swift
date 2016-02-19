//
//  ForecastService.swift
//  StormyTreehouse
//
//  Created by Reed Carson on 2/11/16.
//  Copyright © 2016 Reed Carson. All rights reserved.
//

import Foundation



struct ForecastService {
    
    let forecastAPIKey: String
    
    let forecastBaseURL: NSURL?
    
    init(APIKey: String) {
        
        self.forecastAPIKey = APIKey
        
        forecastBaseURL = NSURL(string: "https://api.forecast.io/forecast/\(forecastAPIKey)/")
        
    }
    
    func getForecast(lat: Double, long: Double, completion: (Forecast? -> Void)) {
        
        if let forecastURL = NSURL(string: "\(lat),\(long)", relativeToURL: forecastBaseURL) {
            
            let networkOperation = NetworkOperation(url: forecastURL)
            
            networkOperation.downloadJSONFromURL {
                
                (let JSONDictionary) in
                
                let forecast = Forecast(weatherDictionary: JSONDictionary)
                
                completion(forecast)
                
            }
            
            
        } else { print("unhelpful message")
        
        
    }

    }

}