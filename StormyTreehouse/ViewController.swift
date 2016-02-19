//
//  ViewController.swift
//  StormyTreehouse
//
//  Created by Reed Carson on 2/10/16.
//  Copyright © 2016 Reed Carson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var dailyWeather: DailyWeather? {
        didSet {
            configureView()
        }
    }
    
    
    
    @IBOutlet weak var humidityLabel: UILabel?
    @IBOutlet weak var precipitationLabel: UILabel?
    @IBOutlet weak var highTempLabel: UILabel?
    @IBOutlet weak var lowTempLabel: UILabel?
    @IBOutlet weak var summaryLabel: UILabel?
    @IBOutlet weak var weatherIcon: UIImageView?
    @IBOutlet weak var sunriseTimeLabel: UILabel?
    @IBOutlet weak var sunsetTimeLabel: UILabel?
    
    func configureView() {
        
        if let weather = dailyWeather {
            
            self.title = weather.day
            weatherIcon?.image = weather.largeIcon
            summaryLabel?.text = weather.summary
            sunriseTimeLabel?.text = weather.sunriseTime
            sunsetTimeLabel?.text = weather.sunsetTime
            
            if let lowTemp = weather.minTemp,
                let highTemp = weather.maxTemp,
                let rain = weather.precipChance,
                let humidity = weather.humidity {
                
                lowTempLabel?.text = "\(lowTemp)º"
                highTempLabel?.text = "\(highTemp)º"
                humidityLabel?.text = "\(humidity)%"
                precipitationLabel?.text = "\(rain)%"

                
            }
            
        }
        
        if let buttonFont = UIFont(name: "HelveticaNeue-Thin", size: 20) {
            let barButtonAttritbutes: [String:AnyObject]? = [
                NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSFontAttributeName: buttonFont
            ]
            
            navigationController?.navigationBar.titleTextAttributes = barButtonAttritbutes
            
            navigationController?.navigationBar.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/225, alpha: 0.05)
            
            UIBarButtonItem.appearance().setTitleTextAttributes(barButtonAttritbutes, forState: .Normal)
            
            
        }
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        return UIStatusBarStyle.LightContent
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    
    
}


