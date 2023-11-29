//
//  ContentView.swift
//  UnitConverter
//
//  Created by Sebastian on 17.11.23.
//

import SwiftUI

struct ContentView: View {
  private let formatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter
  }()
  
  var body: some View {
    NavigationStack {
      Form {
        TemperatureComponent(formatter: formatter)
        LengthComponent(formatter: formatter)
        TimeComponent(formatter: formatter)
        VolumeComponent(formatter: formatter)
      }
      .navigationTitle("UnitConverter")
    }
  }
}

#Preview {
  ContentView()
}
