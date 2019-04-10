//
//  Rain.swift
//  WeatherApp
//
//  Created by Nguyen Dao Huong Tra on 10/04/2019.
//  Copyright © 2019 jasmine. All rights reserved.
//

import Foundation

struct Rain: Codable {
    let rain: Double?
    
    enum CodingKeys: String, CodingKey {
        case rain = "3h"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.rain = try container.decodeIfPresent(Double.self, forKey: .rain)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.rain, forKey: .rain)
    }
}
