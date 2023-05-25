//
//  ProfileVM.swift
//  ExpensesLedger
//
//  Created by Danjuma Nasiru on 02/05/2023.
//

import Foundation

@MainActor
class ProfileVM : ObservableObject{
    @Published private(set) var user : DBUser? = nil
    
    func loadCurrentUser () async throws {
        let authUser = try await AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userID: authUser.userId)
    }
}
