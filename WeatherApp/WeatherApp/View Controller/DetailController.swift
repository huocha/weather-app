//
//  DetailController.swift
//  WeatherApp
//
//  Created by Nguyen Dao Huong Tra on 10/04/2019.
//  Copyright © 2019 jasmine. All rights reserved.
//
import UIKit
import Foundation

class DetailController: UIViewController {
    
    
    @IBOutlet weak var label: UILabel!
    var cityName = ""
    var cityId = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = "\(cityName) - \(cityId)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
