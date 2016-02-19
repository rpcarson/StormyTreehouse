//
//  NetworkOperation.swift
//  StormyTreehouse
//
//  Created by Reed Carson on 2/11/16.
//  Copyright © 2016 Reed Carson. All rights reserved.
//

import Foundation


class NetworkOperation {
    
    lazy var config: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
    lazy var session: NSURLSession = NSURLSession(configuration: self.config)
    
    //    lazy var session: NSURLSession = NSURLSession(configuration: .defaultSessionConfiguration())
    
    let queryURL: NSURL
    
    
    typealias JSONDictionaryCompletion = ([String:AnyObject]?) -> Void
    
    init(url: NSURL) {
        
        self.queryURL = url
    }
    
    
    func downloadJSONFromURL(completion: JSONDictionaryCompletion) {
        
        print("downloading")
        
        let request: NSURLRequest = NSURLRequest(URL: queryURL)
//        let dataTask = session.dataTaskWithURL(request, completionHandler: <#T##(NSData?, NSURLResponse?, NSError?) -> Void#>)
        
        let dataTask = session.dataTaskWithRequest(request) { (let data, let response, let error) in
        
        
            // 1. check HTTP response for successful GET request
            
            if let HTTPResponse = response as? NSHTTPURLResponse {
                
                switch HTTPResponse.statusCode {
                case 200:
                    //2. create json object with data
                    print("case 200 working")
                    
                    let jsonDictionary = try? NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String:AnyObject]
                    completion(jsonDictionary!)
                default:  print("\(HTTPResponse.statusCode)")
                    
                }
                
            } else { print("error not valid shit") }
            
        
        }
    
    
    dataTask.resume()
    
    }
}