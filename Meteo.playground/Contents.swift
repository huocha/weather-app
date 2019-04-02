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

struct Clouds: Codable {
    let all: Int?
}

struct Wind: Codable {
    let speed: Double
    let deg: Double
}

struct Sys: Codable {
    let pod: String?
}

struct Rain: Codable {
    let rain: Double?
    
    enum CodingKeys: String, CodingKey {
        case rain = "3h"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.rain = try container.decodeIfPresent(Double.self, forKey: .rain)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.rain, forKey: .rain)
    }
}

struct Snow: Codable {
    let snow: Double?
    
    enum CodingKeys: String, CodingKey {
        case snow = "3h"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.snow = try container.decodeIfPresent(Double.self, forKey: .snow)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.snow, forKey: .snow)
    }
}

struct CityDetail: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population: Int
}

struct MainDetail: Codable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Double
    let sea_level: Double
    let grnd_level: Double
    let humidity: Double
    let temp_kf: Double
}

struct Detail: Codable {
    let dt: Int
    let main: MainDetail
    let weather: [CityWeather]
    let clouds: Clouds
    let wind: Wind
    let rain: Rain?
    let snow: Snow?
    let sys: Sys
    let dt_txt: String
    
    enum CodingKeys: String, CodingKey {
        case dt = "dt"
        case main = "main"
        case weather = "weather"
        case clouds = "clouds"
        case wind = "wind"
        case rain = "rain"
        case snow = "snow"
        case sys = "sys"
        case dt_txt = "dt_txt"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dt = try container.decode(Int.self, forKey: .dt)
        self.main = try container.decode(MainDetail.self, forKey: .main)
        self.weather = try container.decode([CityWeather].self, forKey: .weather)
        self.clouds = try container.decode(Clouds.self, forKey: .clouds)
        self.wind = try container.decode(Wind.self, forKey: .wind)
        self.rain = try container.decodeIfPresent(Rain.self, forKey: .rain)
        self.snow = try container.decodeIfPresent(Snow.self, forKey: .snow)
        self.sys = try container.decode(Sys.self, forKey: .sys)
        self.dt_txt = try container.decode(String.self, forKey: .dt_txt)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.dt, forKey: .dt)
        try container.encode(self.main, forKey: .main)
        try container.encode(self.weather, forKey: .weather)
        try container.encode(self.clouds, forKey: .clouds)
        try container.encode(self.wind, forKey: .wind)
        try container.encode(self.rain, forKey: .rain)
        try container.encode(self.snow, forKey: .snow)
        try container.encode(self.sys, forKey: .sys)
        try container.encode(self.dt_txt, forKey: .dt_txt)
    }
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
            print(error)
        }
        
    }
    
    task.resume()
}

func queryFiveDayWeather(matching query: [String: String], completion: @escaping (WeatherDetail?) -> Void) -> Void {
    
    let baseURL = URL(string: urlPath+"forecast?")!
    
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
            print(error)
        }
        
    }
    
    task.resume()
}

/*queryCurrentWeather(matching: ["q" : "London"]) { (result) in
 print(result)
 PlaygroundPage.current.finishExecution()
 }*/

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
            print("error:\(error)")
        }
    }
    return nil
}

let cities = loadJson(filename: "city.list")

func queryCityByName(matching cityName: String, completion: @escaping (CityData?) -> Void) -> Void {
    if let city  = cities?.first(where: { $0.name == cityName }) {
        completion(city)
    }
    
}

queryCityByName(matching: "Paris") { (result) in
    print(result)
    
}


PlaygroundPage.current.finishExecution()
