//
//  City.swift
//  WeatherApp
//
//  Created by Nguyen Dao Huong Tra on 10/04/2019.
//  Copyright © 2019 jasmine. All rights reserved.
//

import Foundation

struct CurrentWeather: Codable {
    let id: Int
    let cod: Int
    let name: String
    let coord: Coord
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let snow: Snow?
    let rain: Rain?
    let sys: CurrentSys
    let visibility: Double?
    let clouds: Clouds?
    
    static func queryCurrentWeather(matching query: [String: String], completion: @escaping (CurrentWeather?) -> Void) -> Void {
        
        let baseURL = URL(string: Const.baseUrl+"/weather?")!
        
        var query = query
        query["APPID"] = Const.APPID
        
        let url = baseURL.withQueries(query)!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let results = try? jsonDecoder.decode(CurrentWeather.self, from: data) {
       
                completion(results)
                
            }
            else {
                print(error ?? "Can not decode json")
            }
            
        }
        
        task.resume()
    }
}


struct CurrentSys: Codable {
    let country: String?
    let id: Int?
    let message: Double
    let type: Int?
    let sunrise: Double
    let sunset: Double
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
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

