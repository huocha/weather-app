//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

let urlPath = "https://api.openweathermap.org/data/2.5/"
let APPID = "9a4499be2096eea4ab09d99082cbd7d3"

extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        components?.queryItems = queries.map {
            URLQueryItem(name: $0.0, value: $0.1)
        }
    
        return components?.url
    }
}

struct City: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let weather: [CityWeather]
    let main: Main
}

struct CityWeather: Codable {
    let id: Int
    let main: String?
    let description: String?
    let icon: String
}

struct Coord: Codable {
    let lon: Double
    let lat: Double
}

struct Main: Codable {
    let temp: Double
    let pressure: Double
    let humidity: Double
    let temp_min: Double
    let temp_max: Double
}


// function to start the API
func queryCurrentWeather(matching query: [String: String], completion: @escaping (City?) -> Void) -> Void {
    
    let baseURL = URL(string: urlPath+"/weather?")!
    
    var query = query
    query["APPID"] = APPID
    
    let url = baseURL.withQueries(query)!
    

    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        let jsonDecoder = JSONDecoder()
//        print(String(data: data!, encoding: .utf8))
        if let data = data,
            let results = try? jsonDecoder.decode(City.self, from: data) {
            print(results)
            completion(results)
        }
        else {
            print(error)
        }
        
    }
    
    task.resume()
}

func queryFiveDayWeather(matching query: [String: String], completion: @escaping (City?) -> Void) -> Void {
    
    let baseURL = URL(string: urlPath+"/forcast?")!
    
    var query = query
    query["APPID"] = APPID
    
    let url = baseURL.withQueries(query)!
    
    
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        let jsonDecoder = JSONDecoder()
        //        print(String(data: data!, encoding: .utf8))
        if let data = data,
            let results = try? jsonDecoder.decode(City.self, from: data) {
            print(results)
            completion(results)
        }
        else {
            print(error)
        }
        
    }
    
    task.resume()
}



queryCurrentWeather(matching: ["q": "London"]) { (result) in
    print(result)
    PlaygroundPage.current.finishExecution()
}
