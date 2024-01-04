//
//  ListView.swift
//  Moonshot
//
//  Created by Sebastian Becker on 03.01.24.
//

import SwiftUI

struct ListView: View {
  let astronauts: [String: Astronaut]
  let missions: [Mission]
  
  var body: some View {
    LazyVStack {
      ForEach(missions) { mission in
        NavigationLink {
          MissionView(mission: mission, astronauts: astronauts)
        } label: {
          VStack(alignment: .leading) {
            HStack {
              VStack {
                Text(mission.displayName)
                  .font(.headline)
                  .foregroundStyle(.white)
                Text(mission.formattedLaunchDate)
                  .font(.caption)
                  .foregroundStyle(.gray.opacity(0.5))
              }
              .frame(maxWidth: .infinity, maxHeight: .infinity)
              .background(.lightBackground)
              
              Image(mission.image)
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .padding()
            }
            .clipShape(.rect(cornerRadius: 10))
            .overlay {
              RoundedRectangle(cornerRadius: 10)
                .stroke(.lightBackground)
            }
          }
        }
      }
      ThickDivider()
    }
  }
}

#Preview {
  return ContentView(showingGrid: false)
}
