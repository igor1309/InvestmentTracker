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
    
    enum Modal { case sender, recipient }
    @State private var modal = Modal.sender
    @State private var showModal = false
    
    @Binding var draft: Payment
    @Binding var shouldSave: Bool
    
    var body: some View {
        EditorWrapper(draft: $draft, shouldSave: $shouldSave) {
            List {
                DatePicker("Payment Date", selection: $draft.date, displayedComponents: .date)
                
                Section(header: Text("Amount".uppercased())) {
                    TextField("Amount", value: $draft.amount, formatter: formatter())
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("Note".uppercased())) {
                    //  MARK: change to TextEditor when it get fixed
                    TextField("Note", text: $draft.note)
                    //  TextEditor(text: $draft.note)
                }
                
                Section(header: Text("from".uppercased())) {
                    Button {
                        modal = .sender
                        showModal = true
                    } label: {
                        Text(draft.sender.name)
                    }
                }
                
                Section(header: Text("to".uppercased())) {
                    Button {
                        modal = .recipient
                        showModal = true
                    } label: {
                        Text(draft.recipient.name)
                    }
                }
            }
            .sheet(isPresented: $showModal) {
                presentModal()
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Edit Payment")
        }
    }
    
    @ViewBuilder private func presentModal() -> some View {
        switch modal {
        case .sender:
            EntityPicker(entity: $draft.sender)
                .environmentObject(portfolio)
        case .recipient:
            EntityPicker(entity: $draft.recipient)
                .environmentObject(portfolio)
        }
    }
    
    private func formatter() -> Formatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        return formatter
    }
}

struct PaymentEditor1: View {
    @Environment(\.presentationMode) var presentation
    @EnvironmentObject var portfolio: Portfolio
    
    enum Modal { case sender, recipient }
    @State private var modal = Modal.sender
    @State private var showModal = false
    
    @State private var draft: Payment
    
    init(payment: Payment) {
        _draft = State(initialValue: payment)
    }
    
    var body: some View {
        NavigationView {
            List {
                DatePicker("Payment Date", selection: $draft.date, displayedComponents: .date)
                
                
                
                Section(header: Text("Amount".uppercased())) {
                    TextField("Amount", value: $draft.amount, formatter: formatter())
                        .keyboardType(.decimalPad)
//                    Text("\(draft.currency.symbol)\(draft.amount, specifier: "%.f")")
                }
                
                Section(header: Text("Note".uppercased())) {
                    //  MARK: change to TextEditor when it get fixed
                    TextField("Note", text: $draft.note)
                    //  TextEditor(text: $draft.note)
                }
                
                Section(header: Text("from".uppercased())) {
                    Button {
                        modal = .sender
                        showModal = true
                    } label: {
                        Text(draft.sender.name)
                    }
                }
                
                Section(header: Text("to".uppercased())) {
                    Button {
                        modal = .recipient
                        showModal = true
                    } label: {
                        Text(draft.recipient.name)
                    }
                }
            }
            .sheet(isPresented: $showModal) {
                presentModal()
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Edit Payment")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentation.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    //  MARK: FINISH THIS
                    presentation.wrappedValue.dismiss()
                }
            )
        }
    }
    
    @ViewBuilder private func presentModal() -> some View {
        switch modal {
        case .sender:
            EntityPicker(entity: $draft.sender)
                .environmentObject(portfolio)
        case .recipient:
            EntityPicker(entity: $draft.recipient)
                .environmentObject(portfolio)
        }
    }
    
    private func formatter() -> Formatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        return formatter
    }
}

struct PaymentEditor_Previews: PreviewProvider {
    static var previews: some View {
        PaymentEditor(draft: .constant(Payment.payment01), shouldSave: .constant(true))
            .environmentObject(Portfolio())
            .preferredColorScheme(.dark)
    }
}
