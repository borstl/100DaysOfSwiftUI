//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Sebastian on 30.11.23.
//

import SwiftUI

struct FlagImage: View {
  let countries: [String]
  let number: Int
  
  var body: some View {
    Image(countries[number])
      .clipShape(.capsule)
      .shadow(radius: 5)
  }
}

struct Prominent: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.title)
      .foregroundColor(.blue)
  }
}

extension View {
  func titleStyle() -> some View {
    modifier(Prominent())
  }
}

struct ContentView: View {
  @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
  @State private var correctAwnser = Int.random(in: 0...2)
  @State private var showingScore = false
  private let gameRounds = 8
  @State private var showingFinish = false
  @State private var scoreTitle = ""
  @State private var round = 1
  @State private var score = 0
  
  var body: some View {
    ZStack {
      RadialGradient(stops: [
        .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
        .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
      ], center: .top, startRadius: 200, endRadius: 700)
      .ignoresSafeArea()
      
      VStack {
        Spacer()
        Text("Guess the Flag")
          .font(.largeTitle.bold())
          .foregroundStyle(.white)
        VStack(spacing: 15) {
          VStack {
            Text("Tap the flag of")
              .foregroundStyle(.secondary)
              .font(.subheadline.weight(.heavy))
            
            Text(countries[correctAwnser])
              .titleStyle()
              //.font(.largeTitle.weight(.semibold))
          }
          
          ForEach(0..<3) { number in
            Button() {
              flagTapped(number)
            } label: {
              FlagImage(countries: countries, number: number)
            }
          }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(.regularMaterial)
        .clipShape(.rect(cornerRadius: 20))
        
        Spacer()
        Spacer()
        
        Text("Round \(round)/\(gameRounds)")
        Text("Score: \(score)")
          .font(.title.bold())
          .foregroundStyle(.white)
        
        Spacer()
      }
      .alert("Finish!", isPresented: $showingFinish) {
        Button("Restart", action: resetGame)
      } message: {
        Text("You finished this game with a score of \(score)/\(gameRounds)")
      }
      .alert(scoreTitle, isPresented: $showingScore) {
        Button("Continue", action: askQuestion)
      } message: {
        Text("Your score is \(score)")
      }
      .padding()
    }
  }
  
  func flagTapped(_ number: Int) {
    if number == correctAwnser {
      score += 1
      scoreTitle = "Correct"
    } else {
      scoreTitle = "Wrong, that's the flag of \(countries[number])"
    }
    if gameRounds <= round {
      showingFinish = true
    } else {
      showingScore = true
    }
  }
  
  func askQuestion() {
    countries.shuffle()
    correctAwnser = Int.random(in: 0...2)
    round += 1
  }
  
  func resetGame() {
    score = 0
    round = 1
  }
}

#Preview {
  ContentView()
}
