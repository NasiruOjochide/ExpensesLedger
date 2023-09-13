//
//  BottomBarTextField.swift
//  ExpensesLedger
//
//  Created by Danjuma Nasiru on 13/09/2023.
//

import SwiftUI

struct BottomBarTextField: View {
    
    var placeholder: String = "Enter Text"
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .textInputAutocapitalization(.never)
            .keyboardType(.asciiCapable)
            .autocorrectionDisabled(true)
            .padding(.bottom, 7)
            .overlay(
                Rectangle()
                    .frame(height: 1, alignment: .bottom)
                    .foregroundColor(Color.gray),
                alignment: .bottom
            )
    }
}

struct BottomBarTextField_Previews: PreviewProvider {
    static var previews: some View {
        BottomBarTextField(text: .constant(""))
    }
}
