//
//  Colors.swift
//  WeatherApp
//
//  Created by Nguyen Dao Huong Tra on 13/05/2019.
//  Copyright © 2019 jasmine. All rights reserved.
//

import Foundation
import UIKit
extension UIColor {
    convenience init(rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func getColorByWeather(icon: String) -> UIColor{
        switch icon {
        case "01d":
            return UIColor(rgb: 0xffe963)
        case "01n":
            return UIColor(rgb: 0x4b595e)
        case "02d":
            return UIColor(rgb: 0x8ad0ce)
        case "02n":
            return UIColor(rgb: 0x8ad0ce)
        case "04d":
            return UIColor(rgb: 0x4b595e)
        case "04n":
            return UIColor(rgb: 0x4b595e)
        case "09d":
            return UIColor(rgb: 0x4b595e)
        case "09n":
            return UIColor(rgb: 0x4b595e)
        case "11d":
            return UIColor(rgb: 0x4b595e)
        case "11n":
           return UIColor(rgb: 0x4b595e)
        case "13d":
            return UIColor(rgb: 0xbdf7ff)
        case "13n":
            return UIColor(rgb: 0x4b595e)
        case "50n":
            return UIColor(rgb: 0x4b595e)
        default:
           return UIColor.black
        }
    }
}

extension UIImage {
    func tinted(with color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        color.set()
        withRenderingMode(.alwaysTemplate)
            .draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

extension CALayer {
    func borderBottom(with color: UIColor, view: UIView) -> Void {
        let border = self
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 0.5)
        
        view.layer.addSublayer(border)
    }
    
    func borderTop(with color: UIColor, view: UIView) -> Void {
        let border = self
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 0.5)
        
        view.layer.addSublayer(border)
    }
}
