//
//  ProjectView.swift
//  InvestmentTracker
//
//  Created by Igor Malyarov on 05.07.2020.
//

import SwiftUI
import InvestmentDataModel

struct ProjectView: View {
    @EnvironmentObject var portfolio: Portfolio
    
    var project: Project
    
    enum Modal { case entityEditor, paymentEditor, projectEditor }
    
    @State private var modal: Modal = .projectEditor
    @State private var showModal = false
    
    @State private var showAddAction = false
    
    var body: some View {
        Form {
            Text(project.note)
            
            if !project.entities.isEmpty {
                Section(header: Text("Entities".uppercased())) {
                    Text(project.entities.map { $0.name }.joined(separator: "; "))
                }
            }
            
            if !project.payments.isEmpty {
                Section(header: Text("Payments".uppercased())) {
                    ForEach(project.payments.sorted(by: { $0.date < $1.date })) { payment in
                        NavigationLink(
                            destination: PaymentView(payment: payment)
                                .environmentObject(portfolio)
                        ) {
                            PaymentRow(payment: payment)
                        }
                    }
                }
            }
            
        }
        .navigationTitle(project.name)
        .navigationBarItems(
            trailing: HStack {
                Button {
                    showAddAction = true
                } label: {
                    Image(systemName: "plus")
                        .padding()
                }
                Button("Edit") {
                    modal = .projectEditor
                    showModal = true
                }
            }
        )
        .sheet(isPresented: $showModal) { presentModal() }
        .actionSheet(isPresented: $showAddAction) { addAction() }
    }
    
    @ViewBuilder private func presentModal() -> some View {
        switch modal {
        case .entityEditor:
            Text("TBD: Entity Editor").foregroundColor(.blue)
        case .paymentEditor:
            Text("TBD: Payment Editor").foregroundColor(.blue)
        case .projectEditor:
            ProjectEditor(project)
                .environmentObject(portfolio)
        }
    }
    
    private func addAction() -> ActionSheet {
        return ActionSheet(
            title: Text("Add".uppercased()),
            message: Text("What would you like to add to the Project?"),
            buttons: [
                .default(Text("Add Entity"), action: {
                    modal = .entityEditor
                    showModal = true
                }),
                .default(Text("Add Payment"), action: {
                    modal = .paymentEditor
                    showModal = true
                }),
                .cancel()
            ])
    }
}

struct ProjectView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProjectView(project: Project.natachtari)
        }
        .preferredColorScheme(.dark)
    }
}
