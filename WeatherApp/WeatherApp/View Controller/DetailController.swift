//
//  DetailController.swift
//  WeatherApp
//
//  Created by Nguyen Dao Huong Tra on 10/04/2019.
//  Copyright © 2019 jasmine. All rights reserved.
//
import UIKit
import Foundation

class DetailController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var weatherDetailCollectionView: UICollectionView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var minDegreeLabel: UILabel!
    @IBOutlet weak var maxDegreeLabel: UILabel!
    @IBOutlet weak var currentDayLabel: UILabel!
    
    var cityName: String!
    var cityId: Int!
    var icon = String()
    var detailList: [Detail] = []
    private var converter = Converter()
    var currentDate = Date()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityLabel.text = cityName
        
        cityLabel.adjustsFontSizeToFitWidth = true
        cityLabel.minimumScaleFactor = 0.2
        cityLabel.numberOfLines = 1
        
        weatherLabel.adjustsFontSizeToFitWidth = true
        weatherLabel.minimumScaleFactor = 0.2
        weatherLabel.numberOfLines = 2
        
        
        currentDayLabel.text = currentDate.getDayOfWeek
        
        CurrentWeather.queryCurrentWeather(matching: [ "id" : String(cityId) ]) { (result) in
  
            // Update the UI on the main thread
            DispatchQueue.main.async() {
                let celDegree = self.converter.convertKToC(kevin: (result?.main.temp)!)
                let minDegree = self.converter.convertKToC(kevin: (result?.main.temp_min)!)
                let maxDegree = self.converter.convertKToC(kevin: (result?.main.temp_max)!)
                
                self.weatherLabel.text = result?.weather[0].description
                self.degreeLabel.text = "\(celDegree)°"
                self.minDegreeLabel.text = "\(minDegree)"
                self.maxDegreeLabel.text = "\(maxDegree)"
                self.icon = result?.weather[0].icon ?? "default"
                
                self.iconView.image = UIImage(named: self.icon)
            }
            
        }
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 4.0
        weatherDetailCollectionView.collectionViewLayout = flowLayout
        
        FiveDaysWeather.queryFiveDayWeather(matching: [ "id" : String(cityId) ]) { (result) in

            self.detailList = Array(result?.list.prefix(8) ?? [])
            
            // Update the UI on the main thread
            DispatchQueue.main.async() {
                self.weatherDetailCollectionView.reloadData()
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weatherCell", for: indexPath) as! WeatherCollectionViewCell
        
        // #TODO: add missing time for example 9h -> 12h should be 9h 10h 11h 12h
        
        var degrees = detailList.map({ self.converter.convertKToC(kevin: ($0.main.temp)) })
        var icons = detailList.map({ $0.weather[0].icon + "-small" })
        
        cell.degreeLabel.text = "\(degrees[indexPath.row])°"
        cell.iconImage.image = UIImage(named: icons[indexPath.row])
        
        
        return cell
        
    }
}
