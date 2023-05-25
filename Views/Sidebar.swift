//
//  Sidebar.swift
//  ExpensesLedger
//
//  Created by Danjuma Nasiru on 27/04/2023.
//

import SwiftUI

struct Sidebar: View {
    @Binding var isSideBarOpened : Bool
    @Binding var showBudgetAlert : Bool
    @Binding var showExpenseSheet : Bool
    @Binding var toolbarHidden : Bool
    @Binding var showUpdatePasswordDialog : Bool
    @EnvironmentObject var navVM : NavigationVM
    @EnvironmentObject var signInVM : SignInEmailVM
    var sideBarWidth = UIScreen.main.bounds.width * 0.7
    var bgColor: Color =
    Color(.init(
        red: 52 / 255,
        green: 70 / 255,
        blue: 182 / 255,
        alpha: 1))
    
    var secondaryColor: Color =
    Color(.init(
        red: 100 / 255,
        green: 174 / 255,
        blue: 255 / 255,
        alpha: 1))
    
    var body: some View {
        ZStack{
            GeometryReader{ _ in
                EmptyView()
            }
            .background(.black.opacity(0.6))
            .opacity(isSideBarOpened ? 1 : 0)
            .animation(.easeInOut.delay(0.2), value: isSideBarOpened)
            .onTapGesture {
                isSideBarOpened.toggle()
                toolbarHidden = false
            }
            
            content
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    
    var content : some View{
        HStack(alignment: .top){
            ZStack(alignment: .top){
                bgColor
                
                menuChevron
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("Hello John")
                    
                    Button{
                        isSideBarOpened.toggle()
                        toolbarHidden = false
                        showBudgetAlert = true
                    }label: {
                        Text("Set Your Monthly Budget")
                            .tint(.black)
                    }
                    
                    Button{
                        isSideBarOpened.toggle()
                        toolbarHidden = false
                        showExpenseSheet = true
                    }label: {
                        Text("Add Expense")
                            .tint(.black)
                    }
                    
                    Spacer()
                    
                    Button{
                        //reset password
                        isSideBarOpened.toggle()
                        toolbarHidden = false
                        showUpdatePasswordDialog.toggle()
                    }label: {
                        Label("Reset Password", systemImage: "lock.rotation")
                            .padding(5)
                            .foregroundColor(.red)
                        
                    }
                    Button{
                        do{
                            try signInVM.logOut()
                            navVM.path.removeLast()
                        }catch{
                            print(error.localizedDescription)
                        }
                    }label: {
                        Label("Log out", systemImage: "iphone.and.arrow.forward")
                        //.bold()
                            .padding(5)
                            .padding(.bottom, 40)
                            .foregroundColor(.red)
                    }
                }
                .padding(.top, 80)
                .padding(.horizontal, 5)
                .padding(.bottom)
            }
            .frame(width: sideBarWidth)
            .offset(x: isSideBarOpened ? 0 : -sideBarWidth)
            .animation(.default, value: isSideBarOpened)
            
            Spacer()
        }
    }
    
    
    var menuChevron : some View{
        ZStack{
            RoundedRectangle(cornerRadius: 18)
                .fill(bgColor)
                .frame(width: 60, height: 60)
                .rotationEffect(Angle(degrees: 45))
                .offset(x: isSideBarOpened ? -18 : -10)
            
            
            Image(systemName: "chevron.right")
                .foregroundColor(secondaryColor)
                .rotationEffect(
                    isSideBarOpened ?
                    Angle(degrees: 180) : Angle(degrees: 0))
                .offset(x: isSideBarOpened ? -4 : 8)
                .foregroundColor(.blue)
        }
        .onTapGesture {
            isSideBarOpened.toggle()
            toolbarHidden.toggle()
        }
        .offset(x: sideBarWidth / 2, y: 80)
        .animation(.default, value: isSideBarOpened)
    }
}

struct Sidebar_Previews: PreviewProvider {
    static let x = SignInEmailVM()
    static let y = NavigationVM()
    static var previews: some View {
        Sidebar(isSideBarOpened: .constant(true), showBudgetAlert: .constant(true), showExpenseSheet: .constant(true), toolbarHidden: .constant(true), showUpdatePasswordDialog: .constant(true))
            .environmentObject(x)
            .environmentObject(y)
    }
}
