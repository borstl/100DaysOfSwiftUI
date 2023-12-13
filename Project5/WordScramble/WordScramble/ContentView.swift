//
//  ContentView.swift
//  WordScramble
//
//  Created by Sebastian on 10.12.23.
//

import SwiftUI

struct ContentView: View {
  @State private var usedWords = [String]()
  @State private var rootWord = ""
  @State private var newWord = ""
  
  @State private var errorTitle = ""
  @State private var errorMessage = ""
  @State private var showingError = false
  
  var body: some View {
    NavigationStack {
      List {
        Section {
          TextField("Add your word", text: $newWord)
            .textInputAutocapitalization(.never)
        }
        
        Section {
          ForEach(usedWords, id: \.self) { word in
            HStack {
              Image(systemName: "\(word.count).circle")
              Text(word)
            }
          }
        }
      }
      .navigationTitle(rootWord)
      .onSubmit(addNewWord)
      .onAppear(perform: startGame)
      .alert(errorTitle, isPresented: $showingError) {
        Button("OK") { }
      } message: {
        Text(errorMessage)
      }
    }
  }
  
  func addNewWord() {
    let awnser = newWord.lowercased().trimmingCharacters(in: .whitespaces)
    
    guard awnser.count > 0 else { return }
    guard isOriginal(word: awnser) else {
      wordError(title: "Word used already", message: "Be more original")
      return
    }
    guard isPossible(word: awnser) else {
      wordError(title: "Word not possible", message: "You can't spell that word from \(rootWord)")
      return
    }
    guard isReal(word: awnser) else {
      wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
      return
    }
    
    withAnimation {
      usedWords.insert(awnser, at: 0)
    }
    newWord = ""
  }
  
  func startGame() {
    if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
      if let startWords = try? String(contentsOf: startWordsURL) {
        let allWords = startWords.components(separatedBy: "\n")
        
        rootWord = allWords.randomElement() ?? "silkworm"
        
        return
      }
    }
    
    fatalError("Could not load start.txt from bundle.")
  }
  
  func isOriginal(word: String) -> Bool {
    !usedWords.contains(word)
  }
  
  func isPossible(word: String) -> Bool {
    var tempWord = rootWord
    
    for letter in word {
      if let pos = tempWord.firstIndex(of: letter) {
        tempWord.remove(at: pos)
      } else {
        return false
      }
    }
    
    return true
  }
  
  func isReal(word: String) -> Bool {
    let checker = UITextChecker()
    let range = NSRange(location: 0, length: word.utf16.count)
    let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
    
    return misspelledRange.location == NSNotFound
  }
  
  func wordError(title: String, message: String) {
    errorTitle = title
    errorMessage = message
    showingError = true
  }
}

#Preview {
  ContentView()
}
