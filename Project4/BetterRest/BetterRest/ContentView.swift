//
//  ContentView.swift
//  BetterRest
//
//  Created by Sebastian on 07.12.23.
//

import CoreML
import SwiftUI

struct ContentView: View {
  @State private var wakeUp = defaultWakeTime
  @State private var sleepAmount = 8.0
  @State private var coffeeAmount = 1
  
  @State private var alertTitle = ""
  @State private var alertMessage = ""
  @State private var showingAlert = false
  
  private var idealBedtime: String {
    calculateBedtime2().formatted(date: .omitted, time: .shortened)
  }
  
  static var defaultWakeTime: Date {
    var components = DateComponents()
    components.hour = 7
    components.minute = 0
    return Calendar.current.date(from: components) ?? .now
  }
  
  var body: some View {
    NavigationStack {
      Spacer()
      Text("Your ideal bedtime is \(idealBedtime)")
        .font(.system(size: 25).bold())
      
      Form {
        Section("When do you want to wake up?") {
          DatePicker("Please enter a date", selection: $wakeUp, displayedComponents: .hourAndMinute)
            .labelsHidden()
        }
        .font(.headline)
        //VStack(alignment: .leading, spacing: 0) {
        //  Text("When do you want to wake up?")
        //    .font(.headline)
        //  DatePicker("Please enter a date", selection: $wakeUp, displayedComponents: .hourAndMinute)
        //    .labelsHidden()
        //}
        
        Section("Desired amount of sleep") {
          Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
        }
        .font(.headline)
        //VStack(alignment: .leading, spacing: 0) {
        //  Text("Desired amount of sleep")
        //    .font(.headline)
        //  Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
        //}
        
        Section("Daily coffee intake") {
          Picker("Cups of coffee", selection: $coffeeAmount) {
            ForEach(0..<21) {
              Text($0, format: .number)
            }
          }
          //Stepper("^[\(coffeeAmount) cups](inflect: true)", value: $coffeeAmount, in: 1...20)
        }
        .font(.headline)
        //VStack(alignment: .leading, spacing: 0) {
        //  Text("Daily coffee intake")
        //    .font(.headline)
        //  Stepper("^[\(coffeeAmount) cups](inflect: true)", value: $coffeeAmount, in: 1...20)
        //}
      }
      .navigationTitle("BetterRest")
      .toolbar {
        Button("Bedtime", action: calculateBedtime)
      }
      .alert(alertTitle, isPresented: $showingAlert) {
        Button("OK") { }
      } message: {
        Text(alertMessage)
      }
    }
  }
  
  func calculateBedtime2() -> Date {
    do {
      let config = MLModelConfiguration()
      let model = try SleepCalculator(configuration: config)
      
      let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
      let hour = (components.hour ?? 0) * 60 * 60
      let minute = (components.minute ?? 0) * 60
      
      let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
      
      return wakeUp - prediction.actualSleep
    } catch {
      alertTitle = "Error"
      alertMessage = "Sorry, there was a problem calculating your bedtime."
      showingAlert = true
    }
    
    return Date.now
  }
  
  func calculateBedtime() {
    do {
      let config = MLModelConfiguration()
      let model = try SleepCalculator(configuration: config)
      
      let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
      let hour = (components.hour ?? 0) * 60 * 60
      let minute = (components.minute ?? 0) * 60
      
      let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
      
      let sleepTime = wakeUp - prediction.actualSleep
      alertTitle = "Your ideal bedtime is..."
      alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
      //idealBedtime = sleepTime.formatted(date: .omitted, time: .shortened)
    } catch {
      alertTitle = "Error"
      alertMessage = "Sorry, there was a problem calculating your bedtime."
      //showingAlert = true
    }
    
    showingAlert = true
  }
  
  //  func exampleDates() {
  //    let tomorrow = Date.now.addingTimeInterval(86400)
  //    let range = Date.now...tomorrow
  //
  //    var component = DateComponents()
  //    component.hour = 8
  //    component.minute = 0
  //    let date = Calendar.current.date(from: component) ?? .now
  //
  //    let components = Calendar.current.dateComponents([.hour, .minute], from: .now)
  //    let hour = components.hour ?? 0
  //    let minute = components.minute ?? 0
  //  }
}

#Preview {
  ContentView()
}
