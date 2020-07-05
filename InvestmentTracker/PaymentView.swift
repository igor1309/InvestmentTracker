//
//  PaymentView.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 05.07.2020.
//

import SwiftUI
import InvestmentDataModel

struct PaymentView: View {
    @EnvironmentObject var portfolio: Portfolio
    var payment: Payment

    @State private var draft: Payment = Payment.payment01
    @State private var shouldSave = false
    @State private var showEditor = false
    
    var body: some View {
        List {
            HStack {
                Text("Payment Date").foregroundColor(.secondary)
                Spacer()
                Text(payment.date.toString())
            }
            HStack {
                Text("Amount").foregroundColor(.secondary)
                Spacer()
                Text("\(payment.currency.symbol)\(payment.amount, specifier: "%.f")")
            }
            Text(payment.note)
            
            Section(header: Text("from".uppercased())) {
                Text(payment.sender.name)
            }
            Section(header: Text("to".uppercased())) {
                Text(payment.recipient.name)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Payment Detail")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            trailing: Button("Edit") {
                showEditor = true
            }
            .sheet(isPresented: $showEditor, onDismiss: {
                if shouldSave {
                    //  MARK: FINISH THIS
                    print("saving...")
                    
                    shouldSave = false
                }
            }) {
                PaymentEditor(draft: $draft, shouldSave: $showEditor)
                    .environmentObject(portfolio)
            }
        )
    }
}

struct PaymentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PaymentView(payment: Payment.payment01)
                .environmentObject(Portfolio())
        }
        .preferredColorScheme(.dark)
    }
}
