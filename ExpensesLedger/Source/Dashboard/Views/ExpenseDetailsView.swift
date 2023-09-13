//
//  ExpenseDetailsView.swift
//  ExpensesLedger
//
//  Created by Danjuma Nasiru on 05/05/2023.
//

import SwiftUI

struct ExpenseDetailsView: View {
    @EnvironmentObject var navVM: NavigationVM
    var expense: Expense
    
    var body: some View {
        VStack {
            Text(expense.title)
                .font(.title.bold())
                .foregroundColor(.red)
                .padding()
            Spacer()
            Text(expense.description)
                .font(.body.italic())
                .padding()
            VStack {
                HStack(alignment: .center) {
                    Text("Amount: " + String(format: "%.2f", expense.amount))
                        .padding()
                }
                HStack(alignment: .center) {
                    Text(expense.date.formatted(date: .abbreviated, time: .shortened))
                        .padding()
                }
            }
            
            Spacer()
        }
        .onAppear {
            print(navVM.path.count)
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ExpenseDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseDetailsView(expense: Expense(id: "", title: "groceries", description: "bought food stuff", amount: 2000, date: .now ))
            .environmentObject(NavigationVM())
    }
}
