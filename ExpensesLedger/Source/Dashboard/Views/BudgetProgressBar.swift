//
//  SwiftUIView.swift
//  ExpensesLedger
//
//  Created by Danjuma Nasiru on 18/04/2023.
//

import SwiftUI

struct BudgetProgressBar: View {
    @EnvironmentObject var  budgetVM: BudgetVM
    //@EnvironmentObject var CostAccrued : BudgetVM
    var percentLeft: Int {
        if budgetVM.budget > 0 {
            return 100 - Int((budgetVM.costAccrued/(budgetVM.budget )) * 100)
        } else {
            return 100
        }
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 15)
                .opacity(0.3)
                .foregroundColor(.red)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(budgetVM.costAccrued / (budgetVM.budget), 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .round, lineJoin: .round))
                .foregroundColor(.red)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear, value: budgetVM.costAccrued)
            
//            Text(String(format: "%.0f %%", min(self.CostAccrued, 1.0) * 100.0))
//                .font(.largeTitle)
//                .bold()
            
            Text("\(percentLeft.formatted(.percent)) Left")
                .font(.title)
                .bold()
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetProgressBar()
            .environmentObject(BudgetVM())
    }
}
