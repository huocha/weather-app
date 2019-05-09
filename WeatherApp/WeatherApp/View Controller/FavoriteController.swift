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

    @IBOutlet weak var tableView: UITableView!

    var addedFavoriteCities: [City] = []
    var cities: [City]?
    
    @IBOutlet weak var tbView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // load the list of cities
        cities = City.loadJson()
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
        detailView?.cityName = addedFavoriteCities[indexPath.row].name
        
        self.navigationController?.pushViewController(detailView!, animated: true)
        
    }
    
    func addFavoriteCity(city: City){
        print(city)
        self.addedFavoriteCities.append(city)
        tbView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let searchVC = segue.destination as? SearchController {
            searchVC.delegate = self
            searchVC.cities = cities ?? []
        }
    }
}


