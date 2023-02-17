//
//  ContentView.swift
//  WeatherApp
//
//  Created by 류지예 on 2023/02/17.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selection = 1
    
    var body: some View {
        TabView(selection: $selection) {
            CurrentTemp()
                .tabItem {
                    Image(systemName: "sun.and.horizon.circle")
                    Text("Current")
                }.tag(1)
            
            FiveDaysTemp()
                .tabItem {
                    Image(systemName: "calendar.circle.fill")
                    Text("Current")
                }.tag(1)
            
            Text("3")
                .tabItem {
                    Image(systemName: "map.circle.fill")
                    Text("Map")
                }.tag(1)
        }
        .onAppear() {
            UITabBar.appearance().barTintColor = .white
        }
        .accentColor(.red)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

