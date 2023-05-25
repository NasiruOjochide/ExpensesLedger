//
//  ActivityView.swift
//  ExpensesLedger
//
//  Created by Danjuma Nasiru on 30/04/2023.
//

import SwiftUI

struct ActivityView: View {
    var message : String = "Loading"
    @Binding var showView : Bool  /*{
        didSet{
            if showView == true{
                scaleValue = 3.0
                opacityValue = 1
                rotationAmount = 360
            }
        }
    }*/
    @State private var scaleValue = 1.0
    @State private var opacityValue = 0.3
    @State private var rotationAmount : Double = 0
    var body: some View {
        VStack {
            ZStack{
                Circle()
                    .stroke(.red.opacity(0.4), lineWidth: 15)
                    .frame(width: 150, height: 150)
                Circle()
                    .trim(from: 0.0, to: 0.75)
                    .stroke(.red.opacity(0.7), style: StrokeStyle(lineWidth: 15, lineCap: .round, lineJoin: .round))
                    .frame(width: 150, height: 150)
                    .rotationEffect(Angle(degrees: showView ? 360 : 0))
                    .animation(.linear.repeatForever(autoreverses: false).speed(0.2), value: rotationAmount)
                Circle()
                    .fill(.red.opacity(showView ? 1 : 0.3))
                    .frame(width: 40, height: 40)
                    .scaleEffect(showView ? 3.0 : 1.0)
                    .animation(.easeInOut.repeatForever(autoreverses: true).speed(0.4), value: scaleValue)
            }
//            .onChange(of: showView, perform: {value in
//                if value == true{
//                    scaleValue = 3.0
//                    opacityValue = 1
//                    rotationAmount = 360
//                }
//            })
            
            Text(message)
                .italic()
                .padding()
            
//            Button("animate"){
//                showView.toggle()
//            }
        }
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView(showView: .constant(false))
    }
}
