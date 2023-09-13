//
//  Budget.swift
//  ExpensesLedger
//
//  Created by Danjuma Nasiru on 22/04/2023.
//

import Foundation
import Firebase


class BudgetVM: Codable, ObservableObject {
    @Published var budget: Float = 0
    @Published var costAccrued: Float = 0
    let userDefaultsKey = "budgetVM"
    private let userCollection = Firestore.firestore().collection("users")
    
    init() {
        
    }
    
    func updateCost(by amount: Float) {
        self.costAccrued += amount
        save()
    }
    
    func incrementProgress() {
        let randomValue = Float([50, 100, 150, 200, 250].randomElement() ?? 50)
        self.costAccrued += randomValue
    }
    
    private func userDocument(userID: String) -> DocumentReference {
        userCollection.document(userID).collection("BudgetCollection").document("BudgetDocument")
    }
    
    func save() {
        Task {
            self.saveToUserDefaults()
            do {
                try await self.saveToFirebase()
            } catch {
                print("save to firebase failed")
                print(error.localizedDescription)
            }
        }
    }
    
    func saveToFirebase() async throws {
        let dbUser = try await AuthenticationManager.shared.getAuthenticatedUser()
        let ref = userDocument(userID: dbUser.userId)
        try await ref.setData(["budget" : budget, "costAccrued" : costAccrued])
    }
    
    func saveToUserDefaults() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(self)
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        } catch {
            print("save to defaults failed")
            print(error.localizedDescription)
        }
    }
    
    func fetchfromFirebase() async throws {
        let dbUser = try await AuthenticationManager.shared.getAuthenticatedUser()
        let ref = userDocument(userID: dbUser.userId)
        ref.addSnapshotListener { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                self.fetchFromUserDefaults()
                return
            }
            guard let document = snapshot?.data() else {
                print("document is empty")
                return
            }
            
            self.budget = document["budget"] as? Float ?? 0
            self.costAccrued = document["costAccrued"] as? Float ?? 0
            
            self.saveToUserDefaults()
        }
//        ref.getDocument(completion: {snapshot, error in
//            guard error == nil else{
//                print(error!.localizedDescription)
//                self.fetchFromUserDefaults()
//                return
//            }
//            if let snapshot = snapshot, snapshot.exists{
//                self.budget = snapshot.value(forKey: "budget") as? Float ?? 0
//                self.costAccrued = snapshot.value(forKey: "costAccrued") as? Float ?? 0
//
//                self.saveToUserDefaults()
//            }
//        })

    }
    
    func fetchFromUserDefaults() {
        do {
            guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else { return }
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(BudgetVM.self, from: data)
            self.budget = decodedData.budget
            self.costAccrued = decodedData.costAccrued
        } catch {
            print(error.localizedDescription)
        }
    }
    
    enum CodingKeys: CodingKey {
        case budget, costAccrued
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        budget = try container.decode(Float.self, forKey: .budget)
        costAccrued = try container.decode(Float.self, forKey: .costAccrued)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(budget, forKey: .budget)
        try container.encode(costAccrued, forKey: .costAccrued)
    }
}
