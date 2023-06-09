//
//  SignUpView.swift
//  ExpensesLedger
//
//  Created by Danjuma Nasiru on 23/04/2023.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var signInVM : SignInEmailVM
    @EnvironmentObject var navVM : NavigationVM
    
    var body: some View {
        
            VStack{
                VStack{
                    TextField("enter your email", text: $signInVM.email)
                        
                    Rectangle()
                        .frame(height: 1)
                }
                .padding(.vertical)
                
                VStack{
                    SecureField("enter password", text: $signInVM.password)
                        
                    Rectangle()
                        .frame(height: 1)
                }
                .padding(.vertical)
                
                    Button{
                        Task{
                            do {
                                try await signInVM.signUp()
                                navVM.path.removeLast()
                            }
                            catch{
                                print(error.localizedDescription)
                            }
                        }
                    }label: {
                        Text("Sign Up")
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
            .padding()
            .navigationTitle("Sign Up")
            
    }
    
}

struct SignUpView_Previews: PreviewProvider {
    static let vm = SignInEmailVM()
    static var previews: some View {
        NavigationStack{
            SignUpView()
                .environmentObject(vm)
        }
    }
}
