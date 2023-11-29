//
//  TimeComponent.swift
//  UnitConverter
//
//  Created by Sebastian on 28.11.23.
//

import SwiftUI
import Foundation

extension UnitDuration {
    static let days = UnitDuration(symbol: "days")
}

struct TimeComponent: View {
  @State private var inputTimeValue = 0.0
  @State private var inputTimeUnit = UnitDuration.seconds
  @State private var otherTimeUnit = UnitDuration.hours
  
  private let timeUnits = [UnitDuration.seconds, UnitDuration.minutes, UnitDuration.hours, UnitDuration.days]
  
  private var convertedTime: Measurement<UnitDuration> {
    let time = Measurement(value: inputTimeValue, unit: inputTimeUnit)
    return time.converted(to: otherTimeUnit)
  }
  
  let formatter: NumberFormatter
  
  var body: some View {
    Section("Time") {
      Picker("Input Time", selection: $inputTimeUnit) {
        ForEach(timeUnits, id: \.self) {
          Text($0.symbol)
        }
      }
      .pickerStyle(.segmented)
      
      TextField("Input Time", value: $inputTimeValue, formatter: formatter, prompt: Text("Time"))
        .keyboardType(.numberPad)
      
      Picker("Other Time", selection: $otherTimeUnit) {
        ForEach(timeUnits, id: \.self) {
          Text($0.symbol)
        }
      }
      .pickerStyle(.segmented)
      
      Text(convertedTime, format: .measurement(width: .abbreviated))
    }
  }
}
