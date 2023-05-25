//
//  NavigationVM.swift
//  ExpensesLedger
//
//  Created by Danjuma Nasiru on 26/04/2023.
//

import Foundation
import SwiftUI

@MainActor
class NavigationVM : ObservableObject{
    @Published var path = NavigationPath()
}
