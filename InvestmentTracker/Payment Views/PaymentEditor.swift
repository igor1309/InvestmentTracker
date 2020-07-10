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
    
    let paymentTypes = ["investment", "return"]
    
    @State private var showModal = false
    
    @Binding var payment: Payment
    let project: Project
    
    var body: some View {
        List {
            DatePicker("Payment Date", selection: $payment.date, displayedComponents: .date)
            
            Section(header: Text("Type".uppercased())) {
                Picker("Type", selection: $payment.type) {
                    ForEach(Payment.PaymentType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
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
                        showModal = true
                    } label: {
                        Text("\(payment.amount, specifier: "%.f")")
                    }
                }
            }
            
            Section(header: Text("Note".uppercased())) {
                //  MARK: change to TextEditor when it get fixed
                TextField("Note", text: $payment.note)
                //  TextEditor(text: $payment.note)
            }
            
            EntitySelector(type: .sender, entity: $payment.sender, project: project)
            
            EntitySelector(type: .recipient, entity: $payment.recipient, project: project)
        }
        .sheet(isPresented: $showModal) {
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
        EditorWrapper(original: $payment, isPresented: .constant(true)) { draft in
            PaymentEditor(payment: draft, project: project)
        }
        .environmentObject(Portfolio())
        .preferredColorScheme(.dark)
    }
}
