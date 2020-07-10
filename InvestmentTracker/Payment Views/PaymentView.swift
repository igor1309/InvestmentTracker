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
    
    let payment: Payment
    let project: Project
    
    init(payment: Payment, in project: Project) {
        self.project = project
        self.payment = payment
        _draft = State(initialValue: payment)
    }
    
    @State private var draft: Payment?
    @State private var showEditor = false
    
    var body: some View {
        List {
            HStack {
                Text("Payment Date").foregroundColor(.secondary)
                Spacer()
                Text(payment.date, style: .date)
            }
            
            HStack {
                Text(payment.type.id)
                Spacer()
                Text("\(payment.currency.symbol)\(payment.amount, specifier: "%.f")")
            }
            
            if !payment.note.isEmpty {
                Text(payment.note)
            }
            
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
            .sheet(isPresented: $showEditor) {
                let generator = UINotificationFeedbackGenerator()
                if let draft = draft {
                    print("Payment for \(draft.currency.symbol)\(draft.amount) was created or edited, ready to use")
                    withAnimation {
                        if portfolio.update(draft, in: project, keyPath: \.payments) {
                            generator.notificationOccurred(.success)
                        } else {
                            generator.notificationOccurred(.error)
                        }
                    }
                } else {
                    print("nothing was created or edit was cancelled")
                    draft = payment
                }
            } content: {
                EditorWrapper(original: $draft, isPresented: $showEditor) { draft in
                    PaymentEditor(payment: draft, project: project)
                }
                .environmentObject(portfolio)
            }
        )
    }
}

struct PaymentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PaymentView(payment: Payment(), in: Project())
                .environmentObject(Portfolio())
        }
        .preferredColorScheme(.dark)
    }
}
