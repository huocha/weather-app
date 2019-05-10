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
    var cities: [City]?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // load the list of cities
        cities = City.loadJson()
        
        let savedCityId = Defaults.getIds()
        addedFavoriteCities = cities?.filter({ savedCityId.contains($0.id) }) ?? []
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        
        cell?.degreeLabel.text = "\(addedFavoriteCities[indexPath.row].id)"
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailView = storyboard?.instantiateViewController(withIdentifier: "DetailController") as? DetailController
        
        detailView?.cityId = addedFavoriteCities[indexPath.row].id
        // #TODO: query weather each time
        
        detailView?.cityName = addedFavoriteCities[indexPath.row].name
        
        self.navigationController?.pushViewController(detailView!, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            
            Defaults.remove(id: self.addedFavoriteCities[indexPath.row].id)
            self.addedFavoriteCities.remove(at: indexPath.row)
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


