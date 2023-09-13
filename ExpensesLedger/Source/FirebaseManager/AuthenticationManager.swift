//
//  AuthenticationManager.swift
//  ExpensesLedger
//
//  Created by Danjuma Nasiru on 25/04/2023.
//

import Foundation
import Firebase
import FirebaseAuth

final class AuthenticationManager {
    static let shared = AuthenticationManager()
    private init(){}
    
    func getAuthenticatedUser() async throws-> DBUser {
        guard let user = Auth.auth().currentUser else {
            print("something went wrong")
            throw URLError(.badServerResponse)
        }
        let dbUser = try await UserManager.shared.getUser(userID: user.uid)
        return dbUser
//        var current : AuthDataResultModel?
//        Auth.auth().addStateDidChangeListener{auth, user in
//            guard let authUser = user else{
//                print("Couldn't get current user")
//                return
//            }
//            current = AuthDataResultModel(user: authUser)
//        }
//
//        return current ?? nil
        
    }
    
    func createUser(email: String, password: String) async throws {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        
        try await UserManager.shared.createNewUser(user: authDataResult.user)
    }
    
    @discardableResult
    func signIn(email: String, password: String) async throws -> DBUser {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        
        let user = try await UserManager.shared.getUser(userID: authDataResult.user.uid)
        return user
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func updatePassword(password: String) async throws {
        guard let user = Auth.auth().currentUser else {
            print("Couldn't find current User")
            throw URLError(.badServerResponse)
        }
        
        try await user.updatePassword(to: password)
    }
    
    func updateEmail(email: String) async throws {
        guard let user = Auth.auth().currentUser else {
            print("Couldn't find current User")
            throw URLError(.badServerResponse)
        }
        
        try await user.updateEmail(to: email)
    }
}
