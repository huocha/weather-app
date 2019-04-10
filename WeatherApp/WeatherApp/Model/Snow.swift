//
//  Snow.swift
//  WeatherApp
//
//  Created by Nguyen Dao Huong Tra on 10/04/2019.
//  Copyright © 2019 jasmine. All rights reserved.
//

import Foundation

struct Snow: Codable {
    let snow: Double?
    
    enum CodingKeys: String, CodingKey {
        case snow = "3h"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.snow = try container.decodeIfPresent(Double.self, forKey: .snow)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.snow, forKey: .snow)
    }
}
