//
//  ViewController.swift
//  UnitConvert
//
//  Created by Nguyen Dao Huong Tra on 05/04/2019.
//  Copyright © 2019 jasmine. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    private var temperatureValues = [Int]()
    private var converter = UnitConverter()
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let celsiusValue = temperatureValues[row]
        return "\(celsiusValue) Celsius degrees"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // convert and display temperature
        let celsius:Double! = Double(temperatureValues[row])
        let farenheit = converter.degreesFahrenheit(celsius: celsius)
        
        celsiusLabel.text = "\(temperatureValues[row]) oC"
        farenheitLabel.text = "\(farenheit.toFixed(2)) oF"
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return temperatureValues.count
    }
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var farenheitLabel: UILabel!
    @IBOutlet weak var celsiusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let lowerBound = -100
        let upperBound = 100
        
        for index in lowerBound...upperBound{
            temperatureValues.append(index)
        }
    }
    
    

}

