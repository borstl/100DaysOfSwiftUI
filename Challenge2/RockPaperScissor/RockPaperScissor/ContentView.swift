//
//  ContentView.swift
//  RockPaperScissor
//
//  Created by Sebastian on 06.12.23.
//

import SwiftUI

struct ContentView: View {
  @State private var currentMove = ""
  @State private var result = false
  private let rounds = 10
  @State private var round = 0
  @State private var wins = 0
  private let moves = ["✊", "🤚", "✌️"]
  @State private var showFinish = false
  
  var body: some View {
    ZStack {
      RadialGradient(
        colors: [.red, .blue],
        center: .top, startRadius: 0, endRadius: 1000)
      .ignoresSafeArea()
      
      VStack {
        Spacer()
        Spacer()
        
        Text("Win \(wins)/\(rounds)")
          .font(.title)
          .foregroundColor(.white)
        Text("Round \(round)")
          .font(.headline)
          .foregroundColor(.secondary)
        Spacer()
        
        HStack {
          ForEach(0..<3) { move in
            Button() {
              result = hiddenGame()
              //result = playGame(with: moves[move])
              if true == result {
                wins += 1
              }
              round += 1
              if round >= rounds {
                showFinish = true
              }
            } label: {
              Text(moves[move])
            }
          }
          .font(.system(size: 100))
          .clipShape(.rect(cornerRadius: 20))
          .background(.thinMaterial)
        }
        Spacer()
      }
      .alert("Finished", isPresented: $showFinish) {
        Button("Restart", action: restartGame)
      } message: {
        Text("You finished with a score of \(wins)/\(rounds).")
      }
    }
  }
  
  func hiddenGame() -> Bool {
    return Bool.random()
  }
  
  func playGame(with move: String) -> Bool {
    let otherMove = moves[Int.random(in: 0..<3)]
    if move == otherMove {
      print("Tie!")
      return false
    }
    
    switch move {
    case "✊":
      if otherMove == "✌️" {
        return true
      }
    case "🤚":
      if otherMove == "✊" {
        return true
      }
    case "✌️":
      if otherMove == "✋" {
        return true
      }
    default:
      print("Invalid Input!")
      return false
    }
    return false
  }
  
  func restartGame() {
    round = 0
    wins = 0
  }
}

#Preview {
  ContentView()
}
