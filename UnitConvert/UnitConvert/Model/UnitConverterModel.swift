//
//  UnitConverterModel.swift
//  UnitConvert
//
//  Created by Nguyen Dao Huong Tra on 05/04/2019.
//  Copyright © 2019 jasmine. All rights reserved.
//

import Foundation

extension Double {
    func toFixed(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier)/multiplier
    }
}

class UnitConverter {
    func degreesFahrenheit(celsius: Double) -> Double {
        return 1.8*celsius+32
    }
}
