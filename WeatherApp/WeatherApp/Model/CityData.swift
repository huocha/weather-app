//
//  CityData.swift
//  WeatherApp
//
//  Created by Nguyen Dao Huong Tra on 10/04/2019.
//  Copyright © 2019 jasmine. All rights reserved.
//

// #TODO: sort by alphabetic
// #TODO: filter duplicate

import Foundation

struct City: Codable {
    let id: Int
    let name: String
    let country: String?
    let coord: Coord
    let population: Int?

    static func loadJson() -> [City]? {
        if let url = Bundle.main.url(forResource: "city.list", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([City].self, from: data)
                return jsonData
            } catch {
                print("error")
            }
        }
        return nil
    }
}
