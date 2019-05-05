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
    let cod: Int
    let name: String
    let coord: Coord
    let weather: [CityWeather]
    let main: Main
    let wind: Wind
    let snow: Snow?
    let rain: Rain?
    let sys: CitySys
    
    static func queryCurrentWeather(matching query: [String: String], completion: @escaping (City?) -> Void) -> Void {
        
        let baseURL = URL(string: Const.baseUrl+"/weather?")!
        
        var query = query
        query["APPID"] = Const.APPID
        
        let url = baseURL.withQueries(query)!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let results = try? jsonDecoder.decode(City.self, from: data) {
                print(results)
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
    let country: String?
    let id: Int?
    let message: Double
    let type: Int?
    let sunrise: Double
    let sunset: Double
}

struct CityWeather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Main: Codable {
    let temp: Double
    let pressure: Double
    let humidity: Double
    let temp_min: Double
    let temp_max: Double
    let temp_kf: Double?
    let sea_level: Double?
    let grnd_level: Double?
}


struct CityDetail: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String?
    let population: Int?
}


struct WeatherDetail: Codable {
    let cod: String
    let message: Double
    let cnt: Int
    let list: [Detail]
    let city: CityDetail
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

