//
//  Expense.swift
//  ExpenseTrackerApp
//
//  Created by Chidera Anayo Mbachi on 2025-02-06.
//

import Foundation

struct Expense: Identifiable, Codable {
    var id = UUID()
    var amount: Double
    var description: String
    var category: String
    
    enum CodingKeys: String, CodingKey {
        case amount, description, category
    }
    
    init(amount: Double, description: String, category: String) {
        self.id = UUID()
        self.amount = amount
        self.description = description
        self.category = category
    }
}
