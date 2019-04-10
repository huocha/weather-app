//
//  DetailWeather.swift
//  WeatherApp
//
//  Created by Nguyen Dao Huong Tra on 10/04/2019.
//  Copyright © 2019 jasmine. All rights reserved.
//

import Foundation

struct Sys: Codable {
    let pod: String?
}

struct Detail: Codable {
    let dt: Int
    let main: MainDetail
    let weather: [CityWeather]
    let clouds: Clouds
    let wind: Wind
    let rain: Rain?
    let snow: Snow?
    let sys: Sys
    let dt_txt: String
    
    enum CodingKeys: String, CodingKey {
        case dt = "dt"
        case main = "main"
        case weather = "weather"
        case clouds = "clouds"
        case wind = "wind"
        case rain = "rain"
        case snow = "snow"
        case sys = "sys"
        case dt_txt = "dt_txt"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dt = try container.decode(Int.self, forKey: .dt)
        self.main = try container.decode(MainDetail.self, forKey: .main)
        self.weather = try container.decode([CityWeather].self, forKey: .weather)
        self.clouds = try container.decode(Clouds.self, forKey: .clouds)
        self.wind = try container.decode(Wind.self, forKey: .wind)
        self.rain = try container.decodeIfPresent(Rain.self, forKey: .rain)
        self.snow = try container.decodeIfPresent(Snow.self, forKey: .snow)
        self.sys = try container.decode(Sys.self, forKey: .sys)
        self.dt_txt = try container.decode(String.self, forKey: .dt_txt)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.dt, forKey: .dt)
        try container.encode(self.main, forKey: .main)
        try container.encode(self.weather, forKey: .weather)
        try container.encode(self.clouds, forKey: .clouds)
        try container.encode(self.wind, forKey: .wind)
        try container.encode(self.rain, forKey: .rain)
        try container.encode(self.snow, forKey: .snow)
        try container.encode(self.sys, forKey: .sys)
        try container.encode(self.dt_txt, forKey: .dt_txt)
    }
}
