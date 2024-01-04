//
//  MissionView.swift
//  Moonshot
//
//  Created by Sebastian Becker on 02.01.24.
//

import SwiftUI

struct MissionView: View {
  let mission: Mission
  let crew: [CrewMember]
  
  @State private var showingGrid: Bool
  
  var body: some View {
    ScrollView {
      VStack {
        Image(mission.image)
          .resizable()
          .scaledToFit()
          .containerRelativeFrame(.horizontal) { width, axis in
            width * 0.6
          }
        
        Text(mission.launchDate?.formatted(date: .long, time: .shortened) ?? "N/A")
          .padding(.top, 5)
        
        VStack(alignment: .leading) {
          ThickDivider()
          
          Text("Mission Highlights")
            .font(.title.bold())
            .padding(.bottom, 5)
          
          Text(mission.description)
          ThickDivider()
          
          Text("Crew")
            .font(.title.bold())
            .padding(.bottom, 5)
        }
        .padding(.horizontal)
        
        ScrollableCrewView(crew: crew)
        
      }
      .padding(.bottom)
    }
    .navigationTitle(mission.displayName)
    .navigationBarTitleDisplayMode(.inline)
    .background(.darkBackground)
  }
  
  init(mission: Mission, astronauts: [String: Astronaut], showingGrid: Bool = true) {
    self.mission = mission
    self.crew = mission.crew.map { member in
      if let astronaut = astronauts[member.name] {
        return CrewMember(role: member.role, astronaut: astronaut)
      } else {
        fatalError("Missing \(member.name)")
      }
    }
    self._showingGrid = State(initialValue: showingGrid)
  }
}

#Preview {
  let missions: [Mission] = Bundle.main.decode("missions.json")
  let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
  
  return MissionView(mission: missions[1], astronauts: astronauts)
    .preferredColorScheme(.dark)
}
