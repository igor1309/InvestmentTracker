//
//  ProjectEditor.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 06.07.2020.
//

import SwiftUI
import InvestmentDataModel

struct ProjectEditor: View {
    @Binding var draft: Project
    
    var body: some View {
        Form {
            Section {
                TextField("Project Name", text: $draft.name)
                TextField("Note", text: $draft.note)
            }
            
//            Section(header: Text("Entities".uppercased())) {
//                if !draft.entities.isEmpty {
//                    Button {
//                        prepareEntityListEditor()
//                    } label: {
//                        Text(draft.entities.map { $0.name }.joined(separator: "; "))
//                    }
//                    .sheet(isPresented: $showEntityListEditor) {
//                        handleEntityListEditor()    //  onDismiss
//                    } content: {
//                        EntityListEditor(project: $draft)
//                    }
//                }
//
//                Button {
//                    prepareNewEntity()
//                } label: {
//                    Text("TBD: New Entity")
//                }
//                .sheet(isPresented: $showEntityEditor) {
//                    handleEntityEditor()    //  onDismiss
//                } content: {
//                    EntityEditor(entity: $newEntity, shouldSave: $shouldSave)
//                }
//            }
            
            //  MARK: DECIDE LATER
            /*
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
            */
        }
    }
}

struct ProjectEditor_Previews: PreviewProvider {
    static var previews: some View {
        ProjectEditor(draft: .constant(Project()))
    }
}
