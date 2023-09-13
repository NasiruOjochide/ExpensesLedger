//
//  Routes.swift
//  ExpensesLedger
//
//  Created by Danjuma Nasiru on 12/09/2023.
//

import Foundation
import SwiftUI

enum Routes {
    case dashboard
    case expenseDetail(expense: Expense)
    case addExpense
    case signUp
    case forgotPassword
}

extension Routes: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.hashValue)
    }
    
    static func == (lhs: Routes, rhs: Routes) -> Bool {
        switch (lhs, rhs) {
        case (.dashboard, .dashboard):
            return true
            
        case (.expenseDetail(let lhs), .expenseDetail(let rhs)):
            return lhs == rhs
            
        case (.addExpense, .addExpense):
            return true
        
        case (.signUp, .signUp):
            return true
            
        case (.forgotPassword, .forgotPassword):
            return true
            
        default:
            return true
        }
        
    }
}

extension Routes: View {
    
    var body: some View {
        
        switch self {
        case .dashboard:
            ContentView()
            
        case .expenseDetail(let expense):
            ExpenseDetailsView(expense: expense)
            
        case .addExpense:
            AddExpenseView()
            
        case .signUp:
            SignUpView()
            
        case .forgotPassword:
            ForgotPasswordView()
        }
    }
}
