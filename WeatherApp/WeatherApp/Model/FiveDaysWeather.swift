//
//  FiveDaysWeather.swift
//  WeatherApp
//
//  Created by Nguyen Dao Huong Tra on 05/05/2019.
//  Copyright © 2019 jasmine. All rights reserved.
//

import Foundation

struct FiveDaysWeather: Codable {
    let cod: String
    let message: Double
    let cnt: Int
    let list: [Detail]
    let city: City
    
    static func queryFiveDayWeather(matching query: [String: String], completion: @escaping (FiveDaysWeather?) -> Void) -> Void {
        
        let baseURL = URL(string: Const.baseUrl+"/forecast?")!
        
        var query = query
        query["APPID"] = Const.APPID
        
        let url = baseURL.withQueries(query)!
        
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            
            if let data = data,
                let results = try? jsonDecoder.decode(FiveDaysWeather.self, from: data) {
                completion(results)
            }
            else {
                print(error!)
            }
            
        }
        
        task.resume()
    }
}
