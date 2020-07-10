//
//  PaymentEditor.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 05.07.2020.
//

import SwiftUI
import InvestmentDataModel

struct PaymentEditor: View {
    @EnvironmentObject var portfolio: Portfolio
    
    let amounts: [Double] = [10_000, 100_000, 500_000, 1_000_000, 2_000_000, 3_000_000, 5_000_000, 10_000_000]
    
    enum Modal { case amount, sender, recipient }
    @State private var modal = Modal.sender
    @State private var showModal = false
    
    @Binding var payment: Payment
    
    var body: some View {
        List {
            DatePicker("Payment Date", selection: $payment.date, displayedComponents: .date)
            
            Section(header: Text("Amount".uppercased())) {
                TextField("Amount", value: $payment.amount, formatter: formatter())
                    .keyboardType(.decimalPad)
                
                Stepper("\(payment.amount, specifier: "%.f")", onIncrement: increase, onDecrement: decrease)
                
                Picker("Amount", selection: $payment.amount) {
                    ForEach(amounts, id: \.self) { amount in
                        HStack {
                            Spacer()
                            Text("\(amount, specifier: "%.f")").tag(amount)
                        }
                    }
                }
                .labelsHidden()
                
                Button {
                    modal = .amount
                    showModal = true
                } label: {
                    Text("\(payment.amount, specifier: "%.f")")
                }
            }
            
            Section(header: Text("Note".uppercased())) {
                //  MARK: change to TextEditor when it get fixed
                TextField("Note", text: $payment.note)
                //  TextEditor(text: $payment.note)
            }
            
            Section(header: Text("from".uppercased())) {
                Picker("Sender", selection: $payment.sender) {
                    ForEach(portfolio.entities, id: \.id) { entity in
                        Text(entity.name).tag(entity)
                    }
                }
                Button {
                    modal = .sender
                    showModal = true
                } label: {
                    Text(payment.sender.name)
                }
            }
            
            Section(header: Text("to".uppercased())) {
                Picker("Recipient", selection: $payment.recipient) {
                    ForEach(portfolio.entities, id: \.id) { entity in
                        Text(entity.name).tag(entity)
                    }
                }
                Button {
                    modal = .recipient
                    showModal = true
                } label: {
                    Text(payment.recipient.name)
                }
            }
        }
        .sheet(isPresented: $showModal) {
            presentModal()
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Edit Payment")
    }
    
    @ViewBuilder private func presentModal() -> some View {
        switch modal {
        case .amount:
            AmountPicker(amount: $payment.amount)
        case .sender:
            EntityPicker(entity: $payment.sender)
                .environmentObject(portfolio)
        case .recipient:
            EntityPicker(entity: $payment.recipient)
                .environmentObject(portfolio)
        }
    }
    
    private func formatter() -> Formatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        return formatter
    }
    
    private func increase() {
        payment.amount += 10_000
    }
    
    private func decrease() {
        if payment.amount > 10_000 {
            payment.amount -= 10_000
        } else {
            payment.amount = 0
        }
    }
}

struct PaymentEditor_Previews: PreviewProvider {
    @State static var payment = Payment()
    
    static var previews: some View {
        NavigationView {
            PaymentEditor(payment: $payment)
        }
        .navigationBarTitleDisplayMode(.inline)
        .environmentObject(Portfolio())
        .preferredColorScheme(.dark)
    }
}
