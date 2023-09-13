//
//  AddExpenseView.swift
//  ExpensesLedger
//
//  Created by Danjuma Nasiru on 20/04/2023.
//

import SwiftUI

struct AddExpenseView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var expensesVM : ExpensesVM
    @EnvironmentObject var budgetVM : BudgetVM
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section("Title") {
                        TextField("input expense title", text: $expensesVM.title)
                    }
                    
                    Section("Description") {
                        TextField("describe transaction", text: $expensesVM.desc)
                    }
                    
                    Section("Amount") {
//                        TextField("enter amount", value: $expensesVM.amount, format: .currency(code: Locale.current.currencySymbol ?? "USD"))
                            //.keyboardType(.decimalPad)
                        TextField("enter amount", value: $expensesVM.amount, formatter: expensesVM.formatter)
                            .keyboardType(.decimalPad)
                    }
                    
                }
                .frame(height: 320)
                .padding(.vertical)
                
                DatePicker("Choose date of transaction", selection: $expensesVM.date)
                    .datePickerStyle(.automatic)
                    .labelsHidden()
                
                Spacer()
            }
            .toolbar {
                Button {
                    expensesVM.addExpense()
                    budgetVM.updateCost(by: expensesVM.amount)
                    dismiss()
                } label: {
                    Text("Save")
                        .italic()
                }
            }
        }
    }
}

struct AddExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddExpenseView()
        }
    }
}
