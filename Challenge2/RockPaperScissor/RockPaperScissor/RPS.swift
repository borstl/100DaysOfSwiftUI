//
//  RPS.swift
//  RockPaperScissor
//
//  Created by Sebastian on 07.12.23.
//

import SwiftUI

enum GameMove: String, CaseIterable {
  case rock = "Rock"
  case paper = "Paper"
  case scissors = "Scissors"
}

struct RPS: View {
  @State private var playerMove: GameMove?
  @State private var computerMove: GameMove?
  @State private var gameResult: String?
  
  var body: some View {
    VStack {
      Text("Rock, Paper, Scissors")
        .font(.title)
        .padding()
      
      HStack {
        Button("Rock") { playGame(.rock) }
        Button("Paper") { playGame(.paper) }
        Button("Scissors") { playGame(.scissors) }
      }
      .padding()
      
      Text("Your move: \(playerMove?.rawValue ?? "")")
      Text("Computer's move: \(computerMove?.rawValue ?? "")")
      Text("Result: \(gameResult ?? "")")
    }
  }
  
  func playGame(_ move: GameMove) {
    playerMove = move
    computerMove = GameMove.allCases.randomElement()
    
    if let computerMove = computerMove {
      if move == computerMove {
        gameResult = "It's a tie!"
      } else if (move == .rock && computerMove == .scissors) ||
                  (move == .paper && computerMove == .rock) ||
                  (move == .scissors && computerMove == .paper) {
        gameResult = "You win!"
      } else {
        gameResult = "You lose!"
      }
    }
  }
}

#Preview {
  RPS()
}
