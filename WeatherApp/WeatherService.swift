//
//  WeatherService.swift
//  WeatherApp
//
//  Created by 류지예 on 2023/02/17.
//

import Foundation

enum NetworkError: Error {
    case badUrl
    case noData
    case decodingError
}

class WeatherService {
    private var apiKey: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "APIKeys", ofType: "plist") else {
                fatalError("Couldn't find file 'APIKeys.plist'.")
            }
            
            let plist = NSDictionary(contentsOfFile: filePath)
            
            guard let value = plist?.object(forKey: "CurrentWeather") as? String else {
                fatalError("Couldn't find key 'CurrentWeather' in 'APIKeys.plist'.")
            }
            return value
        }
    }
    
    func getWeather(completion: @escaping (Result<WeatherResponse, NetworkError>) -> Void) {
        
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=seoul&appid=\(apiKey)")
        guard let url = url else {
            return completion(.failure(.badUrl))
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            
            let weatherResponse = try? JSONDecoder().decode(WeatherResponse.self, from: data)

            if let weatherResponse = weatherResponse {
                print(weatherResponse)
                completion(.success(weatherResponse))
            } else {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}

struct WeatherList: Decodable {
    let list: [HourWeather]
}

class FiveDaysWeather {
    private var apiKey: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "APIKeys", ofType: "plist") else {
                fatalError("Couldn't find file 'APIKeys.plist'.")
            }
            
            let plist = NSDictionary(contentsOfFile: filePath)
            
            guard let value = plist?.object(forKey: "FiveDays") as? String else {
                fatalError("Couldn't find key 'FiveDays' in 'APIKeys.plist'.")
            }
            return value
        }
    }
    
    func getWeather(completion: @escaping (Result<HourWeather, NetworkError>) -> Void) {
        
        let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?q=seoul&appid=\(apiKey)&cnt=40")

        guard let url = url else {
            return completion(.failure(.badUrl))
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            
            let hourWeather = try? JSONDecoder().decode(HourWeather.self, from: data)

            if let hourWeather = hourWeather {
                completion(.success(hourWeather))
            } else {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
