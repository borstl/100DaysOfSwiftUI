//
//  ContentView.swift
//  iExpense
//
//  Created by Sebastian Becker on 21.12.23.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
  var id = UUID()
  let name: String
  let type: String
  let amount: Double
}

@Observable
class Expenses {
  var items = [ExpenseItem]() {
    didSet {
      if let encoded = try? JSONEncoder().encode(items) {
        UserDefaults.standard.set(encoded, forKey: "Items")
      }
    }
  }
  
  var personalExpenses: [ExpenseItem] {
      items.filter { $0.type == "Personal" }
  }
  
  var businessExpenses: [ExpenseItem] {
      items.filter { $0.type == "Business" }
  }
  
  func deleteItem(with id: UUID) {
    if let index = items.firstIndex(where: { $0.id == id }) {
      items.remove(at: index)
    }
  }
  
  init() {
    if let savedItems = UserDefaults.standard.data(forKey: "Items") {
      if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
        items = decodedItems
        return
      }
    }
    
    items = []
  }
}

struct ContentView: View {
  @State private var expenses = Expenses()
  
  @State private var showingAddExpense = false
  
  var body: some View {
    NavigationStack {
      List {
        Section("Personal") {
          ForEach(expenses.personalExpenses) { item in
            HStack {
              VStack(alignment: .leading) {
                Text(item.name)
                  .font(.headline)
                Text(item.type)
              }
              Spacer()
              Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                .foregroundStyle(determineColor(for: item.amount))
            }
          }
          .onDelete(perform: { index in removeItems(at: index, section: 0) } )
        }
        
        Section("Business") {
          ForEach(expenses.businessExpenses) { item in
            HStack {
              VStack(alignment: .leading) {
                Text(item.name)
                  .font(.headline)
                Text(item.type)
              }
              Spacer()
              Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                .foregroundStyle(determineColor(for: item.amount))
            }
          }
          .onDelete(perform: { index in removeItems(at: index, section: 1) } )
        }
      }
      .navigationTitle("iExpense")
      .toolbar {
        NavigationLink {
          AddView(expenses: expenses)
        } label: {
          Label("Add Expense", systemImage: "plus")
        }
        // Button("Add Expense", systemImage: "plus") {
        //   showingAddExpense = true
        // }
      }
      // .sheet(isPresented: $showingAddExpense) {
      //   AddView(expenses: expenses)
      // }
    }
  }
  
  func removeItems(at offsets: IndexSet, section: Int) {
      guard let index = offsets.first else { return }
      if section == 0 {
          expenses.deleteItem(with: expenses.personalExpenses[index].id)
      } else {
          expenses.deleteItem(with: expenses.businessExpenses[index].id)
      }
  }
  
  func determineColor(for amount: Double) -> Color {
    switch amount {
    case let value where value > 100:
      return .red
    case let value where value > 10:
      return .orange
    default:
      return .green
    }
  }
}

#Preview {
  ContentView()
}
