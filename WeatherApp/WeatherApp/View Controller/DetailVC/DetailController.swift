//
//  DetailController.swift
//  WeatherApp
//
//  Created by Nguyen Dao Huong Tra on 10/04/2019.
//  Copyright © 2019 jasmine. All rights reserved.
//
import UIKit
import Foundation

class DetailController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,  UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var weatherDetailCollectionView: UICollectionView!
    @IBOutlet weak var weatherInWeekTableView: UITableView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var subHeaderView: UIView!
    @IBOutlet weak var minDegreeLabel: UILabel!
    @IBOutlet weak var maxDegreeLabel: UILabel!
    @IBOutlet weak var currentDayLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var subHeaderView2: UIView!
    @IBOutlet weak var footerView: UICollectionView!
    
    var cityName: String!
    var cityId: Int!
    var icon = String()
    var weatherInDay: [Detail] = []
    var weatherInWeek: [Detail] = []
    var currentWeather: CurrentWeather?
    var converter = Converter()
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
        
        currentDayLabel.text = currentDate.getDayOfWeek()
        
        CurrentWeather.queryCurrentWeather(matching: [ "id" : String(cityId) ]) { (result) in
            self.currentWeather = result
            
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
                
                // let backgroundColor = UIColor().getColorByWeather(icon: result?.weather[0].icon ?? "default")
                // self.initBackgroundColor(color: backgroundColor)
                
                self.iconView.image = UIImage(named: self.icon) //img?.tinted(with: backgroundColor)
                self.footerView.reloadData()
            }
           
        }
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 75, height: 100)
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0.0
        
        weatherDetailCollectionView.collectionViewLayout = flowLayout
        
        FiveDaysWeather.queryFiveDayWeather(matching: [ "id" : String(cityId) ]) { (result) in
            
            // #TODO: group by date and find min max temp
            self.weatherInWeek = result?.list ?? []
            self.weatherInDay = Array(result?.list.prefix(8) ?? [])
            
            // Update the UI on the main thread
            DispatchQueue.main.async() {
                self.weatherInWeekTableView.reloadData()
                self.weatherDetailCollectionView.reloadData()
            }
            
        }
        
        self.weatherInWeekTableView.tableHeaderView = headerView
        self.weatherInWeekTableView.tableFooterView = footerView
        
        CALayer().borderTop(with: UIColor(rgb: 0xa1a9c3), view: weatherDetailCollectionView)
        CALayer().borderBottom(with: UIColor(rgb: 0xa1a9c3), view: weatherDetailCollectionView)
    
    }
    
    func initBackgroundColor(color: UIColor) -> Void{
        headerView.backgroundColor = color
        subHeaderView2.backgroundColor = color
        subHeaderView.backgroundColor = color
        weatherDetailCollectionView.backgroundColor = color
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (collectionView == weatherDetailCollectionView) {
            return weatherInDay.count
        }
        else {
            return 8
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionView == weatherDetailCollectionView){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weatherCell", for: indexPath) as! WeatherCollectionViewCell
            
            // #TODO: add missing time for example 9h -> 12h should be 9h 10h 11h 12h
            let formatter = DateFormatter()
            formatter.dateFormat = "hh"
            
            var time = weatherInDay.map({ $0.dt_txt.substring(with: 11..<13) })
            var degrees = weatherInDay.map({ self.converter.convertKToC(kevin: ($0.main.temp)) })
            var icons = weatherInDay.map({ $0.weather[0].icon + "-small" })
            
            cell.degreeLabel.text = "\(degrees[indexPath.row])°"
            cell.iconImage.image = UIImage(named: icons[indexPath.row])
            cell.timeLabel.text = time[indexPath.row]+"h"
            
            
            return cell
        }
        else  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "footerCollectionCell", for: indexPath) as! FooterCollectionCell
            
            let sunrise = currentWeather?.sys.sunrise.getDateFromUnixStamp() ?? "06:00";
            let sunset = currentWeather?.sys.sunset.getDateFromUnixStamp() ?? "18:00";
            let rain = "\(currentWeather?.rain?.one ?? currentWeather?.rain?.one ?? 0)";
            let humidity = "\(currentWeather?.main.humidity ?? 0) %"
            let wind = "\(currentWeather?.wind.speed ?? 0) km/h"
            let clouds = "\(currentWeather?.clouds?.all ?? 0) %"
            let pressure = "\(currentWeather?.main.pressure ?? 0) hPa"
            let visibility = "\((currentWeather?.visibility ?? 1000/1000).toFixed(0)) km"
            
            var keys = ["Sunrise", "Sunset", "Rain", "Humidity", "Wind", "Visibility", "Pressure", "Clouds",]
            var values = [sunrise, sunset, rain, humidity, wind, visibility, pressure, clouds]
            
            cell.descriptionKeyLabel.text = "\(keys[indexPath.row])"
            cell.valueLabel.text = "\(values[indexPath.row])"
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if (collectionView == weatherDetailCollectionView){
            let width = self.weatherDetailCollectionView.frame.size.width

            return CGSize(width: width/8, height: 100)
        }
        else {
            let width = self.footerView.frame.size.width

            return CGSize(width: width/2 - 10, height: 100)
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherInWeek.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherDaysTableCell", for: indexPath) as! WeatherDaysTableCell

        cell.dayTbViewLabel.text = weatherInWeek[indexPath.row].dt_txt.toDate.getDayOfWeek()
        
        var icons = weatherInWeek.map({ $0.weather[0].icon + "-small" })
        var maxDegree = weatherInWeek.map({ self.converter.convertKToC(kevin: ($0.main.temp_max)) })
        
        var minDegree = weatherInWeek.map({ self.converter.convertKToC(kevin: ($0.main.temp_min)) })
        
        cell.iconImageTbViewLabel.image = UIImage(named: icons[indexPath.row])
        
        cell.maxDegreeTbViewLabel.text = "\(maxDegree[indexPath.row])°"
        
        cell.minDegreeTbViewLabel.text = "\(minDegree[indexPath.row])°"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
}
