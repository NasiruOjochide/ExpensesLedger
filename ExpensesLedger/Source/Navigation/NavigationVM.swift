//
//  NavigationVM.swift
//  ExpensesLedger
//
//  Created by Danjuma Nasiru on 26/04/2023.
//

import Foundation
import SwiftUI

@MainActor
class NavigationVM: ObservableObject {
    
    @Published var path: [Routes] = []
    
    func push(_ route: Routes) {
        path.append(route)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeAll()
    }
}
