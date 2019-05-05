//
//  Rain.swift
//  WeatherApp
//
//  Created by Nguyen Dao Huong Tra on 10/04/2019.
//  Copyright © 2019 jasmine. All rights reserved.
//

import Foundation

struct Rain: Codable {
    let one: Double?
    let three: Double?
    
    enum CodingKeys: String, CodingKey {
        case one = "1h"
        case three = "3h"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.one = try container.decodeIfPresent(Double.self, forKey: .one)
        self.three = try container.decodeIfPresent(Double.self, forKey: .three)
    }
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.one, forKey: .one)
        try container.encode(self.three, forKey: .three)
    }
}
