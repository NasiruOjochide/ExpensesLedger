//
//  LoginView.swift
//  ExpensesLedger
//
//  Created by Danjuma Nasiru on 23/04/2023.
//

import SwiftUI

struct SignInParent: View {
    
    @EnvironmentObject var onboardingVM : OnboardingViewModel
    @EnvironmentObject var navVM : NavigationVM
    @State private var showActivityView = false
    
    var body: some View {
        NavigationStack(path: $navVM.path) {
            ZStack {
                VStack {
                    BottomBarTextField(placeholder: "Enter your Email", text: $onboardingVM.email)
                        .padding(.vertical)
                    
                    PasswordField(text: $onboardingVM.password)
                        .padding(.vertical)
                    
                    HStack {
                        Spacer()
                        NavigationLink(value: Routes.forgotPassword) {
                            Text("Forgot Password?")
                                .italic()
                                .foregroundColor(.blue)
                            
                        }
                    }
                    
                    NavigationLink(value: "ContentViewPage") {
                        Button {
                            Task {
                                do {
                                    showActivityView = true
                                    try await onboardingVM.signIn()
                                    showActivityView = false
                                    navVM.push(Routes.dashboard)
                                } catch {
                                    print(error.localizedDescription)
                                    showActivityView = false
                                }
                            }
                        } label: {
                            Text("Sign In")
                                .bold()
                                .padding()
                                .frame(width: 100, height: 50)
                                .background(.white)
                                .foregroundColor(.red)
                                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                                        .stroke(.red, lineWidth: 2)
                                }
                        }
                        .padding(.vertical)
                    }
                    
                    HStack {
                        Text("Don't have an account? ").italic()
                        NavigationLink(value: Routes.signUp) {
                            Text("Sign Up")
                                .bold()
                                .foregroundColor(.red)
                        }
                    }
                    
                }
                .padding()
                .opacity(showActivityView ? 0.1 : 1)
                
                if showActivityView {
                    //ActivityView(showView: $showActivityView)
                    
                    ProgressView("Checking for existing user")
                }
            }
            .navigationTitle("Log In")
            .onAppear {
                print(navVM.path.count)
                print("Login Screen appeared")
                showActivityView = true
                Task{
                    do{
                        let _ = try await onboardingVM.getCurrentUser()
                        showActivityView = false
                        print("user found")
                        navVM.push(Routes.dashboard)
                        
                    }catch{
                        showActivityView = false
                        print(error.localizedDescription)
                    }
                }
            }
            .navigationDestination(for: Routes.self) { $0 }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        SignInParent()
            .environmentObject(NavigationVM())
            .environmentObject(OnboardingViewModel())
    }
}
