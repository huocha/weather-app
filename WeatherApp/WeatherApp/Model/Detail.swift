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
    let main: Main
    let weather: [CityWeather]
    let clouds: Clouds
    let wind: Wind
    let rain: Rain?
    let snow: Snow?
    let sys: Sys
    let dt_txt: String
}
