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
    let project: Project
    
    @State private var showDeleteAction = false
    
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
                Text("from \(portfolio.entityForID(payment.senderID, in: project)?.name ?? "") to \(portfolio.entityForID(payment.recipientID, in: project)?.name ?? "")")
                Text(payment.note)
            }
            .foregroundColor(Color(UIColor.tertiaryLabel))
            .font(.footnote)
        }
        .contextMenu {
            Button {
                showDeleteAction = true
            } label: {
                Image(systemName: "trash")
                Text("Delete")
            }
        }
        .actionSheet(isPresented: $showDeleteAction) {
            deleteActionSheet(payment)
        }
    }
    
    private func deleteActionSheet(_ payment: Payment) -> ActionSheet {
        func delete() {
            let generator = UINotificationFeedbackGenerator()
            withAnimation {
                if portfolio.delete(payment, from: project, keyPath: \.payments) {
                    generator.notificationOccurred(.success)
                } else {
                    generator.notificationOccurred(.error)
                }
            }
        }
        
        return ActionSheet(
            title: Text("Delete?".uppercased()),
            message: Text("Do you really want to delete this Payment of \(payment.currency.symbol)\(payment.amount, specifier: "%.f") on \(payment.date, style: .date)?\nThis operation cannot be undone."),
            buttons: [
                .destructive(Text("Yes, delete"), action: delete),
                .cancel()
            ])
    }
}

struct PaymentRow_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List(/*@START_MENU_TOKEN@*/0 ..< 5/*@END_MENU_TOKEN@*/) { item in
                PaymentRow(payment: Payment(), project: Project())
            }
        }
        .environmentObject(Portfolio())
        .preferredColorScheme(.dark)
    }
}
