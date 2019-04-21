//
//  City.swift
//  WeatherApp
//
//  Created by Nguyen Dao Huong Tra on 10/04/2019.
//  Copyright © 2019 jasmine. All rights reserved.
//

import Foundation

struct City: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let weather: [CityWeather]
    let main: Main
    
    static func queryCurrentWeather(matching query: [String: String], completion: @escaping (City?) -> Void) -> Void {
        
        let baseURL = URL(string: Const.baseUrl+"/weather?")!
        
        var query = query
        query["APPID"] = Const.APPID
        
        let url = baseURL.withQueries(query)!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let results = try? jsonDecoder.decode(City.self, from: data) {
                completion(results)
                
            }
            else {
                print(error ?? "Can not decode json")
            }
            
        }
        
        task.resume()
    }
}

struct CitySys: Codable {
    let country: String
    let id: Int
    let message: Float
    let sunset: Int
    let sunrise: Int
    let type: Int
}

struct Main: Codable {
    let temp: Double
    let pressure: Double
    let humidity: Double
    let temp_min: Double
    let temp_max: Double
}


struct CityWeather: Codable {
    let id: Int
    let main: String?
    let description: String
    let icon: String
}

struct WeatherDetail: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let weather: [CityWeather]
    let main: Main
}


extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        components?.queryItems = queries.map {
            URLQueryItem(name: $0.0, value: $0.1)
        }
        
        return components?.url
    }
}

