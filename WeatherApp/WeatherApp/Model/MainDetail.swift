//
//  MainDetail.swift
//  WeatherApp
//
//  Created by Nguyen Dao Huong Tra on 10/04/2019.
//  Copyright © 2019 jasmine. All rights reserved.
//

import Foundation

struct MainDetail: Codable {
    let temp: Float
    let temp_min: Float
    let temp_max: Float
    let pressure: Float
    let sea_level: Float
    let grnd_level: Float
    let humidity: Float
    let temp_kf: Float
}
