//
//  SignInEmailVM.swift
//  ExpensesLedger
//
//  Created by Danjuma Nasiru on 25/04/2023.
//

import Foundation
import SwiftUI
@MainActor
final class SignInEmailVM : ObservableObject{
    @Published var email : String = ""
    @Published var password : String = ""
    @Published var uid : String = ""
    
    func signUp()async throws{
        guard !email.isEmpty, !password.isEmpty else{
            return
        }
        try await AuthenticationManager.shared.createUser(email: email, password: password)
        
        print("sign up successful")
    }
    
    func signIn()async throws {
        guard !email.isEmpty, !password.isEmpty else{
            throw URLError(.badServerResponse)
        }
        let _ = try await AuthenticationManager.shared.signIn(email: email, password: password)
        print("sign in successful")
    }
    
    func getCurrentUser() async throws -> DBUser {
        let dbUser = try await AuthenticationManager.shared.getAuthenticatedUser()
        return dbUser
    }
    
    func logOut() throws{
        try AuthenticationManager.shared.signOut()
    }
    
    func resetPassword(email : String) async throws {
//        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
//
//        guard let email = authUser.email else {
//            throw URLError(.fileDoesNotExist)
//        }
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func updateEmail(/*email : String*/)async throws{
        let email = "danjay@gmail.com"
        try await AuthenticationManager.shared.updateEmail(email: email)
    }
    
    func updatePassword(password : String) async throws{
        try await AuthenticationManager.shared.updatePassword(password: password)
    }
}
