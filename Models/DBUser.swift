//
//  DBUser.swift
//  ExpensesLedger
//
//  Created by Danjuma Nasiru on 02/05/2023.
//

import Foundation
import Firebase

struct DBUser : Codable{
    let userId : String
    let email : String?
    let isAnonymous : Bool?
    let photoUrl : String?
    let dateCreated : Date?
}
