//
//  TemperatureComponent.swift
//  UnitConverter
//
//  Created by Sebastian on 28.11.23.
//

import SwiftUI

struct TemperatureComponent: View {
  @State private var inputTemperatureValue = 0.0
  @State private var inputTemperatureUnit = UnitTemperature.celsius
  @State private var otherTemperatureUnit = UnitTemperature.kelvin
  
  private let temperatureUnits = [UnitTemperature.celsius, UnitTemperature.fahrenheit, UnitTemperature.kelvin]
  
  private var convertedTemperature: Measurement<UnitTemperature> {
    let temperature = Measurement(value: inputTemperatureValue, unit: inputTemperatureUnit)
    return temperature.converted(to: otherTemperatureUnit)
  }
  
  let formatter: NumberFormatter
  
  var body: some View {
    Section("Temperatur Converter") {
      Picker("Input Temperatur", selection: $inputTemperatureUnit) {
        ForEach(temperatureUnits, id: \.self) {
          Text("\($0.symbol)")
        }
      }
      .pickerStyle(.segmented)
      
      HStack {
        TextField("Input temperature", value: $inputTemperatureValue, formatter: formatter, prompt: Text("Temperature"))
          .keyboardType(.decimalPad)
        Text(convertedTemperature, format: .measurement())
      }
      
      Picker("Other Temperatur", selection: $otherTemperatureUnit) {
        ForEach(temperatureUnits, id: \.self) {
          Text("\($0.symbol)")
        }
      }
      .pickerStyle(.segmented)
      
      Text(convertedTemperature, format: .measurement(width: .abbreviated))
    }
  }
}
