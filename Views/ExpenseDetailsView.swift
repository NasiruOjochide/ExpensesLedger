//
//  ExpenseDetailsView.swift
//  ExpensesLedger
//
//  Created by Danjuma Nasiru on 05/05/2023.
//

import SwiftUI

struct ExpenseDetailsView: View {
    @EnvironmentObject var navVM : NavigationVM
    //@Binding var navPath : NavigationPath
    var expense : Expense
    var body: some View {
        VStack{
            Text(expense.title)
                .font(.title.bold())
                .foregroundColor(.red)
                .padding()
            Spacer()
            Text(expense.description)
                .font(.body.italic())
                .padding()
            VStack{
                HStack(alignment: .center){
                    Text("Amount: \(expense.amount.formatted(.currency(code: Locale.current.currencySymbol ?? "NGN")))")
                        .padding()
                }
                HStack(alignment: .center){
                    Text(expense.date.formatted(date: .abbreviated, time: .shortened))
                        .padding()
                }
            }
            
            Button{
                navVM.path.removeLast()
                print(navVM.path.count)
            }label: {
                Text("Test pop 2 screens")
            }
            
            Spacer()
        }
        .onAppear{
            print(navVM.path.count)
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ExpenseDetailsView_Previews: PreviewProvider {
    static let expense = Expense(id: "", title: "groceries", description: "bought food stuff", amount: 2000, date: .now )
    static var nav = NavigationVM()
    static var previews: some View {
        ExpenseDetailsView(expense: expense)
            .environmentObject(nav)
    }
}
