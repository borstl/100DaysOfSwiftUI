//
//  LengthComponent.swift
//  UnitConverter
//
//  Created by Sebastian on 28.11.23.
//

import SwiftUI

struct LengthComponent: View {
  @State private var inputLengthValue = 0.0
  @State private var inputLengthUnit = UnitLength.meters
  @State private var otherLengthUnit = UnitLength.feet
  
  private let lengthUnits = [UnitLength.meters, UnitLength.kilometers, UnitLength.feet, UnitLength.yards, UnitLength.miles]
  
  private var convertedLength: Measurement<UnitLength> {
    let length = Measurement(value: inputLengthValue, unit: inputLengthUnit)
    return length.converted(to: UnitLength.meters)
  }
  
  let formatter: NumberFormatter
  
  var body: some View {
    Section("Length") {
      Picker("Input Length", selection: $inputLengthUnit) {
        ForEach(lengthUnits, id: \.self) {
          Text($0.symbol)
        }
      }
      .pickerStyle(.segmented)
      
      TextField("Input Length", value: $inputLengthValue, formatter: formatter, prompt: Text("Length"))
        .keyboardType(.decimalPad)
      
      Picker("Other Length", selection: $otherLengthUnit) {
        ForEach(lengthUnits, id: \.self) {
          Text($0.symbol)
        }
      }
      .pickerStyle(.segmented)
      
      Text(convertedLength, format: .measurement(width: .abbreviated))
    }
  }
}
