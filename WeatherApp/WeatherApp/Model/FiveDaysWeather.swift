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
}
