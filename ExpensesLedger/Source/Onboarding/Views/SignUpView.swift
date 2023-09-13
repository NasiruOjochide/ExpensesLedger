//
//  SignUpView.swift
//  ExpensesLedger
//
//  Created by Danjuma Nasiru on 23/04/2023.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var onboardingVM: OnboardingViewModel
    @EnvironmentObject var navVM: NavigationVM
    
    var body: some View {
        VStack {
            BottomBarTextField(placeholder: "Enter your Email", text: $onboardingVM.email)
                .padding(.vertical)
            
            PasswordField(text: $onboardingVM.password)
                .padding(.vertical)
            
            Button {
                Task {
                    do {
                        try await onboardingVM.signUp()
                        navVM.pop()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            } label: {
                Text("Sign Up")
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
        .padding()
        .navigationTitle("Sign Up")
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            SignUpView()
                .environmentObject(OnboardingViewModel())
        }
    }
}
