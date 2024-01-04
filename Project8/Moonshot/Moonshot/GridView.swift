//
//  GridView.swift
//  Moonshot
//
//  Created by Sebastian Becker on 03.01.24.
//

import SwiftUI

struct GridView: View {
  let astronauts: [String: Astronaut]
  let missions: [Mission]
  
  let columns = [
    GridItem(.adaptive(minimum: 150))
  ]
  
  var body: some View {
    LazyVGrid(columns: columns) {
      ForEach(missions) { mission in
        NavigationLink {
          MissionView(mission: mission, astronauts: astronauts)
        } label: {
          VStack {
            Image(mission.image)
              .resizable()
              .scaledToFit()
              .frame(width: 100, height: 100)
              .padding()
            
            VStack {
              Text(mission.displayName)
                .font(.headline)
                .foregroundStyle(.white)
              
              Text(mission.formattedLaunchDate)
                .font(.caption)
                .foregroundStyle(.gray.opacity(0.5))
            }
            .padding(.vertical)
            .frame(maxWidth: .infinity)
            .background(.lightBackground)
          }
          .clipShape(.rect(cornerRadius: 10))
          .overlay(
            RoundedRectangle(cornerRadius: 10)
              .stroke(.lightBackground)
          )
        }
      }
    }
  }
}

#Preview {
  ContentView()
}
