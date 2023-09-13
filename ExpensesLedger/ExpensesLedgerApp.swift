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
    @StateObject var onboardingVM = OnboardingViewModel()
    @StateObject var navVM = NavigationVM()
    
    var body: some Scene {
        WindowGroup {
            SignInParent()
                .environmentObject(onboardingVM)
                .environmentObject(navVM)
        }
    }
}
