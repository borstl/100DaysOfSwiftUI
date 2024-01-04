//
//  ContentView.swift
//  Edutainment
//
//  Created by Sebastian Becker on 19.12.23.
//

import SwiftUI

struct ContentView: View {
  private let colorWheel: [Color] = [.red, .orange, .yellow, .green, .blue, .indigo, .purple, .red]
  private let multiplicationRow: ClosedRange = 2...12
  @State private var selectedRow: Int = 1
  @State private var questionAmount: Int = 0
  
  var body: some View {
    ZStack {
      RadialGradient(colors: colorWheel, center: .top, startRadius: 5, endRadius: 1000)
        .ignoresSafeArea()
      VStack {
        Stepper(value: $selectedRow, in: multiplicationRow, step: 1) {
          Text("Select a number \(selectedRow)")
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        Picker("Amount of questions", selection: $selectedRow) {
          ForEach(5..<21) { number in
            Text("\(number)")
          }
        }
        .pickerStyle(.wheel)
        Spacer()
      }
      .padding()
      .navigationTitle("Edutainment")
    }
  }
}

#Preview {
  ContentView()
}
