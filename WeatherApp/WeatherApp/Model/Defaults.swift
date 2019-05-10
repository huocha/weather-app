//
//  Default.swift
//  WeatherApp
//
//  Created by Nguyen Dao Huong Tra on 10/05/2019.
//  Copyright © 2019 jasmine. All rights reserved.
//

import Foundation
struct Defaults {

    static func save(id: Int){
        var ids = UserDefaults.standard.array(forKey: "id") as? [Int] ?? []
        ids.append(id)
        
        UserDefaults.standard.set(ids, forKey: "id")
    }
    
    static func remove(id: Int){
        var ids = UserDefaults.standard.array(forKey: "id") as? [Int] ?? []
        
        ids = ids.filter() { $0 != id }
        
        UserDefaults.standard.set(ids, forKey: "id")
    }
    
    static func getIds() -> [Int] {
        return UserDefaults.standard.array(forKey: "id") as? [Int] ?? []
    }
    
    static func clearUserData(){
        UserDefaults.standard.removeObject(forKey: "id")
    }
}
