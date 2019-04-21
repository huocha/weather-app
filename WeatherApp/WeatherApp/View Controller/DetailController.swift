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
    
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    
    var cityName = ""
    var cityId = Int()
    var weatherByCity: City?
    private var converter = Converter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityLabel.text = cityName
        
        City.queryCurrentWeather(matching: [ "q" : cityName ]) { (result) in
            
            // Update the UI on the main thread
            DispatchQueue.main.async() {
                let celDegree = self.converter.convertKToC(kevin: (result?.main.temp)!)
                self.weatherLabel.text = result?.weather[0].description
                self.degreeLabel.text = "\(celDegree.toFixed(2))"
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
