//
//  UserManager.swift
//  ExpensesLedger
//
//  Created by Danjuma Nasiru on 02/05/2023.
//

import Foundation
import Firebase
import FirebaseFirestore

final class UserManager{
    static let shared = UserManager()
    
    private init(){}
    
    private let userCollection = Firestore.firestore().collection("users")
    private func userDocument(userID : String) -> DocumentReference{
        userCollection.document(userID)
    }
    
    func createNewUser(user : User) async throws{
        var userData : [String:Any] = [
            "user_id" : user.uid,
            "is_anonymous" : user.isAnonymous,
            "date_created" : Timestamp()
            ]
            if let email = user.email {
                userData["email"] = email
            }
        if let photoURL = user.photoURL{
            userData["photo_url"] = photoURL
        }
        
        try await userDocument(userID: user.uid).setData(userData, merge: false)
        
    }
    
    func getUser(userID : String) async throws -> DBUser{
        let snapshot = try await userDocument(userID: userID).getDocument()
        
        guard let data = snapshot.data(), let userId = data["user_id"] as? String else{
            throw URLError(.badServerResponse)
        }
        
        let email = data["email"] as? String
        let isAnonymous = data["is_anonymous"] as? Bool
        let photoUrl = data["photo_url"] as? String
        let dateCreated = data["date_created"] as? Date
        
        return DBUser(userId: userId, email: email, isAnonymous: isAnonymous, photoUrl: photoUrl, dateCreated: dateCreated)
    }
}
