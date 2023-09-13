//
//  ContentView.swift
//  ExpensesLedger
//
//  Created by Danjuma Nasiru on 18/04/2023.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var expenseVM = ExpensesVM()
    @StateObject var budgetVM = BudgetVM()
    @EnvironmentObject var onboardingVM: OnboardingViewModel
    @EnvironmentObject var navVM: NavigationVM
    //@State private var navPath = NavigationPath()
    @State private var isSideBarOpened: Bool = false
    @State var costAccrued: Float = 0
    @State private var budget: Float = 0
    @State private var showExpenseSheet: Bool = false
    @State private var showBudgetAlert: Bool = false
    @State var toolbarHidden: Bool = false
    @State private var newPassword: String = ""
    @State private var showUpdatePasswordDialog: Bool = false
    
    var body: some View {
        
        ZStack {
            VStack {
                if budgetVM.budget == 0 {
                    
                } else {
                    BudgetProgressBar()
                        .frame(width: 180, height: 180)
                        .padding(40)
                }
                
                if expenseVM.expenses.isEmpty {
                    Text("Open Side bar to add expense")
                } else {
                    List {
                        ForEach(expenseVM.expenses, id: \.id) { expense in
                            
                            Button {
                                navVM.push(Routes.expenseDetail(expense: expense))
                            } label: {
                                HStack{
                                    Text(expense.title)
                                        .bold()
                                    Spacer()
                                    //                            Text(expense.amount, format: .currency(code: Locale.current.currencySymbol ?? "NGN"))
                                    //                                .padding(.trailing)
                                    Text(expense.date.formatted(date: .abbreviated, time: .shortened))
                                }
                            }
                        }
                        .onDelete { expenseVM.delete(at: $0) }
                    }
                    .scrollContentBackground(.hidden)
//                    .navigationDestination(for: Expense.self) { expense in
//                        ExpenseDetailsView(expense: expense)
//                    }
                }
            }
            
            Sidebar(
                isSideBarOpened: $isSideBarOpened,
                showBudgetAlert: $showBudgetAlert,
                showExpenseSheet: $showExpenseSheet,
                toolbarHidden: $toolbarHidden,
                showUpdatePasswordDialog: $showUpdatePasswordDialog
            )
        }
        .sheet(isPresented: $showExpenseSheet) {
            AddExpenseView()
                .presentationDetents([.large, .medium])
            
        }
        .alert("Set your Budget", isPresented: $showBudgetAlert) {
            TextField("enter value here", value: $budget, format: .number)
            Button("Save") {
                budgetVM.budget = budget
                budgetVM.save()
            }
            Button(role: .cancel) {
                
            } label: {
                Text("Cancel")
            }
            
        }
        .alert("Input your new password", isPresented: $showUpdatePasswordDialog) {
            SecureField("Enter Password here", text: $newPassword)
            Button("Save") {
                Task {
                    do {
                        try await onboardingVM.updatePassword(password: newPassword)
                    } catch {
                        print("update password failed")
                    }
                }
                
            }
            Button(role: .cancel) {
                
            } label: {
                Text("Cancel")
            }
            
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing, content: {
                
                Button {
                    isSideBarOpened.toggle()
                    toolbarHidden.toggle()
                } label: {
                    Label("Toggle SideBar",
                          systemImage: "line.3.horizontal.circle.fill")
                }
            }
            )
        }
        .toolbar(toolbarHidden ? .hidden : .visible)
        .environmentObject(expenseVM)
        .environmentObject(budgetVM)
        .navigationTitle("Expense Ledger")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            Task {
                do {
                    try await expenseVM.fetchFromFirebase()
                    try await budgetVM.fetchfromFirebase()
                } catch {
                    print("fetch from firebase failed")
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ContentView()
                .environmentObject(ExpensesVM())
                .environmentObject(OnboardingViewModel())
                .environmentObject(NavigationVM())
        }
    }
}
