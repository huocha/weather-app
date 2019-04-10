//
//  SearchController.swift
//  WeatherApp
//
//  Created by Nguyen Dao Huong Tra on 05/04/2019.
//  Copyright © 2019 jasmine. All rights reserved.
//
import UIKit
import Foundation

class SearchController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var cities = [CityData]()
    var searchedCities = [CityData]()
    var searching = false
    
    @IBOutlet weak var tbView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cities = CityData.loadJson()!
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchedCities.count
        } else {
            return cities.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        if searching {
            cell?.textLabel?.text = "\(searchedCities[indexPath.row].name) , \(searchedCities[indexPath.row].country)"
            cell?.detailTextLabel?.text = searchedCities[indexPath.row].country
        } else {
            cell?.textLabel?.text = "\(cities[indexPath.row].name) , \(cities[indexPath.row].country)"
            cell?.detailTextLabel?.text = cities[indexPath.row].country
        }
        
        return cell!
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedCities = cities.filter({$0.name.lowercased().prefix(searchText.count) == searchText.lowercased()})
        
        searching = true
        tbView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tbView.reloadData()
    }
}


