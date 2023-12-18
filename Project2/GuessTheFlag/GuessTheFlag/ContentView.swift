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

struct RotatingButton: View {
  @State private var rotationAmount = 0.0
  @State private var opacityAmount = 1.0
  
  let id: Int
  let correctAwnser: Bool
  let flagLabel: FlagImage
  let action: () -> Void
  
  var body: some View {
    Button() {
      withAnimation {
        rotationAmount += 360
        if !correctAwnser {
          opacityAmount -= 0.75
        }
        action()
      }
    } label: {
      flagLabel
    }
    .rotation3DEffect(.degrees(rotationAmount), axis: (x: 0.0, y: 1.0, z: 0.0))
    .opacity(opacityAmount)
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
  
  @State private var selectedButton = 4
  @State private var animationAmount = 1.0
  
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
            RotatingButton(id: number, 
                           correctAwnser: number == correctAwnser ? true : false,
                           flagLabel: FlagImage(countries: countries, number: number)) {
              flagTapped(number)
              selectedButton = number
              withAnimation {
                animationAmount -= 0.5
              }
            }
            .scaleEffect(number == selectedButton ? 1.0 : animationAmount)
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
    animationAmount = 1.0
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
