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
    @State private var title : String = ""
    @State private var desc : String = ""
    @State private var amount : Float = 0
    @State private var date : Date = Date.now
    
    
    var body: some View {
        NavigationView {
            VStack{
                Form{
                    Section("Title", content: {
                        TextField("input expense title", text: $title)
                    })
                    
                    Section("Description", content: {
                        TextField("describe transaction", text: $desc)
                    })
                    
                    Section("Amount", content: {
                        TextField("enter amount", value: $amount, format: .currency(code: Locale.current.currencySymbol ?? "USD"))
                    })
                    
                }
                .frame(height: 320)
                .padding(.vertical)
                
                DatePicker("Choose date of transaction", selection: $date)
                    .datePickerStyle(.automatic)
                    .labelsHidden()
                Spacer()
                
            }.toolbar(content: {
                Button{
                    save()
                } label: {
                    Text("Save")
                        .italic()
                }
        })
        }
    }
    
    func save(){
        let expense = Expense(id: UUID().uuidString, title: title, description: desc, amount: amount, date: date)
        expensesVM.expenses.append(expense)
        budgetVM.costAccrued += amount
        budgetVM.save()
        expensesVM.save(expense: expense)
        dismiss()
    }
}

struct AddExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddExpenseView()
        }
    }
}
