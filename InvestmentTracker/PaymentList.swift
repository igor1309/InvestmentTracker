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
                paymentRow(payment)
            }
        }
        .listStyle(PlainListStyle())
        .navigationTitle("\(project.name): Payments")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            leading: Button {
                //  showSettings = true
            } label: {
                Image(systemName: "gear")
            }
        )
    }
    
    private func paymentRow(_ payment: Payment) -> some View {
        VStack(alignment: .leading) {
            HStack(alignment: .firstTextBaseline) {
                Text(payment.date.toString())
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("\(payment.currency.symbol)\(payment.amount, specifier: "%.f")")
                }
            }
            .font(.subheadline)
            
            Group {
                Text("from \(payment.sender.name) to \(payment.recipient.name)")
                Text(payment.note)
            }
            .foregroundColor(Color(UIColor.tertiaryLabel))
            .font(.footnote)
        }
        .contextMenu {
            Button {
                
            } label: {
                Image(systemName: "plus")
                Text("Add smth")
            }
        }
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
