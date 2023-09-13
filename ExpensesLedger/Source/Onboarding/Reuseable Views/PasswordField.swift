//
//  PasswordField.swift
//  ExpensesLedger
//
//  Created by Danjuma Nasiru on 09/05/2023.
//

import SwiftUI

struct PasswordField: View {
    enum FocusedField {
        case showPasswordField, hidePasswordField
    }
    @FocusState var focusedField : FocusedField?
    @Binding var text : String
    @State private var isSecured = true
    
    var body: some View {
        ZStack(alignment: .trailing) {
            
            if self.isSecured {
                SecureField("Enter Text", text: $text)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.asciiCapable) // This avoids suggestions bar on the keyboard.
                    .autocorrectionDisabled(true)
                    .padding(.bottom, 7)
                    .overlay(
                        Rectangle()
                            .frame(width: nil, height: 1, alignment: .bottom)
                            .foregroundColor(Color.gray),
                        alignment: .bottom
                    )
                    .focused($focusedField, equals: .hidePasswordField)
            } else {
                TextField("Enter Text", text: $text)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.asciiCapable)
                    .autocorrectionDisabled(true)
                    .padding(.bottom, 7)
                    .overlay(
                        Rectangle().frame(width: nil, height: 1, alignment: .bottom)
                            .foregroundColor(Color.gray),
                        alignment: .bottom
                    )
                    .focused($focusedField, equals: .showPasswordField)
            }
            
            Button {
                performToggle()
            } label: {
                Image(systemName: self.isSecured ? "eye.slash" : "eye")
                    .accentColor(.gray)
            }
        }
    }
    
    func performToggle() {
        isSecured.toggle()
        
        if isSecured {
            focusedField = .hidePasswordField
        } else {
            focusedField = .showPasswordField
        }
    }
}

struct PasswordField_Previews: PreviewProvider {
    static var previews: some View {
        PasswordField(text: .constant("hhh"))
    }
}
