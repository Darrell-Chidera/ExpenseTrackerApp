//
//  ContentView.swift
//  ExpenseTrackerApp
//
//  Created by Chidera Anayo Mbachi on 2025-02-06.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ExpenseViewModel()
    @State private var amount: String = ""
    @State private var description: String = ""
    @State private var category: String = "Food"
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    let categories = ["Food", "Travel", "Bills", "Entertainment", "Other"]
    
    private let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "CAD"
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Add Expense")) {
                        TextField("Amount", text: $amount)
                            .keyboardType(.decimalPad)
                        TextField("Description", text: $description)
                        Picker("Category", selection: $category) {
                            ForEach(categories, id: \.self) { category in
                                Text(category)
                            }
                        }
                        
                        Button(action: addExpense) {
                            Text("Add Expense")
                        }
                    }
                    
                    Section(header: Text("Total Expenses: \(currencyFormatter.string(from: NSNumber(value: viewModel.total)) ?? "$0.00")")) {
                        Picker("Filter by Category", selection: $viewModel.selectedCategory) {
                            Text("All").tag("All")
                            ForEach(categories, id: \.self) { category in
                                Text(category).tag(category)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        List(viewModel.filteredExpenses()) { expense in
                            NavigationLink(destination: EditExpenseView(expense: binding(for: expense))) {
                                HStack {
                                    Text(expense.description)
                                    Spacer()
                                    Text(currencyFormatter.string(from: NSNumber(value: expense.amount)) ?? "$0.00")
                                }
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive, action: { deleteExpense(expense) }) {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Expense Tracker")
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func addExpense() {
        guard !amount.isEmpty else {
            showAlert(message: "Please enter an amount.")
            return
        }
        
        guard let amountValue = Double(amount) else {
            showAlert(message: "Invalid amount. Please enter a valid number.")
            return
        }
        
        guard amountValue > 0 else {
            showAlert(message: "Amount must be greater than zero.")
            return
        }
        
        guard !description.isEmpty else {
            showAlert(message: "Please enter a description.")
            return
        }
        
        viewModel.addExpense(amount: amountValue, description: description, category: category)
        amount = ""
        description = ""
    }
    
    private func deleteExpense(_ expense: Expense) {
        if let index = viewModel.expenses.firstIndex(where: { $0.id == expense.id }) {
            viewModel.expenses.remove(at: index)
        }
    }
    
    private func binding(for expense: Expense) -> Binding<Expense> {
        guard let index = viewModel.expenses.firstIndex(where: { $0.id == expense.id }) else {
            showAlert(message: "Expense not found.")
            return .constant(Expense(amount: 0, description: "", category: ""))
        }
        return $viewModel.expenses[index]
    }
    
    private func showAlert(message: String) {
        alertMessage = message
        showingAlert = true
    }
}

