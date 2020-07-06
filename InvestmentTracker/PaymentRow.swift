//
//  PaymentRow.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 05.07.2020.
//

import SwiftUI
import InvestmentDataModel

struct PaymentRow: View {
    @EnvironmentObject var portfolio: Portfolio
    
    let payment: Payment
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .firstTextBaseline) {
                Text(payment.date, style: .date)
                    .font(.system(.footnote, design: .monospaced))
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("\(payment.currency.symbol)\(payment.amount, specifier: "%.f")")
                        .font(.system(.footnote, design: .monospaced))
                }
            }
            .font(.subheadline)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("from \(payment.sender.name) to \(payment.recipient.name)")
                Text(payment.note)
            }
            .foregroundColor(Color(UIColor.tertiaryLabel))
            .font(.footnote)
        }
    }
}

struct PaymentRow_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List(/*@START_MENU_TOKEN@*/0 ..< 5/*@END_MENU_TOKEN@*/) { item in
                PaymentRow(payment: Payment.payment01)
            }
        }
        .environmentObject(Portfolio())
        .preferredColorScheme(.dark)
    }
}
