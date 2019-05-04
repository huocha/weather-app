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
    let cod: Int
    let name: String
    let coord: Coord
    let weather: [CityWeather]
    let main: Main
    let wind: Wind
    let snow: Snow?
    let rain: Rain?
    let sys: CitySys
}

struct CitySys: Codable {
    let country: String?
    let id: Int?
    let message: Double
    let type: Int?
    let sunrise: Double
    let sunset: Double
}

struct CityWeather: Codable {
    let id: Int
    let main: String
    let description: String
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
    let temp_kf: Double?
    let sea_level: Double?
    let grnd_level: Double?
}

struct Clouds: Codable {
    let all: Int?
}

struct Wind: Codable {
    let speed: Double
    let deg: Double?
    let gust: Double?
}

struct Sys: Codable {
    let pod: String?
}

struct Rain: Codable {
    let one: Double?
    let three: Double?
    
    enum CodingKeys: String, CodingKey {
        case one = "1h"
        case three = "3h"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.one = try container.decodeIfPresent(Double.self, forKey: .one)
        self.three = try container.decodeIfPresent(Double.self, forKey: .three)
    }
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.one, forKey: .one)
        try container.encode(self.three, forKey: .three)
    }
}

struct Snow: Codable {
    let one: Double?
    let three: Double?
    
    enum CodingKeys: String, CodingKey {
        case one = "1h"
        case three = "3h"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.one = try container.decodeIfPresent(Double.self, forKey: .one)
        self.three = try container.decodeIfPresent(Double.self, forKey: .three)
    }
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.one, forKey: .one)
        try container.encode(self.three, forKey: .three)
    }
}

struct CityDetail: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String?
    let population: Int?
}

struct Detail: Codable {
    let dt: Int
    let main: Main
    let weather: [CityWeather]
    let clouds: Clouds
    let wind: Wind
    let rain: Rain?
    let snow: Snow?
    let sys: Sys
    let dt_txt: String
}

struct WeatherDetail: Codable {
    let cod: String
    let message: Double
    let cnt: Int
    let list: [Detail]
    let city: CityDetail
}

// function to get current weather by
func queryCurrentWeather(matching query: [String: String], completion: @escaping (City?) -> Void) -> Void {
    
    let baseURL = URL(string: urlPath+"/weather?")!
    
    var query = query
    query["APPID"] = APPID
    
    let url = baseURL.withQueries(query)!
    

    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        let jsonDecoder = JSONDecoder()
        if let data = data,
            let results = try? jsonDecoder.decode(City.self, from: data) {
            completion(results)
        }
        else {
            print(error!)
        }
        
    }
    
    task.resume()
}

func queryFiveDayWeather(matching query: [String: String], completion: @escaping (WeatherDetail?) -> Void) -> Void {
    
    let baseURL = URL(string: urlPath+"/forecast?")!
    
    var query = query
    query["APPID"] = APPID
    
    let url = baseURL.withQueries(query)!
    
    
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        let jsonDecoder = JSONDecoder()
        
        if let data = data,
            let results = try? jsonDecoder.decode(WeatherDetail.self, from: data) {
            completion(results)
        }
        else {
            print(error!)
        }
        
    }
    
    task.resume()
}

struct CityData: Codable {
    let id: Int
    let name: String
    let country: String
    let coord: Coord
}

func loadJson(filename fileName: String) -> [CityData]? {
    if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode([CityData].self, from: data)
            return jsonData
        } catch {
            print("error")
        }
    }
    return nil
}

let cities = loadJson(filename: "city.list")

for i in 0...60 {

    queryCurrentWeather(matching: ["id": String((cities?[i].id)!) ]) { (result) in
        print("\(i)")
        print(result?.name)
        print("\n")
    }

    queryFiveDayWeather(matching: ["id" : String((cities?[i].id)!) ]) { (result) in
        print("\(i)")
        print(result?.city.id)
        print("\n")
    }
}


PlaygroundPage.current.finishExecution()
