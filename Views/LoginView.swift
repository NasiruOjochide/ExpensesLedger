//
//  LoginView.swift
//  ExpensesLedger
//
//  Created by Danjuma Nasiru on 23/04/2023.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var signInVM : SignInEmailVM
    @EnvironmentObject var navVM : NavigationVM
    @State private var showActivityView = false
    var body: some View {
        
        NavigationStack(path: $navVM.path) {
            ZStack {
                VStack{
                    
                    VStack{
                        TextField("enter your email", text: $signInVM.email)
                        
                        Rectangle()
                            .frame(height: 1)
                    }
                    .padding(.vertical)
                    
                    VStack{
                        SecureField("enter password", text: $signInVM.password)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                        Rectangle()
                            .frame(height: 1)
                    }
                    .padding(.vertical)
                    
                    HStack{
                        Spacer()
                        NavigationLink(value: "ForgotPasswordPage"){
                            Text("Forgot Password?")
                                .italic()
                                .foregroundColor(.blue)
                                .onTapGesture {
                                    navVM.path.append("ForgotPasswordPage")
                                }
                        }
                    }
                    
                    NavigationLink(value: "ContentViewPage"){
                        Button{
                            Task{
                                do{
                                    showActivityView = true
                                    try await signInVM.signIn()
                                    showActivityView = false
                                    navVM.path.append("ContentViewPage")
                                }
                                catch{
                                    print(error.localizedDescription)
                                    showActivityView = false
                                }
                            }
                        }label: {
                            Text("Sign In")
                                .bold()
                                .padding()
                                .frame(width: 100, height: 50)
                                .background(.white)
                                .foregroundColor(.red)
                                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                                .overlay{
                                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                                        .stroke(.red, lineWidth: 2)
                                }
                        }
                        .padding(.vertical)
                    }
                    
                    HStack{
                        Text("Don't have an account? ").italic()
                        NavigationLink(value: "SignUpPage"){
                            Text("Sign Up").bold().foregroundColor(.red).onTapGesture {
                                navVM.path.append("SignUpPage")
                            }
                        }
                    }
                    
                }
                .navigationDestination(for: String.self){
                    if $0 == "ContentViewPage" {
                        ContentView()
                    }
                    if $0 == "SignUpPage"{
                        SignUpView()
                    }
                    if $0 == "ForgotPasswordPage"{
                        ForgotPasswordView()
                    }
                }
                .padding()
                .opacity(showActivityView ? 0.1 : 1)
                
                if showActivityView{
                    ActivityView(showView: $showActivityView)
                }
            }
            .navigationTitle("Log In")
            .onAppear{
                print(navVM.path.count)
                print("Login Screen appeared")
                showActivityView = true
                Task{
                    do{
                        let _ = try await signInVM.getCurrentUser()
                        showActivityView = false
                        print("user found")
                        navVM.path.append("ContentViewPage")
                        
                    }catch{
                        showActivityView = false
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static let navVM = NavigationVM()
    static let signInVM = SignInEmailVM()
    static var previews: some View {
        LoginView()
            .environmentObject(navVM)
            .environmentObject(signInVM)
    }
}
