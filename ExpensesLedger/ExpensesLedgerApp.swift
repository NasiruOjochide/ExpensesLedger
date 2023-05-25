//
//  ExpensesLedgerApp.swift
//  ExpensesLedger
//
//  Created by Danjuma Nasiru on 18/04/2023.
//

import SwiftUI

@main
struct ExpensesLedgerApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate 
    @StateObject var signInVM = SignInEmailVM()
    @StateObject var navVM = NavigationVM()
    
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(signInVM)
                .environmentObject(navVM)
        }
    }
}
