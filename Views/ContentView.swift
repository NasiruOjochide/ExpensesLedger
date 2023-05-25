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
    @EnvironmentObject var signInVM : SignInEmailVM
    @EnvironmentObject var navVM : NavigationVM
    //@State private var navPath = NavigationPath()
    @State private var isSideBarOpened = false
    @State var costAccrued : Float = 0
    @State private var budget : Float = 0
    @State private var showExpenseSheet = false
    @State private var showBudgetAlert = false
    @State var toolbarHidden = false
    @State private var newPassword = ""
    @State private var showUpdatePasswordDialog = false
    
    var body: some View {
        
        ZStack {
            VStack{
                if budgetVM.budget == 0{
                    
                }else{
                    BudgetProgressBar()
                        .frame(width: 180, height: 180)
                        .padding(40)
                }
                
                if expenseVM.expenses.isEmpty{
                    Text("Open Side bar to add expense")
                }else{
                    List{
                        ForEach(expenseVM.expenses, id: \.id){expense in
                            NavigationLink(value: expense){
                                HStack{
                                    Text(expense.title)
                                        .bold()
                                    Spacer()
                                    //                            Text(expense.amount, format: .currency(code: Locale.current.currencySymbol ?? "NGN"))
                                    //                                .padding(.trailing)
                                    Text(expense.date.formatted(date: .abbreviated, time: .shortened))
                                }
                                .onTapGesture {
                                    navVM.path.append(expense)
                                }
                            }
                        }
                        .onDelete(perform: delete)
                    }
                    .scrollContentBackground(.hidden)
                    .navigationDestination(for: Expense.self){expense in
                        ExpenseDetailsView(expense: expense)
                    }
                }
            }
            
            .sheet(isPresented: $showExpenseSheet){
                AddExpenseView()
                    .presentationDetents([.large, .medium])
                
            }
            .alert("Set your Budget", isPresented: $showBudgetAlert){
                TextField("enter value here", value: $budget, format: .number)
                Button("Save"){
                    budgetVM.budget = budget
                    budgetVM.save()
                }
                Button(role: .cancel) {
                    
                } label:{
                    Text("Cancel")
                }
                
            }
            .alert("Input your new password", isPresented: $showUpdatePasswordDialog){
                SecureField("Enter Password here", text: $newPassword)
                Button("Save"){
                    Task{
                        do{
                            try await signInVM.updatePassword(password: newPassword)
                        }catch{
                            print("update password failed")
                        }
                    }
                    
                }
                Button(role: .cancel) {
                    
                } label:{
                    Text("Cancel")
                }
                
            }
            .toolbar{
                ToolbarItemGroup(placement: .navigationBarTrailing, content: {
                    
                    Button {
                        isSideBarOpened.toggle()
                        toolbarHidden.toggle()
                    } label: {
                        Label("Toggle SideBar",
                              systemImage: "line.3.horizontal.circle.fill")
                    }
                })
            }
            .toolbar(toolbarHidden ? .hidden : .visible)
            .environmentObject(expenseVM)
            .environmentObject(budgetVM)
            .navigationTitle("Expense Ledger")
            .navigationBarTitleDisplayMode(.inline)
            
            
            
            Sidebar(isSideBarOpened: $isSideBarOpened, showBudgetAlert: $showBudgetAlert, showExpenseSheet: $showExpenseSheet, toolbarHidden: $toolbarHidden, showUpdatePasswordDialog: $showUpdatePasswordDialog)
        }
        
        .navigationBarBackButtonHidden(true)
        .onAppear{
            print("navvm :\(navVM.path.count)")
            //            print("navpath : \(navPath.count)")
            Task{
                do{
                    try await expenseVM.fetchFromFirebase()
                    try await budgetVM.fetchfromFirebase()
                }catch{
                    print("fetch from firebase failed")
                    print(error.localizedDescription)
                }
            }
            
        }
        
    }
    
    func delete(at offsets: IndexSet){
        //        expenseVM.expenses.remove(atOffsets: offsets)
        let expensesToDelete = offsets.map{ expense in
            expenseVM.expenses[expense]
        }
        let _ = expensesToDelete.compactMap{expense in
            expenseVM.deleteFromFirebase(expenseToDelete: expense)
        }
    }
    
    func incrementProgress(){
        let randomValue = Float([50, 100, 150, 200, 250].randomElement() ?? 50)
        self.costAccrued += randomValue
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static let expenses = ExpensesVM()
    static let signInVM = SignInEmailVM()
    static let navVM = NavigationVM()
    static var previews: some View {
        NavigationView{
            ContentView()
                .environmentObject(expenses)
                .environmentObject(signInVM)
                .environmentObject(navVM)
        }
    }
}
