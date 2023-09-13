//
//  ForgotPasswordView.swift
//  ExpensesLedger
//
//  Created by Danjuma Nasiru on 05/05/2023.
//

import SwiftUI

struct ForgotPasswordView: View {
    @EnvironmentObject var onboardingVM: OnboardingViewModel
    @EnvironmentObject var navVM: NavigationVM
    
    var body: some View {
        VStack(alignment: .center) {
            TextField("Enter Email", text: $onboardingVM.email)
                .frame(maxWidth: 380)
            Rectangle()
                .frame(maxWidth: 380, maxHeight: 1)
            
            Button {
                Task {
                    do {
                        try await onboardingVM.resetPassword(email: onboardingVM.email)
                        navVM.pop()
                    }catch{
                        print("password reset failed")
                    }
                }
            } label: {
                Text("Submit")
                    .bold()
                    .padding()
                    .frame(maxWidth: 380)
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
        .padding(20)
        .navigationTitle("Forgot Password")
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            ForgotPasswordView()
                .environmentObject(OnboardingViewModel())
                .environmentObject(NavigationVM())
        }
    }
}
