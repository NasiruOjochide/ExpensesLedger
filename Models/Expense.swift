//
//  Expense.swift
//  ExpensesLedger
//
//  Created by Danjuma Nasiru on 18/04/2023.
//

import Foundation

struct Expense : Identifiable, Codable, Hashable {
    var id : String
    var title : String
    var description : String
    var amount : Float
    var date : Date
}
