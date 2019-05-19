//
//  TimeZone.swift
//  WeatherApp
//
//  Created by Nguyen Dao Huong Tra on 14/05/2019.
//  Copyright © 2019 jasmine. All rights reserved.
//

import Foundation
struct TimeZone: Codable {
    let countryCode: String
    let countryName: String
    // let dstOffset: Int
    // let gmtOffset: Int
    let lat: Double
    let lng: Double
    // let rawOffset: Int
    // let sunrise: String
    // let sunset: String
    let time: String
    let timezoneId: String
    
    static func queryTimezone(matching query: [String: String], completion: @escaping (TimeZone?) -> Void) -> Void {
        
        let baseURL = URL(string: Const.timezoneUrl)!
        
        var query = query
        query["username"] = "jasmine.ngx"
        
        let url = baseURL.withQueries(query)!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let results = try? jsonDecoder.decode(TimeZone.self, from: data) {
                
                completion(results)
                
            }
            else {
                print(error ?? "Can not decode json")
            }
            
        }
        
        task.resume()
    }
}
