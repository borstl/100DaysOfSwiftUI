//
//  ContentView.swift
//  Moonshot
//
//  Created by Sebastian Becker on 28.12.23.
//

import SwiftUI

struct ContentView: View {
  let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
  let missions: [Mission] = Bundle.main.decode("missions.json")
  
  @State private var showingGrid: Bool
  
  var body: some View {
    NavigationStack {
      ScrollView {
        Group {
          if showingGrid {
            GridView(astronauts: astronauts, missions: missions)
          } else {
            ListView(astronauts: astronauts, missions: missions)
          }
        }
        .padding([.horizontal, .bottom])
      }
      .navigationTitle("Moonshot")
      .background(.darkBackground)
      .preferredColorScheme(.dark)
      .toolbar {
        ToolbarItem(placement: .automatic) {
          Button(showingGrid ? "List" : "Grid") {
            showingGrid.toggle()
          }
        }
      }
    }
  }
  
  init(showingGrid: Bool = true) {
    self.showingGrid = showingGrid
  }
}

#Preview {
  ContentView()
}
