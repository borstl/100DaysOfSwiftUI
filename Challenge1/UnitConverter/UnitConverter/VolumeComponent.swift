//
//  VolumeComponent.swift
//  UnitConverter
//
//  Created by Sebastian on 28.11.23.
//

import SwiftUI

struct VolumeComponent: View {
  @State private var inputVolumeValue = 0.0
  @State private var inputVolumeUnit = UnitVolume.milliliters
  @State private var otherVolumeUnit = UnitVolume.cups
  
  private let volumeUnits = [UnitVolume.milliliters, UnitVolume.liters, UnitVolume.cups, UnitVolume.pints, UnitVolume.gallons]
  
  private var convertedVolume: Measurement<UnitVolume> {
    let volume = Measurement(value: inputVolumeValue, unit: inputVolumeUnit)
    return volume.converted(to: otherVolumeUnit)
  }
  
  let formatter: NumberFormatter
  
  var body: some View {
    Section("Volume") {
      Picker("Input Volume", selection: $inputVolumeUnit) {
        ForEach(volumeUnits, id: \.self) {
          Text($0.symbol)
        }
      }
      .pickerStyle(.segmented)
      
      TextField("Input Volume", value: $inputVolumeValue, formatter: formatter, prompt: Text("Volume"))
        .keyboardType(.decimalPad)
      
      Picker("Other Volume", selection: $otherVolumeUnit) {
        ForEach(volumeUnits, id: \.self) {
          Text($0.symbol)
        }
      }
      .pickerStyle(.segmented)
      
      Text(convertedVolume, format: .measurement(width: .abbreviated))
    }
  }
}
