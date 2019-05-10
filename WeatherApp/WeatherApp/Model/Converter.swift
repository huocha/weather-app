//
//  Converter.swift
//  WeatherApp
//
//  Created by Nguyen Dao Huong Tra on 10/04/2019.
//  Copyright © 2019 jasmine. All rights reserved.
//

import Foundation

extension Double {
    func toFixed(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier)/multiplier
    }
    
    var toUTCDate: Date {
        return Date(timeIntervalSince1970: self)
    }
    
}

class Converter {
    func convertKToC(kevin: Double) -> Int {
        let celsius = kevin - 273.15
        return Int(celsius)
    }
}
