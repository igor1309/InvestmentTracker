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
    @EnvironmentObject var settings: Settings
    
    @Binding var payment: Payment
    let project: Project
    
    @State private var showEditor = false
    
    var body: some View {
        List {
            Section(
                            header: Text("Payment".uppercased())
            ) {
            DatePicker("Payment Date", selection: $payment.date, displayedComponents: .date)
                .labelsHidden()
            
                    Picker("Type", selection: $payment.type) {
                    ForEach(Payment.PaymentType.allCases, id: \.self) { type in
                        Text(type.id).tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            Section(header: Text("Amount".uppercased())) {
                //  MARK: FINISH THIS!!!
                //TextField("Amount", value: $payment.amount, formatter: formatter())
                    //.keyboardType(.decimalPad)
                
                Stepper(onIncrement: increase, onDecrement: decrease) {
                    Button {
                        showEditor = true
                    } label: {
                        Text("\(payment.amount, specifier: "%.f")")
                    }
                }
            }
            
            Section(header: Text("Payment Note".uppercased())) {
                TextField("Note", text: $payment.note)
                //  MARK: change to TextEditor when it get fixed
                //  TextEditor(text: $payment.note)
            }
            
            EntitySelector(
                type: .sender,
                paymentType: payment.type,
                entityID: $payment.senderID,
                project: project
            )
            .environmentObject(settings)
            
            EntitySelector(
                type: .recipient,
                paymentType: payment.type,
                entityID: $payment.recipientID,
                project: project
            )
            .environmentObject(settings)
        }
        .sheet(isPresented: $showEditor) {
            AmountPicker(amount: $payment.amount)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Edit Payment")
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
    @State static var payment: Payment? = Payment()
    static let project = Project.natachtari
    
    static var previews: some View {
        EditorWrapper(
            isPresented: .constant(true),
            original: $payment
        ) { payment in
            payment.isValid
        } editor: { payment in
            PaymentEditor(payment: payment, project: project)
        }
        .environmentObject(Portfolio())
        .environmentObject(Settings())
        .preferredColorScheme(.dark)
    }
}
