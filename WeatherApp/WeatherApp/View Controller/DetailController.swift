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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        queryCurrentWeather(matching: [ "q" : cityName ]) { (result) in
            
            print(result)
            
        }
    }
    
    func queryCurrentWeather(matching query: [String: String], completion: @escaping (City?) -> Void) -> Void {
        
        let baseURL = URL(string: Const.baseUrl+"/weather?")!
        
        var query = query
        query["APPID"] = Const.APPID
        
        let url = baseURL.withQueries(query)!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let results = try? jsonDecoder.decode(City.self, from: data) {
                
                completion(results)
            }
            else {
                print(error ?? "Can not decode json")
            }
            
        }
        
        task.resume()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
