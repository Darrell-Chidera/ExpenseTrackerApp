//
//  EditExpenseView.swift
//  ExpenseTrackerApp
//
//  Created by Chidera Anayo Mbachi on 2025-02-06.
//

import SwiftUI

struct EditExpenseView: View {
    @Binding var expense: Expense
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form {
            TextField("Amount", value: $expense.amount, formatter: NumberFormatter())
                .keyboardType(.decimalPad)
            TextField("Description", text: $expense.description)
            TextField("Category", text: $expense.category)
            Button("Save") {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .navigationTitle("Edit Expense")
    }
}
