//
//  FiveDaysTemp.swift
//  WeatherApp
//
//  Created by 류지예 on 2023/02/17.
//

import SwiftUI

struct FiveDaysTemp: View {
    @State var hourWeather: HourWeather?
    @State var isLoading = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                if isLoading {
                    ProgressView()
                } else if let hourWeather = hourWeather {
                    VStack {
                        ForEach(hourWeather.list) { timeWeather in
                            VStack {
                                HStack {
                                    Text("\(timeWeather.dt_txt)")
                                    Spacer()
                                    Text("\(kelvinToCelsius(timeWeather.main.temp))°C")
                                }
                                Divider()
                            }
                        }
                    }
                } else {
                    Text("Weather information is not available.")
                }
            }
            .onAppear {
                self.isLoading = true
                FiveDaysWeather().getWeather { result in
                    DispatchQueue.main.async {
                        self.isLoading = false
                        switch result {
                        case .success(let weatherList):
                            self.hourWeather = HourWeather(list: weatherList.list)
                        case .failure(let error):
                            print(error.localizedDescription)
                            self.hourWeather = nil
                        }
                    }
                }
            }
        }
    }
    
    func kelvinToCelsius(_ kelvin: Double) -> Double {
        return kelvin - 273.15
    }
}



struct FiveDaysTemp_Previews: PreviewProvider {
    static var previews: some View {
        FiveDaysTemp()
    }
}
