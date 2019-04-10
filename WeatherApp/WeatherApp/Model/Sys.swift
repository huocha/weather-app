//
//  Sys.swift
//  WeatherApp
//
//  Created by Nguyen Dao Huong Tra on 10/04/2019.
//  Copyright © 2019 jasmine. All rights reserved.
//

import Foundation

struct CitySys: Codable {
    let country: String
    let id: Int
    let message: Float
    let sunset: Int
    let sunrise: Int
    let type: Int
}
