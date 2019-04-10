//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Nguyen Dao Huong Tra on 10/04/2019.
//  Copyright © 2019 jasmine. All rights reserved.
//

import Foundation

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
