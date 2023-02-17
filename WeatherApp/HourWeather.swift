//
//  HourWeather.swift
//  WeatherApp
//
//  Created by 류지예 on 2023/02/17.
//

import Foundation

struct HourWeather: Decodable {
    let list: [Weathers]
    
    init(list: [Weathers]) {
        self.list = list
    }
}

struct Weathers: Decodable, Identifiable {
    var id = UUID()
    let main: Mains
    let weather: [WeatherDetails]
    let dt_txt: String
}

struct Mains: Decodable {
    let temp: Double
}

struct WeatherDetails: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
