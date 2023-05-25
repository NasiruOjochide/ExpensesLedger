//
//  AuthDataResultModel.swift
//  ExpensesLedger
//
//  Created by Danjuma Nasiru on 02/05/2023.
//

import Foundation
import Firebase

struct AuthDataResultModel{
    let uid : String
    let email : String?
    let photoURl : String?
    let isAnonymous : Bool
    let dateCreated : Date
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoURl = user.photoURL?.absoluteString
        self.isAnonymous = user.isAnonymous
        self.dateCreated = .now
        //ExpensesVM(authData : self)
    }
}
