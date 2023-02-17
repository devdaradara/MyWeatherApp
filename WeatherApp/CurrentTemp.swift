//
//  CurrentTemp.swift
//  WeatherApp
//
//  Created by 류지예 on 2023/02/17.
//

import SwiftUI

struct CurrentTemp: View {
    @State var weather: WeatherResponse?
    @State var isLoading = false
    @State var isBlack = false
    
    var body: some View {
        ZStack {
            backgroundView()
            
            VStack {
                if isLoading {
                    ProgressView()
                } else if let weather = weather {
                    VStack {
                        Text("\(weather.name)")
                            .font(.title)
                            .padding()
                        
                        Text("\(kelvinToCelsius(weather.main.temp), specifier: "%.0f")°C")
                            .font(.system(size: 100))
                            .padding()
                        
                        HStack {
                            Image(systemName: "\(weatherIcon())")
                                .font(.title2)
                            
                            Text("\(weather.weather.first?.description ?? "")")
                                .font(.title2)
                                .padding()
                            
                        }
                        
                        HStack {
                            Text("Max: \(kelvinToCelsius(weather.main.temp_max), specifier: "%.0f")°C")
                                .padding()
                            
                            Text("|")
                            
                            Text("Min: \(kelvinToCelsius(weather.main.temp_min), specifier: "%.0f")°C")
                                .padding()
                        }
                        
                        
                    }
                } else {
                    Text("Weather information is not available.")
                }
            }
            .foregroundColor(isBlack ? .black : .white)
            .onAppear {
                self.isLoading = true
                WeatherService().getWeather { result in
                    DispatchQueue.main.async {
                        self.isLoading = false
                        switch result {
                        case .success(let weatherResponse):
                            self.weather = weatherResponse
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    
    
    @ViewBuilder
    func backgroundView() -> some View {
        let backgroundImage: String = backGroundImage()
        GeometryReader { geometry in
            Image("\(backgroundImage)")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
        }
        .ignoresSafeArea()
    }

    func backGroundImage() -> String {
        guard let weather = self.weather else {
            return "nosign"
        }
        switch weather.weather.first?.icon {
        case "01d":
            isBlack = true
            return "Sun"
        case "01n":
            return "Moon"
        case "02d", "02n", "03d", "03n", "04d", "04n":
            return "Cloud"
        case "09d", "09n", "10d", "10n":
            return "Rain"
        case "11d", "11n":
            return "Thunder"
        case "13d", "13n":
            return "Snow"
        case "50d", "50n":
            return "Fog"
        default:
            return "nosign"
        }
    }
    
    func weatherIcon() -> String {
        guard let weather = self.weather else {
            return "nosign"
        }
        switch weather.weather.first?.icon {
        // 맑음
        case "01d":
            return "sun.max.fill"
        case "01n":
            return "moon.stars.fill"
        // 구름
        case "02d":
            return "cloud.sun.fill"
        case "02n":
            return "cloud.moon.fill"
        case "03d", "03n", "04d", "04n":
            return "cloud.fill"
        // 비
        case "09d", "09n", "10d", "10n":
            return "cloud.drizzle.fill"
        // 번개
        case "11d", "11n":
            return "cloud.bolt.fill"
        //눈
        case "13d", "13n":
            return "cloud.snow.fill"
        // 안개
        case "50d", "50n":
            return "cloud.fog.fill"
        default:
            return "nosign"
        }
    }
    
    func kelvinToCelsius(_ fahrenheit: Double) -> Double {
        return (fahrenheit - 273.15)
    }
}

struct CurrentTemp_Previews: PreviewProvider {
    static var previews: some View {
        CurrentTemp()
    }
}
