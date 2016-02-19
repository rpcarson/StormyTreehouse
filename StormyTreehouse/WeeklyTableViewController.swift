//
//  WeeklyTableViewController.swift
//  StormyTreehouse
//
//  Created by Reed Carson on 2/13/16.
//  Copyright © 2016 Reed Carson. All rights reserved.
//

import UIKit
import CoreLocation



let userInfo = NSUserDefaults.standardUserDefaults()



class WeeklyTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    private let forecastAPIKey: String = "91c786e2d174430c2d8851c933bc826a"
    
    
    
    
    
    let locationManager = CLLocationManager()
    
    var coordinate: (lat: Double, long: Double)?
    
    var weeklyWeather: [DailyWeather] = []
    
    @IBAction func refreshWeather() {
        
        locationManager.startUpdatingLocation()
        retrieveWeatherForecast()
        getCityNameAndForecast()
        refreshControl?.endRefreshing()

    
    }
    
    
    @IBOutlet weak var currentTempLabel: UILabel!
    
    @IBOutlet weak var currentPrecipLabel: UILabel!
    
    @IBOutlet weak var currentRangeLabel: UILabel!
    
    @IBOutlet weak var currentWeatherIcon: UIImageView!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    func setDefaultValues() {
        
        if let cityName = userInfo.stringForKey("city") {
            cityLabel.text = cityName
        }
        
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.startUpdatingLocation()

        getCityNameAndForecast()
        configureView()

    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locationManager.location?.coordinate else { return }
        
        coordinate = (location.latitude, location.longitude)
        
        locationManager.stopUpdatingLocation()
    
    }
    
    func getCityNameAndForecast() {
        
        let geoCoder = CLGeocoder()
        
        guard let location = locationManager.location else { print("city coding error") ; return }
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in

            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            if let city = placeMark.addressDictionary!["City"] as? NSString,
            state = placeMark.addressDictionary!["State"] as? NSString {
                
                print(city)
                
                self.cityLabel.text = "\(city), \(state)"
                
                userInfo.setObject("\(city)", forKey: "currentCity")
                
                self.retrieveWeatherForecast()
                
            } else { print("unable to find location") }
    
        })
    }

    func configureView() {
        
        tableView.backgroundView = BackgroundView()
        
        tableView.rowHeight = 64
        
        if let navBarFont = UIFont(name: "HelveticaNeue-Thin", size: 20) {
            let navBarAttributesDictionary: [String:AnyObject]? = [
                NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSFontAttributeName: navBarFont
            ]
            
            navigationController?.navigationBar.titleTextAttributes = navBarAttributesDictionary
            
            navigationController?.navigationBar.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/225, alpha: 0.05)
            
        }
        
        refreshControl?.layer.zPosition = tableView.backgroundView!.layer.zPosition + 1
        refreshControl?.tintColor = UIColor.whiteColor()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    // MARK:  - Navigation
    
    override func performSegueWithIdentifier(identifier: String, sender: AnyObject?) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowDaily" {
            
            if let indexPath = tableView.indexPathForSelectedRow {
                
                let dailyWeather = weeklyWeather[indexPath.row]
                
                (segue.destinationViewController as! ViewController).dailyWeather = dailyWeather
                
            }
            
        }
        
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Forecast"
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weeklyWeather.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("WeatherCell") as! DailyWeatherTableViewCell
        
        let dailyWeather = weeklyWeather[indexPath.row]
        
        if let maxTemp = dailyWeather.maxTemp {
            
            cell.temperatureLabel.text = "\(maxTemp)º "
            
        }
        cell.weatherIcon.image = dailyWeather.icon
        cell.dayLabel.text = dailyWeather.day
        
        return cell
        
    }
    
    // MARK: - Delegate Methods
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
            view.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/225, alpha: 0.25)
        
        if let header = view as? UITableViewHeaderFooterView {
            
            header.textLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 14)
            
            header.textLabel?.textColor = UIColor.whiteColor()
            
        }
        
    }
    
    override func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.contentView.backgroundColor = UIColor.clearColor()
        
        let highlightView = UIView()
        
        highlightView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/225, alpha: 0.25)
        cell?.selectedBackgroundView = highlightView
        
    }
    
    
    //    MARK: - Data Fetching
    
    
    func retrieveWeatherForecast() {
        
        let forecastService = ForecastService(APIKey: forecastAPIKey)
        
        guard let coordinate = coordinate else { print("no coordinates found") ; return }
        
        forecastService.getForecast(coordinate.lat, long: coordinate.long) { (let forecast) in
            
            if let weatherForecast = forecast,
                let currentWeather = weatherForecast.currentWeather {
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        guard let temperature = currentWeather.temperature else { return }
                        self.currentTempLabel?.text = "\(temperature)º"
                        guard let precipitation = currentWeather.precipProbability else { return }
                        self.currentPrecipLabel?.text = "Rain: \(precipitation)%"
                        guard let icon = currentWeather.icon else { return }
                        self.currentWeatherIcon?.image = icon
                        
                        self.weeklyWeather = weatherForecast.weekly
          
                        if let highTemp = self.weeklyWeather.first?.maxTemp,
                        let lowTemp = self.weeklyWeather.first?.minTemp {
                            
                            self.currentRangeLabel.text = "↑\(highTemp)º↓\(lowTemp)º"
                            
                        }
                        
                        self.tableView.reloadData()
                    }
            }
        }
    }
}
