//
//  ExpenseViewModel.swift
//  ExpenseTrackerApp
//
//  Created by Chidera Anayo Mbachi on 2025-02-06.
//

import Foundation
import Combine

class ExpenseViewModel: ObservableObject {
    @Published var expenses: [Expense] = [] {
        didSet {
            saveExpenses()
            calculateTotal()
        }
    }
    @Published var total: Double = 0.0
    @Published var selectedCategory: String = "All"
    
    init() {
        loadExpenses()
        calculateTotal()
    }
    
    func addExpense(amount: Double, description: String, category: String) {
        let newExpense = Expense(amount: amount, description: description, category: category)
        expenses.append(newExpense)
    }
    
    func calculateTotal() {
        total = expenses.reduce(0) { $0 + $1.amount }
    }
    
    func filteredExpenses() -> [Expense] {
        if selectedCategory == "All" {
            return expenses
        } else {
            return expenses.filter { $0.category == selectedCategory }
        }
    }
    
    private func saveExpenses() {
        do {
            let encoded = try JSONEncoder().encode(expenses)
            UserDefaults.standard.set(encoded, forKey: "expenses")
        } catch {
            print("Failed to save expenses: \(error.localizedDescription)")
        }
    }
    
    private func loadExpenses() {
        guard let data = UserDefaults.standard.data(forKey: "expenses") else { return }
        
        do {
            expenses = try JSONDecoder().decode([Expense].self, from: data)
        } catch {
            print("Failed to load expenses: \(error.localizedDescription)")
        }
    }
}
