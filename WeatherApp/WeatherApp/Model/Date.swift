//
//  Date.swift
//  WeatherApp
//
//  Created by Nguyen Dao Huong Tra on 09/05/2019.
//  Copyright © 2019 jasmine. All rights reserved.
//

import Foundation
extension String {
    var toDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.date(from: self)!
    }
}



extension Date {
    var getDayOfWeek: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en-US")
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE")
        
        return dateFormatter.string(from: self)
    }
}
