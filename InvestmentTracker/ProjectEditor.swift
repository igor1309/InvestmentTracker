//
//  ProjectEditor.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 05.07.2020.
//

import SwiftUI
import InvestmentDataModel

struct ProjectEditor: View {
    @EnvironmentObject var portfolio: Portfolio
    
    @State private var draft: Project
    @State private var showPaymentEditor = false
    @State private var showEntityEditor = false
    @State private var showEntityListEditor = false
    @State private var showAction = false
    
    @State private var shouldSave = false
    
    @State private var newEntity = Entity("", note: "")
    @State private var newPayment = Payment.payment01
    
    init(_ project: Project){
        self._draft = State(initialValue: project)
    }
    
    var body: some View {
        EditorWrapper(draft: $draft, shouldSave: $shouldSave) {
            Form {
                Section {
                    TextField("Project Name", text: $draft.name)
                    TextField("Note", text: $draft.note)
                }
                
                Section(header: Text("Entities".uppercased())) {
                    if !draft.entities.isEmpty {
                        Button {
                            prepareEntityListEditor()
                        } label: {
                            Text(draft.entities.map { $0.name }.joined(separator: "; "))
                        }
                        .sheet(isPresented: $showEntityListEditor) {
                            handleEntityListEditor()    //  onDismiss
                        } content: {
                            EntityListEditor(project: $draft)
                        }
                    }
                    
                    Button {
                        prepareNewEntity()
                    } label: {
                        Text("TBD: New Entity")
                    }
                    .sheet(isPresented: $showEntityEditor) {
                        handleEntityEditor()    //  onDismiss
                    } content: {
                        EntityEditor(entity: $newEntity, shouldSave: $shouldSave)
                    }
                }
                
                Section(header: Text("Payments".uppercased())) {
                    Button {
                        prepareNewPayment()
                    } label: {
                        Text("TBD: New Payment")
                    }
                    .sheet(isPresented: $showPaymentEditor) {
                        handlePaymentEditor()   //  onDismiss
                    } content: {
                        PaymentEditor(draft: $newPayment, shouldSave: $shouldSave)
                    }
                    
                    ForEach(draft.payments.sorted(by: { $0.date < $1.date })) { payment in
                        paymentRow(payment)
                    }
                    .onDelete(perform: deletePayment)
                    .actionSheet(isPresented: $showDeleteConfirmation) {
                        deleteConfirmationActionSheet()
                    }
                }
            }
            .navigationTitle("Edit Project")
        }
    }
    
    @State private var showDeleteConfirmation = false
    @State private var offsets = IndexSet()
    
    private func deleteConfirmationActionSheet() -> ActionSheet {
        ActionSheet(
            title: Text("Delete?".uppercased()),
            message: Text("Do you really want to delete this payment?\nThis action cannot be undone."), buttons: [
                .destructive(Text("Yes, delete"), action: {
                    //  MARK: FINISH THIS
                    //  using @State private var offsets: IndexSet
                    
                    print("deleting...")
                }),
                .cancel()
            ]
        )
    }
    
    private func deletePayment(at offsets: IndexSet) {
        //  MARK: FINISH THIS
        self.offsets = offsets
        showDeleteConfirmation = true
    }
    
    private func addProject() {
        //  MARK: FINISH THIS
        
    }
    
    private func handleEntityListEditor() {
        //  MARK: FINISH THIS
        print("saving...")
        
        shouldSave = false
    }
    
    private func prepareEntityListEditor() {
        //  MARK: FINISH THIS
        //  open entities editor
        //  MARK: do not delete entities used in payments!!
        
        showEntityListEditor = true
    }
    
    private func handleEntityEditor() {
        if shouldSave {
            //  MARK: FINISH THIS
            print("saving...")
            
            shouldSave = false
        }
    }
    
    private func prepareNewEntity() {
        //  MARK: FINISH THIS
        newEntity = Entity("", note: "")
        showEntityEditor = true
    }
    
    private func handlePaymentEditor() {
        if shouldSave {
            //  MARK: FINISH THIS
            print("saving...")
            
            shouldSave = false
        }
    }
    
    private func prepareNewPayment() {
        //  MARK: FINISH THIS
        newPayment = Payment(
            date: Date(),
            amount: 0,
            currency: .rub,
            sender: Entity.igor,
            recipient: Entity.progressOOO,
            note: "Очередной транш")
        
        showPaymentEditor = true
    }
    
    private func paymentRow(_ payment: Payment) -> some View {
        PaymentRow(payment: payment)
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

struct ProjectEditor_Previews: PreviewProvider {
    static var previews: some View {
        ProjectEditor(Project.saperavi)
            .environmentObject(Portfolio())
            .preferredColorScheme(.dark)
    }
}
