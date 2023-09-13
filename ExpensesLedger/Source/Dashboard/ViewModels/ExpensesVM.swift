//
//  ExpensesVM.swift
//  ExpensesLedger
//
//  Created by Danjuma Nasiru on 20/04/2023.
//

import Foundation
import FirebaseFirestore

@MainActor
class ExpensesVM: ObservableObject {
    
    @Published var expenses = [Expense]()
    @Published var title: String = ""
    @Published var desc: String = ""
    @Published var amount: Float = 0
    @Published var date: Date = Date.now
    let directory = "Expense"
    var formatter: NumberFormatter {
        let nf = NumberFormatter()
        nf.currencySymbol = Locale.current.currencySymbol ?? "NGN"
        nf.numberStyle = .currency
        nf.allowsFloats = true
        return nf
    }
    
    init() {
        
    }
        
    func addExpense() {
        let expense = Expense(id: UUID().uuidString, title: title, description: desc, amount: amount, date: date)
        expenses.append(expense)
        save(expense: expense)
    }
    
    func save(expense : Expense) {
        Task {
            self.saveDataToFM()
            do{
                try await self.saveToFirebase(exp: expense)
            }catch{
                print(error.localizedDescription)
            }
        }
    }
    
    func saveDataToFM() {
        let dir = getDocumentsDirectory().appendingPathComponent(directory)
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(expenses)
            try data.write(to: dir, options: [.atomic, .completeFileProtection])
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func saveToFirebase(exp: Expense) async throws {
        let db = Firestore.firestore()
        let dbUser = try await AuthenticationManager.shared.getAuthenticatedUser()
        let ref = db.collection("users").document(dbUser.userId).collection("Expenses").document(exp.id)
        try await ref.setData(["id" : exp.id, "title" : exp.title, "description" : exp.description, "amount" : exp.amount, "date" : exp.date])
    }
    
    func fetchFromFM() {
        let dir = getDocumentsDirectory().appendingPathComponent(directory)
        
        do {
            let data = try Data(contentsOf: dir)
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode([Expense].self, from: data)
            expenses = decodedData
        } catch {
            print(error.localizedDescription)
            expenses = []
        }
    }
    
    func fetchFromFirebase() async throws {
        expenses.removeAll()
        let db = Firestore.firestore()
        let dbUser = try await AuthenticationManager.shared.getAuthenticatedUser()
        let ref = db.collection("users").document(dbUser.userId).collection("Expenses")
        
        ref.addSnapshotListener( { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                self.fetchFromFM()
                return
            }
            guard let documents = snapshot?.documents else{
                print("no doocuments")
                return
            }
            self.expenses = documents.map {
                let data = $0.data()
                
                let id = data["id"] as? String ?? ""
                let title = data["title"] as? String ?? ""
                let desc = data["description"] as? String ?? ""
                let amount = data["amount"] as? Float ?? 0
                let date = (data["date"] as? Timestamp)?.dateValue() ?? .now
                
                return Expense(id: id, title: title, description: desc, amount: amount, date: date)
            }
            self.saveDataToFM()
        })
        
//        ref.getDocuments(completion: {snapshot, error in
//            guard error == nil else{
//                print(error!.localizedDescription)
//                self.fetchFromFM()
//                return
//            }
//            if let snapshot = snapshot {
//                for document in snapshot.documents{
//                    let data = document.data()
//                    let id = data["id"] as? String ?? ""
//                    let title = data["title"] as? String ?? ""
//                    let desc = data["description"] as? String ?? ""
//                    let amount = data["amount"] as? Float ?? 0
//                    let date = (data["date"] as? Timestamp)?.dateValue() ?? .now
//
//                    let expense = Expense(id: id, title: title, description: desc, amount: amount, date: date)
//                    self.expenses.append(expense)
//                }
//                self.saveDataToFM()
//            }
//        })
    }
    
    func delete(at offsets: IndexSet) {
        //        expenseVM.expenses.remove(atOffsets: offsets)
        let expensesToDelete = offsets.map { expense in
            expenses[expense]
        }
        let _ = expensesToDelete.compactMap { expense in
            deleteFromFirebase(expenseToDelete: expense)
        }
    }
    
    func deleteFromFirebase(expenseToDelete : Expense) {
        let db = Firestore.firestore()
        db.collection("Expenses").document(expenseToDelete.id).delete(completion: { error in
            if error == nil {
                DispatchQueue.main.async {
                    self.expenses.removeAll{expense in
                        return expense.id == expenseToDelete.id
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        })
    }
    
    func getDocumentsDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let dir = path[0]
        return dir
    }
}
