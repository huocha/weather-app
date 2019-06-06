//
//  SearchController.swift
//  WeatherApp
//
//  Created by Nguyen Dao Huong Tra on 05/04/2019.
//  Copyright © 2019 jasmine. All rights reserved.
//
import UIKit
import Foundation

class FavoriteController: UIViewController, UITableViewDelegate, UITableViewDataSource, FavoriteCityDelegate {

    @IBOutlet weak var tbView: UITableView!
    var addedFavoriteCities: [City] = []
    var currentCityTime: [Date] = []
    var cities: [City]?
    var currentWeatherCities: [Int] = []
    var converter = Converter()
    var timer: Timer?
    var updateTime = false
    deinit  {
        NotificationCenter.default.removeObserver(self)
        
        if let timer = self.timer {
            timer.invalidate()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // load the list of cities
        cities = City.loadJson()
        
        let savedCityId = Defaults.getIds()
        addedFavoriteCities = cities?.filter({ savedCityId.contains($0.id) }) ?? []
        
        self.timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: Selector(("updateTimeLabel")), userInfo: nil, repeats: true)
        
        NotificationCenter.default.addObserver(self,
                                               selector: Selector(("updateTimeLabel")),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        updateTime = true
    }
    
    @objc func updateTimeLabel() {
        if (updateTime) {
            for i in 0...currentCityTime.count-1 {
                currentCityTime[i] = currentCityTime[i].addingTimeInterval(1.0)
            }
            
            DispatchQueue.main.async {
                self.tbView.reloadData()
            }
        }
    }
    
    // Blocking function. Must not be called on main queue!
    func queryManyWeather(cities: [City]) -> Void {
        let group = DispatchGroup()
        self.currentWeatherCities.removeAll()
        
        for city in cities {
            
            group.enter()
            CurrentWeather.queryCurrentWeather(matching: [ "id" : String(city.id) ]) { (result) in
                if (result != nil) {
                    let celDegree = self.converter.convertKToC(kevin: (result!.main.temp))

                    self.currentWeatherCities.append(celDegree)
                }
                group.leave()
            }
            group.wait()
        }
        
    }
    
    func queryManyTime(cities: [City]) -> Void {
        let group = DispatchGroup()
        self.currentCityTime.removeAll()
        for city in cities {
            
            group.enter()
            TimeZone.queryTimezone(matching: [ "lat" : String(city.coord.lat), "lng": String(city.coord.lon) ]) { (result) in
                if (result != nil) {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
 
                    let date = dateFormatter.date(from: result?.time ?? "")

                    self.currentCityTime.append(date ?? Date())
                }
                group.leave()
               
            }
            group.wait()
            
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        queryManyWeather(cities: addedFavoriteCities)
        queryManyTime(cities: addedFavoriteCities)
        
        tbView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addedFavoriteCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? FavoriteCityCell

        cell?.cityLabel.text = "\(addedFavoriteCities[indexPath.row].name)"
        cell?.cityLabel.sizeToFit()

        cell?.degreeLabel.text = "\(currentWeatherCities[indexPath.row])°"
        cell?.timeLabel.text = currentCityTime[indexPath.row].formatDate(format: "HH:mm")
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailView = storyboard?.instantiateViewController(withIdentifier: "DetailController") as? DetailController
        
        detailView?.cityId = addedFavoriteCities[indexPath.row].id
        
        detailView?.cityName = addedFavoriteCities[indexPath.row].name
        
        self.navigationController?.pushViewController(detailView!, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            
            Defaults.remove(id: self.addedFavoriteCities[indexPath.row].id)
            self.addedFavoriteCities.remove(at: indexPath.row)
            self.currentWeatherCities.remove(at: indexPath.row)
            self.currentCityTime.remove(at: indexPath.row)
            self.tbView.reloadData()
            
            completionHandler(true)
        }
        
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
        swipeActionConfig.performsFirstActionWithFullSwipe = false
        return swipeActionConfig
    }
    
    func addFavoriteCity(city: City){
        self.addedFavoriteCities.append(city)
        Defaults.save(id: city.id)
        tbView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let searchVC = segue.destination as? SearchController {
            searchVC.delegate = self
            searchVC.cities = cities ?? []
        }
    }
}


