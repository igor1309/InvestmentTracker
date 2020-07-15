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
    @EnvironmentObject var settings: Settings
    
    let payment: Payment
    let project: Project
    
    init(payment: Payment, in project: Project) {
        self.project = project
        self.payment = payment
        _draft = State(initialValue: payment)
    }
    
    @State private var draft: Payment?
    @State private var showEditor = false
    
    var color: Color {
        let color = payment.type == .investment
            ? Color(UIColor.orange)
            : Color(UIColor.green)
        let opacity = 1.0//0.7
        return color.opacity(opacity)
    }
    
    var body: some View {
        List {
            HStack {
                Text("Payment Date").foregroundColor(.secondary)
                Spacer()
                Text(payment.date, style: .date)
            }
            
            HStack {
                Text(payment.type.id)
                    .foregroundColor(color)
                Spacer()
                Text("\(payment.amount, specifier: "%.f")")
            }
            
            if !payment.note.isEmpty {
                Text(payment.note)
            }
            
            Section(header: Text("from".uppercased())) {
                Text(portfolio.entityForID(payment.senderID, in: project)?.name ?? "")
            }
            Section(header: Text("to".uppercased())) {
                Text(portfolio.entityForID(payment.recipientID, in: project)?.name ?? "")
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Payment Detail")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            trailing: Button("Edit") {
                showEditor = true
            }
            .sheet(isPresented: $showEditor) {
                // onDismiss
                portfolio.updatePayment(draft, in: project)
                draft = payment
            } content: {
                EditorWrapper(
                    isPresented: $showEditor,
                    original: $draft
                ) { payment in
                    portfolio.isPaymentValid(payment, in: project)
                } editor: { payment in
                    PaymentEditor(payment: payment, project: project)
                }
                .environmentObject(portfolio)
                .environmentObject(settings)
            }
        )
    }
}

struct PaymentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PaymentView(payment: Payment(), in: Project())
        }
        .environmentObject(Portfolio())
        .environmentObject(Settings())
        .preferredColorScheme(.dark)
    }
}
