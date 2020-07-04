//
//  PaymentList.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 04.07.2020.
//

import SwiftUI
import InvestmentDataModel

struct PaymentList: View {
    var project: Project
    
    var body: some View {
        List {
            ForEach(project.payments) { payment in
                HStack {
                    Text(payment.date.toString())
                    
                    Spacer()
                    
                    Text("\(payment.amount, specifier: "%.f")")
                }
                .font(.subheadline)
            }
        }
        .navigationTitle(project.name)
    }
}

struct PaymentList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PaymentList(project: Project.saperavi)
        }
        .preferredColorScheme(.dark)
    }
}
