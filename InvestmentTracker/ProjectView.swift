//
//  ProjectView.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 05.07.2020.
//

import SwiftUI
import InvestmentDataModel

struct ProjectView: View {
    @Environment(\.presentationMode) var presentation
    @EnvironmentObject var portfolio: Portfolio
    
    @State private var draft: Project
    @State private var showEntityEditor = false
    @State private var showEntityListEditor = false
    @State private var showPaymentEditor = false
    @State private var showAction = false
    
    init(_ project: Project){
        self._draft = State(initialValue: project)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Project Name", text: $draft.name)
                    TextField("Note", text: $draft.note)
                }
                
                Section(header: Text("Entities".uppercased())) {
                    if !draft.entities.isEmpty {
                        Button {
                            //  MARK: FINISH THIS
                            //  open entities editor
                            //  MARK: do not delete entities used in payments!!
                            
                            showEntityListEditor = true
                        } label: {
                            Text(draft.entities.map { $0.name }.joined(separator: "; "))
                        }
                        .sheet(isPresented: $showEntityListEditor, onDismiss: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=On Dismiss@*/{ }/*@END_MENU_TOKEN@*/) {
                            EntityListEditor()
                        }
                    }
                    
                    Button {
                        //  MARK: FINISH THIS
                        showEntityEditor = true
                    } label: {
                        Text("TBD: New Entity")
                    }
                    .sheet(isPresented: $showEntityEditor, onDismiss: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=On Dismiss@*/{ }/*@END_MENU_TOKEN@*/) {
                        EntityEditor()
                    }
                }
                
                Section(header: Text("Payments".uppercased())) {
                    Button {
                        //  MARK: FINISH THIS
                        showPaymentEditor = true
                    } label: {
                        Text("TBD: New Payment")
                    }
                    .sheet(isPresented: $showPaymentEditor, onDismiss: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=On Dismiss@*/{ }/*@END_MENU_TOKEN@*/) {
                        PaymentEditor()
                    }
                    
                    ForEach(draft.payments.sorted(by: { $0.date < $1.date })) { payment in
                        paymentRow(payment)
                    }
                }
            }
            .navigationTitle("Project Details")
            .navigationBarItems(
                leading: Button {
                    presentation.wrappedValue.dismiss()
                } label: {
                    Text("Cancel")
                },
                trailing: Button {
                    //  MARK: FINISH THIS
                    if portfolio.addProject(draft) {
                        presentation.wrappedValue.dismiss()
                    }
                } label: {
                    Text("Save")
                }
            )
        }
    }
    
    private func addProject() {
        //  MARK: FINISH THIS
        
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
            trashRowButton(payment)
        }
    }
    
    private func trashRowButton(_ payment: Payment) -> some View {
        Button {
            showAction = true
        } label: {
            Image(systemName: "trash")
            Text("Delete")
        }
        .actionSheet(isPresented: $showAction) {
            ActionSheet(
                title: Text("Delete?".uppercased()),
                message: Text("Delete \(payment.amount, specifier: "%.f") payment on \(payment.date.toString()) from \(payment.sender.name) to \(payment.recipient.name)?\nThis action cannot be undone."),
                buttons: [
                    .destructive(Text("Yes, delete"), action: {
                        //  MARK: FINISH THIS
                        
                        
                    }),
                    .cancel()
                ]
            )
        }
    }
}

struct ProjectView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectView(Project.saperavi)
            .preferredColorScheme(.dark)
    }
}
